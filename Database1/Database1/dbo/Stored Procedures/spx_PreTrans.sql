
CREATE PROCEDURE [dbo].[spx_PreTrans]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN
	DECLARE @SQL nvarchar(MAX)=''	
	
	-- transpose table before using the data
	SET @SQL = 'EXEC spx_PreTranspose ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @targetTable + ''', ''' + @sourceTable + ''', ''' + @importLogId + ''''
	EXEC sp_executesql @SQL

	-- remove previous data base on same period
	SET @SQL = 'IF EXISTS ( SELECT 1 FROM ' + @sourceTable + ')
				BEGIN
					DELETE ' + @targetTable + ' WHERE importLogID = ' + @importLogId + '
				END'
	EXEC sp_executesql @SQL

	-- remove previous data of targetTable when the same date exist at sourceTable
	IF @targetTable = 'tblRecTypeB' OR @targetTable = 'tblActual' OR @targetTable = 'tblActual2'
	BEGIN
		DECLARE @tableID VARCHAR(100)=''
		IF @targetTable = 'tblRecTypeB'
			SET @tableID = 'rtbEntryDate'
		IF @targetTable = 'tblActual'
			SET @tableID = 'actClaimDayDate'
		IF @targetTable = 'tblActual2'
			SET @tableID = 'acwClaimDayDate'

		SET @SQL = 'DELETE a
				FROM ' + @targetTable + ' a
				INNER JOIN ' + @sourceTable + ' b ON a.' + @tableID + ' = b.' + @tableID + '
				AND a.countryID = b.countryID
				AND a.countryID = ' + CAST(@countryID AS VARCHAR(200))
		EXEC sp_executesql @SQL
	END
END




