
CREATE PROCEDURE [dbo].[spx_GeneratePromotionRMCNDetail]
	@PromotionID int,
	@CustomerID int
AS
BEGIN
	SELECT DISTINCT prm.promotionID,0 AS customerID,fin.finConditionType,
	'I' AS I,'40' AS Postingkey,fin.finGeneralLedgerCodeBSh AS GLAccNo,
	'' AS TaxCode,'' AS CostCenter,'' AS [Order],'' AS Assignment,
	fin.finGeneralLedgerCodeBShDesc+'-'+UPPER((CONVERT(CHAR(4), prm.prmDateStart, 100)))+'-'+RIGHT((CONVERT(CHAR(4), prm.prmDateStart, 102)),2) AS ItemText,
	CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END AS Customer
	, prd.prdProductClientCode AS Product,'' AS Plant,cus.cusCustomerClientCode
	FROM tblPromotion AS prm 
	INNER JOIN tblPromotionCustomer vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID
	LEFT JOIN tblPromotionCustomerSelection AS pcus on prm.promotionID = pcus.promotionID 
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	INNER JOIN tblAccrualGeneration AS jgen ON jgen.promotionID = prm.promotionID 
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
	INNER JOIN tblPromotionProductSelection AS prs ON prs.promotionID=prm.promotionID 
	INNER JOIN tblProduct AS prd ON prd.productID = prs.prdProductID 
	INNER JOIN tblCusGroup1 AS cgr1 ON cgr1.cusGroup1ID = cus.cusGroup1ID	
	WHERE prm.promotionID = @PromotionID
	AND (vcus.customerID = @CustomerID or cast(vcus.customerID AS varchar(30)) = (cast(@CustomerID as varchar(20)))) 
	GROUP BY prm.promotionID,prm.prmPromotionClientCode,cus.cusCustomerClientCode,vcus.customerID,cus.cusCustomerName,fin.finGeneralLedgerCodeBSh,
	fin.finGeneralLedgerCodeBShDesc,prd.productID, prd.prdGroup6ID,prd.prdConversionFactor,fin.finConditionType,prd.prdProductClientCode,prd.prdProductName,
	jcc.jccCusCustomerClientCode,prm.prmDateStart,prm.prmUnitID,cus.cusCustomerClientCode
	ORDER BY cus.cusCustomerClientCode
END



