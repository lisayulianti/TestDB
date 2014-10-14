-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 18 Aug 2014
-- Description:	Get end of month of the input datetime
-- =============================================
CREATE FUNCTION [dbo].[fGetEndOfMonth]
(
@date as datetime
)
RETURNS datetime
AS
BEGIN
	-- Return the result of the function
	RETURN DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,-1,@date),0))

END



