-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 03 July 2014
-- Description:	Fill in columns in tblPromotion related to GrossSales/Expenses/GP/GPPerc
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromotionApprovalTarget]
	@PromotionID int,
	@Result int output
AS
BEGIN

SET NOCOUNT ON;

declare @maxBudgetAndForecastNr as int
set @maxBudgetAndForecastNr = 0

if exists (
	select top 1 prm.promotionid from tblpromotion prm
	inner join tblPromoFinancial fin on fin.promotionID = prm.promotionid 
	where prm.promotionID = @promotionID)
begin
	-- get the max tblBudgetAndForecast

	Declare @tblCusGroup as table
	(
		promotionID int,
		cusGroup5ID int,
		cusGroup6ID int,
		secGroup2ID int
	)

	-- LKY (2014.10.09): commented
	--insert into @tblCusGroup
	--select distinct
	--@promotionID, null, null, secGroup2ID 
	--from vw_PromoSecCust vsec
	--inner join tblSecondaryCustomer seccust on seccust.secondaryCustomerID = vsec.secondaryCustomerID 
	--where promotionID = @promotionID

	--if not exists (select top 1 secgroup2id from @tblCusGroup)
	--begin
	--	insert into @tblCusGroup
	--	select distinct
	--	@promotionID, cusGroup5ID, cusGroup6ID, null
	--	from vw_PromoCust v
	--	inner join tblCustomer cust on cust.customerID = v.customerID
	--	where promotionID = @promotionID
	--end

	insert into @tblCusGroup
	select distinct @promotionID, cusGroup5ID, cusGroup6ID, null
	from vw_PromoCust prmcust WITH (NOLOCK)
	inner join tblCustomer cust WITH (NOLOCK) on prmcust.customerId = cust.customerID
	where promotionID = @promotionID
	union
	select distinct @promotionID, cust1.cusGroup5ID, cust1.cusGroup6ID, secGroup2ID
	from vw_PromoSecCust prmcust WITH (NOLOCK)
	inner join tblSecondaryCustomer cust WITH (NOLOCK) on prmcust.secondaryCustomerId = cust.secondaryCustomerID and prmcust.customerID = cust.customerID
	inner join tblCustomer cust1 WITH (NOLOCK) on cust1.customerID = prmcust.customerID
	where promotionID = @promotionID

	select @maxBudgetAndForecastNr = max (budBudgetNr)
	from tblBudgetAndForecast

	-- update values for all tblPromotion additional columns
	update tblPromotion
	set
		prmBudgetNr = @maxBudgetAndForecastNr,
		prmGrossSales = bud1.AptGrossSales,
		prmTotalExpenses = bud1.aptTotalExpenses,
		prmGP = bud1.aptGP,
		prmGPPerc = (bud1.aptGP - bud1.aptListingFees) / bud1.AptGrossSales,
		prmListingFees = bud1.aptListingFees
	from tblPromotion prm
	inner join (
		select @promotionID promotionID,
			sum(bud.budGrossSales) AptGrossSales,
			SUM(bud.budTradeSpend)+SUM(bud.budSandD)+SUM(bud.budTARO)+SUM(bud.budMaterialCost)+SUM(bud.budProductionCost)+SUM(bud.budVariances)+SUM(bud.budAAndPPromo) aptTotalExpenses,
			SUM(bud.budGP) aptGP,
			--AVG(bud.budGPPerc) aptGPPerc,
			SUM(bud.budListingFees) aptListingFees
		from (
		select bud.budGrossSales, bud.budTradeSpend, bud.budSAndD, bud.budTARO, bud.budMaterialCost, bud.budProductionCost, bud.budVariances,
		bud.budAAndPPromo, bud.budGP, bud.budGPPerc, bud.budListingFees
		from tblPromotion prm WITH (NOLOCK)
		inner join @tblCusGroup prmcust on prm.promotionID = prmcust.promotionID
		inner join tblBudgetAndForecast bud WITH (NOLOCK) on 
		(prmcust.cusGroup5ID is null or prmcust.cusGroup5ID = bud.cusGroup5ID)
		and
		(prmcust.cusGroup6ID is null or prmcust.cusGroup6ID = bud.cusGroup6ID)
		and 
		(prmcust.secGroup2ID is null or prmcust.secGroup2ID = bud.secGroup2ID)
		inner join tblPromotionProductSelection prmprd WITH (NOLOCK) on prm.promotionid = prmprd.promotionID
		inner join tblProduct prd WITH (NOLOCK) on prd.productID = prmprd.prdProductID and bud.budParentCode = prd.prdParentCode
		where prm.promotionID = @PromotionID 
		) bud
	) bud1 on prm.promotionID = bud1.promotionID
	where prm.promotionID = @promotionID
	
	set @Result = 1
end	
else
begin
	set @Result = 0
end

END

