-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 19 Aug 2014
-- Description:	daily job to insert budget owner's data
-- =============================================
CREATE PROCEDURE [dbo].[spx_DailyJobCalculateBudget]
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

Declare @countryID as int

DECLARE country_cursor CURSOR for
select countryID from tblCountry

OPEN country_cursor
FETCH NEXT from country_cursor into @countryID

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC spx_CalculateBudgetOverview @countryID
	FETCH NEXT from country_cursor into @countryID
END

CLOSE country_cursor
DEALLOCATE country_cursor

END



