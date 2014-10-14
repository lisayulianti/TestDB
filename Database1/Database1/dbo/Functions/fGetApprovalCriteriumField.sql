-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fGetApprovalCriteriumField]
(
	@PromotionID int,
	@ApprovalCriteriumFieldID int
)
RETURNS varchar(100)
AS
BEGIN

	Declare @query as nvarchar(max)
	Declare @from as nvarchar(max)
	Declare @where as nvarchar(max)
	Declare @type as nvarchar(max)
	Declare @result as nvarchar(100)	

	select @query = acfQuery, @from = acfFrom, @where = acfWhere, @type = acfFieldType
	from tblApprovalCriteriumField
	where approvalCriteriumFieldId = @ApprovalCriteriumFieldID
	
	Declare @sqlString as nvarchar(max)
	
	set @sqlString = N'select @resultOUT = cast(' + @query + ' as nvarchar(max)) from ' + @from + ' where ' + @where + ' ' + cast (@promotionID as nvarchar(100))

	Declare @params as nvarchar(max)
	set @params = N'@ResultOUT nvarchar(max) OUTPUT'

	execute sp_executesql @sqlstring, @params, @resultOUT = @result OUTPUT;

	-- Return the result of the function
	RETURN @result

END



