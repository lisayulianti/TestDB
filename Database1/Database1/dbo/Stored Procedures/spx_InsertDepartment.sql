-- =============================================
-- Author:		Robert de Castro
-- Create date: 18 July 2014
-- Description:	Checks the last Department ID and inserts a new record in tblDepartment
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertDepartment]
	-- Add the parameters for the stored procedure here
	@countryId int,
	@departmentName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET IDENTITY_INSERT tblDepartment ON

	DECLARE @lastDepartmentId int

	SELECT @lastDepartmentId = MAX(departmentID) + 1 FROM tblDepartment WHERE countryID = @countryId
	
	INSERT INTO tblDepartment (departmentID, countryID, depDepartmentName) VALUES(@lastDepartmentId, @countryId, @departmentName)
END



