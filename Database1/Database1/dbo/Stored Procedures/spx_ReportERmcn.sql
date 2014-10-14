-- =============================================
-- Author:		Nora Limanto
-- Create date: 26 Aug 2014
-- Description:	Get ERmcn report related data
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportERmcn] 
	@countryId int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
	SELECT DISTINCT prm.prmpromotionClientCode,Cast(prm.prmPromotionDescription as NVarchar(Max)) prmPromotionDescription, 
	CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcc.jccCusCustomerClientCode AS VARCHAR(50)) ELSE CAST(cus.cusCustomerClientCode AS VARCHAR(50)) END cusCustomerClientCode,
	CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcc.jccCustomerName AS VARCHAR(50)) ELSE '' END cusCustomerName,
	(CONVERT(varchar(50), prm.prmDateStart, 106)) AS prmDateStartConverted, (CONVERT(varchar(50), prm.prmDateEnd, 106)) AS prmDateEndConverted, pst.psStatusDescription,
	CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcccus.customerID AS VARCHAR(50)) ELSE CAST(cus.customerID AS VARCHAR(50)) END customerID,
	CASE WHEN GETDATE() < prmDateEnd THEN 'Yes' ELSE 'No' END AS endeddata,cn.cnStatus,
	CASE WHEN cn.cnStatus=1 THEN 'Yes' ELSE 'No' END AS Status,prmDateStart,prmDateEnd,
	(CONVERT(varchar(50),cn.cnCreationDate, 113)) AS cnCreationDate,cn.cnCreator,prm.promotionID,prm.prmStatusID,
	tuse.useFullName
	FROM tblPromotion AS prm	
	INNER JOIN tblUSer tuse ON prm.prmCreator = tuse.userID
	INNER JOIN vw_PromoCust vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON vcus.customerID = cus.customerID and vcus.countryID = cus.countryID
	LEFT JOIN tblCusGroup1 AS cg1 ON cg1.countryID = cus.countryID AND cg1.cusGroup1ID = cus.cusGroup1ID
	LEFT JOIN tblPromotionCustomerSelection AS sel ON sel.promotionID = prm.promotionID 
	LEFT JOIN tblCusGroup1 AS scg1 ON scg1.countryID = sel.countryID AND scg1.cusGroup1ID = sel.cusGroup1ID
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.countryID=cus.countryID AND jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	LEFT JOIN tblCustomer AS jcccus ON jcc.jccCusCustomerClientCode = jcccus.cusCustomerClientCode
	INNER JOIN tblPromotionStatus AS pst ON pst.promotionStatusID=prm.prmStatusID 
	LEFT JOIN (SELECT b.countryID,b.claimClientCode,b.promotionID,b.cnPromotionClientCode
				,b.customerID,b.secondaryCustomerID,b.cnStatus,b.cnCreationDate,b.cnCreator 
			FROM
			(SELECT promotionID,customerID,MAX(cnCreationDate) AS cnCreationDate
			FROM tblClaimNoteGeneration
			GROUP BY promotionID,customerID) a
			INNER JOIN tblClaimNoteGeneration b ON a.promotionID=b.promotionID AND a.customerID=b.customerID AND a.cnCreationDate=b.cnCreationDate) AS cn 
			ON cn.promotionID = prm.promotionID AND cn.customerID = CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcccus.customerID AS VARCHAR(50)) ELSE CAST(cus.customerID AS VARCHAR(50)) END
	WHERE prm.isDeleted = 0 AND (CASE WHEN sel.customerID IS NOT NULL THEN cg1.c01CusGroup1ClientCode ELSE scg1.c01CusGroup1ClientCode END = '01')
		AND prm.prmStatusID IN (10,11) AND prm.CountryID=@countryId
		AND prm.prmPromotionStructure<>'Parent' AND RIGHT(prm.prmpromotionClientCode, 2) NOT IN ('E1','E2','E3','E4','E5') -- parent and top up promotions can never appear in the Claim Notes website
		
END
