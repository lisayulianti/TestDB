-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 27 Aug 2014
-- Description:	Get budget overview for certain role id or department id
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetBudgetOverviewForRoleOrDepartment]
@promotionID int,
@countryID int,
@saveBudget bit = 0,
@loadBudget bit = 1,
@roleID int = null,
@departmentID int = null
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

if @roleID = 102033 -- MT Head (har har... :D)
begin
	Declare @cusGroup1ID int
	select @cusGroup1ID = dbo.fGetCusGroup1ID ('', 'Modern Trade', @countryID)

	Declare @year as int
	Set @year = datepart(year, getdate())

	-- group by cusgroup5-cusgroup6 combination

	Declare @budgetId as int
	Select top 1 @budgetID = budgetOverviewId
	from tblBudgetOverview
	where countryID = @countryID
	order by createdDate desc

	Declare @budgetOverview as table
	(
	rowMonth int,
	rowCode varchar(100),
	cusGroup5ID int,
	cusGroup6ID int,
	rowAmount float,
	rowStep float
	)

	insert into @budgetOverview
	select
	rowMonth, rowCode, cusgroup.cusGroup5ID, cusgroup.cusGroup6ID, sum(rowAmount) rowAmount,
	case when right(rowCode,1) = '3' or right(rowCode,1) = '4' then 21 else 1 end 
	from tblBudgetOverviewDetail bod
	inner join tblBudgetOwnerGroupDetail cusgroup on	
		(cusgroup.cusGroup5ID = bod.cusGroup5ID and cusgroup.cusGroup6ID = bod.cusGroup6ID)
	where budgetOverviewID = @budgetId and cusgroup.cusGroup1ID = @cusGroup1ID
	group by cusgroup.cusGroup5ID, cusgroup.cusGroup6ID, rowMonth, rowCode
	order by rowMonth, cusgroup.cusGroup5ID, cusgroup.cusGroup6ID

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
	select pnlcode,PnLSubGroup,PnLSubGroupItem from tblProfitAndLossHelper
	where IncludedInBudget = 1 and countryID = @countryID

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

		-- primary customer
		insert into @budgetOverview (rowStep, rowMonth, rowCode, rowAmount)
		select
		21, monthID, 
		case PnLSubGroup
			when 'Rebates' then 'rebates' 
			when 'SellOutReimbursement' then 'sellout'
			when 'Displays' then 'display'
			when 'Promotions' then 'promotion'
			when 'SellInRebates' then 'sellin'
			when 'AssetsManagement' then 'assets'
			when 'Advertising' then 'advertising'
			when 'Distribution' then 'distribution'
		end + codeIdx, sum(rtbAmount)
		from
		(
		select
		'5' as codeIdx, tblMOnth.monthId, PnlSubGroup,
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
			prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup, sum(finAmount) finAmount
			from 
			(
				select prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, fin.pnlID, prm.prmDateStart, prm.prmDateEnd, (finAmount * (budgetNr.amount / prm.prmGrossSales)) finAmount
				--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
				from tblPromotion prm
				inner join tblPromoFinancial fin on fin.promotionID = prm.promotionID and fin.finCostTypeID = 1
				inner join vw_PromoCust prmcust on prmcust.promotionId = prm.promotionID
				inner join tblCustomer cust on cust.customerID = prmcust.customerId
				inner join @budgetNr budgetNr on budgetNr.budgetNr = prm.prmBudgetNr and budgetnr.cusGroup5ID = cust.cusGroup5ID
					and budgetnr.cusGroup6ID = cust.cusGroup6ID
				where prm.countryID = @countryID and prm.isDeleted = 0 and prm.prmDateStart between cust.ValidFrom and cust.ValidTo 
					and prm.prmStatusID in (1,2,3,4,5,6,7)
					and prm.prmDateStart > GETDATE() and prm.prmDateStart <= @endOfYear
				--group by fin.pnlID, cust.cusGroup5ID, cust.cusGroup6ID
			) prm
			inner join @tblHelper helper on helper.pnlcode = prm.pnlID
			group by prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup
		) prm on (tblMonth.monthId between datepart(month,prm.prmDateStart) and datepart(month, prm.prmDateEnd))
			--and helper.PnlSubGroup = prm.PnlSubGroup
		group by tblMonth.monthId, PnlSubGroup
		union
		select
		'6', tblMOnth.monthId, PnlSubGroup,
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
					(prm.finAmount* DAY(dbo.fGetEndOfMonth(prm.prmDateStart)))/(DATEDIFF(day,prm.prmDateStart,prm.prmDateEnd)+1) -- fix
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
			prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup, sum(finAmount) finAmount
			from tblPromotion prm 
			inner join tblPromoFinancial prmfin on prm.promotionID = @promotionID and prmfin.promotionID = prm.promotionID
			inner join @tblHelper helper on helper.pnlcode = prmfin.pnlID
			where prm.countryID = @countryID
			group by prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup
		) prm on (tblMonth.monthId between datepart(month,prm.prmDateStart) and datepart(month, prm.prmDateEnd))
			--and helper.PnlSubGroup = prm.PnlSubGroup
		group by tblMonth.monthId, PnlSubGroup
		) tbl1621
		group by PnlSubGroup, codeIdx, monthID

		--insert into @budgetOverview (rowstep, rowmonth, rowcode, rowamount)
		--select 21.5, rowMonth, 'activitySpend', sum(rowAmount) 
		--from @budgetOverview
		--where rowStep = 21
		--group by rowMonth

		--select 'step 5-21' -- end of step 5-21

		Declare @tblLatestRFPerc as table
		(
			cusGroup5ID int,
			cusGroup6ID int,
			rowAmount float
		)
		insert into @tblLatestRFPerc
		select cusGroup5ID, cusGroup6ID, latestRF from tblBudgetOverviewSummary where budgetOverviewID = @budgetId
			and rowCode = 'balTotalTradeSpendPerc' and cusGroup5ID is not null and cusGroup6ID is not null

		--Declare @latestRFPerc as float

		--select @latestRFPerc = latestRF
		--from tblBudgetOverviewSummary  
		--where budgetOverviewID = @budgetID and rowCode = 'balTotalTradeSpendPerc'

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.1, rowMonth, 'availBudget1', sum(bo.rowAmount * latestRF.rowAmount)
		from @budgetOverview bo
		inner join @tblLatestRFPerc latestRF on latestRF.cusGroup5ID = bo.cusGroup5ID and latestRF.cusGroup6ID = bo.cusGroup6ID
		where rowCode = 'latestRF'
		group by bo.rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.2, rowMonth, 'spendftt1', sum(rowAmount)
		from @budgetOverview
		where rowCode in ('rebates1','sellout1','display1','promotion1','sellin1','assets1','advertising1','distribution1')
		group by rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.3, rowMonth, 'spendAbs1', sum(rowAmount)
		from @budgetOverview
		where right(rowCode,1) = '2'
		group by rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.4, rowMonth, 'spendListFee1', sum(rowAmount)
		from @budgetOverview
		where rowCode = 'listingfee'
		group by rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.5, rowMonth, 'spendCdf1', sum(rowAmount)
		from @budgetOverview
		where rowCode = 'cdf'
		group by rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.6, rowMonth, 'spendAct1', sum(rowAmount)
		from @budgetOverview
		where right(rowCode,1) in ('3','4','5','6')
		group by rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.7, rowMonth, 'totalSpend1', sum(rowAmount)
		from @budgetOverview
		where rowStep >= 22
		group by rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		22.8, bud1.rowMonth, 'spendGS1', 
		avg(case when isnull(bud2.rowAmount,0) = 0 then 0
		else bud1.rowAmount / bud2.rowAmount end)
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'totalSpend1' and bud2.rowCode = 'latestRF'
		group by bud1.rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		22.9, bud1.rowMonth, 'balance1', 
		sum(isnull(bud2.rowAmount,0) - bud1.rowAmount)
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'totalSpend1' and bud2.rowCode = 'budget'
		group by bud1.rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		23, bud1.rowMonth, 'balanceP1', 
		avg(case when isnull(bud2.rowAmount,0) = 0 then 0
		else isnull(bud1.rowAmount,0) / bud2.rowAmount end)
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'balance1' and bud2.rowCode = 'latestRF'
		group by bud1.rowMonth

		Set @ctr = 1

		Declare @ctr2 as int

		while @ctr <= 12
		begin
			set @ctr2 = 1

			while @ctr2 <= 10
			begin
				if @ctr2 <> 8 and @ctr2 <> 10
				begin
					insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
					select rowStep + 1, @ctr, left(rowCode, len(rowCode)-1) + '2', sum(rowAmount)
					from @budgetOverview
					where rowStep = 22 + (0.1 * @ctr2)
					and rowMonth <= @ctr
					group by rowStep, rowCode
				end
				set @ctr2 = @ctr2 + 1
			end

			set @ctr = @ctr + 1
		end

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		23.8, bud1.rowMonth, 'spendGS2', 
		avg(case when isnull(bud2.rowAmount,0) = 0 then 0
		else bud1.rowAmount / bud2.rowAmount end)
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'totalSpend2' and bud2.rowCode = 'latestRF'
		group by bud1.rowMonth

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		24, bud1.rowMonth, 'balanceP2', 
		avg(case when isnull(bud2.rowAmount,0) = 0 then 0
		else isnull(bud1.rowAmount,0) / bud2.rowAmount end)
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'balance2' and bud2.rowCode = 'latestRF'
		group by bud1.rowMonth

		Declare @tblTop1 as table
		(
		rowCode varchar(50),
		YTD float,
		YTG float,
		FullYear float
		)

		insert into @tblTop1
		select 
		left(budYTD.rowCode, len(budYTD.rowCode)-1) + 'TL' rowCode, 
		budYTD.rowAmount YTD, 
		budYTG.rowAmount - budYTD.rowAmount YTG, 
		budYTG.rowAmount FullYear
		from
		(select rowCode, rowAmount
		from @budgetOverview budYTD
		where rowStep between 23.1 and 23.6
		and rowMonth = datepart(month, getdate()) - 1
		) budYTD
		inner join
		(select rowCode, rowAmount
		from @budgetOverview budYTG
		where rowStep between 23.1 and 23.6
		and rowMonth = 12
		) budYTG on budYTD.rowCode = budYTG.rowCode

		Declare @latestRFTYTD as float
		Declare @latestRFTYTG as float

		select @latestRFTYTD = sum(rowAmount)
		from @budgetOverview where rowCode = 'latestRF' and rowMonth < datepart(month, getdate())

		select @latestRFTYTG = sum(rowAmount)
		from @budgetOverview where rowCode = 'latestRF' and rowMonth >= datepart(month, getdate())

		insert into @tblTop1
		select 'totalSpendTL', sum(YTD), sum(YTG), sum(fullyear)
		from @tblTop1

		insert into @tblTop1
		select
		'promoGSVPercTL',
		case when isnull(@latestRFTYTD,0) = 0 then 0 else YTD / @latestRFTYTD end,
		case when isnull(@latestRFTYTG,0) = 0 then 0 else YTG / @latestRFTYTG end,
		case when isnull(@latestRFTYTD,0) + isnull(@latestRFTYTG,0) = 0 then 0 else 
			FullYear / (isnull(@latestRFTYTD,0) + isnull(@latestRFTYTG,0)) end
		from @tblTop1
		where rowCode = 'spendActTL'

		insert into @tblTop1
		select 'availInvTL', top1.YTD + top2.YTD,
			top1.YTG + top2.YTG, top1.FullYear + top2.FullYear 
		from @tblTop1 top1
		,@tblTop1 top2 
		where top1.rowCode = 'availBudgetTL' and top2.rowCode = 'totalSpendTL'

		Declare @budgetTitle as varchar(500)

		select @budgetTitle = c01CusGroup1Desc from tblCusGroup1 where cusGroup1ID = @cusGroup1ID

		--select * from @budgetOverview order by rowMonth, rowstep

		if @loadBudget = 1
		begin
			select * from 
			(
			select bo.rowMonth, bo.cusGroup5ID, bo.cusGroup6ID, helper.rowGroup rowCode, sum(bo.rowAmount) rowAmount, rowOrder
			from @budgetOverview bo 
			inner join tblBudgetOverviewHelper helper on helper.roleID = @roleID and helper.rowCode = bo.rowCode 
				and (helper.rowGroup is not null and helper.rowGroup not in ('monthDetail', 'monthCumulative'))
			group by bo.cusGroup5ID, bo.cusGroup6ID, helper.rowGroup, rowMonth, rowOrder
			union
			select bo.rowMonth, bo.cusGroup5ID, bo.cusGroup6ID, helper.rowCode, bo.rowAmount, rowOrder
			from @budgetOverview bo 
			inner join tblBudgetOverviewHelper helper on helper.roleID = @roleID and helper.rowCode = bo.rowCode 
				and (helper.rowGroup is null or helper.rowGroup in ('monthDetail', 'monthCumulative'))
			union
			select bo.rowMonth, null, null, 'total' + helper.rowGroup rowCode, sum(bo.rowAmount) rowAmount, rowOrder
			from @budgetOverview bo 
			inner join tblBudgetOverviewHelper helper on helper.roleID = @roleID and helper.rowCode = bo.rowCode 
				and (helper.rowGroup not in ('monthDetail', 'monthCumulative'))
			group by helper.rowGroup, rowMonth, rowOrder
			union
			select bo.rowMonth, null, null, 'total' + helper.rowCode rowCode, sum(bo.rowAmount) rowAmount, rowOrder
			from @budgetOverview bo 
			inner join tblBudgetOverviewHelper helper on helper.roleID = @roleID and helper.rowCode = bo.rowCode 
				and (helper.rowGroup is null)
			group by helper.rowCode, rowMonth, rowOrder
			) A
			order by rowOrder, rowMonth

			select @budgetTitle as budgetTitle	

		end
end

END

