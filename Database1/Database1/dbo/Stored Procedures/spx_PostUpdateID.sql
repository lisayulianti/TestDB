
CREATE PROCEDURE [dbo].[spx_PostUpdateID]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN
	DECLARE @targetFieldNames varchar(MAX)
	SELECT @targetFieldNames=COALESCE(@targetFieldNames + ', ', '') + COLUMN_NAME FROM information_schema.columns WHERE table_name = @targetTable

	DECLARE @rawFieldNames varchar(MAX),@setString varchar(MAX)='',@tempString varchar(100)='',@rawString varchar(100)='',@idColumn varchar(100),@idDigit varchar(100)='000000'
	SET @idColumn = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND COLUMNPROPERTY(OBJECT_ID(TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1 AND TABLE_NAME=@targetTable)
	-- since tempOutlet doesnt have Primary Key, it is required to define it manually
	IF @targetTable = 'tempOutlet'
	BEGIN
		SET @idColumn = 'outletID'
	END
	SET @targetFieldNames=REPLACE(REPLACE(@targetFieldNames,', '+@idColumn,''),@idColumn+', ','') -- remove id column from selection
	SET @rawFieldNames=@targetFieldNames

	-- set @idDigit for different table 
	IF @targetTable='tblSecGroup0'
	BEGIN
		SET @idDigit='0000000'
	END

	-- generate set string
	WHILE LEN(@rawFieldNames) > 0
	BEGIN
		IF PATINDEX('%,%',@rawFieldNames) > 0
		BEGIN
			SET @tempString = REPLACE(SUBSTRING(@rawFieldNames, 0, PATINDEX('%,%',@rawFieldNames)),' ','')
			SET @setString = @setString + ' AND ((tempID.' + @tempString + ' IS NULL AND src.' + @tempString + ' IS NULL) OR (tempID.' + @tempString + '=src.' + @tempString + '))'
			SET @rawString = SUBSTRING(@rawFieldNames, 0, PATINDEX('%,%',@rawFieldNames))

			SET @rawFieldNames = SUBSTRING(@rawFieldNames, LEN(@rawString + ',') + 1,LEN(@rawFieldNames))
		END
		ELSE
		BEGIN
			SET @rawFieldNames = REPLACE(@rawFieldNames,' ','')
			SET @setString = @setString + ' AND ((tempID.' + @rawFieldNames + ' IS NULL AND src.' + @rawFieldNames + ' IS NULL) OR (tempID.' + @rawFieldNames + '=src.' + @rawFieldNames + '))'
			SET @rawFieldNames = NULL
		END
	END
	SET @setString = RIGHT(@setString,LEN(@setString)-5)

	DECLARE @SQL nvarchar(MAX)=''	
	
	IF OBJECT_ID ('tempID','U') IS NOT NULL
	BEGIN
		-- drop temp table
		SET @SQL = 'DROP TABLE tempID'
		EXEC sp_executesql @SQL
	END

	-- insert 
	SET @SQL='SELECT DISTINCT ' + CAST(@countryID AS VARCHAR(200)) + @idDigit + ' ' + @idColumn + ',' + @targetFieldNames + ' INTO tempID FROM ' + @targetTable + ' WHERE ' + @idColumn + '>' + CAST(@countryID AS VARCHAR(200)) + @idDigit + '0'
	EXEC sp_executesql @SQL

	SET @SQL='UPDATE tempID
			SET tempID.' + @idColumn + ' = src.theNewID
			FROM
			 (
			   SELECT ' + @targetFieldNames + ',
				  ISNULL((SELECT MAX(' + @idColumn + ') FROM ' + @targetTable + ' WHERE countryID=' + CAST(@countryID AS VARCHAR(200)) + ' AND ' + @idColumn + '<' + CAST(@countryID AS VARCHAR(200)) + @idDigit + '0' + ' GROUP BY countryID),' + CAST(@countryID AS VARCHAR(200)) + @idDigit + ') +
				  ROW_NUMBER() OVER (ORDER BY ' + @targetFieldNames + ') AS theNewID 
			   FROM tempID WHERE ' + @idColumn + '=' + CAST(@countryID AS VARCHAR(200)) + @idDigit + '
			 ) AS src
			WHERE ' + REPLACE(@setString,'trg.','tempID.') + ' AND tempID.' + @idColumn + '=' + CAST(@countryID AS VARCHAR(200)) + @idDigit 
	EXEC sp_executesql @SQL

	SET @SQL='DELETE ' + @targetTable + ' WHERE ' + @idColumn + '>' + CAST(@countryID AS VARCHAR(200)) + @idDigit + '0'
	EXEC sp_executesql @SQL

	-- since tempOutlet doesnt have Primary Key, it is required to define it manually
	IF @targetTable = 'tempOutlet'
	BEGIN
		SET @SQL='IF EXISTS ( SELECT 1 FROM tempID)
			BEGIN
				INSERT INTO ' + @targetTable +' (' + @idColumn + ',' + @targetFieldNames + ')
				SELECT ' + @idColumn + ',' + @targetFieldNames + ' FROM tempID
			END'
	END
	ELSE
	BEGIN
		SET @SQL='IF EXISTS ( SELECT 1 FROM tempID)
			BEGIN
				SET IDENTITY_INSERT ' + @targetTable + ' ON 
				INSERT INTO ' + @targetTable +' (' + @idColumn + ',' + @targetFieldNames + ')
				SELECT ' + @idColumn + ',' + @targetFieldNames + ' FROM tempID
			END'
	END
	EXEC sp_executesql @SQL
	
	IF OBJECT_ID ('tempID','U') IS NOT NULL
	BEGIN
		-- drop temp table
		SET @SQL = 'DROP TABLE tempID'
		EXEC sp_executesql @SQL
	END
END




