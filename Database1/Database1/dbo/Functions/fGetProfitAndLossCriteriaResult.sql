-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fGetProfitAndLossCriteriaResult]
(
@PromotionID int,
@ProductID int = 0,
@PnLField varchar(50),
@finCostTypeID int
)
RETURNS float
AS
BEGIN

Declare @result as float

select @result =
(case @finCostTypeID 
	when 0 then vol.volVolumeP1Base + vol.volVolumeP2Base + vol.volVolumeP3Base
	when 1 then vol.volVolumeP1Plan + vol.volVolumeP2Plan + vol.volVolumeP3Plan
	when 2 then vol.volVolumeP1Actual + vol.volVolumeP2Actual + vol.volVolumeP3Actual
	when 5 then vol.volVolumeP1ActualSellOut + vol.volVolumeP2ActualSellOut + vol.volVolumeP3ActualSellOut
end) * 
(case criteria.sysAmount when 0 then 1 else acc.sysAmount end) *
(case criteria.netWeight when 0 then 1 else  prd.prdNetWeight end) * 
(case criteria.prdConversionFactor when 0 then 1 else prd.prdConversionFactor end) / 
(case criteria.prdConversionFactorDiv when 0 then 1 else prd.prdConversionFactor end) /
(case criteria.sysAmountDiv when 0 then 1 else acc.sysAmount end)
from tblPromotion prm 
inner join tblPromotionProductSelection prmprd on prmprd.promotionID = prm.promotionID and prm.promotionID = @PromotionID
inner join tblProduct prd on prd.productID = prmprd.prdProductID and prd.productID = @ProductID
inner join dbo.fn_GetSysAmountByPromotionID(@promotionID, @ProductID) acc on acc.productid = prd.ProductID 
--inner join tblPriTrans prt on prt.productID = acc.productID 
inner join tblPromoVolumeSelection vol on vol.promotionID = prm.promotionID and vol.productID = prmprd.prdProductID
inner join tblProfitAndLossCriteria criteria on criteria.UnitID = prm.prmUnitID 
	and (criteria.prdGroup6ID is null or criteria.prdGroup6ID = prd.prdGroup6ID)
	and (criteria.sysUOMClientCode is null or criteria.sysUOMClientCode = acc.sysUomClientCode)
where PnLField = @PnLField and finCostTypeID = @finCostTypeID

return @result

END



