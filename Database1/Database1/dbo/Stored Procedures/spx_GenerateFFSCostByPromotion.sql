-- =============================================
-- Author:		Anthony Steven
-- Create date: 20 August 2014
-- Description:	Generate FFS Cost By Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateFFSCostByPromotion]
	@promotionId INT	
AS
BEGIN
Declare @sysAmount as table
	(
		productID int,
		sysAmount float,
		sysUOMClientCode varchar(10),
		combinationID int
	)

	insert into @sysAmount
	select * from dbo.fn_GetSysAmountValueByPromotionID(@promotionId)

Declare @highestRow as table
(
	id int,
	price float,
	netWeight float
)
insert into @highestRow
select top 1 id,price,netWeight
from (
	select products.productID as id, (case when sa.sysUomClientCode='CTN' then sa.sysAmount
	when sa.sysUomClientCode='EA' then sa.sysAmount*prod.prdConversionFactor end) as price,
	prod.prdNetWeight as netWeight
	from
	(
		select distinct (case when parentMapping.parentProductId is null then p.productID
		when parentMapping.parentProductId is not null then parentMapping.parentProductId end) as productID, p.prdConversionFactor, p.prdGroup7ID, 
		p.prdGroup21ID,  p.prdGroup4ID,  p.prdGroup9ID
		from tblProduct p  WITH (NOLOCK) inner join tblPromotionProductSelection s  WITH (NOLOCK) 
		on p.productID = s.prdProductID 
		left join vw_ProductParentMapping parentMapping  WITH (NOLOCK)  on p.productID = parentMapping.productID		   
		where s.promotionID = @promotionId
	)products  inner join @sysAmount sa on products.productID = sa.productID
	inner join tblProduct prod on products.productId = prod.productID
) source
order by source.price desc


 SELECT	   isnull(sum(isnull(isnull(dinc.detOutletClass,0) * (isnull(dinc.detMaximumPayoutPercentage,0)/100)* (isnull(dinc.detVolumeReqRetailer,0) * hr.price / hr.netWeight),0)),0)
	       from tblPromotionDetailsIncentive dinc   WITH (NOLOCK) 
		   inner join tblPromotion promo  WITH (NOLOCK)  on dinc.promotionID = promo.promotionID		  
           and promo.promotionID = @promotionId
		   cross join @highestRow hr
END



