-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 11 Sep 2014
-- Description:	Generate data for budget overview report for Shopper Marketing
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchBudgetOverviewReportForSM]
@countryID int,
@reportID int,
@budgetOwners BudgetGroups READONLY
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

-- get correct set of cusgroup5-cusgroup6-secgroup2 combinations
Declare @tblCusGroup as table
(
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	budgetOwnerName varchar(255)
)

Declare @tblGroup as table
(
budgetOwnerGroupID int
)

insert into @tblGroup
select distinct bog.budgetOwnerGroupID 
from tblBudgetOwnerGroupDetail bogd
inner join tblBudgetOwnerGroup bog on bog.budgetOwnerGroupID = bogd.budgetOwnerGroupID and bog.countryID = @countryID
inner join (select distinct cusgroup5ID, cusgroup6ID, secGroup2ID from @budgetOwners) cusgroup on cusgroup.cusGroup5ID = bogd.cusGroup5ID 
and cusgroup.cusGroup6ID = bogd.cusGroup6ID
and (cusgroup.secGroup2ID = bogd.secGroup2ID or (cusgroup.secGroup2ID is null and bogd.secGroup2ID is null))

insert into @tblCusGroup 
select
case cusGroup5ID when 0 then null else cusGroup5ID end, 
case cusGroup6ID when 0 then null else cusGroup6ID end, 
case secGroup2ID when 0 then null else secGroup2ID end, 
''
from @budgetOwners bo
union
select cusGroup5ID, cusGroup6ID, secGroup2ID, ''
from tblBudgetOwnerGroupDetail bogd
where bogd.budgetOwnerGroupID in (select budgetOwnerGroupID from @tblGroup)

update @tblCusGroup
set budgetOwnerName = bal.budgetOwnerGroupName
from @tblCusGroup cusgroup
inner join 
(
select distinct cusGroup5ID, cusGroup6ID, secGroup2ID, grp.budgetOwnerGroupName
from tblBudgetOwnerGroupDetail det 
inner join tblBudgetOwnerGroup grp on grp.budgetOwnerGroupID = det.budgetOwnerGroupID) bal
on (bal.cusGroup5ID = cusgroup.cusGroup5ID and bal.cusGroup6ID = cusgroup.cusGroup6ID)
	and (bal.secGroup2ID = cusgroup.secGroup2ID or (bal.secGroup2ID is null and cusgroup.secGroup2ID is null))
where cusGroup.budgetOwnerName = ''

-- get the latest budget data of the input countryID
Declare @budgetId as int
Select top 1 @budgetID = budgetOverviewId
from tblBudgetOverview
where countryID = @countryID and endTime is not null and startTime is not null
order by createdDate desc

delete @tblCusGroup
where budgetOwnerName = ''

select distinct budgetOwnerName from @tblCusGroup


Declare @year as int
Set @year = datepart(year, getdate())

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

Declare @tblHelper as table
(
	pnlcode INT, PnlSubGroup NVARCHAR(50), PnlSubGroupItem NVARCHAR(50)
)

insert into @tblHelper
values (102049, 'CDF', 'CDF')
--select pnlcode,PnLSubGroup,PnLSubGroupItem from tblProfitAndLossHelper
--where IncludedInBudget = 1

Declare @budgetNr as table
(
	budgetNr int,
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int,
	amount float
)
		
--Declare @ctr as int
Set @ctr = 0

while @ctr < 4
begin
	insert into @budgetNr --(budgetNr, amount)
	select @ctr, cusGroup5ID, cusGroup6ID, secGroup2ID, sum(rowAmount) rowAmount from tblBudgetOverviewDetail
	where rowCode in ('budget', 'latestRF')
	and budgetOverviewID = @budgetId and rowMonth in ((@ctr * 3)+1, (@ctr * 3)+2, (@ctr * 3)+3)
	group by cusGroup5ID, cusGroup6ID, secGroup2ID

	set @ctr = @ctr + 1
end

Declare @startOfYear as datetime
Declare @endOfYear as datetime
Declare @endOfLastMonth as datetime

set @startOfYear = cast('01-Jan-' + cast(@year as varchar(5)) as datetime) 
set @endOfYear = cast('31-Dec-' + cast(@year as varchar(5)) as datetime) 
set @endOfLastMonth = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))

Declare @budgetOverview as table
(
cusGroup5ID int,
cusGroup6ID int,
secGroup2ID int,
rowCode nvarchar(50),
rowMonth int,
rowAmount float
)

insert into @budgetOverview
select
detail.cusGroup5ID, detail.cusGroup6ID, detail.secGroup2ID, rowCode, rowMonth, rowamount-- sum(rowAmount) rowAmount
from tblBudgetOverviewDetail detail
inner join @tblCusGroup cusgroup on detail.cusGroup5ID = cusgroup.cusGroup5ID and cusgroup.cusGroup6ID = detail.cusGroup6ID
	and (cusgroup.secGroup2ID = detail.secGroup2ID or (cusgroup.secGroup2ID is null and detail.secGroup2ID is null))
where detail.rowCode in (select rowCode from tblBudgetOverviewHelper where forOutputReport = 1 and reportID = @reportID and rowGroup is null)
and detail.budgetOverviewID = @budgetId
--group by detail.cusGroup5ID, detail.cusGroup6ID, detail.secGroup2ID, rowCode, rowMonth
union
select
detail.cusGroup5ID, detail.cusGroup6ID, detail.secGroup2ID, 
--helper.rowCode, 
rowGroup,
rowMonth, sum(rowAmount) rowAmount
from tblBudgetOverviewDetail detail
inner join @tblCusGroup cusgroup on detail.cusGroup5ID = cusgroup.cusGroup5ID and cusgroup.cusGroup6ID = detail.cusGroup6ID
	and (cusgroup.secGroup2ID = detail.secGroup2ID or (cusgroup.secGroup2ID is null and detail.secGroup2ID is null))
inner join tblBudgetOverviewHelper helper on helper.reportID = @reportID and forOutputReport = 1 and helper.rowCode = detail.rowCode and rowGroup is not null
where detail.budgetOverviewID = @budgetId
group by detail.cusGroup5ID, detail.cusGroup6ID, detail.secGroup2ID, rowGroup, rowMonth
union
select
cusGroup5ID, cusGroup6ID, secGroup2ID, 
--helper.rowCode, 
'cdf5',
monthId, sum(rtbAmount) rtbAmount
from
(
		select
		'5' as codeIdx, tblMOnth.monthId, PnlSubGroup, cusGroup5ID, cusGroup6ID, secGroup2ID,
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
		) as rtbAmount
		from
		(select * from @tblMonth where monthId >= datepart(month, getdate())) tblMonth 
		--cross join (select distinct pnlSubGroup from @tblHelper) helper 
		inner join
		(
			select
			prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup, fin.finAmount * (budgetNr.amount / prm.prmGrossSales) finAmount,
			budgetNR.cusGroup5ID, budgetNR.cusGroup6ID, budgetNr.secGroup2ID
			from 
			(
				select distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, prm.prmDateStart, prm.prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales
				--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
				from tblPromotion prm WITH (NOLOCK) 
				inner join vw_PromoCust prmcust WITH (NOLOCK) on prmcust.promotionId = prm.promotionID
				inner join tblCustomer cust WITH (NOLOCK) on cust.customerID = prmcust.customerId
				inner join @tblCusGroup cg on cg.cusGroup5ID = cust.cusGroup5ID and cg.cusGroup6ID = cust.cusGroup6ID and cg.secGroup2ID is null
				where prm.countryID = @countryID and prm.isDeleted = 0 and prm.prmDateStart between cust.ValidFrom and cust.ValidTo 
					and prm.prmStatusID in (1,2,3,4,5,6,7)
					and prm.prmDateStart > GETDATE() and prm.prmDateStart <= @endOfYear
				--group by prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, prm.prmDateStart, prm.prmDateEnd
			) prm
			inner join @budgetNr budgetNr on budgetNr.budgetNr = prm.prmBudgetNr and budgetnr.cusGroup5ID = prm.cusGroup5ID
				and budgetnr.cusGroup6ID = prm.cusGroup6ID and budgetNr.secGroup2ID is null
			inner join tblPromoFinancial fin WITH (NOLOCK) on fin.promotionID = prm.promotionID and fin.finCostTypeID = 1
			inner join @tblHelper helper on helper.pnlcode = fin.pnlID
			--group by prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup
		) prm on (tblMonth.monthId between datepart(month,prm.prmDateStart) and datepart(month, prm.prmDateEnd))
			--and helper.PnlSubGroup = prm.PnlSubGroup
		group by cusGroup5ID, cusGroup6ID, secGroup2ID, tblMonth.monthId, PnlSubGroup
		union
		select
		'5' codeIdx, tblMOnth.monthId, PnlSubGroup, cusGroup5ID, cusGroup6ID, secGroup2ID,
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
		) as rtbAmount
		from
		(select * from @tblMonth where monthId >= datepart(month, getdate())) tblMonth 
		--cross join (select distinct pnlSubGroup from @tblHelper) helper 
		inner join
		(
			select
			prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup, fin.finAmount * (budgetNr.amount / prm.prmGrossSales) finAmount,
			budgetNR.cusGroup5ID, budgetNR.cusGroup6ID, budgetNr.secGroup2ID
			from 
			(
				select distinct prm.promotionID, cust1.cusGroup5ID, cust1.cusGroup6ID, cust.secGroup2ID, prm.prmDateStart, prm.prmDateEnd, prm.prmGrossSales, prmBudgetNr
				--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
				from tblPromotion prm
				inner join vw_PromoSecCust prmcust WITH (NOLOCK) on prmcust.promotionId = prm.promotionID
				inner join tblSecondaryCustomer cust WITH (NOLOCK) on cust.secondaryCustomerID = prmcust.secondaryCustomerId
				inner join tblCustomer cust1 WITH (NOLOCK) on cust1.customerID = cust.customerID
				inner join @tblCusGroup cusgroup on cusgroup.cusGroup5ID = cust1.cusGroup5ID and cusgroup.cusGroup6ID = cust1.cusGroup6ID
					and cusgroup.secGroup2ID = cust.secGroup2ID
				where prm.countryID = @countryID and prm.isDeleted = 0 and prm.prmDateStart between cust.ValidFrom and cust.ValidTo 
					and prm.prmStatusID in (1,2,3,4,5,6,7)
					and prm.prmDateStart > GETDATE() and prm.prmDateStart <= @endOfYear
				--group by prm.promotionID, cust1.cusGroup5ID, cust1.cusGroup6ID, cust.secGroup2ID, prm.prmDateStart, prm.prmDateEnd
			) prm
			inner join @budgetNr budgetNr on budgetNr.budgetNr = prm.prmBudgetNr and budgetnr.secGroup2ID = prm.secGroup2ID
				and budgetNr.cusGroup5ID = prm.cusGroup5ID and budgetNr.cusGroup6ID = prm.cusGroup6ID 
			inner join tblPromoFinancial fin WITH (NOLOCK) on fin.promotionID = prm.promotionID and fin.finCostTypeID = 1
			inner join @tblHelper helper on helper.pnlcode = fin.pnlID
			--group by prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup
		) prm on (tblMonth.monthId between datepart(month,prm.prmDateStart) and datepart(month, prm.prmDateEnd))
			--and helper.PnlSubGroup = prm.PnlSubGroup
		group by cusGroup5ID, cusGroup6ID, secGroup2ID,tblMonth.monthId, PnlSubGroup) A
	group by cusGroup5ID, cusGroup6ID, secGroup2ID, monthId


Declare @budgetByOwner as table
(
budgetOwnerName nvarchar(50),
rowCode nvarchar(50),
rowMonth int,
rowAmount float
)
insert into @budgetByOwner
select cg.budgetOwnerName, helper.rowCode, rowMonth,
	case helper.rowPercentage when 1 then avg(rowAmount) 
	else sum(rowAmount) end rowAmount
from @budgetOverview bo
inner join @tblCusGroup cg on bo.cusGroup5ID = cg.cusGroup5ID and bo.cusGroup6ID = cg.cusGroup6ID
	and (bo.secGroup2ID = cg.secGroup2ID or (bo.secGroup2ID is null and cg.secGroup2ID is null))
inner join tblBudgetOverviewHelper helper on helper.reportID = @reportID and helper.forOutputReport = 1
	and helper.rowCode = bo.rowCode
group by cg.budgetOwnerName, helper.rowCode, rowMonth, helper.rowPercentage

insert into @budgetByOwner (rowCode, rowMonth, rowAmount)
select 'total' + rowCode, rowMonth, sum(rowAmount) 
from @budgetByOwner
group by rowCode, rowMonth


select * from @budgetByOwner



select *, 
case rowCode
	when 'YTD' then 1
	when 'YTG' then 2
	when 'YTG Balance' then 3
	when 'FullYear' then 4
end colOrder,
'table1' as [rowTable],
0 rowPercentage
from
(
select ROW_NUMBER() OVER (ORDER BY isnull(YTD.budgetOwnerName, YTG.budgetOwnerName)) as rowOrder, 
budget.budgetOwnerName, 
isnull(YTD.rowAmount,0) YTD,
isnull(YTG.rowAmount,0) YTG, 
isnull(YTD.rowAmount,0) + isnull(YTG.rowAmount,0) FullYear,
budget.latestRF + isnull(YTD.rowAmount,0) + isnull(YTG.rowAmount,0) [YTG Balance]
from
(
select cg.budgetOwnerName, avg(latestRF) latestRF
from tblBudgetOverviewSummary bos
inner join @tblCusGroup cg on cg.cusGroup5ID = bos.cusGroup5ID and cg.cusGroup6ID = bos.cusGroup6ID
	and (cg.secGroup2ID = bos.secGroup2ID or (cg.secGroup2ID is null and bos.secGroup2ID is null))
where bos.budgetOverviewID = @budgetId and bos.rowCode = 'balCDF'
group by cg.budgetOwnerName
) budget
left outer join
(
select bbo.budgetOwnerName, sum(rowAmount) rowAmount
from @budgetByOwner bbo
where rowCode like 'cdf%'
	and rowMonth < datepart(month, getdate())
group by budgetOwnerName
) YTD on YTD.budgetOwnerName = budget.budgetOwnerName
left outer join
(
select bbo.budgetOwnerName, sum(rowAmount) rowAmount
from @budgetByOwner bbo
where rowCode like 'cdf%'
	and rowMonth >= datepart(month, getdate())
group by budgetOwnerName
) YTG on budget.budgetOwnerName = YTG.budgetOwnerName
union
select 99 as rowOrder, 'Total' budgetOwnerName, 
isnull(YTD.rowAmount,0) YTD,
isnull(YTG.rowAmount,0) YTG, 
isnull(YTD.rowAmount,0) + isnull(YTG.rowAmount,0) FullYear,
budget.latestRF + isnull(YTD.rowAmount,0) + isnull(YTG.rowAmount,0) [YTG Balance]
from
(
select 'Total' budgetOwnerName, avg(latestRF) latestRF
from tblBudgetOverviewSummary bos
inner join @tblCusGroup cg on cg.cusGroup5ID = bos.cusGroup5ID and cg.cusGroup6ID = bos.cusGroup6ID
	and (cg.secGroup2ID = bos.secGroup2ID or (cg.secGroup2ID is null and bos.secGroup2ID is null))
where bos.budgetOverviewID = @budgetId and bos.rowCode = 'balCDF'
) budget left outer join
(
select 'Total' budgetOwnerName, sum(rowAmount) rowAmount
from @budgetByOwner bbo
where rowCode like 'cdf%'
	and rowMonth < datepart(month, getdate())
) YTD on YTD.budgetOwnerName = budget.budgetOwnerName left outer join
(
select 'Total' budgetOwnerName, sum(rowAmount) rowAmount
from @budgetByOwner bbo
where rowCode like 'cdf%'
	and rowMonth >= datepart(month, getdate())
) YTG on YTD.budgetOwnerName = budget.budgetOwnerName
) p
UNPIVOT
(
	rowAmount for rowCode in (YTD, YTG, FullYear, [YTG Balance])
) unpvt

union
select *, 
case rowCode
	when 'Budget' then 1
	when 'latestRF' then 2
end colOrder,
'table2' as [rowTable],
0 rowPercentage
from
(
select ROW_NUMBER() OVER (ORDER BY budgetOwnerName) as rowOrder,
cg.budgetOwnerName, avg(bos.budget) Budget, avg(latestRF) latestRF
from tblBudgetOverviewSummary bos
inner join @tblCusGroup cg on cg.cusGroup5ID = bos.cusGroup5ID and cg.cusGroup6ID = bos.cusGroup6ID
	and (cg.secGroup2ID = bos.secGroup2ID or (cg.secGroup2ID is null and bos.secGroup2ID is null))
where bos.budgetOverviewID = @budgetId and bos.rowCode = 'balCDF'
group by cg.budgetOwnerName
) p
UNPIVOT
(
	rowAmount for rowCode in (Budget, latestRF)
) unpvt
order by rowTable

END

