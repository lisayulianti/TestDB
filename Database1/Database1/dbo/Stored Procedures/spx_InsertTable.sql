CREATE PROCEDURE [dbo].[spx_InsertTable]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@targetFieldNames varchar(MAX),	-- target field names in the FieldName1, FieldName2 format
	@sourceFieldNames varchar(MAX), -- source field names in the src.FieldName1, src.FieldName2 format
	@setString varchar(MAX) = '',
	@checkDuplicateFieldNames varchar(MAX), -- source field names for checking duplicate in the FieldName1, FieldName2 format
	@startRow varchar(10) = '1',
	@isOverwrite bit = 0,
	@isIDInsert bit = 0,
	@isTempDB bit = 0,
	@Constraint varchar(MAX) = '',
	@preProcessSP varchar(200) = '',
	@postProcessSP varchar(200) = '',
	@importLogId varchar(10) = '0'
AS
BEGIN

	DECLARE @SQL nvarchar(MAX)
	SET @SQL = ''

	-- Only import if the target table exists
	IF OBJECT_ID (@targetTable,'U') IS NOT NULL

		BEGIN
			-- Set warnings to off, to prevent the procedure from failing when columns need to be cropped
			SET ANSI_WARNINGS OFF

			-- Check duplicate
			IF @setString<>''
			BEGIN
					SET @SQL = 'EXEC spx_IgnoreDuplicate ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @targetTable + ''', ''' + @sourceTable + ''', ''' + REPLACE(@setString,'''','''''') 
								+ ''', ''' + REPLACE(@checkDuplicateFieldNames,'''','''''') + ''''
					EXEC sp_executesql @SQL
			END

			--run Pre Process stored procedure
			IF @preProcessSP <> ''
			BEGIN
				SET @SQL = 'EXEC ' + @preProcessSP + ' ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @targetTable + ''', ''' + @sourceTable + ''', ''' + @importLogId + ''''
				EXEC sp_executesql @SQL
			END

			-- If @isOverwrite then Empty the table
			IF @isOverwrite = 1 
			BEGIN
				IF @sourceTable = 'tempTable3'
				BEGIN
					SET @SQL = 'DELETE ' + @targetTable + ' WHERE countryID=(SELECT TOP 1 F2 FROM ' + @sourceTable +  ')'
					EXEC sp_executesql @SQL
				END
				ELSE
				BEGIN
					SET @SQL = 'DELETE ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200))
					EXEC sp_executesql @SQL
				END
			END

			-- delete unnecessary rownum, to prevent unmatch datatype between header and data
			SET @SQL = 'WITH tblDelete AS (
						SELECT *,ROW_NUMBER() OVER (ORDER BY (SELECT 0)) as rowNum FROM ' + @sourceTable + ' ) 
						DELETE FROM tblDelete WHERE rowNum <' + @startRow
			EXEC sp_executesql @SQL

			-- Check Indentity Insert
			IF @isIDInsert = 1 
			BEGIN
				SET @SQL = 'SET IDENTITY_INSERT ' + @targetTable + ' ON '
			END
			ELSE
			BEGIN
				SET @SQL = ''
			END

			-- Insert the new records
			SET @SQL = @SQL + 'INSERT INTO ' + @targetTable +
			' (' + @targetFieldNames + ', importLogID)' +
			' SELECT ' + @sourceFieldNames + ', ' + @importLogId + 
			' FROM ' + 
				' (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 0)) AS rowNum, * FROM (
						SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 0)) AS tmpNum, * FROM ' + @sourceTable + ') AS tmpsrc) AS src WHERE 1=1 '
			IF @Constraint<>''
			BEGIN
				SET @SQL = @SQL + ' AND ' + @Constraint
			END 

			EXEC sp_executesql @SQL			
			
			--Update tblSetTimeStamp table
			SET @SQL = 'IF EXISTS ( SELECT 1 FROM ' + @sourceTable + ')
				BEGIN
					UPDATE tblSetTimeStamp
					SET stpSyncStamp=0, stpSqlStamp = GETDATE()
					WHERE stpTableName = ''' + @targetTable + ''' AND countryID=' + CAST(@countryID AS VARCHAR(200)) + '
				END'
			EXEC sp_executesql @SQL

			SET @SQL = 'IF EXISTS(SELECT stpFieldLatest FROM tblSetTimeStamp
					WHERE stpTableName = ''' + @targetTable + ''' AND countryID=' + CAST(@countryID AS VARCHAR(200)) + ' AND stpFieldLatest IN 
					(SELECT COLUMN_NAME FROM information_schema.columns WHERE table_name = ''' + @targetTable + '''))
				BEGIN
					DECLARE @SQL nvarchar(MAX),@colName AS VARCHAR(50)
					SELECT @colName = stpFieldLatest FROM tblSetTimeStamp WHERE stpTableName = ''' + @targetTable + ''' AND countryID=' + CAST(@countryID AS VARCHAR(200)) + '
					SET @SQL = ''IF (SELECT MAX('' +@colName + '') FROM ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200)) + ') IS NOT NULL
							BEGIN						
								DECLARE @SQL nvarchar(MAX),@colName AS VARCHAR(50)	
								IF (SELECT ISDATE(CAST(MAX('' +@colName + '') AS VARCHAR(50))) FROM ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200)) + ')=1
								BEGIN	
									SET @colName = '''''' +@colName + ''''''						
									SET @SQL = ''''UPDATE tblSetTimeStamp SET stpSqlLatest = (SELECT CAST(YEAR(MAX('''' +@colName + '''')) AS INT)*10000 + CAST(MONTH(MAX('''' +@colName + '''')) AS INT)*100 + CAST(DAY(MAX('''' +@colName + '''')) AS INT) 
										FROM ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200)) + ') 
									WHERE stpTableName = ''''''''' + @targetTable + ''''''''' AND countryID=' + CAST(@countryID AS VARCHAR(200)) + '''''
									EXEC sp_executesql @SQL
								END
								ELSE
								BEGIN
									SET @colName = '''''' +@colName + ''''''		
									SET @SQL = ''''UPDATE tblSetTimeStamp SET stpSqlLatest = (SELECT MAX('''' +@colName + '''') FROM ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200)) + ') 
									WHERE stpTableName = ''''''''' + @targetTable + ''''''''' AND countryID=' + CAST(@countryID AS VARCHAR(200)) + '''''
									EXEC sp_executesql @SQL
								END
							END''
					EXEC sp_executesql @SQL
				END'
			EXEC sp_executesql @SQL

			--run Post Process stored procedure
			IF @postProcessSP <> ''
			BEGIN
				SET @SQL = 'EXEC ' + @postProcessSP + ' ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @targetTable + ''', ''' + @sourceTable + ''', ''' + @importLogId + ''''
				EXEC sp_executesql @SQL
			END

			--if from file, delete temp table
			IF @isTempDB = 1
			BEGIN
				SET @SQL = 'DROP TABLE ' + @sourceTable
				EXEC sp_executesql @SQL
			END

			SET ANSI_WARNINGS ON

		END
END




