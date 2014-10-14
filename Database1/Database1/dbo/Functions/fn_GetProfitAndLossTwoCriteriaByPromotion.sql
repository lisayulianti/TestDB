-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetProfitAndLossTwoCriteriaByPromotion]
(	
@PromotionID int
)
RETURNS TABLE 
AS
RETURN 
(
select criteria.PnLField, criteria.finCostTypeID, prd.productID,
(case finCostTypeID 
	when 0 then vol.volVolumeP2Base
	when 1 then vol.volVolumeP2Plan
	when 2 then vol.volVolumeP2Actual
	when 5 then vol.volVolumeP2ActualSellOut
end) * 
(case criteria.sysAmount when 0 then 1 else acc.sysAmount end) *
(case criteria.netWeight when 0 then 1 else  prd.prdNetWeight end) * 
(case criteria.prdConversionFactor when 0 then 1 else prd.prdConversionFactor end) / 
(case criteria.prdConversionFactorDiv when 0 then 1 else prd.prdConversionFactor end) /
(case criteria.sysAmountDiv when 0 then 1 else acc.sysAmount end) pnlValue
from tblPromotion prm 
inner join tblPromotionProductSelection prmprd on prmprd.promotionID = prm.promotionID 
inner join tblProduct prd on prd.productID = prmprd.prdProductID --and prd.productID = @ProductID
inner join dbo.fn_GetSysAmountByPromotionID(@PromotionID, 0) acc on acc.productid = prd.ProductID 
inner join tblPromoVolumeSelection vol on vol.promotionID = prm.promotionID and vol.productID = prmprd.prdProductID
inner join tblProfitAndLossCriteria criteria on criteria.UnitID = prm.prmUnitID 
	and (criteria.prdGroup6ID is null or criteria.prdGroup6ID = prd.prdGroup6ID)
	and (criteria.sysUOMClientCode is null or criteria.sysUOMClientCode = acc.sysUomClientCode)
where prm.promotionID = @PromotionID and prm.countryID = criteria.countryID
--order by finCostTypeID, PnLField
)


