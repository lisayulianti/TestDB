-- =============================================
-- Author:		Anthony Steven
-- Create date: 19th August 2014
-- Description:	Generate KRIS IS Output Report
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateKRISISOutputReport]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @promotionId int

    set @promotionId = (select top 1 promotionId from tblPromotion
	where prmStatusId = 9 and promotionTypeId = 102020)

	Declare @maxAmount as table
	(
		productId int,
		maxAmount float
	)

	insert into @maxAmount
	select z.productId, max(z.calcAmount) as maxAmount
	from
	(
		select x.productid, x.sysAmount, x.sysUomClientCode, p.prdConversionFactor, 
		(case when x.sysUomClientCode = 'CTN' then sysAmount*(isnull(prdConversionFactor,0))
		when x.sysUomClientCode = 'EA' then sysAmount
		end) as calcAmount
		from
		(select * from dbo.fn_GetSysAmountByPromotionID(@promotionId,0))x
		inner join tblProduct p on x.productid = p.productid
	)z
	group by z.productId

	SELECT a.OutletGroup, a.Outlet, 
isnull((case when a.ProductField = 'prdGroup1ID' then (Select p01PrdGroup1Desc from tblPrdGroup1 where prdGroup1ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup2ID' then (Select p02PrdGroup2Desc from tblPrdGroup2 where prdGroup2ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup3ID' then (Select p03PrdGroup3Desc from tblPrdGroup3 where prdGroup3ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup4ID' then (Select p04PrdGroup4Desc from tblPrdGroup4 where prdGroup4ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup5ID' then (Select p05PrdGroup5Desc from tblPrdGroup5 where prdGroup5ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup6ID' then (Select p06PrdGroup6Desc from tblPrdGroup6 where prdGroup6ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup7ID' then (Select p07PrdGroup7Desc from tblPrdGroup7 where prdGroup7ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup8ID' then (Select p08PrdGroup8Desc from tblPrdGroup8 where prdGroup8ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup9ID' then (Select p09PrdGroup9Desc from tblPrdGroup9 where prdGroup9ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup10ID' then (Select p10PrdGroup10Desc from tblPrdGroup10 where prdGroup10ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup11ID' then (Select p11PrdGroup11Desc from tblPrdGroup11 where prdGroup11ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup12ID' then (Select p12PrdGroup12Desc from tblPrdGroup12 where prdGroup12ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup13ID' then (Select p13PrdGroup13Desc from tblPrdGroup13 where prdGroup13ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup14ID' then (Select p14PrdGroup14Desc from tblPrdGroup14 where prdGroup14ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup15ID' then (Select p15PrdGroup15Desc from tblPrdGroup15 where prdGroup15ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup16ID' then (Select p16PrdGroup16Desc from tblPrdGroup16 where prdGroup16ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup17ID' then (Select p17PrdGroup17Desc from tblPrdGroup17 where prdGroup17ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup18ID' then (Select p18PrdGroup18Desc from tblPrdGroup18 where prdGroup18ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup19ID' then (Select p19PrdGroup19Desc from tblPrdGroup19 where prdGroup19ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup20ID' then (Select p20PrdGroup20Desc from tblPrdGroup20 where prdGroup20ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup21ID' then (Select p21PrdGroup21Desc from tblPrdGroup21 where prdGroup21ID = a.ProductValue) 
	  when a.ProductField = 'prdGroup22ID' then (Select p22PrdGroup22Desc from tblPrdGroup22 where prdGroup22ID = a.ProductValue)	  
end),'Total Sales') as prdGroup,


a.AmountPreviousFullYear,a.AmountPreviousFullYearGrowth,
a.AmountFirstHalfActual, a.FHTier, a.AmountFirstHalfActualPayoutPercentage, a.FHPercentage,
a.SHTier, a.SHPercentage, a.AmountSecondHalfActual, a.AmountSecondHalfActualPayoutPercentage, 
isnull(a.AmountFirstHalfActual,0)+isnull(a.AmountSecondHalfActual,0) as AmountCurrentYearActual 
FROM
(
	SELECT y.OutletGroup, y.Outlet, x.ProductField, x.ProductValue, x.AmountPreviousFullYear, x.AmountPreviousFullYearGrowth,
	 y.AmountFirstHalfActual, y.Tier as FHTier, y.AmountFirstHalfActualPayoutPercentage, y.PayoutPercentage as FHPercentage,
	 z.Tier as SHTier, z.PayoutPercentage as SHPercentage, z.AmountSecondHalfActual, z.AmountSecondHalfActualPayoutPercentage
	FROM (
		select x.OutletGroup, x.Outlet, x.ProductField, x.ProductValue,  sum(isnull(x.Amount,0)) as AmountPreviousFullYear,
		sum(isnull(x.Amount,0)*isnull(x.GrowthTargetPercentage/100,0)) as AmountPreviousFullYearGrowth
		from 
			 (
				 select sec.secCustomerName as Outlet, group4.s04SecGroup4Desc as OutletGroup, 
				 di.detProductField as ProductField ,di.detProductValue as ProductValue,		
				 trans.sctInvQtyEa*ma.maxAmount as Amount, di.detGrowthTargetPercentage as GrowthTargetPercentage
				from 
				tblPromotionSecondaryCustomer prom  WITH (NOLOCK) 
				inner join tblSecondaryCustomer sec  WITH (NOLOCK) on prom.secondaryCustomerID = sec.secondaryCustomerID and prom.promotionId = @promotionId			
				inner join tblPromotionDetailsIncentive di  WITH (NOLOCK) on prom.promotionId = di.promotionId
				inner join tblSecTrans trans WITH (NOLOCK) on prom.secondaryCustomerID = trans.secondaryCustomerID
				inner join @maxAmount ma on trans.productID = ma.productId 
				inner join tblSecGroup4 group4  WITH (NOLOCK) on sec.secGroup4ID = group4.secGroup4ID
				where DatePart(year,trans.dayDate) = DatePart(year,GETDATE())-1
			)x
		group by x.OutletGroup, x.Outlet, x.ProductField, x.ProductValue
	)x

	right join 

	(
		select x.OutletGroup, x.Outlet,  x.ProductField, x.ProductValue, x.Tier, sum(isnull(x.Amount,0)) as AmountFirstHalfActual
		,max(isnull(x.PayoutPercentage,0)/100) as PayoutPercentage,  
		isnull(sum(isnull(x.Amount,0))*max(isnull(x.PayoutPercentage,0)/100),0) as AmountFirstHalfActualPayoutPercentage
		from 
			 (
				 select sec.secCustomerName as Outlet, group4.s04SecGroup4Desc as OutletGroup, 
				isnull(di.detProductField,'')  as ProductField ,di.detProductValue as ProductValue, di.detIncentiveTier as Tier,
				 trans.sctInvQtyEa*ma.maxAmount as Amount, di.detPayoutPercentage as PayoutPercentage
				from 
				tblPromotionSecondaryCustomer prom  WITH (NOLOCK) 
				inner join tblSecondaryCustomer sec  WITH (NOLOCK) on prom.secondaryCustomerID = sec.secondaryCustomerID and prom.promotionId = @promotionId
				inner join tblPromotionDetailsIncentive di  WITH (NOLOCK) on prom.promotionId = di.promotionId
				inner join tblSecTrans trans  WITH (NOLOCK) on prom.secondaryCustomerID = trans.secondaryCustomerID
				inner join @maxAmount ma on trans.productID = ma.productId 
				inner join tblSecGroup4 group4  WITH (NOLOCK) on sec.secGroup4ID = group4.secGroup4ID
				where DatePart(year,trans.dayDate) = DatePart(year,GETDATE()) and DatePart(month,trans.dayDate) <= 6
			)x
		group by x.OutletGroup, x.Outlet,  x.ProductField, x.ProductValue, x.Tier  
	)y

	on x.Outlet = y.Outlet and x.OutletGroup = y.OutletGroup
	and x.ProductField = y.ProductField and x.ProductValue = y.ProductValue


	inner join 

	(
	select x.OutletGroup, x.Outlet,  x.ProductField, x.ProductValue, x.Tier, sum(isnull(x.Amount,0)) as AmountSecondHalfActual
	,max(isnull(x.PayoutPercentage,0)/100) as PayoutPercentage, 
	 isnull(sum(isnull(x.Amount,0))*max(isnull(x.PayoutPercentage,0)/100),0) as AmountSecondHalfActualPayoutPercentage
	from 
		 (
			 select sec.secCustomerName as Outlet, group4.s04SecGroup4Desc as OutletGroup, 
			 isnull(di.detProductField,'')  as ProductField ,di.detProductValue as ProductValue, di.detIncentiveTier as Tier,
			 trans.sctInvQtyEa*ma.maxAmount as Amount, di.detPayoutPercentage as PayoutPercentage
			from 
			tblPromotionSecondaryCustomer prom  WITH (NOLOCK) 
			inner join tblSecondaryCustomer sec  WITH (NOLOCK) on prom.secondaryCustomerID = sec.secondaryCustomerID and prom.promotionId = @promotionId
			inner join tblPromotionDetailsIncentive di WITH (NOLOCK)  on prom.promotionId = di.promotionId
			inner join tblSecTrans trans WITH (NOLOCK)  on prom.secondaryCustomerID = trans.secondaryCustomerID
			inner join @maxAmount ma on trans.productID = ma.productId 
			inner join tblSecGroup4 group4  WITH (NOLOCK) on sec.secGroup4ID = group4.secGroup4ID
			where DatePart(year,trans.dayDate) = DatePart(year,GETDATE()) and DatePart(month,trans.dayDate) > 6
		)x
	group by x.OutletGroup, x.Outlet,  x.ProductField, x.ProductValue, x.Tier  
	)z

	on y.Outlet = z.Outlet and y.OutletGroup = z.OutletGroup
	and y.ProductField = z.ProductField and y.ProductValue = z.ProductValue
	and y.Tier = z.Tier
)a


	
END



