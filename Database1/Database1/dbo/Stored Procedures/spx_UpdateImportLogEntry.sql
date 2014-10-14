-- =============================================
-- Author:		<Author,,Name>
-- create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdateImportLogEntry]
@importLogID INT,
@imlImportLogDescription VARCHAR(200)
AS
BEGIN
	UPDATE tblImportLog 
		SET imlImportLogDescription = @imlImportLogDescription
		WHERE importLogID = @importLogID;
END




