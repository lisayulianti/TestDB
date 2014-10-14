CREATE PROCEDURE [dbo].[spx_IgnoreDuplicate]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@setString nvarchar(MAX),
	@checkDuplicateFieldNames varchar(MAX) -- source field names for checking duplicate in the FieldName1, FieldName2 format
AS
BEGIN
	DECLARE @SQL nvarchar(MAX)	
	--SET @setString = REPLACE(@setString,'=',' collate Latin1_General_CI_AI =')
	
	IF @sourceTable = 'tempTable' 
	BEGIN
		-- update import status for duplicate
		SET @SQL = 'UPDATE tblImportLog SET imlImportLogDescription2=ISNULL(imlImportLogDescription2,'''') + '' Some duplicate(s) were found and removed.''
					WHERE importLogID = ISNULL((SELECT TOP 1 importLogID FROM tblImportLog WHERE countryID = ' + CAST(@countryID AS VARCHAR(200)) + ' AND imlTargetTable = ''' + @targetTable + ''' AND imlImportLogDescription LIKE ''%Import started%''),0)
					AND EXISTS (SELECT 1 FROM ' + @sourceTable + ' src INNER JOIN ' + @targetTable + ' trg ON 
					' + @setString + ')'
		EXEC sp_executesql @SQL 		
		
		-- delete duplicate data from temp table
		SET @SQL = 'DELETE src FROM ' + @sourceTable + ' src' +
					' WHERE EXISTS (SELECT 1 FROM ' + @targetTable + ' AS trg 
					  WHERE ' + @setString + ')'
		EXEC sp_executesql @SQL
		
	END
	ELSE
	BEGIN
		-- update import status for duplicate
		SET @SQL = 'UPDATE tblImportLog SET imlImportLogDescription2=ISNULL(imlImportLogDescription2,'''') + '' Some duplicate(s) were found and removed.''
					WHERE importLogID = (SELECT TOP 1 importLogID FROM ' + @sourceTable + ' WHERE countryID = ' + CAST(@countryID AS VARCHAR(200)) + ')
					AND EXISTS (SELECT 1 FROM ' + @sourceTable + ' src INNER JOIN ' + @targetTable + ' trg ON 
					' + @setString + ')'
		EXEC sp_executesql @SQL 
			
		-- delete duplicate data from temp table
		SET @SQL = 'DELETE src FROM ' + @sourceTable + ' src' +
					' WHERE EXISTS (SELECT 1 FROM ' + @targetTable + ' AS trg 
					  WHERE ' + @setString + ')'
		EXEC sp_executesql @SQL
	END
END




