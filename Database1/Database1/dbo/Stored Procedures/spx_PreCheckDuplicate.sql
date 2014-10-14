
CREATE PROCEDURE [dbo].[spx_PreCheckDuplicate]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importL@sourceTableogId varchar(10) = '0'
AS
BEGIN
	DECLARE @targetFieldNames varchar(MAX),@rawFieldNames varchar(MAX),@setString varchar(MAX)='',@tempString varchar(100)='',@rawString varchar(100)=''
	DECLARE @colEsc TABLE(col VARCHAR(100))
	DECLARE @SQL nvarchar(MAX)=''	
	
	-- remove duplicate at temp table
	IF @sourceTable = 'tempCoGS'
	BEGIN
		SET @SQL = 'SELECT DISTINCT * INTO tempTable2 FROM ' + @sourceTable 
		EXEC sp_executesql @SQL

		SET @SQL = 'TRUNCATE TABLE ' + @sourceTable
		EXEC sp_executesql @SQL
	
		SET @SQL = 'INSERT INTO ' + @sourceTable + ' SELECT * FROM tempTable2'
		EXEC sp_executesql @SQL
	
		SET @SQL = 'DROP TABLE tempTable2'
		EXEC sp_executesql @SQL
	END
	
	-- get excluded columns of target table
	IF @targetTable = 'tblFOC'
	BEGIN
		INSERT INTO @colEsc SELECT 'focMinQty'
		INSERT INTO @colEsc SELECT 'focMinQtyUOMClientCode'
		INSERT INTO @colEsc SELECT 'focQualQtyUOMClientCode'
		INSERT INTO @colEsc SELECT 'focFreeQty'
		INSERT INTO @colEsc SELECT 'focFreeQtyUOMClientCode'
	END	
	
	IF @targetTable = 'tblSystemAccrual'
	BEGIN
		INSERT INTO @colEsc SELECT 'sysCurrency'
		INSERT INTO @colEsc SELECT 'sysAmount'
	END	
	
	IF @targetTable = 'tblLKATT'
	BEGIN
		INSERT INTO @colEsc SELECT 'lkaAmount'
	END	
	
	IF @targetTable = 'tblCoGS'
	BEGIN
		INSERT INTO @colEsc SELECT 'cgsAmount'
	END	

	IF @targetTable = 'tblOutlet'
	BEGIN
		INSERT INTO @colEsc SELECT 'outletID'
	END	

	IF @targetTable = 'tblSKU'
	BEGIN
		INSERT INTO @colEsc SELECT 'skuID'
	END	

	IF @targetTable = 'tblDkaInc'
	BEGIN
		INSERT INTO @colEsc SELECT 'dkaAmount'
	END	

	INSERT INTO @colEsc SELECT 'validFrom'
	INSERT INTO @colEsc SELECT 'validTo'
	INSERT INTO @colEsc SELECT 'importLogID'

	SELECT @targetFieldNames=COALESCE(@targetFieldNames + ', ', '') + COLUMN_NAME FROM information_schema.columns WHERE table_name = @targetTable AND COLUMN_NAME NOT IN (SELECT col FROM @colEsc)
	SET @rawFieldNames = @targetFieldNames

	-- generate set string
	WHILE LEN(@rawFieldNames) > 0
	BEGIN
		IF PATINDEX('%,%',@rawFieldNames) > 0
		BEGIN
			SET @tempString = REPLACE(SUBSTRING(@rawFieldNames, 0, PATINDEX('%,%',@rawFieldNames)),' ','')
			SET @setString = @setString + ' AND ((trg.' + @tempString + ' IS NULL AND src.' + @tempString + ' IS NULL) OR (trg.' + @tempString + '=src.' + @tempString + '))'
			SET @rawString = SUBSTRING(@rawFieldNames, 0, PATINDEX('%,%',@rawFieldNames))

			SET @rawFieldNames = SUBSTRING(@rawFieldNames, LEN(@rawString + ',') + 1,LEN(@rawFieldNames))
		END
		ELSE
		BEGIN
			SET @rawFieldNames = REPLACE(@rawFieldNames,' ','')
			SET @setString = @setString + ' AND ((trg.' + @rawFieldNames + ' IS NULL AND src.' + @rawFieldNames + ' IS NULL) OR (trg.' + @rawFieldNames + '=src.' + @rawFieldNames + '))'
			SET @rawFieldNames = NULL
		END
	END
	SET @setString = RIGHT(@setString,LEN(@setString)-5)

	-- set tblName validFrom to tempName validTo-1 when tempName validTo < tblName MAX(validFrom)
	SET @SQL = 'IF EXISTS ( SELECT 1 FROM ' + @sourceTable + ') AND EXISTS ( SELECT 1 FROM ' + @targetTable + ')
				BEGIN
					UPDATE tbl
					SET tbl.ValidTo = DATEADD(day,-1,src.ValidFrom)
					FROM ' + @targetTable + ' tbl
					INNER JOIN (SELECT ' + @targetFieldNames + ',MAX(ValidTo) ValidTo FROM ' + @targetTable + ' GROUP BY ' + @targetFieldNames + ') trg
						ON ' + REPLACE(@setString,'src.','tbl.') + ' AND tbl.ValidTo = trg.ValidTo
					INNER JOIN ' + @sourceTable + ' src ON ' + @setString + ' AND src.ValidFrom > trg.ValidTo
				END'
	EXEC sp_executesql @SQL
END




