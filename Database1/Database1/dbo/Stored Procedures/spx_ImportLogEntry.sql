-- =============================================
-- Author:		<Author,,Name>
-- create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_ImportLogEntry]
@countryID INT,
@imlFilePeriod VARCHAR(6), 
@imlFileName VARCHAR(200), 
@imlFileCode VARCHAR(200),
@imlImportDate DATETIME,
@imlTargetTable VARCHAR(200),
@imlImportLogDescription VARCHAR(200)
AS
BEGIN
	IF EXISTS (SELECT importLogID FROM tblImportLog AS iml
		WHERE iml.countryID = @countryID AND iml.imlFileName = @imlFileName AND iml.imlTargetTable = @imlTargetTable AND iml.imlFilePeriod = @imlFilePeriod) 
		BEGIN
		UPDATE tblImportLog SET 
			countryID=@countryID,
			imlFilePeriod=@imlFilePeriod,
			imlFileName=@imlFileName,
			imlFileCode=@imlFileCode,
			imlImportDate=@imlImportDate, 
			imlTargetTable=@imlTargetTable, 
			imlImportLogDescription=@imlImportLogDescription
		WHERE countryID = @countryID AND imlFileName = @imlFileName AND imlTargetTable = @imlTargetTable AND imlFilePeriod = @imlFilePeriod

		SELECT importLogID FROM tblImportLog AS iml WHERE iml.countryID = @countryID AND iml.imlFileName = @imlFileName AND iml.imlTargetTable = @imlTargetTable AND imlFilePeriod = @imlFilePeriod
		END
	ELSE
		BEGIN
		INSERT INTO tblImportLog (countryID, imlFilePeriod, imlFileName, imlImportDate, imlTargetTable, imlImportLogDescription, imlFileCode)
			VALUES (@countryID, @imlFilePeriod, @imlFileName, @imlImportDate, @imlTargetTable, @imlImportLogDescription, @imlFileCode);

		SELECT SCOPE_IDENTITY()
		END
END




