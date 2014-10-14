CREATE PROCEDURE [dbo].[spx_PostUpdateIdDropTbl]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN	
	DECLARE @SQL nvarchar(MAX)=''	

	SET @SQL = 'EXEC spx_PostUpdateID ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @targetTable + ''', ''' + @sourceTable + ''', ''' + @importLogId + ''''
	EXEC sp_executesql @SQL

	SET @SQL = 'EXEC spx_PostIgnoreAppend ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @targetTable + ''', ''' + @sourceTable + ''', ''' + @importLogId + ''''
	EXEC sp_executesql @SQL
END




