
CREATE PROCEDURE [dbo].[spx_GeneratePromotionRMCN]
	@PromotionID int,
	@CustomerID int
AS
BEGIN
	SELECT prm.promotionID,vcus.customerID,prd.productID,'DLMI Finance Department' AS [To],
	cus.cusCustomerName AS [From],
	CAST(fin.finGeneralLedgerCodeBSh AS varchar(50))+'-'+ISNULL(fin.finGeneralLedgerCodeBShDesc,'') AS Account,
	CONVERT(VARCHAR(50),GETDATE(),101) AS RequestDate,
	prm.prmPromotionClientCode+ '_' + CAST(cus.cusCustomerClientCode AS VARCHAR(20)) AS RMCNNo,
	CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END AS DistributorSAPCode,
	fin.finConditionType AS Conditiontype,
	prm.prmPromotionClientCode,
	prd.prdProductClientCode AS MaterialCode,
	prd.prdProductName AS ProductName,
	UPPER(CONVERT(CHAR(4), prm.prmDateStart, 100))+'-'+RIGHT((CONVERT(CHAR(4), prm.prmDateStart, 102)),2) AS PromoMonth,
	'' AS QuantityCtn
	FROM
	tblPromotion AS prm 
	INNER JOIN tblPromotionCustomer vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID
	--LEFT JOIN tblPromotionCustomerSelection AS pcus on prm.promotionID = pcus.promotionID 
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	INNER JOIN tblAccrualGeneration AS jgen ON jgen.promotionID = prm.promotionID 
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
	INNER JOIN tblPromotionProductSelection AS prs ON prs.promotionID=prm.promotionID 
	INNER JOIN tblProduct AS prd ON prd.productID = prs.prdProductID 
	WHERE prm.promotionID = @PromotionID 
	AND (vcus.customerID = @CustomerID or cast(vcus.customerID AS varchar(30)) = (cast(prm.countryID as varchar(10)) + cast(@CustomerID as varchar(20)))) 
	GROUP BY prm.promotionID,prm.prmPromotionClientCode,vcus.customerID,cus.cusCustomerClientCode,cus.cusCustomerName,fin.finGeneralLedgerCodeBSh,
	fin.finGeneralLedgerCodeBShDesc,prd.productID, prd.prdGroup6ID,prd.prdConversionFactor,fin.finConditionType,prd.prdProductClientCode,prd.prdProductName,
	jcc.jccCusCustomerClientCode,prm.prmDateStart,prm.prmUnitID,cus.cusCustomerClientCode
	ORDER BY cus.cusCustomerClientCode
END

