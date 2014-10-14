-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 1 Sep 2014
-- Description:	to get budget overview report filters
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportBudgetOverviewFilters]
@countryID int,
@userID int
AS
BEGIN

SET NOCOUNT ON;

exec spx_ReportGetFilters @countryID, 'budgetOverview'

Declare @budgetId as int
Select top 1 @budgetID = budgetOverviewId
from tblBudgetOverview
where countryID = @countryID
order by createdDate desc

select distinct cusGroup5ID, cusGroup6ID, secGroup2ID
from tblBudgetOverviewSummary
where budgetOverviewID = @budgetId

exec spx_ReportSettings @countryID, @userID, 'BudgetOverview'

END

