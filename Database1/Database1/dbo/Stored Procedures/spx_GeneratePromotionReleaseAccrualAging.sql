-- =============================================
-- Author:           Nora Limanto
-- Create date: 8 Oct 2014
-- Description:      Get Aged Accrual report
-- =============================================
CREATE PROCEDURE [dbo].[spx_GeneratePromotionReleaseAccrualAging] 
       @countryId int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
	SELECT cg1.cusGroup1ID,cg5.cusGroup5ID,cg6.cusGroup6ID,cg1.c01CusGroup1Desc, cg5.c05CusGroup5Desc, cg6.c06CusGroup6Desc
	,CASE WHEN jcc.jccCusCustomerClientCode <> '' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END AS CustomerCode
	,CASE WHEN jcc.jccCusCustomerClientCode <> '' THEN jcc.cusCustomerName ELSE cus.cusCustomerName END AS CustomerName
	, pt.ptyPromotionTypeName,prm.promotionID,fin.finGeneralLedgerCode,fin.finGeneralLedgerCodeDesc
	,CONVERT(varchar(50),prm.prmDateStart,106) prmDateStart,CONVERT(varchar(50),prm.prmDateEnd,106) prmDateEnd,prm.prmStatusID, ps.psStatusDescription
	,CAST(fin.finAmount * (pnl.GrossSales/ tbl.totalGrossSalesPerPromo) AS MONEY) AS Budget
	,CAST(rtb.rtbAmount AS MONEY) as Accrual,CAST((fin.finAmount * (pnl.GrossSales/ tbl.totalGrossSalesPerPromo)) AS MONEY) - CAST(rtb.rtbAmount AS MONEY) AS Release
	,cast(ISNULL(actw.acwAmount, act.actAmount ) as money) AS Claim
	,CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) AS Balance
	,DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) AS AgedDays
	,CASE WHEN DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) BETWEEN 0 AND 30 THEN CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) ELSE 0 END AS Days30
	,CASE WHEN DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) BETWEEN 31 AND 60 THEN CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) ELSE 0 END AS Days60
	,CASE WHEN DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) BETWEEN 61 AND 90 THEN CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) ELSE 0 END AS Days90
	,CASE WHEN DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) BETWEEN 91 AND 120 THEN CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) ELSE 0 END AS Days120
	,CASE WHEN DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) BETWEEN 121 AND 150 THEN CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) ELSE 0 END AS Days150
	,CASE WHEN DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) BETWEEN 151 AND 180 THEN CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) ELSE 0 END AS Days180
	,CASE WHEN DATEDIFF(DAY,prm.prmDateEnd,GETDATE()) >180 THEN CAST(rtb.rtbAmount AS MONEY)-cast(ISNULL(actw.acwAmount, act.actAmount ) as money) ELSE 0 END AS Above180
	FROM tblPromotion AS prm
	INNER JOIN tblPromotionType pt ON prm.promotionTypeID = pt.promotionTypeID
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID = prm.PromotionID
	INNER JOIN tblPromotionCustomer2 vcus ON prm.promotionID = vcus.promotionID
	INNER JOIN tblCustomer cus ON prm.countryID = cus.countryID AND vcus.customerId = cus.customerId
	INNER JOIN tblCusGroup1 cg1 ON cus.cusGroup1ID = cg1.cusGroup1ID
	INNER JOIN tblCusGroup5 cg5 ON cus.cusGroup5ID = cg5.cusGroup5ID
	INNER JOIN tblCusGroup6 cg6 ON cus.cusGroup6ID = cg6.cusGroup6ID
	LEFT JOIN (SELECT a.*,b.cusCustomerName 
				FROM tblJournalCustomerCode a 
				INNER JOIN tblCustomer b 
				ON a.countryID = b.countryID AND a.jccCusCustomerClientCode = b.cusCustomerClientCode) 
				AS jcc ON jcc.cusGroup5ID = cus.cusGroup5ID AND jcc.cusGroup6ID = cus.cusGroup6ID
	INNER JOIN (SELECT promotionID,customerId,SUM(GrossSales) GrossSales
				FROM (
					SELECT DISTINCT a.promotionID,b.customerId,d.GrossSales
					FROM tblPromotion a
					INNER JOIN tblPromotionCustomer2 b ON a.promotionID=b.promotionID
					INNER JOIN tblPromotionProductSelection c ON a.promotionID=c.promotionID
					INNER JOIN tblInAcrPnL d ON b.customerId = d.customerID AND c.prdProductID = d.productID
				) tbl0 GROUP BY promotionID,customerId) pnl ON prm.promotionID = pnl.promotionID AND cus.customerID = pnl.customerId
	INNER JOIN tblpromotionStatus ps ON prm.prmStatusID = ps.promotionStatusID
	INNER JOIN (SELECT promotionID,SUM(GrossSales) totalGrossSalesPerPromo
				FROM (
					SELECT DISTINCT a.promotionID,d.GrossSales
					FROM tblPromotion a
					INNER JOIN tblPromotionCustomer2 b ON a.promotionID=b.promotionID
					INNER JOIN tblPromotionProductSelection c ON a.promotionID=c.promotionID
					INNER JOIN tblInAcrPnL d ON b.customerId = d.customerID AND c.prdProductID = d.productID
				) tbl0 GROUP BY promotionID) tbl ON prm.promotionID = tbl.promotionID
	INNER JOIN ( SELECT countryID, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(rtbHeader,'E1',''),'E2',''),'E3',''),'E4',''),'E5','') rtbHeader, 
				customerID , SUM (ISNULL( rtbAmount,0 )) AS rtbAmount, pnlID FROM tblRecTypeB GROUP BY countryID, 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(rtbHeader,'E1',''),'E2',''),'E3',''),'E4',''),'E5',''), customerID, pnlID ) 
			   AS rtb ON rtb.rtbHeader = prm.prmPromotionClientCode AND rtb.customerID = cus.customerID and rtb.pnlID = fin.pnlID
	LEFT JOIN tblSetPnL setpnl on setpnl.pnlPnlActCond = fin.finConditionType and setpnl.pnlPnlActGL = fin.finGeneralLedgerCodeBSh
	LEFT JOIN ( SELECT countryID, actHeader, customerID , SUM (ISNULL( actAmount,0 )) AS actAmount, pnlID FROM tblActual GROUP BY countryID, actHeader, customerID, pnlID HAVING actHeader IS NOT NULL )
			   AS act ON (act.actHeader = prm.prmPromotionClientCode AND act.customerID = cus.customerID and act.pnlID = setpnl.pnlID)
	INNER JOIN tblClaimNoteGeneration AS cn ON cn.promotionID = prm.promotionID
	LEFT JOIN (SELECT * FROM tblActualtwo WHERE acwHeader IS NOT NULL) AS actw ON actw.acwHeader = cn.claimClientCode
	WHERE prm.countryID= @countryId AND prm.prmStatusID>=8 AND prm.isDeleted=0
END
