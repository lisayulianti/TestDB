-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 8 Sep 2014
-- Description:	to get the budget overview report
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateBudgetOverviewReport]
@countryID int,
@reportID int,
@budgetOwners BudgetGroups READONLY
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

-- get filename
if @reportID = 0  
begin
	set @reportID = null
end

if @reportID is not null
begin
	select top 1 
	[FileName] 
	from tblReportTemplate 
	where reportID = @reportID 
end
else
begin
	select 'BudgetOverview.xls' FileName
end
-- get helpers

exec spx_FetchBudgetOverviewHelper 
	@countryID = @countryID, 
	@reportID = @reportID,
	@forWebPage = null,
	@forOutputReport = 1

Declare @strSP as nvarchar(500)

select top 1 @strSP = N'exec ' + sqlSP + N' @countryID, @reportID, @budgetOwners'
from tblBudgetOverviewReport
where ((reportID is null and @reportID is null) or reportID = @reportID)
	and countryID = @countryID

-- this stored procedure is designed with assumption that all budget overview report SPs always have 3 parameters: @countryID, @reportID and @budgetOwners
execute sp_executesql @strSP , N'@countryID int, @reportID int, @budgetOwners BudgetGroups READONLY',
	@countryID = @countryID, @reportID = @reportID, @budgetOwners = @budgetOwners

-- the stored procedure must return at least 2 sets of data
-- 1. filename (from tblReportTemplate)
-- 2. helper table (from tblBudgetOverviewHelper)
-- 3. list of budget owner names
-- 4. main/detail list of budgets of which linked tblBudgetOverviewHelper
-- 5. if there is any summary tables (like the tables on the top in normal user budget overview), it will be in the last sets returned by SP

END

