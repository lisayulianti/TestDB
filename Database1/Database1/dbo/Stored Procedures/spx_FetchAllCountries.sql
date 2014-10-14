-- =============================================
-- Author:		Anthony Steven
-- Create date: 14th August 2014
-- Description:	Fetch All Countries
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchAllCountries]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT countryID, countryName 
	FROM tblCountry WITH (NOLOCK) ORDER BY countryName
END



