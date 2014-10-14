-- =============================================
-- Author:		Anthony Steven
-- Create date: 14th August 2014
-- Description:	Fetch Countries By User
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchCountriesByUser]
	@userId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT c.countryID, c.countryName 
	FROM tblCountry c  WITH (NOLOCK) inner join tblUserCountry uc  WITH (NOLOCK) 
	on c.countryID = uc.countryID
	WHERE uc.userID = @userId
END



