
CREATE PROCEDURE [dbo].[spx_GeneratePromotionFOC]	
	@PromotionID varchar(250),
	@CustomerPromotionList CustomerPromotionList READONLY
AS
BEGIN	

SELECT DistributorCode,PromotionCode,PromotionIndex,FOCPrdCategoryLevel,FOCPrdCategoryCode,UOMCode,FOCQuantity,MAX(FOCListPrice) AS FOCListPrice
FROM (
	SELECT DISTINCT 'HQ' AS DistributorCode,
	ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) AS PromotionCode,
	CASE WHEN (ISNULL(prd.detStepNr,'')='' OR prd.detStepNr=1) THEN '1' ELSE prd.detStepNr END PromotionIndex,
	'3' AS FOCPrdCategoryLevel,
	prgfg.p21PrdGroup21ClientCode AS FOCPrdCategoryCode,
	CASE WHEN prd.detFreegoodsunit = 102000002 THEN 
		'CTN' ELSE CASE WHEN prd.detFreegoodsunit = 102000003 THEN  'EA' ELSE '' END
	END AS UOMCode,
	prd.detFreegoodsamount AS FOCQuantity,	
	CAST(CASE WHEN sysa.sysUomClientCode = 'CTN' AND prd.detFreegoodsunit = 102000002 THEN sysa.sysAmount ELSE
		CASE WHEN sysa.sysUomClientCode = 'CTN' AND prd.detFreegoodsunit = 102000003 THEN sysa.sysAmount/prodfg.prdConversionFactor ELSE
			CASE WHEN sysa.sysUomClientCode = 'EA' AND prd.detFreegoodsunit = 102000003 THEN sysa.sysAmount ELSE
				CASE WHEN sysa.sysUomClientCode = 'EA' AND prd.detFreegoodsunit = 102000002 THEN sysa.sysAmount*prodfg.prdConversionFactor END
			END
		END
	END AS DECIMAL(18,2)) AS FOCListPrice
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.customerID = vcus.customerID AND cus.countryID = prm.countryID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN tblPromotionType pt ON prm.countryID=pt.countryID AND prm.promotionTypeID=pt.promotionTypeID
	INNER JOIN tblDetSelTab dst ON pt.countryID = dst.countryID AND pt.promotionTypeID = dst.promotionTypeID
	INNER JOIN tblPromotionDetails prd ON prm.promotionID = prd.PromotionID
	LEFT JOIN tblPromotionFreeGoods fg ON prm.promotionID = fg.promotionID
	LEFT JOIN tblProduct AS prodfg ON prodfg.productID = fg.productID AND prodfg.countryID = fg.countryID		
	LEFT JOIN tblPrdGroup21 AS prgfg ON prgfg.prdGroup21ID = prodfg.prdGroup21ID AND prgfg.countryID = prodfg.countryID
	INNER JOIN tbldistributorNames AS dms ON dms.dinCustomerClientCode = cus.cusCustomerClientCode AND dms.countryID = cus.countryID
	INNER JOIN dbo.fn_GetSysAmount()
	AS sysa ON sysa.productID=fg.freeProductID AND (sysa.customerID is null or (sysa.customerID = cus.customerID)) and 
		(sysa.cusGroup1ID is null or (cus.cusGroup1ID = sysa.cusGroup1ID)) and 
		(sysa.cusGroup4ID is null or (cus.cusGroup4ID = sysa.cusGroup4ID)) and 
		(sysa.cusGroup7ID is null or (cus.cusGroup7ID = sysa.cusGroup7ID))
	WHERE prm.countryId = 102 AND prm.promotionTypeID NOT IN (102005,102006,102007,102021)
		AND dst.BuildingBlockID=102008
) tbl
GROUP BY DistributorCode,PromotionCode,PromotionIndex,FOCPrdCategoryLevel,FOCPrdCategoryCode,UOMCode,FOCQuantity
ORDER BY DistributorCode
END
