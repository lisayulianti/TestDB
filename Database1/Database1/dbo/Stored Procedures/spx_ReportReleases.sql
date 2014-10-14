-- =============================================
-- Author:		Nora Limanto
-- Create date: 26 Aug 2014
-- Description:	Get Releases report related data
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportReleases]
	@countryId int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
	SELECT DISTINCT 
		prm.promotionID,
		prm.prmPromotionClientCode,
		CAST(prm.prmPromotionDescription as varchar(max)) as PromotionDescription,
		CASE WHEN jcc.jccCusCustomerClientCode <>'' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END AS CustomerCode,
		sec.secSecondaryCustomerName,
		sec.secSecGroup2ClientCode, 
		sec.secSecGroup3ClientCode,
		CONVERT(VARCHAR(100),prmDateStart,106) AS prmDateStartConverted,
		CONVERT(VARCHAR(100),prmDateEnd,106) AS prmDateEndConverted,
		prm.prmDateStart,
		prm.prmDateEnd, 
		prs.psStatusDescription,
		rtb.rtbAmount as Accrualamount,
		ISNULL(actw.acwAmount,act.actAmount) AS Claimedamount,
		rtb.rtbAmount - ISNULL(actw.acwAmount,act.actAmount) AS Releaseamount,
		CASE WHEN rgen.rgJournalgeneration IS NULL THEN '0' ELSE rgen.rgJournalgeneration END AS rgReleaseJournalGeneration,
		CASE WHEN rgen.rgJournalgeneration = 1 THEN 'Yes' ELSE 'No' END AS rgStatus,
		CONVERT(VARCHAR(100),rgen.rgJournalcreationDate,113) AS rgReleasejournalCreationDate,
		prm.prmStatusID,
		cus.cusGroup1ID,
		cg1.c01CusGroup1Desc,
		CASE WHEN jcc.jccCusCustomerClientCode <>'' THEN prm.countryID*1000000+CAST(jcc.jccCusCustomerClientCode AS INT) 
		ELSE prm.countryID*1000000+CAST(cus.cusCustomerClientCode AS INT) END AS CustomerID
    FROM tblPromotion AS prm 
    INNER JOIN vw_PromoCust vcus ON prm.countryID = vcus.countryID AND prm.promotionID = vcus.promotionID
    LEFT JOIN vw_PromoSecCust vsec ON prm.countryID = vsec.countryID AND prm.promotionID = vsec.promotionID AND vcus.customerID = vsec.customerID
    LEFT JOIN tblCustomer AS cus ON cus.countryID = vcus.countryID AND cus.customerID=vcus.customerID
    LEFT JOIN tblCusGroup1 AS cg1 ON cus.countryID = cg1.countryID AND cus.cusGroup1ID=cg1.cusGroup1ID
    LEFT JOINtblJournalCustomerCode AS jcc ON jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
    LEFT JOIN tblSecondaryCustomer AS sec ON sec.SecondaryCustomerID=vsec.SecondaryCustomerID
        AND ((sec.secGroup2ID IS NOT NULL AND sec.secondaryCustomerID IS NULL) OR prm.promotionTypeID IN (020,017))
    INNER JOIN (SELECT a.*,b.CusCustomerClientCode FROM tblAccrualGeneration a 
	    INNER JOIN tblCustomer b ON a.countryID = b.countryID AND a.customerID = b.customerID) AS jgen 
	    ON jgen.promotionID=prm.promotionID AND jgen.CusCustomerClientCode = CASE WHEN jcc.jccCusCustomerClientCode <>'' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END
    INNER JOIN tblPromotionStatus AS prs ON prm.prmStatusID = prs.promotionStatusID
    INNER JOIN tblClaimNoteGeneration AS cn ON cn.promotionID = prm.promotionID AND cn.promotionID=jgen.promotionID
    LEFT JOIN (SELECT b.*
            FROM
            (SELECT countryID,promotionID,MAX(rgJournalcreationDate) AS rgJournalcreationDate
            FROM tblReleaseJournalGeneration
            GROUP BY countryID,promotionID) a
            INNER JOIN tblReleaseJournalGeneration b ON a.countryID=b.countryID AND a.promotionID=b.promotionID AND a.rgJournalcreationDate=b.rgJournalcreationDate
    )AS rgen ON rgen.promotionID=jgen.promotionID
    INNER JOIN (SELECT countryID ,rtbHeader,customerID ,SUM(rtbAmount) rtbAmount
				FROM ( SELECT DISTINCT countryID ,pnlID
					  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(rtbHeader,'E1',''),'E2',''),'E3',''),'E4',''),'E5','') rtbHeader
					  ,customerID  ,rtbAmount
					  FROM tblRecTypeB
					  WHERE rtbHeader<>''
				) a GROUP BY countryID ,rtbHeader,customerID ) AS rtb ON rtb.rtbHeader=prm.prmPromotionClientCode AND rtb.customerID = jgen.customerID
    LEFT JOIN (SELECT countryID, actHeader, customerID, SUM(ISNULL(actAmount,0)) AS actAmount FROM tblActual GROUP BY countryID, actHeader, customerID)
	    AS act ON act.actHeader=prm.prmPromotionClientCode AND act.customerID=jgen.customerID
    LEFT JOIN tblActualtwo AS actw ON actw.acwHeader=cn.claimClientCode
    WHERE prm.isDeleted = 0 AND prm.prmStatusID IN (11,10, 12) AND Prm.countryID=@countryID
	AND prm.prmPromotionStructure<>'Parent' AND RIGHT(prm.prmpromotionClientCode, 2) NOT IN ('E1','E2','E3','E4','E5') -- parent and top up promotions can never appear in the Release website
    GROUP BY prm.prmPromotionClientCode,jcc.jccCusCustomerClientCode,cus.cusCustomerClientCode,
    CAST(prm.prmPromotionDescription As varchar(max)),
    prm.prmDateStart,prm.prmDateEnd,sec.secSecondaryCustomerName,sec.secSecGroup2ClientCode, sec.secSecGroup3ClientCode ,
    prs.psStatusDescription,prm.promotionID,rgen.rgJournalgeneration,actw.acwAmount,act.actAmount,rtb.rtbAmount,
    rgen.rgJournalcreationDate ,prm.prmStatusID, cus.cusGroup1ID,cg1.c01CusGroup1Desc, prm.countryID
    ORDER BY prm.prmDateStart, Prm.prmPromotionClientCode

END
