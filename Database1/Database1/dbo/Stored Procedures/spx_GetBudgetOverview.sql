-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 19 Aug 2014
-- Description:	get budget overview
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetBudgetOverview]-- 10446,102,0,1,102000024
@promotionID int,
@countryID int,
@saveBudget bit = 0,
@loadBudget bit = 1,
@userID int = null
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

Declare @roleID as int
Declare @departmentID as int

select top 1 @roleID = useRole, @departmentID = useDepartment from tblUser where userID = @userID and countryID = @countryID

if NOT EXISTS (select distinct roleID from tblBudgetOverviewHelper where countryID = @countryID and roleID = @roleID and forWebPage = 1)
begin
	set @roleID = null
end

if NOT EXISTS (select distinct @departmentID from tblBudgetOverviewHelper where countryID = @countryID and departmentID = @departmentID and forWebPage = 1)
begin
	set @departmentID = null
end

if @roleID is null and @departmentID is null
begin

	Declare @year as int
	Set @year = datepart(year, getdate())

	if not exists (select top 1 promotionID from tblPromotionBudgetOverview where promotionID = @promotionID)
	begin

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
		select bog.budgetOwnerGroupID 
		from tblBudgetOwnerGroupDetail bogd
		inner join tblBudgetOwnerGroup bog on bog.budgetOwnerGroupID = bogd.budgetOwnerGroupID and bog.countryID = @countryID
		inner join 
		(
			select distinct cusGroup5ID, cusGroup6ID, null secGroup2ID
			from vw_PromoCust prmcust WITH (NOLOCK)   --dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
			inner join tblCustomer cust WITH (NOLOCK) on prmcust.customerId = cust.customerID
			where promotionID = @promotionID
			union
			select distinct cust1.cusGroup5ID, cust1.cusGroup6ID, secGroup2ID
			from tblPromotionSecondaryCustomer prmcust WITH (NOLOCK)  --dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
			inner join tblSecondaryCustomer cust WITH (NOLOCK) on prmcust.secondaryCustomerId = cust.secondaryCustomerID
			inner join tblCustomer cust1 WITH (NOLOCK) on cust1.customerID = cust.customerID
			where promotionID = @promotionID
		) cusgroup on cusgroup.cusGroup5ID = bogd.cusGroup5ID 
		and cusgroup.cusGroup6ID = bogd.cusGroup6ID 
		and (bogd.secGroup2ID is null or (cusgroup.secGroup2ID = bogd.secGroup2ID))

		if (select count(*) from @tblGroup) > 0
		begin
			insert into @tblCusGroup
			select distinct cusGroup5ID, cusGroup6ID, null, ''
			from vw_PromoCust prmcust WITH (NOLOCK)  --dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
			inner join tblCustomer cust WITH (NOLOCK) on prmcust.customerId = cust.customerID
			where promotionID = @promotionID
			union
			select distinct cust1.cusGroup5ID, cust1.cusGroup6ID, secGroup2ID, ''
			from vw_PromoSecCust prmcust  --dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
			inner join tblSecondaryCustomer cust WITH (NOLOCK) on prmcust.secondaryCustomerId = cust.secondaryCustomerID and prmcust.customerID = cust.customerID
			inner join tblCustomer cust1 WITH (NOLOCK) on cust1.customerID = prmcust.customerID
			where promotionID = @promotionID
			union
			select cusGroup5ID, cusGroup6ID, secGroup2ID, ''
			from tblBudgetOwnerGroupDetail bogd
			where bogd.budgetOwnerGroupID in (select budgetOwnerGroupID from @tblGroup)
		end
		else
		begin
			insert into @tblCusGroup
			select distinct cusGroup5ID, cusGroup6ID, null, ''
			from vw_PromoCust prmcust WITH (NOLOCK)  --dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
			inner join tblCustomer cust WITH (NOLOCK) on prmcust.customerId = cust.customerID
			where promotionID = @promotionID
			union
			select distinct cust1.cusGroup5ID, cust1.cusGroup6ID, secGroup2ID, ''
			from vw_PromoSecCust prmcust WITH (NOLOCK)  --dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
			inner join tblSecondaryCustomer cust WITH (NOLOCK) on prmcust.secondaryCustomerId = cust.secondaryCustomerID and prmcust.customerID = cust.customerID
			inner join tblCustomer cust1 WITH (NOLOCK) on cust1.customerID = prmcust.customerID
			where promotionID = @promotionID
		end
	
		update @tblCusGroup
		set budgetOwnerName = bog.budgetOwnerGroupName
		from @tblCusGroup cusgroup
		inner join 
		tblBudgetOwnerGroupDetail bogd on bogd.cusGroup5ID = cusGroup.cusGroup5ID and 
			bogd.cusGroup6ID = cusGroup.cusGroup6ID and
			(bogd.secGroup2ID is null or (bogd.secGroup2ID = cusgroup.secGroup2ID))
		inner join tblBudgetOwnerGroup bog on bog.budgetOwnerGroupID = bogd.budgetOwnerGroupID and 
			bog.countryID = @countryID
	
		update @tblCusGroup
		set budgetOwnerName = bal.balBudgetOwnerName
		from @tblCusGroup cusgroup
		inner join 
		(
		select distinct cusGroup5ID, cusGroup6ID, secGroup2ID, balBudgetOwnerName 
		from tblBudgetAllocation WITH (NOLOCK)) bal 
		on (bal.cusGroup5ID = cusgroup.cusGroup5ID and bal.cusGroup6ID = cusgroup.cusGroup6ID)
			and (bal.secGroup2ID = cusgroup.secGroup2ID or (bal.secGroup2ID is null and cusgroup.secGroup2ID is null))
		where cusGroup.budgetOwnerName = ''

		--select * from @tblCusGroup

		Declare @budgetId as int
		Select top 1 @budgetID = budgetOverviewId
		from tblBudgetOverview
		where countryID = @countryID and endTime is not null and startTime is not null
		order by createdDate desc

		Declare @budgetOverview as table
		(
		rowMonth int,
		rowCode varchar(100),
		rowAmount float,
		rowStep float
		)

		insert into @budgetOverview
		select
		rowMonth, helper.rowCode, sum(rowAmount) rowAmount,
		case when right(helper.rowCode,1) = '3' or right(helper.rowCode,1) = '4' then 21 else 1 end 
		from tblBudgetOverviewDetail bod
		inner join @tblCusGroup cusgroup on	
			(cusgroup.cusGroup5ID = bod.cusGroup5ID and cusgroup.cusGroup6ID = bod.cusGroup6ID)
			AND (cusgroup.secGroup2ID = bod.secGroup2ID or (cusgroup.secGroup2ID is null and bod.SecGroup2ID is null))
		inner join tblBudgetOverviewHelper helper on helper.rowCode = bod.rowCode 
			and helper.roleID is null and helper.departmentID is null and forwebPage = 1
		where budgetOverviewID = @budgetId
		group by rowMonth, helper.rowCode


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
		where IncludedInBudget = 1

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

	if exists (select top 1 secgroup2id from @tblCusGroup where secGroup2ID is null)
	begin
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
			prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup, fin.finAmount * (budgetNr.amount / prm.prmGrossSales) finAmount
			from 
			(
				select distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, prm.prmDateStart, prm.prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales
				--distinct prm.promotionID, cust.cusGroup5ID, cust.cusGroup6ID, finAmount, pnlID, prm.prmDateStart, prmDateEnd, prm.prmBudgetNr, prm.prmGrossSales prmGSV 
				from tblPromotion prm WITH (NOLOCK) 
				inner join vw_PromoCust prmcust WITH (NOLOCK) on prmcust.promotionId = prm.promotionID
				inner join tblCustomer cust WITH (NOLOCK) on cust.customerID = prmcust.customerId
				inner join @tblCusGroup cg on cg.cusGroup5ID = cust.cusGroup5ID and cg.cusGroup6ID = cust.cusGroup6ID
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
			inner join tblPromoFinancial prmfin WITH (NOLOCK) on prm.promotionID = @promotionID and prmfin.promotionID = prm.promotionID
			inner join @tblHelper helper on helper.pnlcode = prmfin.pnlID
			where prm.countryID = @countryID
			group by prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup
		) prm on (tblMonth.monthId between datepart(month,prm.prmDateStart) and datepart(month, prm.prmDateEnd))
			--and helper.PnlSubGroup = prm.PnlSubGroup
		group by tblMonth.monthId, PnlSubGroup
		) tbl1621
		group by PnlSubGroup, codeIdx, monthID
	end
	else
	begin
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
		'5' codeIdx, tblMOnth.monthId, PnlSubGroup,
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
			prm.promotionID, prm.prmDateStart, prm.prmDateEnd, helper.PnlSubGroup, fin.finAmount * (budgetNr.amount / prm.prmGrossSales) finAmount
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
		group by tblMonth.monthId, PnlSubGroup
		union
		select
		'6' codeIdx, tblMOnth.monthId, PnlSubGroup,
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
	end


		insert into @budgetOverview (rowstep, rowmonth, rowcode, rowamount)
		select 21.5, rowMonth, 'activitySpend', sum(rowAmount) 
		from @budgetOverview
		where rowStep = 21
		group by rowMonth

		--select 'step 5-21' -- end of step 5-21

		Declare @latestRFPerc as float

		select @latestRFPerc = avg(latestRF)
		from tblBudgetOverviewSummary summ
		inner join @tblCusGroup cg on (cg.cusGroup5ID =  summ.cusGroup5ID and cg.cusGroup6ID = summ.cusGroup6ID)
		and (cg.secGroup2ID = summ.secGroup2ID or (cg.secGroup2ID is null and summ.secGroup2ID is null))
		where budgetOverviewID = @budgetID and rowCode = 'balTotalTradeSpendPerc'

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 22.1, rowMonth, 'availBudget1', rowAmount * isnull(@latestRFPerc,0)
		from @budgetOverview
		where rowCode = 'latestRF'

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
		where rowStep >= 22.2
		group by rowMonth

-- Lisa (05.09.2014) --> TradeSpend = Month.TotalSpend
		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 5.5, 
		rowMonth, 'tradeSpend', rowAmount
		from @budgetOverview 
		where rowCode = 'totalSpend1'
--

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		22.8, bud1.rowMonth, 'spendGS1', 
		case when isnull(bud2.rowAmount,0) = 0 then 0
		else bud1.rowAmount / bud2.rowAmount end
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'totalSpend1' and bud2.rowCode = 'latestRF'

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		22.9, bud1.rowMonth, 'balance1', 
		isnull(bud2.rowAmount,0) + bud1.rowAmount
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'totalSpend1' and bud2.rowCode = 'availBudget1'

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		23, bud1.rowMonth, 'balanceP1', 
		case when isnull(bud2.rowAmount,0) = 0 then 0
		else isnull(bud1.rowAmount,0) / bud2.rowAmount end
		from @budgetOverview bud1
		inner join @budgetOverview bud2 on bud1.rowMonth = bud2.rowMonth
		and bud1.rowCode = 'balance1' and bud2.rowCode = 'latestRF'

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
		case when isnull((select sum(rowAmount) from @budgetOverview where rowCode = 'latestRF' and rowMonth <= bud1.rowMonth),0) = 0 then 0
		else bud1.rowAmount / (select sum(rowAmount) from @budgetOverview where rowCode = 'latestRF' and rowMonth <= bud1.rowMonth) end
		from @budgetOverview bud1
		inner join @tblMonth bud2 on bud1.rowMonth = bud2.monthId
		and bud1.rowCode = 'totalSpend2' --and bud2.rowCode = 'latestRF'

		insert into @budgetOverview(rowstep, rowmonth, rowcode, rowamount)
		select 
		24, bud1.rowMonth, 'balanceP2', 
		case when isnull((select sum(rowAmount) from @budgetOverview where rowCode = 'latestRF' and rowMonth <= bud1.rowMonth),0) = 0 then 0
		else isnull(bud1.rowAmount,0) / (select sum(rowAmount) from @budgetOverview where rowCode = 'latestRF' and rowMonth <= bud1.rowMonth) end
		from @budgetOverview bud1
		inner join @tblMonth bud2 on bud1.rowMonth = bud2.monthId
		and bud1.rowCode = 'balance2'-- and bud2.rowCode = 'latestRF'

		Declare @tblTop1 as table
		(
		rowCode varchar(50),
		YTD float,
		YTG float,
		FullYear float
		)

		insert into @tblTop1
		select 
		left(budYTG.rowCode, len(budYTG.rowCode)-1) + 'TL' rowCode, 
		isnull(budYTD.rowAmount,0) YTD, 
		isnull(budYTG.rowAmount,0) - isnull(budYTD.rowAmount,0) YTG, 
		isnull(budYTG.rowAmount,0) FullYear
		from
		(select rowCode, rowAmount
		from @budgetOverview budYTG
		where rowStep between 23.1 and 23.6
		and rowMonth = 12
		) budYTG 
		left outer join
		(select rowCode, rowAmount
		from @budgetOverview budYTD
		where rowStep between 23.1 and 23.6
		and rowMonth = datepart(month, getdate()) - 1
		) budYTD on budYTD.rowCode = budYTG.rowCode

		Declare @latestRFTYTD as float
		Declare @latestRFTYTG as float

		select @latestRFTYTD = sum(rowAmount)
		from @budgetOverview where rowCode = 'latestRF' and rowMonth < datepart(month, getdate())

		select @latestRFTYTG = sum(rowAmount)
		from @budgetOverview where rowCode = 'latestRF' and rowMonth >= datepart(month, getdate())

		insert into @tblTop1
		select 'totalSpendTL', sum(YTD), sum(YTG), sum(fullyear)
		from @tblTop1
		where rowCode <> 'availBudgetTL'

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

		if (select count(distinct budgetOwnerName) from @tblCusGroup where budgetOwnerName <> '') > 1
		begin
			set @budgetTitle = 'Multiple Budget Owners'
		end
		else
		begin
			select top 1 @budgetTitle = budgetOwnerName from @tblCusGroup where budgetOwnerName <> ''
		end

		if @loadBudget = 1
		begin
			select * from @budgetOverview
			--where rowMonth = 1
			order by rowstep, rowMonth

			select helper.rowCode, isnull(ytd,0) YTD, isnull(ytg,0) YTG, isnull(fullyear,0) FullYear 
			from tblBudgetOverviewHelper helper 
			left outer join @tblTop1 top1 on top1.rowCode collate Latin1_General_CI_AI = helper.rowCode or top1.rowCode is null
			where helper.tblName = 'topLeft' and helper.countryID = @countryID and helper.roleID is null
				and helper.departmentID is null and forWebPage = 1

			select rowCode, sum(budget) Budget, sum(latestRF) latestRF from
			(
			select 
			helper.rowCode, isnull(Budget,0) Budget, isnull(latestRF,0) latestRF
			from tblBudgetOverviewHelper helper 
			left outer join 
			(
			select 
			bos.rowCode, case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end as Budget, 
			case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end latestRF
			from tblBudgetOverviewSummary bos
			inner join (select distinct cusgroup5id, cusgroup6id, secGroup2ID from @tblCusGroup) cusgroup on	
				(cusgroup.cusGroup5ID = bos.cusGroup5ID and cusgroup.cusGroup6ID = bos.cusGroup6ID)
				AND (cusgroup.secGroup2ID = bos.secGroup2ID or (cusgroup.secGroup2ID is null and bos.secGroup2ID is null))
			where budgetOverviewID = @budgetId
			group by bos.rowCode
			) top2 on top2.rowCode = helper.rowCode or top2.rowCode is null
			where helper.tblName = 'topRight' and helper.countryID = @countryID and helper.roleID is null
				and helper.departmentID is null and forWebPage = 1
			--union
			--select 
			--helper.rowCode, isnull(Budget,0) Budget, isnull(latestRF,0) latestRF
			--from tblBudgetOverviewHelper helper 
			--left outer join 
			--(
			--select 
			--bos.rowCode, case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end as Budget, 
			--case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end latestRF
			--from tblBudgetOverviewSummary bos
			--inner join (select distinct secGroup2ID from @tblCusGroup) cusgroup on	
			--	cusgroup.secGroup2ID = bos.secGroup2ID
			--where budgetOverviewID = @budgetId
			--group by bos.rowCode
			--) top2 on top2.rowCode = helper.rowCode or top2.rowCode is null
			--where helper.tblName = 'topRight' and helper.countryID = @countryID and helper.roleID is null
			--	and helper.departmentID is null and forWebPage = 1
			) a
			group by rowCode

			--select @budgetTitle
			select distinct budgetOwnerName from @tblCusGroup where budgetOwnerName <> ''
		end

		if @saveBudget = 1
		begin
			insert into tblPromotionBudgetOverview (promotionID, tblName, rowCode, roleID)
			select @promotionID, 'title', @budgetTitle, @roleID
		
			insert into tblPromotionBudgetOverview (promotionID, tblName, rowCode, rowAmount, rowMonth, roleID)
			select @promotionID, 'centre', rowCode, rowAmount, rowMonth, @roleID
			from @budgetOverview

			insert into tblPromotionBudgetOverview(promotionID, tblName, rowCode, rowAmount, budgetPivot, roleID)
			select @promotionID, 'topLeft', rowCode, isnull(rowAmount,0) rowAmount, rowPivot, @roleID
			from
			(
			select helper.rowCode, isnull(ytd,0) YTD, isnull(ytg,0) YTG, isnull(FullYear,0) FullYear 
			from tblBudgetOverviewHelper helper 
			left outer join @tblTop1 top1 on top1.rowCode collate Latin1_General_CI_AI = helper.rowCode or top1.rowCode is null
			where helper.tblName = 'topLeft' and helper.countryID = @countryID and helper.roleID is null
				and helper.departmentID is null and helper.forWebPage = 1
			) p 
			unpivot 
			(
			rowAmount for rowPivot in (YTD, YTG, FullYear)
			)as unpvt

			insert into tblPromotionBudgetOverview(promotionID, tblName, rowCode, rowAmount, budgetPivot)
			select @promotionID, 'topRight', rowCode, isnull(rowAmount,0) rowAmount, rowPivot
			from
			(
			select rowCode, sum(budget) Budget, sum(latestRF) latestRF from
			(
			select 
			helper.rowCode, isnull(Budget,0) Budget, isnull(latestRF,0) latestRF
			from tblBudgetOverviewHelper helper 
			left outer join 
			(
				select 
				bos.rowCode, case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end as Budget, 
				case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end latestRF
				from tblBudgetOverviewSummary bos
				inner join (select distinct cusgroup5id, cusgroup6id from @tblCusGroup) cusgroup on	
					(cusgroup.cusGroup5ID = bos.cusGroup5ID and cusgroup.cusGroup6ID = bos.cusGroup6ID)
					--or cusgroup.secGroup2ID = bos.secGroup2ID
				where budgetOverviewID = @budgetId
				group by bos.rowCode
				) top2 on top2.rowCode = helper.rowCode or top2.rowCode is null
				where helper.tblName = 'topRight' and helper.countryID = @countryID and helper.roleID is null
					and helper.departmentID is null and forWebPage = 1
				union
				select 
				helper.rowCode, isnull(Budget,0) Budget, isnull(latestRF,0) latestRF
				from tblBudgetOverviewHelper helper 
				left outer join 
				(
				select 
				bos.rowCode, case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end as Budget, 
				case when rowCode = 'balTotalTradeSpendPerc' or rowCode = 'promoInv' or rowCode = 'fts' then avg(bos.budget) else sum(bos.budget) end latestRF
				from tblBudgetOverviewSummary bos
				inner join (select distinct secGroup2ID from @tblCusGroup) cusgroup on	
					cusgroup.secGroup2ID = bos.secGroup2ID
				where budgetOverviewID = @budgetId
				group by bos.rowCode
				) top2 on top2.rowCode = helper.rowCode or top2.rowCode is null
				where helper.tblName = 'topRight' and helper.countryID = @countryID and helper.roleID is null
					and helper.departmentID is null and forWebPage = 1
				) a
				group by rowCode
			) p 
			unpivot 
			(
			rowAmount for rowPivot in (Budget, latestRF)
			)as unpvt
		end
	end
	else
	begin
		if @loadBudget = 1
		begin
			if @roleID is null
			begin
				-- load from tblPromotionBudgetOverview
				select promotionID, tblName, rowCode, rowAmount, rowMonth
				from tblPromotionBudgetOverview
				where promotionID = @promotionID and tblName = 'centre'
					and roleID is null

				select rowCode, YTD, YTG, FullYear
				from 
				(
					select rowCode, budgetPivot, rowAmount from tblPromotionBudgetOverview
					where 
					promotionID = @promotionID and 
					tblName = 'topLeft' and roleID is null
				) p
				pivot
				(
					avg(rowAmount) for budgetPivot in (YTD, YTG, FullYear)
				) pvt

	
				select rowCode, Budget, latestRF
				from 
				(
					select rowCode, budgetPivot, rowAmount from tblPromotionBudgetOverview
					where 
					promotionID = @promotionID and 
					tblName = 'topRight' and roleID is null
				) p
				pivot
				(
					avg(rowAmount) for budgetPivot in (Budget, latestRF)
				) pvt

				select rowCode from tblPromotionBudgetOverview
				where promotionID = @promotionID and tblName = 'title'
					and roleID is null
			end
		end
	end

end
else
begin
	exec spx_GetBudgetOverviewForRoleOrDepartment 
		@promotionID,
		@countryID, 
		@saveBudget,
		@loadBudget,
		@roleID,
		@departmentID
end

END

