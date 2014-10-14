
CREATE PROCEDURE [dbo].[spx_PreIgnoreAppend]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN
	DECLARE @SQL nvarchar(MAX)	
	DECLARE @IDString VARCHAR(100)		
	
	-- remove duplicate at temp table
	IF @sourceTable = 'tempProduct' OR @sourceTable = 'tempSecGroup6Discount'
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

	-- executing spx_PostTempTbl to update ValidFrom as file date
	IF @targetTable = 'tblSecondaryCustomer'
	BEGIN
		SET @SQL = 'EXEC spx_PostTempTbl ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @sourceTable + ''', '''', '''''
		EXEC sp_executesql @SQL
	END

	-- set ID column of target table
	IF @targetTable = 'tblCustomer'
		SET @IDString = 'customerID'
	IF @targetTable = 'tblSecondaryCustomer'
		SET @IDString = 'secondaryCustomerID'
	IF @targetTable = 'tblProduct'
		SET @IDString = 'productID'
	IF @targetTable = 'tblSecGroup6Discount'
		SET @IDString = 'secGroup6ID'

	-- update import status for file date < Max(Valid_From in target table)
	SET @SQL = 'UPDATE tblImportLog SET imlImportLogDescription2=ISNULL(imlImportLogDescription2,'''') + '' Some data with File Date smaller than existing data were found and removed.''
				WHERE importLogID = (SELECT TOP 1 importLogID FROM ' + @sourceTable + ' WHERE countryID = ' + CAST(@countryID AS VARCHAR(200)) + ')
				AND EXISTS (SELECT 1 FROM ' + @sourceTable + ' WHERE 
				DATEDIFF(DAY, validFrom, (SELECT MAX(validFrom) FROM ' + @targetTable + ')) < 0)'
	EXEC sp_executesql @SQL 

	-- delete temp table when file date < Max(Valid_From in target table)
	SET @SQL = 'DELETE a
				FROM ' + @sourceTable + ' a
				INNER JOIN (SELECT countryID,' + @IDString + ', MAX(validFrom) AS maxValidFrom FROM ' + @targetTable + ' GROUP BY countryID,' + @IDString + ') b
				  ON a.' + @IDString + ' = b.' + @IDString + '
				AND a.countryID = b.countryID
				AND a.countryID = ' + CAST(@countryID AS VARCHAR(200)) + '
				AND DATEDIFF(DAY, b.maxValidFrom, a.validFrom) < 0'
	EXEC sp_executesql @SQL
		
	-- if data in source table exist, update valid_to of max(valid_from) data at target table
	SET @SQL = 'IF EXISTS ( SELECT 1 FROM ' + @sourceTable + ') AND EXISTS ( SELECT 1 FROM ' + @targetTable + ')
				BEGIN
					UPDATE trg
					SET trg.validTo = DATEADD(DAY,-1,src.ValidFrom)
					FROM ' + @targetTable + ' trg' + '
					INNER JOIN ' + @sourceTable + ' src ON trg.countryID = src.countryID AND trg.' + @IDString + ' = src.' + @IDString + '
					INNER JOIN (SELECT countryID,' + @IDString + ', MAX(validFrom) AS maxValidFrom
						FROM ' + @targetTable + ' GROUP BY countryID,' + @IDString + ') trg2 
						ON trg.countryID = trg2.countryID AND trg.' + @IDString + ' = trg2.' + @IDString + ' AND trg.validFrom=trg2.maxValidFrom
					WHERE trg.countryID=' + CAST(@countryID AS VARCHAR(200)) + '
				END'
	EXEC sp_executesql @SQL	
END




