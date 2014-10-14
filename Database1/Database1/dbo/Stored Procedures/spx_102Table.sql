-- =============================================
-- Author:		Wouter van Rij
-- Create date: February 16th 2014
-- Description: Procedure merges tempTable with target table
-- =============================================
CREATE PROCEDURE [dbo].[spx_102Table]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@targetFieldNames varchar(MAX),	-- target field names in the FieldName1, FieldName2 format
	@sourceFieldNames varchar(MAX), -- source field names in the src.FieldName1, src.FieldName2 format
	@targetIdField varchar(100),
	@sourceIdField varchar(100),
	@setString varchar(MAX),
	@startRow varchar(10) = '1',
	@isTempDB bit = 0,
	@Constraint varchar(MAX) = '',
	@importLogId varchar(10) = '0'
AS
BEGIN
	DECLARE @SQL nvarchar(MAX)

	-- Only import if the target table exists
	IF OBJECT_ID (@targetTable,'U') IS NOT NULL

		BEGIN
			-- delete unnecessary rownum, to prevent unmatch datatype between header and data
			SET @SQL = 'WITH tblDelete AS (
			SELECT *,ROW_NUMBER() OVER (ORDER BY (SELECT 0)) as rowNum FROM ' + @sourceTable + ' ) 
			DELETE FROM tblDelete WHERE rowNum <' + @startRow
			EXEC sp_executesql @SQL
		
			--102 data
			SET @SQL = '102 ' + @targetTable +
						' SET ' + @setString + 
						' FROM ' + @targetTable + ' trg' +
						' INNER JOIN ' + @sourceTable + ' src ON trg.' + @targetIdField + ' = ' + @sourceIdField +
						' WHERE trg.countryID=' + CAST(@countryID AS VARCHAR(200))

			IF @Constraint<>''
			BEGIN
				SET @SQL = @SQL + ' AND ' + @Constraint
			END 

			EXEC sp_executesql @SQL	
			
			--102 tblSetTimeStamp table
			SET @SQL = 'IF EXISTS ( SELECT 1 FROM ' + @sourceTable + ')
				BEGIN
					102 tblSetTimeStamp
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
									SET @SQL = ''''102 tblSetTimeStamp SET stpSqlLatest = (SELECT CAST(YEAR(MAX('''' +@colName + '''')) AS INT)*10000 + CAST(MONTH(MAX('''' +@colName + '''')) AS INT)*100 + CAST(DAY(MAX('''' +@colName + '''')) AS INT) 
										FROM ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200)) + ') 
									WHERE stpTableName = ''''''''' + @targetTable + ''''''''' AND countryID=' + CAST(@countryID AS VARCHAR(200)) + '''''
									EXEC sp_executesql @SQL
								END
								ELSE
								BEGIN
									SET @colName = '''''' +@colName + ''''''		
									SET @SQL = ''''102 tblSetTimeStamp SET stpSqlLatest = (SELECT MAX('''' +@colName + '''') FROM ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200)) + ') 
									WHERE stpTableName = ''''''''' + @targetTable + ''''''''' AND countryID=' + CAST(@countryID AS VARCHAR(200)) + '''''
									EXEC sp_executesql @SQL
								END
							END''
					EXEC sp_executesql @SQL
				END'
			EXEC sp_executesql @SQL

			--if from file, delete temp table
			IF @isTempDB = 1
			BEGIN
				SET @SQL = 'DROP TABLE ' + @sourceTable
				EXEC sp_executesql @SQL
			END
		END
END



