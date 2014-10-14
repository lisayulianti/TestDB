-- =============================================
-- Author:		Anthony Steven
-- Create date: 14th August 2014
-- Description:	Return Logged-in User Data
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetLoggedInUser] 
	@username VARCHAR(100),
	@password VARCHAR(50),
	@countryId INT
AS
BEGIN
	
	SET NOCOUNT ON;

 
	  select u.userId,u.countryID,u.useEmail,u.useFullName,u.useMasterFinance, u.useMasterProfitTool, u.useDepartment as Department, u.useMasterImportApp
		from tblUser u 
		--inner join tblUserCountry uc
		--on u.userID = uc.userID 
		--inner join tblCountry c
		--on uc.countryID = c.countryID
		where u.useEmail = @username
		and u.usePassword = @password
		--and uc.countryID = @countryId
		AND useIsActive = 1

 -- select u.userId,uc.countryID,u.useEmail,u.useFullName,u.useMasterFinance, u.useMasterProfitTool, u.useDepartment as Department, u.useMasterImportApp
	--from tblUser u inner join tblUserCountry uc
	--on u.userID = uc.userID inner join tblCountry c
	--on uc.countryID = c.countryID
	--where u.useEmail = @username
	--and u.usePassword = @password
	--and uc.countryID = @countryId

END



