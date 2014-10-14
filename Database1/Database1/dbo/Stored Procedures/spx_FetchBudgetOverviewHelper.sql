

-- =============================================
-- Author:		Anthony Steven
-- Create date: 7th August 2014
-- Description:	Fetch Budget Overview Helper
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchBudgetOverviewHelper] 
	@countryID int,
	@userID int = 0,
	@reportID int = 0,
	@forWebPage bit = null,
	@forOutputReport bit = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @reportID = 0
	begin
		Declare @roleID as int
		Declare @departmentID as int

		select top 1 @roleID = useRole, @departmentID = useDepartment from tblUser where userID = @userID and countryID = @countryID

		if NOT EXISTS (select distinct roleID from tblBudgetOverviewHelper where countryID = @countryID and roleID = @roleID and forWebPage = 1)
		begin
			set @roleID = null
		end

		if NOT EXISTS (select distinct roleID from tblBudgetOverviewHelper where countryID = @countryID and departmentID = @departmentID and forWebPage = 1)
		begin
			set @departmentID = null
		end
	
	   select tblName,rowOrder,rowCode,
	   rowDescription,
	   rowGroup,rowSubGroup,rowBold,rowEmpty,rowPercentage,rowTotal,
		case when (rowGroup = rowCode or rowGroup is null) and rowBold = 1  then 0  
		when (rowGroup <> rowCode and rowSubGroup is null) or ((rowGroup = rowCode or rowGroup is null) and rowBold = 0)  then 20  	
		when rowGroup <> rowCode and rowSubGroup is not null then 40
		end as rowMargin
		from tblBudgetOverviewHelper 
		where ((@roleID is null and roleID is null) or roleID = @roleID)
			and ((@departmentID is null and departmentID is null) or departmentID = @departmentID)
			and (@forWebPage is null or forWebPage = @forWebPage) 
			and (@forOutputReport is null or forOutputReport = @forOutputReport)
			and rowDisplayed = 1
		union
		select tblName,rowOrder - 1,'gap',
		   'gap',
		   null,null,rowBold,rowEmpty,rowPercentage,rowTotal,
		case when (rowGroup = rowCode or rowGroup is null) and rowBold = 1  then 0  
		when (rowGroup <> rowCode and rowSubGroup is null) or ((rowGroup = rowCode or rowGroup is null) and rowBold = 0)  then 20  	
		when rowGroup <> rowCode and rowSubGroup is not null then 40
		end as rowMargin
		from tblBudgetOverviewHelper 
		where tblName = 'centre' and rowGroup = rowCode
			and ((@roleID is null and roleID is null) or roleID = @roleID)
			and ((@departmentID is null and departmentID is null) or departmentID = @departmentID)
			and (@forWebPage is null or forWebPage = @forWebPage) 
			and (@forOutputReport is null or forOutputReport = @forOutputReport)
			and rowDisplayed = 1
	end
	else
	begin
	   select tblName,rowOrder,rowCode,
	   rowDescription,
	   rowGroup,rowSubGroup,rowBold,rowEmpty,rowPercentage,rowTotal,
		case when (rowGroup = rowCode or rowGroup is null) and rowBold = 1  then 0  
		when (rowGroup <> rowCode and rowSubGroup is null) or ((rowGroup = rowCode or rowGroup is null) and rowBold = 0)  then 20  	
		when rowGroup <> rowCode and rowSubGroup is not null then 40
		end as rowMargin
		from tblBudgetOverviewHelper 
		where ((@reportID is null and reportID is null) or reportID = @reportID)
			and (@forWebPage is null or forWebPage = @forWebPage) 
			and (@forOutputReport is null or forOutputReport = @forOutputReport)
			and rowDisplayed = 1
		union
		select tblName,rowOrder - 1,'gap',
		   'gap',
		   null,null,rowBold,rowEmpty,rowPercentage,rowTotal,
		case when (rowGroup = rowCode or rowGroup is null) and rowBold = 1  then 0  
		when (rowGroup <> rowCode and rowSubGroup is null) or ((rowGroup = rowCode or rowGroup is null) and rowBold = 0)  then 20  	
		when rowGroup <> rowCode and rowSubGroup is not null then 40
		end as rowMargin
		from tblBudgetOverviewHelper 
		where tblName = 'centre' and rowGroup = rowCode
			and ((@reportID is null and reportID is null) or reportID = @reportID)
			and (@forWebPage is null or forWebPage = @forWebPage) 
			and (@forOutputReport is null or forOutputReport = @forOutputReport)
			and rowDisplayed = 1
	end
END





