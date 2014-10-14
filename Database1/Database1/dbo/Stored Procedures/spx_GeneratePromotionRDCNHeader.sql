
CREATE PROCEDURE [dbo].[spx_GeneratePromotionRDCNHeader]
	@PromotionID int,
	@CustomerID int,
	@Conditiontype nvarchar(50)
AS
BEGIN
	SELECT prm.promotionID,sel.customerID,fin.finConditionType,'H' AS H,CONVERT(VARCHAR(50),GETDATE(),101) AS DocDate,
	'SA' AS DocType,'20' AS CompanyCode,CONVERT(VARCHAR(50),GETDATE(),101) AS PostingDate,'11' AS Period,
	'MYR' AS DocCurrency,'1' AS ExchangeRate,pdb.bblBlockName AS Reference,prm.prmPromotionClientCode AS DocHeader 
	,'' AS Branch,'' AS CalculateTax,
	cast(prm.prmPromotionDescription as nvarchar(500)) prmPromotionDescription, pty.ptyPromotionTypeName,
	sum(fin.finAmount) finAmount
	FROM tblPromotion AS prm 
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
	INNER JOIN tblPromotionType AS pty ON pty.promotiontypeID=prm.promotionTypeID 
	INNER JOIN tblPromotionCustomerSelection AS sel ON sel.promotionID = prm.promotionID 
	INNER JOIN tblDetSelTab AS dst ON dst.promotionTypeID=pty.promotionTypeID
	INNER JOIN tblPromotionDetailsBuildingBlock AS pdb ON pdb.BuildingBlockID=dst.BuildingBlockID
	WHERE prm.promotionID = @PromotionID AND sel.customerID = @CustomerID	
		and fin.finCostTypeID = 1 and fin.finConditionType = @Conditiontype
	GROUP BY prm.promotionID, sel.customerID, fin.finConditionType, pdb.bblBlockName, prm.prmPromotionClientCode,
		cast(prm.prmPromotionDescription as nvarchar(500)), pty.ptyPromotionTypeName
	ORDER BY prm.promotionID,sel.customerID
END

