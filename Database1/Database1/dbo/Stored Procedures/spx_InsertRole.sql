-- =============================================
-- Author:		Robert de Castro
-- Create date: 17 July 2014
-- Description:	Insert a row in tblRole. Check the max roleID first.
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertRole]
	-- Add the parameters for the stored procedure here
	@countryId int,
	@roleName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET IDENTITY_INSERT tblRole ON

	DECLARE @lastRoleId int

	SELECT @lastRoleId = MAX(roleID) + 1 FROM tblRole WHERE countryID = @countryId
	
	INSERT INTO tblRole (roleID, countryID, rolRoleName) VALUES(@lastRoleId, @countryId, @roleName)
	
    
END



