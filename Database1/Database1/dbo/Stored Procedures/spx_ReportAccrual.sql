-- =============================================
-- Author:		Nora Limanto (original script) / Lisa Yulianti (SP creator)
-- Create date: 21 Aug 2014
-- Description:	Get Accrual report related data
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportAccrual]
@countryID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @YearMonthStart int, @YearMonthEnd int

SELECT @YearMonthStart = (SELECT YEAR(MIN(prmDateStart))*100+MONTH(MIN(prmDateStart)) FROM tblPromotion WHERE countryID= @countryId AND prmStatusID NOT IN (0,12,13)) 
SELECT @YearMonthEnd = (SELECT YEAR(MAX(prmDateEnd))*100+MONTH(MAX(prmDateEnd)) FROM tblPromotion WHERE countryID= @countryId AND prmStatusID NOT IN (0,12,13)) 

SELECT DISTINCT prm.prmpromotionClientCode, CAST(prm.prmPromotionDescription as varchar(max)) AS PromotionDescription, 
prmStaus.psStatusDescription AS StatusDescription, 
CONVERT(VARCHAR(50),prm.prmDateStart,106) AS StartDate, CONVERT(VARCHAR(50),prm.prmDateEnd,106) AS EndDate,  
CASE WHEN RIGHT(prm.prmpromotionClientCode, 2) IN ('E1','E2','E3','E4','E5') THEN 'Yes' ELSE 'No' END AS Topup
, prm.promotionID, CONVERT(VARCHAR(50),jGen.jgJournalCreationDate,113) AS JournalCreationDate, 
jGen.jgJournalgeneration,
CASE WHEN jGen.jgJournalgeneration = 1 THEN 'Yes' ELSE 'No' END AS Journalgeneration, 
prm.prmStatusId,
CASE WHEN prm.prmStatusID = 12 THEN 'Yes' ELSE 'No' END AS [Status]
, CAST(RIGHT(bm.YearMonth,2) AS VARCHAR(2)) + '/' + CAST(LEFT(bm.YearMonth,4)AS VARCHAR(4)) AS BookMonth
,CASE WHEN ts.finSpendType IS NULL THEN 'No' ELSE 'Yes' END AS TradeSpend
,CASE WHEN ap.finSpendType IS NULL THEN 'No' ELSE 'Yes' END AS AnP
,CASE WHEN prm.prmIOnumber='' AND ap.finSpendType IS NOT NULL THEN 'Yes' ELSE 'No' END AS IoFilled
, vcus.cusGroup1IDs,vsec.secGroup2IDs
,CAST(fin.finAmount
	* (SELECT CASE WHEN YEAR(prm.prmDateStart)*100+MONTH(prm.prmDateStart) = bm.YearMonth THEN
			CASE WHEN YEAR(prm.prmDateEnd)*100+MONTH(prm.prmDateEnd) = bm.YearMonth THEN
				DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1
			ELSE
				DATEDIFF(day,prm.prmDateStart,DATEADD(DAY,-1,CAST(MONTH(prm.prmDateStart)+1 AS VARCHAR(10))+'/1/'+CAST(YEAR(prm.prmDateStart) AS VARCHAR(10))))+1
			END
		ELSE
			CASE WHEN YEAR(prm.prmDateEnd)*100+MONTH(prm.prmDateEnd) = bm.YearMonth THEN
				DATEDIFF(day,CAST(MONTH(prm.prmDateEnd) AS VARCHAR(10))+'/1/'+CAST(YEAR(prm.prmDateEnd) AS VARCHAR(10)),prm.prmDateEnd)+1
			ELSE
				DATEDIFF(day,CAST(CAST(RIGHT(bm.YearMonth,2) AS VARCHAR(10))+'/1/'+CAST(LEFT(bm.YearMonth,4) AS VARCHAR(10)) AS DATETIME)
				,DATEADD(DAY,-1,CAST(CAST(RIGHT(bm.YearMonth,2)+1 AS VARCHAR(10))+'/1/'+CAST(LEFT(bm.YearMonth,4) AS VARCHAR(10)) AS DATETIME)))+1
			END
		END) / cast(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1 as DECIMAL(18,0) ) AS DECIMAL(18,2)) as finAmount
		
FROM	tblPromotion prm 
INNER JOIN (SELECT promotionID, SUM(finAmount) finAmount FROM tblPromoFinancial where finCostTypeID = 1 GROUP BY promotionID) AS fin ON fin.promotionID=prm.PromotionID
LEFT JOIN (SELECT DISTINCT promotionID, SUBSTRING(
        (
            SELECT DISTINCT ','+CAST(cus.cusGroup1ID AS VARCHAR(50))  AS [text()]
            FROM vw_PromoCust ST1
			INNER JOIN tblCustomer cus ON ST1.countryID = cus.countryID AND ST1.customerID = cus.customerID
            WHERE ST1.promotionID = ST2.promotionID
            FOR XML PATH ('')
        ), 2, 1000) cusGroup1IDs
FROM vw_PromoCust ST2) vcus ON prm.promotionID = vcus.promotionID
LEFT JOIN (SELECT DISTINCT promotionID, SUBSTRING(
        (
            SELECT DISTINCT ','+CAST(sec.secGroup2ID AS VARCHAR(50))  AS [text()]
            FROM vw_PromoSecCust ST1
			INNER JOIN tblSecondaryCustomer sec ON ST1.countryID = sec.countryID AND ST1.secondaryCustomerID = sec.secondaryCustomerID
            WHERE ST1.promotionID = ST2.promotionID
            FOR XML PATH ('')
        ), 2, 1000) secGroup2IDs
FROM vw_PromoSecCust ST2) vsec ON prm.promotionID = vsec.promotionID
LEFT JOIN (SELECT * FROM tblPromoFinancial WHERE finSpendType='Trade spend' and finCostTypeID = 1) AS ts ON ts.promotionID=prm.PromotionID
LEFT JOIN (SELECT * FROM tblPromoFinancial WHERE finSpendType='A&P' and finCostTypeID = 1) AS ap ON ap.promotionID=prm.PromotionID
INNER JOIN tblPromotionStatus prmStaus ON prm.prmStatusID = prmStaus.promotionStatusID
INNER JOIN dbo.fn_YearMonth(@YearMonthStart,@YearMonthEnd) bm 
	ON bm.YearMonth BETWEEN YEAR(prm.prmDateStart)*100+MONTH(prm.prmDateStart) AND YEAR(prm.prmDateEnd)*100+MONTH(prm.prmDateEnd) 
LEFT JOIN (SELECT b.* FROM
    (SELECT countryID,promotionID,jgBookmonth,MAX(jgJournalCreationDate) AS jgJournalCreationDate
    FROM tblAccrualGeneration
    GROUP BY countryID,promotionID,jgBookmonth) a
    INNER JOIN tblAccrualGeneration b ON a.countryID=b.countryID AND a.promotionID=b.promotionID AND a.jgBookmonth=b.jgBookmonth AND a.jgJournalCreationDate=b.jgJournalCreationDate) AS jGen 
ON jGen.countryID = prm.countryID AND jGen.promotionID = prm.promotionID AND jGen.jgBookmonth = bm.YearMonth
WHERE prm.isDeleted = 0 AND prm.prmStatusID IN (8,9,10,11) AND prm.countryID= @countryId
AND prm.prmPromotionStructure<>'Parent' -- parent promotions can never appear int he accrual website

END
