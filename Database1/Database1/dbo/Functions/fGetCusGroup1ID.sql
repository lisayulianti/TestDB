-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 27 Aug 2014
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fGetCusGroup1ID]
(
@cus1ClientCode nvarchar(50),
@cus1ClientDesc nvarchar(50),
@countryID int
)
RETURNS int
AS
BEGIN

Declare @cusGroup1ID as int

select top 1 @cusGroup1ID = cusGroup1ID 
from tblCusGroup1 
where (@cus1ClientCode = '' or c01CusGroup1ClientCode = @cus1ClientCode)
	and (@cus1ClientDesc = '' or c01CusGroup1Desc = @cus1ClientDesc)
	and countryID = @countryID

return @cusGroup1ID

END

