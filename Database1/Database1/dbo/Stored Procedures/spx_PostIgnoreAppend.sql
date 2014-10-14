CREATE PROCEDURE [dbo].[spx_PostIgnoreAppend]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN
	DECLARE @SQL nvarchar(MAX)
	-- delete temp table
	SET @SQL = 'TRUNCATE TABLE ' + @sourceTable 
	EXEC sp_executesql @SQL
END

