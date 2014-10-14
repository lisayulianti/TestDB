
CREATE PROCEDURE [dbo].[spx_GeneratePromotionProduct]	
	@PromotionID varchar(250)	,
	@CustomerPromotionList CustomerPromotionList READONLY	
AS
BEGIN	
	SELECT DISTINCT 'HQ' AS DistributorCode,
	ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) AS PromotionCode,
	CASE WHEN (ISNULL(prd.detStepNr,'') = '' OR prd.detStepNr = 1) THEN '1' ELSE prd.detStepNr  END AS PromotionIndex,
	'5' AS PrdCategoryLevel,	
	prod.prdProductClientCode AS PrdCategoryCode,
	CASE WHEN prm.prmUnitID = 102000002 THEN 'CTN' ELSE 
		CASE WHEN prm.prmUnitID = 102000003 THEN 'EA' ELSE '' END
	END AS UOMCode,		
	'1' AS MinimumQuantity,
	'0' AS MustInd
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionType AS pty ON pty.promotionTypeId = prm.promotionTypeId
	INNER JOIN tblPromotionDetails AS prd ON prd.PromotionID = prm.promotionID
	INNER JOIN tblPromotionProductSelection AS pps ON pps.promotionID = prm.promotionID
	INNER JOIN tblProduct AS prod ON prod.productID = pps.prdProductID AND prod.countryID = prm.countryID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.customerID = vcus.customerID AND cus.countryID = prm.countryID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN tbldistributorNames AS dms ON dms.dinCustomerClientCode = cus.cusCustomerClientCode AND dms.countryID = cus.countryID
	WHERE prm.countryId = 102 AND prod.productID=pps.prdProductID AND pty.ptyDMSCode = 'D'
	ORDER BY ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix)
END
