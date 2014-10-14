-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 19 Aug 2014
-- Description:	insert budget owner's data
-- =============================================
CREATE PROCEDURE [dbo].[spx_CalculateBudgetOverview] 
@countryID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

Declare @createdDate as date
set @createdDate = getdate()

select @createdDate as createdDate

insert into tblBudgetOverview (createdDate, startTime, endTime, countryID)
values (@createdDate, getdate(), null, @countryID)

Declare @id as int
Set @id = SCOPE_IDENTITY()

Declare @year as int
Set @year = datepart(year, getdate())

Declare @tblCusGroup as table
(
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int
)

Declare @tblCustomer as table
(
	customerID int,
	cusGroup5ID int,
	cusGroup6ID int,
	validFrom datetime, 
	validTo datetime
)
Declare @tblSecCustomer as table
(
	customerID int,
	secCustomerID int,
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	validFrom datetime, 
	validTo datetime
)

-- get all combination of cusgroup5/cusgroup6 and secgroup2 from tblBudgetAllocation

insert into @tblCusGroup (cusGroup5ID, cusGroup6ID, secGroup2ID)
select distinct cusGroup5ID, cusGroup6ID, secGroup2ID from tblBudgetAllocation where balBudgetNr = 0 and balYear = @year

select * from @tblCusGroup

insert into @tblCustomer
select customerID, cusGroup.cusGroup5ID, cusGroup.cusGroup6ID, cust.validFrom, cust.validTo from tblCustomer cust
inner join @tblCusGroup cusgroup on cusgroup.cusGroup5ID = cust.cusGroup5ID and cusgroup.cusGroup6ID = cust.cusGroup6ID

insert into @tblSecCustomer
select seccust.customerid, secondaryCustomerID, cusGroup.cusGroup5ID, cusGroup.cusGroup6ID, cusGroup.secGroup2ID, seccust.validFrom, seccust.validTo 
from tblSecondaryCustomer seccust
inner join tblCustomer cust on cust.customerID = seccust.customerID
inner join @tblCusGroup cusGroup on cusGroup.secGroup2ID = seccust.secGroup2ID and cusgroup.cusGroup5ID = cust.cusGroup5ID 
	and cusGroup.cusGroup6ID = cust.cusGroup6ID

-- tblTopRight

-- STEP 1,2,2A,2B,3,4,4A & 4B

Declare @min smallint, @max smallint

select @min = min(bal.balBudgetNr), @max = max(bal.balBudgetNr) 
from tblBudgetAllocation bal 
inner join (select cusGroup5ID, cusGroup6ID, secGroup2ID from @tblCusGroup) cust 
	on (bal.cusGroup5ID = cust.cusGroup5ID and bal.cusGroup6ID = cust.cusGroup6ID)
	and (bal.secGroup2ID = cust.secGroup2ID or (bal.secGroup2ID is null and cust.secGroup2ID is null))
where bal.balYear = @year and bal.countryID = @countryID

--select @min min, @max max

Declare @tblTop2 as table
(
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	rowCode varchar(50),
	Budget float,
	latestRF float
)

insert into @tblTop2
select 
cusGroup5ID, cusGroup6ID, secGroup2ID,
[desc], [0] Budget, isnull([99],0) latestRF --, rowOrder, rowGroup, rowSubGroup, rowBold
from
(
select
cusGroup5ID, cusGroup6ID, secGroup2ID,
balBudgetNr, [desc], [amount]
from
(
select bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID,
case when bal.balBudgetNr = @max then 99 else bal.balBudgetNr end balBudgetNr,
bal.balTotalTradeSpendPerc, 
bal.balFixedTT, bal.balListFee, bal.balCDF, fts,
sum(baf.budGrossSales) GSV,
case when sum(baf.budGrossSales) = 0 then 0
else ((balTotalTradeSpendPerc - fts) * sum(baf.budGrossSales) - balListFee - balCDF - balFixedTT) / sum(baf.budGrossSales) end promoInv--(balTotalTradeSpendPerc - fts) * 
From
(
select 
bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID, bal.balYear, 
balBudgetNr, 
avg(bal.balTotalTradeSpendPerc) balTotalTradeSpendPerc , avg(bal.balFixedTT) balFixedTT, avg(bal.balListFee) balListFee, avg(balCDF) balCDF,
avg(isnull(ConRebF,0) + isnull(DistTargetF,0) + isnull(LightF,0) + isnull(CdisDistDevF,0) + isnull(DispMtF,0) + isnull(SpaceBuyGtF,0) + isnull(ComAssortF,0) + 
isnull(CatManF,0) + isnull(AnnivF,0) + isnull(TprF,0) + isnull(EdlpDiscountF,0) + isnull(FeatureCostF,0) + isnull(LocPromoF,0) + isnull(MailAdvF,0) + 
isnull(UnconRebateF,0) + isnull(UllagesF,0) + isnull(NewStoreF,0) + isnull(DcAllowF,0)) fts
from tblBudgetAllocation bal 
inner join (select cusGroup5ID, cusGroup6ID, secGroup2ID from @tblCusGroup) cust 
	on (bal.cusGroup5ID = cust.cusGroup5ID and bal.cusGroup6ID = cust.cusGroup6ID)
	and (bal.secGroup2ID = cust.secGroup2ID or (bal.secGroup2ID is null and cust.secGroup2ID is null))
where bal.balYear = @year and balBudgetNr in (@min, @max) and bal.countryID = @countryID
group by bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID, bal.balYear, bal.balBudgetNr
) bal
left outer join 
	(select budYear, budBudgetNr, cusGroup5ID, cusGroup6ID, secGroup2ID, 
	sum(budGrossSales) budGrossSales 
	from tblBudgetAndForecast where budYear = @year and countryID = @countryID
		and budBudgetNr in (@min, @max)
	group by budYear, budBudgetNr, cusGroup5ID, cusGroup6ID, secGroup2ID) 
	baf 
	on baf.budYear = bal.balYear and baf.budBudgetNr = bal.balBudgetNr and 
	(baf.cusGroup5ID = bal.cusGroup5ID and baf.cusGroup6ID = bal.cusGroup6ID)
	and (bal.secGroup2ID = baf.secGroup2ID or (bal.secGroup2ID is null and baf.secGroup2ID is null))
group by bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID, bal.balYear, balBudgetNr,
bal.balTotalTradeSpendPerc , bal.balFixedTT, bal.balListFee, balCDF, fts
) p
unpivot 
(
	[amount] for [desc]
	in
	(
		balTotalTradeSpendPerc,
		balFixedTT,
		balListFee,
		balCDF,
		GSV,
		promoInv,
		fts
	)
) pvt
) p2
pivot
(
	avg([amount])
	for [balBudgetNr] in
	(
		[0], [99]
	)
) pvt2

select * from @tblTop2

insert into tblBudgetOverviewSummary 
	(budgetOverviewID, countryID, rowCode, cusGroup5ID, cusGroup6ID, secGroup2ID, budget, latestRF)
select @id, @countryID, rowCode, cusGroup5ID, cusGroup6ID, secGroup2ID, Budget, latestRF 
from @tblTop2

--select rowCode, isnull(rowAmount,0) rowAmount, rowPivot
--from
--(
--select rowCode, isnull(budget,0) budget, isnull(latestRF, 0) latestRF from @tblTop2
--) p 
--unpivot 
--(
--rowAmount for rowPivot in (Budget, latestRF)
--)as unpvt


Declare @tblMonth as table
(
	monthId int
)
Declare @ctr as smallint
Set @ctr = 1
while @ctr <= 12
begin
	insert into @tblMonth
	values (@ctr)
	set @ctr = @ctr + 1
end

Declare @budgetOverview as table
(
	rowStep float,
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	rowMonth int,
	rowCode varchar(50),
	rowAmount float
)

-- STEP 5
insert into @budgetOverview
select 
5, baf.cusGroup5ID, baf.cusGroup6ID, baf.secGroup2ID, monthDate, 'budget', sum(budGrossSales) GSV 
from tblBudgetAndForecast baf
inner join (select cusGroup5ID, cusGroup6ID, secGroup2ID from @tblCusGroup) cust
	on (baf.cusGroup5ID = cust.cusGroup5ID and baf.cusGroup6ID = cust.cusGroup6ID)
	and (cust.secGroup2ID = baf.secGroup2ID or (cust.secGroup2ID is null and baf.secGroup2ID is null))
where baf.budBudgetNr = 0 and baf.budYear = @year and baf.countryID = @countryID
group by budBudgetNr, monthDate, baf.cusGroup5ID, baf.cusGroup6ID, baf.secGroup2ID

-- STEP 6,7,8,9
insert into @budgetOverview
select
rowstep, 
cusGroup5ID, cusGroup6ID, secGroup2ID,
monthId,  
case when [Description] = 'latestRF' then [Description]
else [Description] + '1' end [Description],		
Amount
from
(
select 6 as rowStep, 
cusGroup5ID, cusGroup6ID, secGroup2ID,
monthId,
GSV latestRF,
(ConRebF + DistTargetF) as rebates, 
(LightF + CdisDistDevF) as sellout, 
(DispMtF + SpaceBuyGtF + ComAssortF + CatManF) as display, 
(AnnivF + TprF + EdlpDiscountF + FeatureCostF + LocPromoF) as promotion, 
MailAdvF as advertising, 
(UnconRebateF + UllagesF) as sellin, 
NewStoreF as assets, 
DcAllowF as distribution
from
(
select 
cust.cusGroup5ID, cust.cusGroup6ID, null secGroup2ID,
cast(right(inacr.MonthDate,2) as int) monthId, sum(isnull(inacr.GrossSales,0)) GSV,
sum(isnull(inacr.ConRebF,0)) ConRebF, sum(isnull(inacr.DistTargetF,0)) DistTargetF, sum(isnull(inacr.LightF,0)) LightF,
sum(isnull(inacr.CdisDistDevF,0)) CdisDistDevF, sum(isnull(inacr.DispMtF,0)) DispMtF, sum(isnull(inacr.SpaceBuyGtF,0)) SpaceBuyGtF,
sum(isnull(inacr.ComAssortF,0)) ComAssortF, sum(isnull(inacr.CatManF,0)) CatManF, sum(isnull(inacr.AnnivF,0)) AnnivF,
sum(isnull(inacr.TprF,0)) TprF, sum(isnull(inacr.EdlpDiscountF,0)) EdlpDiscountF, sum(isnull(inacr.FeatureCostF,0)) FeatureCostF,
sum(isnull(inacr.LocPromoF,0)) LocPromoF, sum(isnull(inacr.MailAdvF,0)) MailAdvF, sum(isnull(inacr.UnconRebateF,0)) UnconRebateF,
sum(isnull(inacr.UllagesF,0)) UllagesF, sum(isnull(inacr.NewStoreF,0)) NewStoreF, sum(isnull(inacr.DcAllowF,0)) DcAllowF
from tblInAcrPnl inacr
inner join @tblCustomer cust on cust.customerID = inacr.customerID-- and cust.secGroup2ID is null
where inacr.countryID = @countryID and cast(left(inacr.MonthDate,4) as int) = @year and cast(right(inacr.MonthDate,2) as int) < datepart(month, getdate())
group by inacr.MonthDate, cust.cusGroup5ID, cust.cusGroup6ID
union
select 
seccust.cusGroup5ID, seccust.cusGroup6ID, seccust.secGroup2ID,
cast(right(outacr.MonthDate,2) as int) monthId, sum(isnull(outacr.GrossSales,0)) GSV,
sum(isnull(outacr.ConRebF,0)) ConRebF, sum(isnull(outacr.DistTargetF,0)) DistTargetF, sum(isnull(outacr.LightF,0)) LightF,
sum(isnull(outacr.CdisDistDevF,0)) CdisDistDevF, sum(isnull(outacr.DispMtF,0)) DispMtF, sum(isnull(outacr.SpaceBuyGtF,0)) SpaceBuyGtF,
sum(isnull(outacr.ComAssortF,0)) ComAssortF, sum(isnull(outacr.CatManF,0)) CatManF, sum(isnull(outacr.AnnivF,0)) AnnivF,
sum(isnull(outacr.TprF,0)) TprF, sum(isnull(outacr.EdlpDiscountF,0)) EdlpDiscountF, sum(isnull(outacr.FeatureCostF,0)) FeatureCostF,
sum(isnull(outacr.LocPromoF,0)) LocPromoF, sum(isnull(outacr.MailAdvF,0)) MailAdvF, sum(isnull(outacr.UnconRebateF,0)) UnconRebateF,
sum(isnull(outacr.UllagesF,0)) UllagesF, sum(isnull(outacr.NewStoreF,0)) NewStoreF, sum(isnull(outacr.DcAllowF,0)) DcAllowF
from tblOutAcrPnl outacr
inner join @tblSecCustomer seccust on seccust.customerID = outacr.customerID and seccust.secCustomerID = outacr.secondaryCustomerID
where outacr.countryID = @countryID and cast(left(outacr.MonthDate,4) as int) = @year and cast(right(outacr.MonthDate,2) as int) < datepart(month, getdate())
group by outacr.MonthDate, seccust.cusGroup5ID, seccust.cusGroup6ID, seccust.secGroup2ID
) step68
union
select 
7 as rowstep, 
cusGroup5ID, cusGroup6ID, secGroup2ID,
monthDate,
GSV,
-GSV * (ConRebF + DistTargetF) as Rebates, 
-GSV * (LightF + CdisDistDevF) as SellOutReimbursement, 
-GSV * (DispMtF + SpaceBuyGtF + ComAssortF + CatManF) as Displays, 
-GSV * (AnnivF + TprF + EdlpDiscountF + FeatureCostF + LocPromoF) as Promotions, 
-GSV * MailAdvF as Advertising, 
-GSV * (UnconRebateF + UllagesF) as SellInRebates, 
-GSV * NewStoreF as AssetsManagement, 
-GSV * DcAllowF as Distribution
from
(
select 
cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID,
budBudgetNr, monthDate, sum(isnull(budGrossSales,0)) GSV,
avg(isnull(ftt.ConRebF,0)) ConRebF, avg(isnull(ftt.DistTargetF,0)) DistTargetF, avg(isnull(ftt.LightF,0)) LightF,
avg(isnull(ftt.CdisDistDevF,0)) CdisDistDevF, avg(isnull(ftt.DispMtF,0)) DispMtF, avg(isnull(ftt.SpaceBuyGtF,0)) SpaceBuyGtF,
avg(isnull(ftt.ComAssortF,0)) ComAssortF, avg(isnull(ftt.CatManF,0)) CatManF, avg(isnull(ftt.AnnivF,0)) AnnivF,
avg(isnull(ftt.TprF,0)) TprF, avg(isnull(ftt.EdlpDiscountF,0)) EdlpDiscountF, avg(isnull(ftt.FeatureCostF,0)) FeatureCostF,
avg(isnull(ftt.LocPromoF,0)) LocPromoF, avg(isnull(ftt.MailAdvF,0)) MailAdvF, avg(isnull(ftt.UnconRebateF,0)) UnconRebateF,
avg(isnull(ftt.UllagesF,0)) UllagesF, avg(isnull(ftt.NewStoreF,0)) NewStoreF, avg(isnull(ftt.DcAllowF,0)) DcAllowF
from tblBudgetAndForecast baf
inner join (select cusGroup5ID, cusGroup6ID, secGroup2ID from @tblCusGroup) cust
	on (baf.cusGroup5ID = cust.cusGroup5ID and baf.cusGroup6ID = cust.cusGroup6ID)
	and (cust.secGroup2ID = baf.secGroup2ID or (cust.secGroup2ID is null and baf.secGroup2ID is null))
inner join tblBudgetAllocation ftt  
	on ((ftt.cusGroup5ID = cust.cusGroup5ID and ftt.cusGroup6ID = cust.cusGroup6ID)
	and (cust.secGroup2ID = ftt.secGroup2ID or (cust.secGroup2ID is null and ftt.secGroup2ID is null)))
	and ftt.balBudgetNr = baf.budBudgetNr and ftt.balYear = baf.budYear
where baf.countryID = @countryID 
and baf.monthDate >= datepart(month, getdate())
and baf.budBudgetNr = @max and baf.budYear = @year
group by budBudgetNr, monthDate, cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID
) step79
) p
unpivot
(
Amount for Description in (latestRF, rebates, sellout, display, promotion, advertising, sellin, assets, distribution)
) unpvt

-- Lisa commented (05.09.2014) --> TradeSpend = Month.TotalSpend
--insert into @budgetOverview
--select 5.5, 
--cusGroup5ID, cusGroup6ID, secGroup2ID,
--rowMonth, 'tradeSpend', sum(rowAmount)
--from @budgetOverview 
--where rowCode in ('budget','latestRF')
--group by cusGroup5ID, cusGroup6ID, secGroup2ID, rowMonth

-- STEP 10,11

Declare @tblHelper as table
(
	pnlcode INT, PnlSubGroup NVARCHAR(50), PnlSubGroupItem NVARCHAR(50)
)

insert into @tblHelper
select pnlcode,PnLSubGroup,PnLSubGroupItem from tblProfitAndLossHelper
where IncludedInBudget = 1

Declare @tbl10AB11AB as table
(
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	monthId int,
	pnlID int,
	rtbAmount float
)

insert into @tbl10AB11AB
select
cust.cusGroup5ID, cust.cusGroup6ID, null secGroup2ID,
datepart(month, daydate) monthId, recb.pnlID, sum(rtbAmount) rtbAmount
from tblRecTypeB recb
inner join @tblCustomer cust on cust.customerID = recb.customerID
inner join tblCustomer custm on custm.customerID = recb.customerID and recb.dayDate between custm.validFrom and custm.validTo
	and  cust.cusGroup5ID = custm.cusGroup5ID 
	and cust.cusGroup6ID = custm.cusGroup6ID 
inner join 
(
select
distinct bal.cusGroup5ID, bal.cusGroup6ID, pnlmap.pnlID
from tblBudgetAllocation bal 
inner join (select cusGroup5ID, cusGroup6ID from @tblCusGroup where secGroup2ID is null) cust
	on cust.cusGroup5ID = bal.cusGroup5ID and cust.cusGroup6ID = bal.cusGroup6ID and bal.secGroup2ID is null
inner join tblPromotionPnLMapping pnlmap on pnlmap.finGeneralLedgerCode in (bal.balFixedTTGL, bal.balFixedTTGLTwo)
where bal.countryID = @countryID
) bal on bal.cusGroup5ID = cust.cusGroup5ID and bal.cusGroup6ID = cust.cusGroup6ID 
where recb.countryID = @countryID and (recb.pnlID = bal.pnlID) 
	and DATEPART(year, dayDate) = @year and DATEPART(month, dayDate) < DATEPART(month, getdate())
group by datepart(month, daydate), recb.pnlID, cust.cusGroup5ID, cust.cusGroup6ID
union
select
cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID,
datepart(month, daydate) monthId, recb.pnlID, sum(rtbAmount) rtbAmount
from tblRecTypeB recb
inner join (select distinct customerID, cusGroup5ID, cusGroup6ID, secGroup2ID from @tblSecCustomer) cust on recb.customerID = cust.customerID
inner join 
(
select
distinct bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID, pnlmap.pnlID
from tblBudgetAllocation bal 
inner join @tblCusGroup cust
	on cust.secGroup2ID = bal.secGroup2ID and cust.cusGroup5ID = bal.cusGroup5ID and cust.cusGroup6ID = bal.cusGroup6ID
inner join tblPromotionPnLMapping pnlmap on pnlmap.finGeneralLedgerCode in (bal.balFixedTTGL, bal.balFixedTTGLTwo)
where bal.countryID = @countryID
) bal on bal.secGroup2ID = cust.secGroup2ID and bal.cusGroup5ID = cust.cusGroup5ID and bal.cusGroup6ID = cust.cusGroup6ID
where recb.countryID = @countryID and (recb.pnlID = bal.pnlID)
	and DATEPART(year, dayDate) = @year and DATEPART(month, dayDate) < DATEPART(month, getdate())
group by datepart(month, daydate), recb.pnlID, cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID

insert into @tbl10AB11AB
select
bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID,
monthId, tblMonth.pnlcode, isnull(rtbAmount,0)
from 
(
select
distinct monthId, helper.pnlcode
from 
@tblMonth tblMonth , @tblHelper helper 
where monthId >= DATEPART(month, getdate())) tblMonth
inner join
(
select
cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID,
helper.PnLCode, 
((sum(bal.balFixedTT) - sum(tbl10AB.rtbAmount)) / ((12 - datepart(month, getdate()) + 1))) * -1 rtbAmount
from tblBudgetAllocation bal 
inner join @tblCusGroup cust
	on (cust.cusGroup5ID = bal.cusGroup5ID and cust.cusGroup6ID = bal.cusGroup6ID)
	and (cust.secGroup2ID = bal.secGroup2ID or (cust.secGroup2ID is null and bal.secGroup2ID is null))
inner join (select distinct finGeneralLedgerCode, pnlID from tblPromotionPnLMapping) pnlmap on pnlmap.finGeneralLedgerCode in (bal.balFixedTTGL, bal.balFixedTTGLTwo)
inner join @tblHelper helper on helper.PnLCode = pnlmap.pnlID 
inner join @tbl10AB11AB tbl10AB on tbl10AB.pnlID = helper.PnLCode
where bal.countryID = @countryID and bal.balYear = @year
group by cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID, PnLCode
) bal on bal.PnLCode = tblMonth.pnlcode

insert into @budgetOverview
select 10, cusGroup5ID, cusGroup6ID, secGroup2ID, monthID, 
case helper.PnLSubGroup
	when 'Rebates' then 'rebates2' 
	when 'SellOutReimbursement' then 'sellout2'
	when 'Displays' then 'display2'
	when 'Promotions' then 'promotion2'
	when 'SellInRebates' then 'sellin2'
	when 'AssetsManagement' then 'assets2'
	when 'Advertising' then 'advertising2'
	when 'Distribution' then 'distribution2'
end,
sum(rtbAmount) 
from @tbl10AB11AB tbl10
inner join tblProfitAndLossHelper helper on helper.PnLCode = tbl10.pnlID
group by helper.PnLSubGroup, monthId, cusGroup5ID, cusGroup6ID, secGroup2ID
order by monthId

insert into @budgetOverview
select 11.5, cusGroup5ID, cusGroup6ID, secGroup2ID, rowMonth, 'ftTerms', sum(rowAmount)
from @budgetOverview
where rowStep in (6,7,10) and rowCode <> 'latestRF'
group by rowMonth, cusGroup5ID, cusGroup6ID, secGroup2ID

--STEP 12-15

Declare @tbl1215 as table
(
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	monthId int,
	pnlID int,
	rtbAmount float
)

insert into @tbl1215
select
cusGroup5ID, cusGroup6ID, secGroup2ID,
monthId, helper.PnLCode, -sum(rtbAmount) rtbAmount
from 
(
select
cust.cusGroup5ID, cust.cusGroup6ID, null secGroup2ID,
datepart(month, daydate) monthId, recb.pnlID, sum(rtbAmount) rtbAmount
from tblRecTypeB recb
inner join @tblCustomer cust on cust.customerID= recb.customerID 
inner join tblCustomer custm on custm.customerID = recb.customerID and recb.dayDate between custm.validFrom and custm.validTo
	and cust.cusGroup5ID = custm.cusGroup5ID 
	and cust.cusGroup6ID = custm.cusGroup6ID 
inner join 
(
select
distinct bal.cusGroup5ID, bal.cusGroup6ID, pnlmap.pnlID
from tblBudgetAllocation bal 
inner join (select cusGroup5ID, cusGroup6ID from @tblCusGroup where secGroup2ID is null) cust
	on cust.cusGroup5ID = bal.cusGroup5ID and cust.cusGroup6ID = bal.cusGroup6ID and bal.secGroup2ID is null
inner join tblPromotionPnLMapping pnlmap on pnlmap.pnlID in (102063,102049) and pnlmap.finGeneralLedgerCode in (bal.balFixedTTGL, bal.balFixedTTGLTwo)
where bal.countryID = @countryID
) bal on bal.cusGroup5ID = cust.cusGroup5ID and bal.cusGroup6ID = cust.cusGroup6ID
where recb.countryID = @countryID and (recb.pnlID = bal.pnlID) 
	and DATEPART(year, dayDate) = @year and DATEPART(month, dayDate) < DATEPART(month, getdate())
group by datepart(month, daydate), recb.pnlID, cust.cusGroup5ID, cust.cusGroup6ID
union
select
bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID,
datepart(month, daydate) monthId, recb.pnlID, sum(rtbAmount) rtbAmount
from tblRecTypeB recb
inner join (select distinct customerID, cusGroup5ID, cusGroup6ID, secGroup2ID from @tblSecCustomer) cust on recb.customerID = cust.customerID 
inner join 
(
select
distinct bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID, pnlmap.pnlID
from tblBudgetAllocation bal 
inner join (select cusGroup5ID, cusGroup6ID, secGroup2ID from @tblCusGroup where secGroup2ID is not null) cust
	on cust.secGroup2ID = bal.secGroup2ID and cust.cusGroup5ID = bal.cusGroup5ID and cust.cusGroup6ID = bal.cusGroup6ID
inner join tblPromotionPnLMapping pnlmap on pnlmap.pnlID in (102063,102049) and pnlmap.finGeneralLedgerCode in (bal.balFixedTTGL, bal.balFixedTTGLTwo)
where bal.countryID = @countryID
) bal on bal.secGroup2ID = cust.secGroup2ID and bal.cusGroup5ID = cust.cusGroup5ID and bal.cusGroup6ID = cust.cusGroup6ID
where recb.countryID = @countryID and (recb.pnlID = bal.pnlID)
	and DATEPART(year, dayDate) = @year and DATEPART(month, dayDate) < DATEPART(month, getdate())
group by datepart(month, daydate), recb.pnlID, bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID
) bal inner join (select distinct pnlID pnlCode from tblPromotionPnLMapping where pnlID in (102063,102049)) helper on helper.PnLCode = bal.pnlID --and helper.IncludedInBudget = 1
group by bal.monthId, helper.PnLCode, bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID
--) bal on bal.monthId = tblmonth.monthId and bal.pnlcode = tblmonth.PnLCode

insert into @tbl1215
select
bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID,
tblMonth.monthId, tblMonth.PnLCode, isnull(bal.rtbAmount,0)
from 
(
select
distinct monthId, helper.PnLCode
from 
@tblMonth tblMonth ,  (select distinct pnlID pnlCode from tblPromotionPnLMapping where pnlID in (102063,102049)) helper 
where monthId >= DATEPART(month, getdate())) tblMonth
inner join
(
select
case bal.RowCode when 'balListFee' then 102063 
	when 'balCDF' then 102049 end PnLCode, 
cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID, bal.rowCode, 
-1 * ((sum(bal.Budget) + sum(isnull(tbl12.rtbAmount,0))) / ((12 - datepart(month, getdate()) + 1))) rtbAmount
--	bal.Budget, bal.latestRF -- sum(bal.balListFee), sum(bal.balCDF)
from @tblTop2 bal 
inner join @tblCusGroup cust
	on (cust.cusGroup5ID = bal.cusGroup5ID and cust.cusGroup6ID = bal.cusGroup6ID)
		AND (cust.secGroup2ID = bal.secGroup2ID or (cust.secGroup2ID is null and bal.secGroup2ID is null))
left outer join @tbl1215 tbl12 on ((tbl12.cusGroup5ID = bal.cusGroup5ID and tbl12.cusGroup6ID = bal.cusGroup6ID)
	AND (tbl12.secGroup2ID = bal.secGroup2ID or (tbl12.secGroup2ID is null and bal.secGroup2ID is null)))
	and ((tbl12.pnlID = 102063 and bal.RowCode = 'balListFee') or (tbl12.pnlID = 102049 and bal.RowCode = 'balCDF'))--tbl12.pnlID in (102063, 102049)
where bal.rowcode in ('balListFee', 'balCDF')
group by bal.rowCode, cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID
) bal on bal.PnLCode = tblMonth.PnLCode
where tblMonth.monthId >= datepart(month, getdate())

insert into @budgetOverview
select 12, cusGroup5ID, cusGroup6ID, secGroup2ID, 
monthID, 
case tbl12.pnlID
	when 102063 then 'listingfee' 
	when 102049 then 'cdf'
end,
sum(rtbAmount) 
from @tbl1215 tbl12
group by tbl12.pnlID, monthId, cusGroup5ID, cusGroup6ID, secGroup2ID
order by monthId

-- STEP 16-19

Declare @startOfYear as datetime
Declare @endOfYear as datetime
Declare @endOfLastMonth as datetime

set @startOfYear = cast('01-Jan-' + cast(@year as varchar(5)) as datetime) 
set @endOfYear = cast('31-Dec-' + cast(@year as varchar(5)) as datetime) 
set @endOfLastMonth = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))

Declare @budgetNr as table
(
	budgetNr int,
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	amount float
)

Set @ctr = 0

while @ctr < 4
begin
	insert into @budgetNr --(budgetNr, amount)
	select @ctr, cusGroup5ID, cusGroup6ID, secGroup2ID, sum(rowAmount) rowAmount from @budgetOverview
	where rowCode in ('budget', 'latestRF') and
	rowMonth in ((@ctr * 3)+1, (@ctr * 3)+2, (@ctr * 3)+3)
	group by cusGroup5ID, cusGroup6ID, secGroup2ID

	set @ctr = @ctr + 1
end

--pnlcode INT, PnlSubGroup NVARCHAR(50), PnlSubGroupItem NVARCHAR(50)

insert into @tblHelper(pnlcode, PnlSubGroup, PnlSubGroupItem)
values (102049, 'CDF', 'CDF')

--if not exists (select top 1 secgroup2id from @tblSecCustomer)
begin
	insert into @budgetOverview
	select
	19, cusGroup5ID, cusGroup6ID, null, monthID, 
	case PnLSubGroup
		when 'Rebates' then 'rebates' 
		when 'SellOutReimbursement' then 'sellout'
		when 'Displays' then 'display'
		when 'Promotions' then 'promotion'
		when 'SellInRebates' then 'sellin'
		when 'AssetsManagement' then 'assets'
		when 'Advertising' then 'advertising'
		when 'Distribution' then 'distribution'
		when 'CDF' then 'cdf'
	end + codeIdx, sum(rtbAmount)
	from
	(
		select
		16 as rowStep, '3' as codeIdx, cusGroup5ID, cusGroup6ID, null secGroup2ID, 
		datepart(month, recB.dayDate) monthID, helper.PnLSubGroup, sum(recb.rtbAmount) rtbAmount--, prm.prmStatusID
		from
		(
			select
			prmCust.customerID, prm.promotionID, prm.prmPromotionClientCode, cust.cusGroup5ID, cust.cusGroup6ID--, prm.prmStatusID
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoCust prmCust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID and prm.prmStatusID in (12)
				and (prm.prmDateStart between @startOfYear
					and @endOfLastMonth
				or prm.prmDateEnd between @startOfYear
					and @endOfLastMonth)
			inner join @tblCustomer cust on cust.customerID = prmcust.customerID
				 and prm.prmDateStart between cust.validFrom and cust.validTo
			where prm.countryID = @countryID and prm.isDeleted = 0
		) prm
		inner join tblRecTypeB recB WITH (NOLOCK) on recB.customerID = prm.customerID and recb.promotionID = prm.promotionID
			and recB.dayDate between @startOfYear
				and @endOfLastMonth
		inner join @tblHelper helper on helper.PnLCode = recb.pnlID
		where recb.countryID = @countryID
		group by datepart(month, recB.dayDate), helper.PnLSubGroup, cusGroup5ID, cusGroup6ID--, prm.prmStatusID
	union
		select
		17 as rowStep, '4', prm.cusGroup5ID, prm.cusGroup6ID, null, 
		datepart(month, recB.dayDate) monthID, helper.PnLSubGroup, sum(recb.rtbAmount) rtbAmount--, prm.prmStatusID
		from
		(
			select
			prmCust.customerID, prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID--, prm.prmStatusID
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoCust prmCust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID and prm.prmStatusID in (9,10,11)
				and (prm.prmDateStart between @startOfYear
					and @endOfLastMonth
				or prm.prmDateEnd between @startOfYear
					and @endOfLastMonth)
			inner join @tblCustomer cust on cust.customerID = prmcust.customerID and prm.prmDateStart between cust.validFrom and cust.validTo
			--inner join 
			--(select distinct cusgroup5Id, cusGroup6id from @tblCust) custgrp on custgrp.cusGroup5ID = cust.cusGroup5ID
			--	and custgrp.cusGroup6ID = cust.cusGroup6ID
			where prm.countryID = @countryID and prm.isDeleted = 0
		) prm
		inner join tblRecTypeB recB WITH (NOLOCK) on recB.customerID = prm.customerID and recB.promotionID = prm.promotionID --recb.rtbHeader = prm.prmPromotionClientCode
			and recB.dayDate between @startOfYear
				and @endOfLastMonth
		inner join @tblHelper helper on helper.PnLCode = recb.pnlID
		where recb.countryID = @countryID
		group by datepart(month, recB.dayDate), helper.PnLSubGroup, cusGroup5ID, cusGroup6ID--, prm.prmStatusID

	union
	select 
	18, '4', fin.cusGroup5ID, fin.cusGroup6ID, null secGroup2ID, 
	tblMonth.monthId, helper.PnLSubGroup, isnull(fin.rtbAmount,0) rtbAmount
	from 
	(select * from @tblMonth where monthId >= datepart(month, getdate())) tblMonth 
	, (select distinct pnlSubGroup from @tblHelper) helper
	inner join
	(
		select recb.cusGroup5ID, recb.cusGroup6ID, helper.PnlSubGroup, -(sum(finAmount) - sum(rtbAmount)) / ((12 - datepart(month, getdate()) + 1)) rtbAmount
		from
		(
			select
			cust.cusGroup5ID, cust.cusGroup6ID, helper.pnlcode, sum(rtbAmount) rtbAmount
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoCust prmCust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID and prm.prmStatusID in (9)
				and getdate() between prm.prmDateStart and prm.prmDateEnd
			inner join @tblCustomer cust on cust.customerID = prmcust.customerID 
				and prm.prmDateStart between cust.validFrom and cust.validTo
			--inner join 
			--(select distinct cusgroup5Id, cusGroup6id from @tblCust) custgrp on custgrp.cusGroup5ID = cust.cusGroup5ID
			--	and custgrp.cusGroup6ID = cust.cusGroup6ID
			inner join tblRecTypeB recB WITH (NOLOCK) on recB.customerID = prmCust.customerID 
				and recB.dayDate between @startOfYear and getdate()
				and recB.promotionID = prm.promotionID --recB.rtbHeader = prm.prmPromotionClientCode
			inner join @tblHelper helper on helper.pnlcode = recB.pnlID
			where prm.countryID = @countryID and prm.isDeleted = 0
			group by helper.pnlcode, cust.cusGroup5ID, cust.cusGroup6ID
		) recb inner join
		(
			select prm.cusGroup5ID, prm.cusGroup6ID, helper.pnlcode, sum(fin.finAmount * (budgetNr.amount / prm.prmGrossSales)) finAmount 
			from
			(
			select distinct prm.promotionID, prm.prmBudgetNr, cust.cusGroup5ID, cust.cusGroup6ID, prm.prmGrossSales 
			--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoCust prmcust WITH (NOLOCK) on prmcust.promotionId = prm.promotionID
			inner join @tblCustomer cust on cust.customerID = prmcust.customerId
			where prm.countryID = @countryID and prm.isDeleted = 0 and prm.prmDateStart between cust.ValidFrom and cust.ValidTo 
			and prm.prmStatusID in (9) and getdate() between prm.prmDateStart and prm.prmDateEnd
			) prm
			inner join tblPromoFinancial fin WITH (NOLOCK) on fin.promotionID = prm.promotionID and fin.finCostTypeID = 1
			inner join @tblHelper helper on helper.pnlcode = fin.pnlID			
			inner join @budgetNr budgetNr on budgetNr.budgetNr = prm.prmBudgetNr and budgetnr.cusGroup5ID = prm.cusGroup5ID
				and budgetnr.cusGroup6ID = prm.cusGroup6ID and budgetNr.secGroup2ID is null
			group by helper.pnlcode, prm.cusGroup5ID, prm.cusGroup6ID
		) prmfin on (recb.pnlcode = prmfin.pnlcode) and recb.cusGroup5ID = prmfin.cusGroup5ID
			and recb.cusGroup6ID = prmfin.cusGroup6ID
		inner join @tblHelper helper on helper.pnlCode = recb.pnlcode and helper.pnlcode = prmfin.pnlcode
		group by helper.PnlSubGroup, recb.cusGroup5ID, recb.cusGroup6ID
	) fin on fin.PnLSubGroup = helper.PnLSubGroup

	union
	select
	19, '4', cusGroup5ID, cusGroup6ID, null,
	tblMOnth.monthId, PnlSubGroup,
	-sum(
		CASE 
		--WHEN datepart(MONTH,prm.prmDateEnd) < tblMonth.monthId THEN 0
		WHEN datepart(Month,prm.prmDateEnd) = tblMonth.monthId THEN 
			CASE WHEN datepart(Month,prm.prmDateStart) < tblMonth.monthId THEN
				(prm.finAmount*datepart(DAY,prm.prmDateEnd))/(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1)
				WHEN datepart(Month,prm.prmDateStart) = tblMonth.monthId THEN	isnull(prm.finAmount,0)
			END
		WHEN datepart(Month,prm.prmDateEnd) > tblMonth.monthId THEN
			CASE WHEN datepart(Month,prm.prmDateStart) < tblMonth.monthId THEN
				(prm.finAmount* DAY(dbo.fGetEndOfMonth(prm.prmDateStart)) )/(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1) -- fix
				WHEN datepart(Month,prm.prmDateStart) = tblMonth.monthId THEN
				(prm.finAmount* (DAY(dbo.fGetEndOfMonth(prm.prmDateStart))-datepart(DAY,prm.prmDateStart)+1))/(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1) -- fix
				ELSE 0
			END
		ELSE 0 
		END
	) as Amount
	from
	(select * from @tblMonth where monthId >= datepart(month, getdate())) tblMonth 
	--cross join (select distinct pnlSubGroup from @tblHelper) helper 
	inner join
	(
		select
		prm.promotionID, prm.prmDateStart, prm.prmDateEnd, prm.PnlSubGroup, sum(finAmount) finAmount, prm.cusGroup5ID, prm.cusGroup6ID
		from 
		(
			select prm.PromotionID, prm.prmDateStart, prm.prmDateEnd, prm.cusGroup5ID, prm.cusGroup6ID, helper.PnlSubGroup, sum(fin.finAmount * (budgetNr.amount / prm.prmGrossSales)) finAmount 
			from
			(
			select distinct prm.promotionID, prm.prmBudgetNr, prm.prmDateStart, prm.prmDateEnd, cust.cusGroup5ID, cust.cusGroup6ID, prm.prmGrossSales 
			--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoCust prmcust WITH (NOLOCK) on prmcust.promotionId = prm.promotionID
			inner join @tblCustomer cust on cust.customerID = prmcust.customerId
			where prm.countryID = @countryID and prm.isDeleted = 0 and prm.prmDateStart between cust.ValidFrom and cust.ValidTo 
			and prm.prmStatusID in (8) and prm.prmDateStart > GETDATE() and prm.prmDateStart <= @endOfYear
			) prm
			inner join tblPromoFinancial fin WITH (NOLOCK) on fin.promotionID = prm.promotionID and fin.finCostTypeID = 1
			inner join @tblHelper helper on helper.pnlcode = fin.pnlID
			inner join @budgetNr budgetNr on budgetNr.budgetNr = prm.prmBudgetNr and budgetnr.cusGroup5ID = prm.cusGroup5ID
				and budgetnr.cusGroup6ID = prm.cusGroup6ID and budgetNr.secGroup2ID is null
			group by prm.promotionID, helper.PnlSubGroup, prm.cusGroup5ID, prm.cusGroup6ID, prm.prmDateStart, prm.prmDateEnd
		) prm
		group by prm.promotionID, prm.prmDateStart, prm.prmDateEnd, prm.PnlSubGroup, prm.cusGroup5ID, prm.cusGroup6ID
	) prm on tblMOnth.monthId between datepart(month,prm.prmDateStart) and datepart(month, prm.prmDateEnd)
	group by tblMonth.monthId, PnlSubGroup, cusGroup5ID, cusGroup6ID
		--(tblMonth.monthId = datepart(month,prm.prmDateStart) or tblMonth.monthId = datepart(month, prm.prmDateEnd))
		--and helper.PnlSubGroup = prm.PnlSubGroup
	) tbl1619
	group by PnlSubGroup, codeIdx, cusGroup5ID, cusGroup6ID, monthID
end
--else
begin
	-- secondary customers only
	--select 'secondary'
	insert into @budgetOverview
	select
	19, cusGroup5ID, cusGroup6ID, secGroup2ID, monthID, 
	case PnLSubGroup
		when 'Rebates' then 'rebates' 
		when 'SellOutReimbursement' then 'sellout'
		when 'Displays' then 'display'
		when 'Promotions' then 'promotion'
		when 'SellInRebates' then 'sellin'
		when 'AssetsManagement' then 'assets'
		when 'Advertising' then 'advertising'
		when 'Distribution' then 'distribution'
		when 'CDF' then 'cdf'
	end + codeIdx, sum(rtbAmount)
	from
	(
		select
		16 as rowStep, '3' as codeIdx, datepart(month, recB.dayDate) monthID, helper.PnLSubGroup, sum(recb.rtbAmount) rtbAmount, secGroup2ID--, prm.prmStatusID
		, cusGroup5ID, cusGroup6ID
		from
		(
			select
			distinct prmCust.customerID, prm.promotionID, cust.secGroup2ID, cust.cusGroup5ID, cust.cusGroup6ID--, prm.prmStatusID
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoSecCust prmCust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID and prm.prmStatusID in (12)
				and (prm.prmDateStart between @startOfYear
					and @endOfLastMonth
				or prm.prmDateEnd between @startOfYear
					and @endOfLastMonth)
			inner join @tblSecCustomer cust on cust.secCustomerID = prmcust.secondaryCustomerID
				and prm.prmDateStart between cust.validfrom and cust.validTo
			where prm.countryID = @countryID and prm.isDeleted = 0
		) prm
		inner join tblRecTypeB recB WITH (NOLOCK) on recB.customerID = prm.customerID and recB.promotionID = prm.promotionID -- recb.rtbHeader = prm.prmPromotionClientCode
			and recB.dayDate between @startOfYear
				and @endOfLastMonth
		inner join @tblHelper helper on helper.PnLCode = recb.pnlID
		where recb.countryID = @countryID
		group by datepart(month, recB.dayDate), helper.PnLSubGroup, secGroup2ID, prm.cusGroup5ID, prm.cusGroup6ID
	union
		select
		17 as rowStep, '4', datepart(month, recB.dayDate) monthID, helper.PnLSubGroup, sum(recb.rtbAmount) rtbAmount, secGroup2ID--, prm.prmStatusID
		, prm.cusGroup5ID, prm.cusGroup6ID
		from
		(
			select
			distinct prmCust.customerID, prm.promotionID, cust.secGroup2ID, cust.cusGroup5ID, cust.cusGroup6ID
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoSecCust prmCust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID and prm.prmStatusID in (9,10,11)
				and (prm.prmDateStart between @startOfYear
					and @endOfLastMonth
				or prm.prmDateEnd between @startOfYear
					and @endOfLastMonth)
			inner join @tblSecCustomer cust on cust.secCustomerID = prmcust.secondaryCustomerID and 
				prm.prmDateStart between cust.validFrom and cust.Validto
			where prm.countryID = @countryID and prm.isDeleted = 0
		) prm
		inner join tblRecTypeB recB WITH (NOLOCK) on recB.customerID = prm.customerID and recB.promotionID = prm.promotionID -- recb.rtbHeader = prm.prmPromotionClientCode
			and recB.dayDate between @startOfYear
				and @endOfLastMonth
		inner join @tblHelper helper on helper.PnLCode = recb.pnlID
		where recb.countryID = @countryID
		group by datepart(month, recB.dayDate), helper.PnLSubGroup, secGroup2ID, prm.cusGroup5ID, prm.cusGroup6ID--, prm.prmStatusID

	union
	select 
	18, '4', tblMonth.monthId, helper.PnLSubGroup, isnull(fin.rtbAmount,0) rtbAmount, secGroup2ID
	, cusGroup5ID, cusGroup6ID
	from 
	(select * from @tblMonth where monthId >= datepart(month, getdate())) tblMonth 
	, (select distinct pnlSubGroup from @tblHelper) helper
	inner join
	(
		select helper.PnlSubGroup, -(sum(finAmount) - sum(rtbAmount)) / ((12 - datepart(month, getdate()) + 1)) rtbAmount, recb.secGroup2ID
		, recb.cusGroup5ID, recb.cusGroup6ID
		from
		(
			select
			helper.pnlcode, sum(rtbAmount) rtbAmount, secGroup2ID, cusGroup5ID, cusGroup6ID
			from 
			(
			select distinct prm.promotionID, prmCust.customerID, cust.secGroup2ID, cust.cusGroup5ID, cust.cusGroup6ID
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoSecCust prmCust WITH (NOLOCK) on prm.promotionID = prmcust.promotionID and prm.prmStatusID in (9)
				and getdate() between prm.prmDateStart and prm.prmDateEnd
			inner join @tblSecCustomer cust on cust.secCustomerID = prmcust.secondaryCustomerID 
				and prm.prmDateStart between cust.validFrom and cust.validTo
			where prm.countryID = @countryID and prm.isDeleted = 0
			) prm 
			inner join tblRecTypeB recB WITH (NOLOCK) on recB.customerID = prm.customerID 
				and recB.dayDate between @startOfYear and getdate()
				and recb.promotionID = prm.promotionID -- recB.rtbHeader = prm.prmPromotionClientCode
			inner join @tblHelper helper on helper.pnlcode = recB.pnlID
			group by helper.pnlcode, cusGroup5ID, cusGroup6ID, secGroup2ID
		) recb inner join
		(
			select prm.secGroup2ID, prm.cusGroup5ID, prm.cusGroup6ID, helper.pnlcode, sum(fin.finAmount * (budgetNr.amount / prm.prmGrossSales)) finAmount 
			from
			(
			select distinct prm.promotionID, prm.prmBudgetNr, cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID, prm.prmGrossSales 
			--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoSecCust prmcust WITH (NOLOCK) on prmcust.promotionId = prm.promotionID
			inner join @tblSecCustomer cust on cust.secCustomerID = prmcust.customerId
			where prm.countryID = @countryID and prm.isDeleted = 0 and prm.prmDateStart between cust.ValidFrom and cust.ValidTo 
			and prm.prmStatusID in (9) and getdate() between prm.prmDateStart and prm.prmDateEnd
			) prm
			inner join tblPromoFinancial fin WITH (NOLOCK) on fin.promotionID = prm.promotionID and fin.finCostTypeID = 1
			inner join @tblHelper helper on helper.pnlcode = fin.pnlID			
			inner join @budgetNr budgetNr on budgetNr.budgetNr = prm.prmBudgetNr and budgetnr.cusGroup5ID = prm.cusGroup5ID
				and budgetnr.cusGroup6ID = prm.cusGroup6ID and budgetNr.secGroup2ID = prm.secGroup2ID
			group by helper.pnlcode, prm.cusGroup5ID, prm.cusGroup6ID, prm.secGroup2ID
		) prmfin on recb.pnlcode = prmfin.pnlcode and recb.secGroup2ID = prmfin.secGroup2ID
			and recb.cusGroup5ID = prmfin.cusGroup5ID and recb.cusGroup6ID = prmfin.cusGroup6ID
		inner join @tblHelper helper on helper.pnlCode = recb.pnlcode and helper.pnlcode = prmfin.pnlcode
		group by helper.PnlSubGroup, recb.secGroup2ID, recb.cusGroup5ID, recb.cusGroup6ID
	) fin on fin.PnLSubGroup = helper.PnLSubGroup

	union
	select
	19, '4', tblMOnth.monthId, PnlSubGroup,
	-sum(
		CASE 
		--WHEN datepart(MONTH,prm.prmDateEnd) < tblMonth.monthId THEN 0
		WHEN datepart(Month,prm.prmDateEnd) = tblMonth.monthId THEN 
			CASE WHEN datepart(Month,prm.prmDateStart) < tblMonth.monthId THEN
				(prm.finAmount*datepart(DAY,prm.prmDateEnd))/(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1)
				WHEN datepart(Month,prm.prmDateStart) = tblMonth.monthId THEN	isnull(prm.finAmount,0)
			END
		WHEN datepart(Month,prm.prmDateEnd) > tblMonth.monthId THEN
			CASE WHEN datepart(Month,prm.prmDateStart) < tblMonth.monthId THEN
				(prm.finAmount* DAY(dbo.fGetEndOfMonth(prm.prmDateStart)) )/(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1) -- fix
				WHEN datepart(Month,prm.prmDateStart) = tblMonth.monthId THEN
				(prm.finAmount* (DAY(dbo.fGetEndOfMonth(prm.prmDateStart))-datepart(DAY,prm.prmDateStart)+1))/(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1) -- fix
				ELSE 0
			END
		ELSE 0 
		END
	) as Amount, secGroup2ID, cusGroup5ID, cusGroup6ID
	from
	(select * from @tblMonth where monthId >= datepart(month, getdate())) tblMonth 
	--cross join (select distinct pnlSubGroup from @tblHelper) helper 
	inner join
	(
			select prm.PromotionID, prm.prmDateStart, prm.prmDateEnd, prm.cusGroup5ID, prm.cusGroup6ID, prm.secGroup2ID
			, helper.PnlSubGroup
			, sum(fin.finAmount * (budgetNr.amount / prm.prmGrossSales)) finAmount 
			from
			(
			select distinct prm.promotionID, prm.prmBudgetNr, prm.prmDateStart, prm.prmDateEnd, cust.cusGroup5ID, cust.cusGroup6ID, cust.secGroup2ID,
			prm.prmGrossSales 
			--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
			from tblPromotion prm WITH (NOLOCK) 
			inner join vw_PromoSecCust prmcust WITH (NOLOCK) on prmcust.promotionId = prm.promotionID
			inner join @tblSecCustomer cust on cust.secCustomerID = prmcust.secondaryCustomerId
			where prm.countryID = @countryID and prm.isDeleted = 0 and prm.prmDateStart between cust.ValidFrom and cust.ValidTo 
			and prm.prmStatusID in (8) and prm.prmDateStart > GETDATE() and prm.prmDateStart <= @endOfYear
			) prm
			inner join tblPromoFinancial fin WITH (NOLOCK) on fin.promotionID = prm.promotionID and fin.finCostTypeID = 1
			inner join @tblHelper helper on helper.pnlcode = fin.pnlID			
			inner join @budgetNr budgetNr on budgetNr.budgetNr = prm.prmBudgetNr and budgetnr.cusGroup5ID = prm.cusGroup5ID
				and budgetnr.cusGroup6ID = prm.cusGroup6ID and budgetNr.secGroup2ID = prm.secGroup2ID
			group by prm.promotionID, helper.PnlSubGroup, prm.cusGroup5ID, prm.cusGroup6ID, prm.secGroup2ID, prm.prmDateStart, prm.prmDateEnd
	) prm on tblMOnth.monthId between datepart(month,prm.prmDateStart) and datepart(month, prm.prmDateEnd)
	group by tblMonth.monthId, PnlSubGroup, cusGroup5ID, cusGroup6ID, secGroup2ID
	) tbl1619
	group by PnlSubGroup, codeIdx, cusGroup5ID, cusGroup6ID, secgroup2id, monthID

end

select * from @budgetOverview
order by rowStep

insert into tblBudgetOverviewDetail 
	(budgetOverviewID, countryID, year, rowMonth, CusGroup5ID, CusGroup6ID, SecGroup2ID, rowCode, rowAmount)
select @id, @countryID, @year, rowMonth, cusGroup5ID, cusGroup6ID, secGroup2ID, rowCode, rowAmount 
from @budgetOverview

update tblBudgetOverview
set endTime = getdate()
where budgetOverviewID = @id

END
