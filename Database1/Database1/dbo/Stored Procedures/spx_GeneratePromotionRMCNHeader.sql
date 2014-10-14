
CREATE PROCEDURE [dbo].[spx_GeneratePromotionRMCNHeader]
	@PromotionID int,
	@CustomerID int,
	@Conditiontype nvarchar(50)
AS
BEGIN
	SELECT prm.promotionID,vcus.customerID,fin.finConditionType,'H' AS H,CONVERT(VARCHAR(50),GETDATE(),101) AS DocDate,
	'SA' AS DocType,'20' AS CompanyCode,CONVERT(VARCHAR(50),GETDATE(),101) AS PostingDate,'11' AS Period,
	'MYR' AS DocCurrency,'1' AS ExchangeRate,pdb.bblBlockName AS Reference,prm.prmPromotionClientCode AS DocHeader 
	,'' AS Branch,'' AS CalculateTax, 
	cast(prm.prmPromotionDescription as nvarchar(500)) prmPromotionDescription, pty.ptyPromotionTypeName,
	sum(fin.finAmount) finAmount
	FROM tblPromotion AS prm 
	INNER JOIN tblPromotionCustomer vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID
	LEFT JOIN tblPromotionCustomerSelection AS pcus on prm.promotionID = pcus.promotionID 
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
	INNER JOIN tblPromotionType AS pty ON pty.promotiontypeID=prm.promotionTypeID 
	INNER JOIN tblDetSelTab AS dst ON dst.promotionTypeID=pty.promotionTypeID
	INNER JOIN tblPromotionDetailsBuildingBlock AS pdb ON pdb.BuildingBlockID=dst.BuildingBlockID
	WHERE prm.promotionID = @PromotionID AND (vcus.customerID = @CustomerID or vcus.customerID = (cast(@CustomerID as varchar(20)))) 
		and fin.finConditionType = @Conditiontype
	group by prm.promotionID, vcus.customerId, fin.finConditionType, pdb.bblBlockName, prm.prmPromotionClientCode,
	cast(prm.prmPromotionDescription as nvarchar(500)), pty.ptyPromotionTypeName
	ORDER BY prm.promotionID,vcus.customerID
END

