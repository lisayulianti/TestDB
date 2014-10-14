
-- =============================================
-- Author:		Nora Limanto / Lisa Yulianti 
-- Create date: 21 Aug 2014
-- Description:	Get report filters
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportGetFilters] 
@countryID int,
@report varchar(100)
--@userID int = null
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

IF @report = 'Accrual'
begin
-- include cusGroup1 as a filter

select 
'Channel' as filterCode, cusGroup1ID as filterValue, c01CusGroup1Desc as filterText
from tblCusGroup1 WITH (NOLOCK) 
where countryID = @countryID
UNION
select 
'DMSKey' as filterCode, secGroup2ID as filterValue, s02SecGroup2ClientCode as filterText
from tblSecGroup2 WITH (NOLOCK) 
where countryID =@countryID
order by filterText

end

IF @report = 'AccrualAging'
begin
-- include cusGroup1 as a filter

select 
'Channel' as filterCode, cusGroup1ID as filterValue, c01CusGroup1Desc as filterText
from tblCusGroup1 WITH (NOLOCK) 
where countryID = @countryID
UNION
select 
'SubChannel' as filterCode, cusGroup5ID as filterValue, c05CusGroup5Desc as filterText
from tblCusGroup5 WITH (NOLOCK) 
where countryID = @countryID
UNION
select 
'Region' as filterCode, cusGroup6ID as filterValue, c06CusGroup6Desc as filterText
from tblCusGroup6 WITH (NOLOCK) 
where countryID = @countryID
UNION
select 
'PromotionStatus' as filterCode, promotionStatusID as filterValue, psStatusDescription as filterText
from tblpromotionStatus WITH (NOLOCK) 
where countryID = @countryID AND promotionStatusID IN (8,9,10,11,12)
order by filterText

end

IF @report = 'budgetOverview'
begin

Declare @tblCusGroup as table
(
	cusGroup5ID int,
	cusGroup6ID int,
	secGroup2ID int
)


Declare @budgetId as int
Select top 1 @budgetID = budgetOverviewId
from tblBudgetOverview WITH (NOLOCK) 
where countryID = @countryID
order by createdDate desc


Insert into @tblCusGroup
select distinct cusGroup5ID, cusGroup6ID, secGroup2ID
from tblBudgetOverviewSummary WITH (NOLOCK) 
where budgetOverviewID = @budgetId

	select 
	'SubChannel' as filterCode, cg.cusGroup5ID as filterValue, c05CusGroup5Desc as filterText
	from tblCusGroup5 cg5 WITH (NOLOCK) 
	inner join @tblCusGroup cg on cg.cusGroup5ID = cg5.cusGroup5ID
	where countryID = @countryID
	--and (@userID is null or cusGroup5ID in (
	--select 
	--cusGroup5ID
	--from tblUser usr 
	--inner join tblUserGroup usg on usr.userID = usg.userID
	--where usr.useIsActive = 1 and usr.userID = @userID)
	--)
	UNION
	select 
	'Region' as filterCode, cg.cusGroup6ID as filterValue, c06CusGroup6Desc as filterText
	from tblCusGroup6 cg6 WITH (NOLOCK) 
	inner join @tblCusGroup cg on cg.cusGroup6ID = cg6.cusGroup6ID
	where countryID = @countryID
	--and (@userID is null or cusGroup6ID in (
	--select 
	--cusGroup6ID
	--from tblUser usr 
	--inner join tblUserGroup usg on usr.userID = usg.userID
	--where usr.useIsActive = 1 and usr.userID = @userID)
	--)
	UNION
	select 
	'DMS' as filterCode, cg.secGroup2ID as filterValue, s02SecGroup2ClientCode as filterText
	from tblSecGroup2 sg2 WITH (NOLOCK) 
	inner join @tblCusGroup cg on cg.secGroup2ID = sg2.secGroup2ID
	where countryID =@countryID 
	--and (@userID is null or secGroup2ID in (
	--select 
	--secGroup2ID
	--from tblUser usr 
	--inner join tblUserGroup usg on usr.userID = usg.userID
	--where usr.useIsActive = 1 and usr.userID = @userID)
	--)
end

END
