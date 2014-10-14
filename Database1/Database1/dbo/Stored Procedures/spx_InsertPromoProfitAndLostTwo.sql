-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 14 July 2014
-- Description:	Insert into tblPromoProfitAndLostTwo
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromoProfitAndLostTwo] 
	@PromotionID int,
	@CountryID int = 102
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if exists (select top 1 prm.promotionID 
from tblPromotion prm WITH (NOLOCK) 
inner join tblPromotionCustomerSelection prmcust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID
inner join tblPromotionProductSelection prmprd WITH (NOLOCK) on prm.promotionID = prmprd.promotionID
inner join tblPromoVolumeSelection prmvol WITH (NOLOCK) on prm.promotionID = prmvol.promotionID
inner join tblPromotionDetails prmdtl WITH (NOLOCK) on prm.promotionID = prmdtl.PromotionID
where prm.promotionID = @PromotionID)
OR
exists (select top 1 prm.promotionID 
from tblPromotion prm WITH (NOLOCK) 
inner join tblPromotionCustomerSelection prmcust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID
inner join tblPromotionProductSelection prmprd WITH (NOLOCK) on prm.promotionID = prmprd.promotionID
inner join tblPromoVolumeSelection prmvol WITH (NOLOCK) on prm.promotionID = prmvol.promotionID
inner join tblPromotionDetailsIncentive prmdtl WITH (NOLOCK) on prm.promotionID = prmdtl.PromotionID
where prm.promotionID = @PromotionID)
begin 

    -- Insert statements for procedure here
if exists (select top 1 promoProfitAndLossTwoID from tblPromoProfitAndLossTwo WITH (NOLOCK) where promotionid = @promotionID)
begin
	delete tblPromoProfitAndLossDetailTwo where promotionID = @promotionID
	delete tblPromoProfitAndLossTwo where promotionID = @promotionID
end

declare @prmEndDate as datetime
declare @prmStartDate as datetime

select @prmStartDate = prmDateStart, @prmEndDate = prmDateEnd
from tblPromotion where promotionid = @promotionID and countryID = @CountryID

Declare @tbl as table 
(
	pnlField nvarchar(50),
	pnlType varchar(50),
	pnlGroup varchar(50),
	pnlValue float
)

-- TOTAL CTN, EA, NET WEIGHT AND GROSS SALES

Declare @pnltbl as table
(
	pnlField nvarchar(50),
	finCostTypeID float
)

Declare @pnltblValue as table
(
	pnlField nvarchar(50),
	finCostTypeID float,
	productID int,
	pnlValue float
)

insert into @pnltblValue
select * 
from dbo.fn_GetProfitAndLossTwoCriteriaByPromotion(@promotionID)


Declare @pnlField nvarchar(50)
Declare @finCostTypeID int

insert into @tbl
select pnlField, finCostTypeID, null, sum(pnlValue)
from @pnltblValue
group by finCostTypeID, pnlField

-- END TOTAL CTN, EA, NET WEIGHT AND GROSS SALES

Declare @tblCusGroup as table
(
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int
)

insert into @tblCusGroup
select distinct
cust.cusGroup5ID, cust.cusGroup6ID, seccust.secGroup2ID 
from tblPromotionSecondaryCustomer vsec WITH (NOLOCK) 
inner join tblSecondaryCustomer seccust WITH (NOLOCK) on seccust.secondaryCustomerID = vsec.secondaryCustomerID
inner join tblCustomer cust WITH (NOLOCK) on cust.customerID = seccust.customerID
where vsec.promotionID = @promotionID

if not exists (select top 1 secgroup2id from @tblCusGroup)
begin
	insert into @tblCusGroup
	select distinct
	cusGroup5ID, cusGroup6ID, null
	from vw_PromoCust v
	inner join tblCustomer cust WITH (NOLOCK) on cust.customerID = v.customerID
	where promotionID = @promotionID
end

Declare @index as int
Set @index = 0

Declare @tblSubItem as table
(
	pnlItem varchar(50),
	pnlSubItem varchar(50),
	finCostTypeID int,
	pnlGroup varchar(50), 
	finAmount float
)

-- ABSOLUTE TRADE TERM ITEMS

declare @maxBudgetAllocationNr as int
set @maxBudgetAllocationNr = 0
select @maxBudgetAllocationNr = max (balBudgetNr)
from tblBudgetAllocation
where balYear = DATEPART(year, @prmStartDate)

insert into @tblSubItem
select helper.PnLSubGroup, helper.PnLSubGroupItem, 0, helper.PnlGroup, 
case when avg(budGrossSales) > 0
	then avg((bal.balFixedTT)) * -(select pnlValue from @tbl where pnlField = 'GrossSales' and pnlType = 0) / avg(budGrossSales)
	else 0
end
from tblBudgetAllocation bal WITH (NOLOCK) 
inner join @tblCusGroup cusgroup on 
	(bal.cusGroup5ID is null or bal.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bal.cusGroup6ID is null or bal.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bal.secGroup2ID is null and cusgroup.secGroup2ID is null) or bal.secGroup2ID = cusGroup.secGroup2ID)
	--isnull(cusgroup.cusGroup5ID, '') = isnull(bal.CusGroup5ID, '') 
	--and isnull(cusgroup.cusGroup6ID, '') = isnull(bal.cusGroup6ID, '')
	--and isnull(cusgroup.secGroup2ID, '') = isnull(bal.secGroup2ID, '')
inner join tblProfitAndLossHelper helper WITH (NOLOCK) on helper.GLCode = bal.balFixedTTGL or helper.GLCode = bal.balFixedTTGLTwo
left join (select sum(budGrossSales) budGrossSales, cusGroup5ID, cusGroup6ID, secGroup2ID
	from tblBudgetAndForecast WITH (NOLOCK) 
	where budBudgetNr = @maxBudgetAllocationNr and budyear = DATEPART(year, @prmStartDate)
	group by cusGroup5ID, cusGroup6ID, secGroup2ID) bud on 	(bud.cusGroup5ID is null or bud.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bud.cusGroup6ID is null or bud.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bud.secGroup2ID is null and cusgroup.secGroup2ID is null) or bud.secGroup2ID = cusGroup.secGroup2ID)
where bal.countryID = @countryID and balBudgetNr = @maxBudgetAllocationNr and helper.countryID = @CountryID
	and balYear = DATEPART(year, @prmStartDate)
group by helper.PnLSubGroup, helper.PnLSubGroupItem, helper.PnlGroup

insert into @tblSubItem
select helper.PnLSubGroup, helper.PnLSubGroupItem, 1, helper.PnlGroup, 
case when avg(budGrossSales) > 0
	then avg((bal.balFixedTT)) * -(select pnlValue from @tbl where pnlField = 'GrossSales' and pnlType = 0) / avg(budGrossSales)
	else 0
end
from tblBudgetAllocation bal WITH (NOLOCK) 
inner join @tblCusGroup cusgroup on 
	(bal.cusGroup5ID is null or bal.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bal.cusGroup6ID is null or bal.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bal.secGroup2ID is null and cusgroup.secGroup2ID is null) or bal.secGroup2ID = cusGroup.secGroup2ID)
	--isnull(cusgroup.cusGroup5ID, '') = isnull(bal.CusGroup5ID, '') 
	--and isnull(cusgroup.cusGroup6ID, '') = isnull(bal.cusGroup6ID, '')
	--and isnull(cusgroup.secGroup2ID, '') = isnull(bal.secGroup2ID, '')
inner join tblProfitAndLossHelper helper WITH (NOLOCK) on helper.GLCode = bal.balFixedTTGL or helper.GLCode = bal.balFixedTTGLTwo
left join (select sum(budGrossSales) budGrossSales, cusGroup5ID, cusGroup6ID, secGroup2ID
	from tblBudgetAndForecast WITH (NOLOCK) 
	where budBudgetNr = @maxBudgetAllocationNr and budYear = DATEPART(year, @prmStartDate)
	group by cusGroup5ID, cusGroup6ID, secGroup2ID) bud on 	(bud.cusGroup5ID is null or bud.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bud.cusGroup6ID is null or bud.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bud.secGroup2ID is null and cusgroup.secGroup2ID is null) or bud.secGroup2ID = cusGroup.secGroup2ID)
where bal.countryID = @countryID and balBudgetNr = @maxBudgetAllocationNr and helper.countryID = @CountryID
	and balYear = DATEPART(year, @prmStartDate)
group by helper.PnLSubGroup, helper.PnLSubGroupItem, helper.PnlGroup

insert into @tblSubItem
select helper.PnLSubGroup, helper.PnLSubGroupItem, 2, helper.PnlGroup, 
case when avg(budGrossSales) > 0
	then avg((bal.balFixedTT)) * -(select pnlValue from @tbl where pnlField = 'GrossSales' and pnlType = 0) / avg(budGrossSales)
	else 0
end
from tblBudgetAllocation bal WITH (NOLOCK) 
inner join @tblCusGroup cusgroup on 
	(bal.cusGroup5ID is null or bal.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bal.cusGroup6ID is null or bal.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bal.secGroup2ID is null and cusgroup.secGroup2ID is null) or bal.secGroup2ID = cusGroup.secGroup2ID)
	--isnull(cusgroup.cusGroup5ID, '') = isnull(bal.CusGroup5ID, '') 
	--and isnull(cusgroup.cusGroup6ID, '') = isnull(bal.cusGroup6ID, '')
	--and isnull(cusgroup.secGroup2ID, '') = isnull(bal.secGroup2ID, '')
inner join tblProfitAndLossHelper helper WITH (NOLOCK) on helper.GLCode = bal.balFixedTTGL or helper.GLCode = bal.balFixedTTGLTwo
left join (select sum(budGrossSales) budGrossSales, cusGroup5ID, cusGroup6ID, secGroup2ID
	from tblBudgetAndForecast WITH (NOLOCK) 
	where budBudgetNr = @maxBudgetAllocationNr and budYear = DATEPART(year, @prmStartDate)
	group by cusGroup5ID, cusGroup6ID, secGroup2ID) bud on 	(bud.cusGroup5ID is null or bud.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bud.cusGroup6ID is null or bud.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bud.secGroup2ID is null and cusgroup.secGroup2ID is null) or bud.secGroup2ID = cusGroup.secGroup2ID)
where bal.countryID = @countryID and balBudgetNr = @maxBudgetAllocationNr and helper.countryID = @CountryID
	and balYear = DATEPART(year, @prmStartDate)
group by helper.PnLSubGroup, helper.PnLSubGroupItem, helper.PnlGroup

insert into @tblSubItem
select helper.PnLSubGroup, helper.PnLSubGroupItem, 5, helper.PnlGroup, 
case when avg(budGrossSales) > 0
	then avg((bal.balFixedTT)) * -(select pnlValue from @tbl where pnlField = 'GrossSales' and pnlType = 0) / avg(budGrossSales)
	else 0
end
from tblBudgetAllocation bal WITH (NOLOCK) 
inner join @tblCusGroup cusgroup on 
	(bal.cusGroup5ID is null or bal.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bal.cusGroup6ID is null or bal.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bal.secGroup2ID is null and cusgroup.secGroup2ID is null) or bal.secGroup2ID = cusGroup.secGroup2ID)
	--isnull(cusgroup.cusGroup5ID, '') = isnull(bal.CusGroup5ID, '') 
	--and isnull(cusgroup.cusGroup6ID, '') = isnull(bal.cusGroup6ID, '')
	--and isnull(cusgroup.secGroup2ID, '') = isnull(bal.secGroup2ID, '')
inner join tblProfitAndLossHelper helper WITH (NOLOCK) on helper.GLCode = bal.balFixedTTGL or helper.GLCode = bal.balFixedTTGLTwo
left join (select sum(budGrossSales) budGrossSales, cusGroup5ID, cusGroup6ID, secGroup2ID
	from tblBudgetAndForecast WITH (NOLOCK) 
	where budBudgetNr = @maxBudgetAllocationNr and budYear = DATEPART(year, @prmStartDate)
	group by cusGroup5ID, cusGroup6ID, secGroup2ID) bud on 	(bud.cusGroup5ID is null or bud.cusGroup5ID = cusGroup.cusGroup5ID)
	and (bud.cusGroup6ID is null or bud.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((bud.secGroup2ID is null and cusgroup.secGroup2ID is null) or bud.secGroup2ID = cusGroup.secGroup2ID)
where bal.countryID = @countryID and balBudgetNr = @maxBudgetAllocationNr and helper.countryID = @CountryID
	and balYear = DATEPART(year, @prmStartDate)
group by helper.PnLSubGroup, helper.PnLSubGroupItem, helper.PnlGroup

-- END ABSOLUTE TRADE TERM ITEMS


Declare @tblFTTHelper as table
(
	PnLItem varchar(50),
	PnLSubGroupItem varchar(50),
	pnlGroup varchar(50),
	sysAmount float
)

-- COST ITEM BY GROSS SALES FOR ALL COST TYPE

if exists (select top 1 * from tblLKATT WITH (NOLOCK) where secGroup2ID in (select secGroup2ID from @tblCusGroup))
begin
	insert into @tblFTTHelper
	select 
	helper.PnLSubGroup, helper.PnLSubGroupItem, helper.PnlGroup, isnull(avg(lkaAmount),0) sysAmount
	from tblProfitAndLossHelper helper 
	left outer join 
	(
	select 
	att.pnlID, att.lkaAmount
	from vw_PromoSecCust prmsec WITH (NOLOCK) 
	inner join tblSecondaryCustomer seccust WITH (NOLOCK) on prmsec.promotionID = @PromotionID and seccust.secondaryCustomerID = prmsec.secondaryCustomerID
	inner join 
	(
	select distinct prmprd.promotionID, prdGroup11ID
	from tblPromotionProductSelection prmprd WITH (NOLOCK) 
	inner join tblProduct prd WITH (NOLOCK) on prd.ProductID = prmprd.prdProductID
	where promotionID = @PromotionID
	) prd on prd.promotionID = prmsec.promotionID 
	inner join tblLKATT att WITH (NOLOCK) on att.secGroup2ID = seccust.secGroup2ID and att.prdGroup11ID = prd.prdGroup11ID
	) acc on helper.PnLCode = acc.pnlID
	where helper.PnLCode is not null  and helper.countryID = @CountryID
	group by helper.PnlGroup, helper.PnLSubGroup, helper.PnLSubGroupItem
end
else
begin
	insert into @tblFTTHelper
	select 
	helper.PnLSubGroup, helper.PnLSubGroupItem, helper.PnlGroup, isnull(avg(sysAmount),0) / 100 sysAmount
	from tblProfitAndLossHelper helper 
	left outer join 
	(
	select acc.pnlID, sysAmount 
	from tblSystemAccrual acc WITH (NOLOCK) 
	inner join (select distinct customerid, cusgroup1ID, cusgroup4id, cusgroup7id from dbo.fn_GetCustomerIDsByPromotionID (@PromotionID)) cust on 
		(acc.customerID is null or (acc.customerID = cust.customerID)) and 
		(acc.cusGroup1ID is null or (cust.cusGroup1ID = acc.cusGroup1ID)) and 
		(acc.cusGroup4ID is null or (cust.cusGroup4ID = acc.cusGroup4ID)) and 
		(acc.cusGroup7ID is null or (cust.cusGroup7ID = acc.cusGroup7ID))
	inner join
	(
	select distinct prdProductID, prdGroup6ID, prdGroup11ID, prdGroup12ID
	from tblPromotionProductSelection prmprd WITH (NOLOCK) 
	inner join tblProduct prd WITH (NOLOCK) on prd.ProductID = prmprd.prdProductID
	where promotionID = @PromotionID
	) prd on
		(acc.productID is null or acc.productID = prd.prdProductID) 
		and (acc.prdGroup6ID is null or acc.prdGroup6ID = prd.prdGroup6ID) 
		and (acc.prdGroup11ID is null or acc.prdGroup11ID = prd.prdGroup11ID) 
		and (acc.prdGroup12ID is null or acc.prdGroup12ID = prd.prdGroup12ID) 
	where (sysDelete = '' or sysDelete is null) and acc.countryID = @countryID and (select prmDateStart from tblPromotion where promotionID = @PromotionID) between acc.validFrom and acc.validTo	
	and sysCurrency = '%'
	) acc on helper.PnLCodeForFTT = acc.pnlID
	where helper.PnLCodeForFTT is not null and helper.countryID = @CountryID
	group by helper.PnlGroup, helper.PnLSubGroup, helper.PnLSubGroupItem

end

While @index < 6
begin
	insert into @tblSubItem
	select pnlItem, pnlSubGroupItem, @index, pnlGroup, 
	sysAmount * (select pnlValue from @tbl where pnlField = 'GrossSales' and pnlType = @index)
	from @tblFTTHelper

	if @index = 2
	begin
		set @index = 5
	end
	else
	begin
		set @index = @index + 1
	end
end
--select * from @tblSubItem
-- COST ITEM BY GROSS SALES FOR ALL COST TYPE

-- remove any FTT when there's already an absolute trade term in tblBudgetAllocation
Delete @tblFTTHelper
where pnlSubGroupItem in (select pnlSubItem from @tblSubItem)

-- PLANNED and ACTUAL PROMOTION COST
-- for finCostTypeID = 1,2 and 5

insert into @tblSubItem
select helper.PnLSubGroup, helper.PnLSubGroupItem, finCostTypeID, helper.PnlGroup, sum(prmfin.finAmount) *-1
from tblPromoFinancial prmfin WITH (NOLOCK) 
inner join tblProfitAndLossHelper helper WITH (NOLOCK) on helper.PnLCode = prmfin.pnlID
where finCostTypeID in (1,2) and promotionID = @promotionID and helper.countryID = @CountryID
group by PnLSubGroupItem, PnLSubGroup, finCostTypeID, PnlGroup

insert into @tblSubItem
select helper.PnLSubGroup, helper.PnLSubGroupItem, 5, helper.PnlGroup, sum(prmfin.finAmount) *-1
from tblPromoFinancial prmfin WITH (NOLOCK) 
inner join tblProfitAndLossHelper helper WITH (NOLOCK) on helper.PnLCode = prmfin.pnlID
where finCostTypeID = 2 and promotionID = @promotionID and helper.countryID = @CountryID
group by PnLSubGroupItem, PnLSubGroup, finCostTypeID, PnlGroup

-- END PLANNED and ACTUAL PROMOTION COST

-- INSERT COSTS INTO @TBL

insert into @tbl
select 
helper.PnLSubGroup, finCostTypeID, helper.PnlGroup, sum(finAmount)
from @tblSubItem subitem
inner join tblProfitAndLossHelper helper WITH (NOLOCK) on helper.PnLSubGroup = subitem.pnlItem and helper.PnlGroup = subitem.pnlGroup
	and helper.PnLSubGroupItem = subitem.pnlSubItem
where  helper.countryID = @CountryID
group by helper.PnLSubGroup, helper.PnlGroup, finCostTypeID

-- END INSERT

-- SUM ALL TOTAL FOR EACH GROUP 

insert into @tbl
select 
'Total' + pnlGroup, pnlType, pnlGroup, sum(pnlValue)
from @tbl tbl 
where pnlGroup is not null
group by pnlType, pnlGroup

-- END SUM ALL TOTAL FOR EACH GROUP 

-- MARKET RETURN 

declare @maxBudgetAndForecastNr as int
set @maxBudgetAndForecastNr = 0

select @maxBudgetAndForecastNr = max (budBudgetNr)
from tblBudgetAndForecast 
where budYear = DATEPART(year, @prmStartDate)

declare @marketbyGrossSales as float

select
@marketbyGrossSales = sum(budMarketReturn) / (case when sum(isnull(budGrossSales,0)) = 0 then 1 else sum(isnull(budGrossSales,0)) end)
from tblBudgetAndForecast baf WITH (NOLOCK) 
inner join @tblCusGroup cusgroup on 
	(baf.cusGroup5ID is null or baf.cusGroup5ID = cusGroup.cusGroup5ID)
	and (baf.cusGroup6ID is null or baf.cusGroup6ID = cusGroup.cusGroup6ID)
	and ((baf.secGroup2ID is null and cusgroup.secGroup2ID is null) or baf.secGroup2ID = cusGroup.secGroup2ID)
	--isnull(cusgroup.cusGroup5ID, '') = isnull(bal.CusGroup5ID, '') 
	--and isnull(cusgroup.cusGroup6ID, '') = isnull(bal.cusGroup6ID, '')
	--and isnull(cusgroup.secGroup2ID, '') = isnull(bal.secGroup2ID, '')
where
baf.countryID = @countryID and
baf.budBudgetNr = @maxBudgetAndForecastNr and
baf.budYear = DATEPART(year, @prmStartDate)

insert into @tbl
select
'MarketReturn', pnlType, null, @marketbyGrossSales * pnlValue 
from @tbl tbl 
where pnlField = 'GrossSales'

-- END MARKET RETURN

-- DIRECT SELLING COSTS

insert into @tbl
select 
'DirectSellingCosts', pnlType, null, sum(pnlValue) 
from @tbl tbl
where pnlfield in ('TotalGroup1', 'TotalGroup2', 'MarketReturn')
group by pnlTYpe

-- END DIRECT SELLING COSTS

-- NET SALES & COGS & SUMMARY

Set @index = 0

Declare @grossSales as float
Declare @directSellingCost as float
Declare @totalCTN as float
Declare @cogs as float
Declare @anp as float

While @index < 6
begin
	select @grossSales = pnlValue
	from @tbl tbl 
	where pnlField = 'GrossSales' and pnltype = @index

	select @directSellingCost = pnlValue
	from @tbl tbl 
	where pnlField = 'DirectSellingCosts' and pnltype = @index

	select @totalCTN = pnlValue
	from @tbl tbl 
	where pnlField = 'TotalCTN' and pnltype = @index

	insert into @tbl
	select 'TotalNetSales', @index, null, @grossSales + @directSellingCost

	insert into @tbl
	select 'NetSalesPercentage', @index, null, 
		case when @grossSales <> 0 then (@grossSales + @directSellingCost) / @grossSales
		else 0 end

	--select @cogs =
	--	sum((case when datepart(month, getdate()) <= 3 then fcgFirstQuarter
	--	when datepart(month, getdate()) <= 6 then fcgSecondQuarter
	--	when datepart(month, getdate()) <= 9 then fcgThirdQuarter
	--	else fcgFourthQuarter end) * dbo.fGetProfitAndLossCriteriaResult(@promotionID, prmprd.prdProductID, 'TotalCTN', @index))-- / 365 * datediff(day, @prmStartDate, @prmEndDate) * 3)
	--from tblPromotionProductSelection prmprd
	--inner join (select distinct productID, fcgFirstQuarter, fcgSecondQuarter, fcgThirdQuarter, fcgFourthQuarter from tblForecastedCogs) cogs on cogs.productID = prmprd.prdProductID
	--where promotionid = @promotionID

	select @cogs =
		sum(
		case when fcgFirstQuarter is null and fcgSecondQuarter is null
			and fcgThirdQuarter is null and fcgFourthQuarter is null then -cgsAmount
		else
		(case when datepart(month, getdate()) <= 3 then fcgFirstQuarter
		when datepart(month, getdate()) <= 6 then fcgSecondQuarter
		when datepart(month, getdate()) <= 9 then fcgThirdQuarter
		else fcgFourthQuarter end) end * prmprd.pnlValue * -1)-- / 365 * datediff(day, @prmStartDate, @prmEndDate) * 3)
	from 
	(
		select prmprd.prdProductID productID,
		avg(cogs.fcgFirstQuarter) fcgFirstQuarter, avg(cogs.fcgSecondQuarter) fcgSecondQuarter, 
		avg(cogs.fcgThirdQuarter) fcgThirdQuarter, avg(cogs.fcgFirstQuarter) fcgFourthQuarter,
		avg(cgsAmount) cgsAmount
		from tblPromotionProductSelection prmprd WITH (NOLOCK) 
		inner join tblProduct prd WITH (NOLOCK) on prd.productID = prmprd.prdProductID
		left outer join tblProduct prdParent WITH (NOLOCK) on prdParent.prdParentCode = replace(replace(prd.prdParentCode, '_BASE', ''), '_PROMO', '')
		left outer join tblForecastedCogs cogs WITH (NOLOCK) on cogs.productID in (prd.productID, prdParent.productID)
		left outer join
		(
			select productID, avg(cgsAmount) cgsAmount 
			from tblCogs WITH (NOLOCK) 
			where productID in (select prdproductid from tblPromotionProductSelection where promotionID = @PromotionID)
			group by productID
		) hcogs on hcogs.productID in (prmprd.prdProductID, prdParent.productID)
		where promotionID = @PromotionID
		group by prmprd.prdProductID
	) cogs 
	inner join @pnltblValue prmprd on cogs.productID = prmprd.ProductID and prmprd.finCostTypeID = @index and prmprd.pnlField = 'TotalCTN'


	insert into @tbl
	select 'COGS', @index, null, @cogs

	insert into @tbl
	select 'GrossProfit', @index, null, (@grossSales + @directSellingCost) + @cogs

	insert into @tbl
	select 'GPPercentage', @index, null, 
		case when (@grossSales + @directSellingCost) <> 0 then (@grossSales + @directSellingCost + @cogs) / (@grossSales + @directSellingCost)
		else 0 end

	if @index = 0
	begin
		set @anp = 0
	end
	else
	begin
		select @anp = isnull(sum(isnull(finAmount,0)),0) * -1
		from tblPromoFinancial
		where promotionID = @promotionID and finCostTypeID = @index
			and finSpendType = 'A&P'
	end

	insert into @tbl
	select 'AnP', @index, null, @anp

	insert into @tbl
	select 'TotalExpense', @index, null, @cogs + @directSellingCost

	insert into @tbl
	select 'GP_P', @index, null, ((@grossSales + @directSellingCost) + @cogs) + @anp

	if @index = 2
	begin
		set @index = 5
	end
	else
	begin
		set @index = @index + 1
	end
end

-- END NET SALES & COGS & SUMMARY

--select * from @tbl order by pnltype, pnlField

-- INSERT RESULT TO tblPromoProfitAndLossTwo

insert into tblPromoProfitAndLossTwo (promotionid, countryID, pnlitem, finCostTypeID, finAmount)
select @promotionID promotionID, @CountryID countryID, helper.pnlitem, tbl.pnlType, sum(isnull(tbl.pnlValue,0))
from @tbl tbl
left outer join (select distinct pnlSubGroup, pnlItem from tblProfitAndLossHelper where countryID = @CountryID) helper on helper.PnLSubGroup = tbl.pnlField
group by tbl.pnlType, helper.PnLItem
order by tbl.pnlType, helper.PnLItem

--select * from tblPromoProfitAndLossTwo where promotionID = @promotionID
--order by finCostTypeID, PnLItem
--select * from @tblSubItem
--order by finCostTypeID, pnlGroup, pnlItem

insert into tblPromoProfitAndLossDetailTwo (promoProfitAndLossTwoID, pnlSubItem, finCostTypeID, finAmount, promotionID)
select 
promopnl.promoProfitAndLossTwoID, subitem.pnlSubItem, subitem.finCostTypeID, sum(subitem.finAmount), promopnl.promotionID
from @tblSubItem subitem
inner join tblProfitAndLossHelper helper on helper.PnLSubGroup = subitem.pnlItem and helper.PnlGroup = subitem.pnlGroup
	and helper.PnLSubGroupItem = subitem.pnlSubItem
inner join tblPromoProfitAndLossTwo promopnl on promopnl.pnlitem = helper.PnLItem and promopnl.finCostTypeID = subitem.finCostTypeID
where promopnl.promotionID = @promotionID and helper.countryID = @CountryID
group by promopnl.promoProfitAndLossTwoID, subitem.pnlSubItem, subitem.finCostTypeID, promotionID
--order by subitem.finCostTypeID, helper.PnlGroup, PnLSubGroup


end
END

