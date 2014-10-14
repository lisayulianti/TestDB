
CREATE PROCEDURE [dbo].[spx_GeneratePromotionExclusionProduct]
	@PromotionID varchar(250) = '1',
	@CustomerPromotionList CustomerPromotionList READONLY
AS
BEGIN
	SELECT DISTINCT 'HQ' AS DistributorCode,
	ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) AS PromotionCode,
	CASE WHEN (ISNULL(pd.detStepNr,'') = '' OR pd.detStepNr = 1) THEN '1'
		 ELSE pd.detStepNr 
	END AS PromotionIndex,
	prod.prdProductClientCode
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionDetails AS pd ON pd.PromotionID = prm.promotionID
	LEFT JOIN tblPromotionExclusionProduct pep ON pep.PromotionID = prm.promotionID
	INNER JOIN tblProduct AS prod ON prod.productID = pep.exclfreeProductID AND prod.countryID = pep.countryID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.customerID = vcus.customerID AND cus.countryID = prm.countryID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN tbldistributorNames AS dms ON dms.dinCustomerClientCode = cus.cusCustomerClientCode
	WHERE prm.countryId = 102
	ORDER BY ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix)
END
