CREATE PROCEDURE [dbo].[spx_CheckFileEntry]
@countryID INT,
@chkFileName NVARCHAR(200), 
@chkFileSizeKB INT
AS
BEGIN
	UPDATE tblImportLog SET chkFileSizeKB = @chkFileSizeKB WHERE countryID = @countryID AND imlFileName = @chkFileName
END



