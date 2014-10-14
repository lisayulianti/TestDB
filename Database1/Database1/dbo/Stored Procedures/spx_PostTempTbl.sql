
CREATE PROCEDURE [dbo].[spx_PostTempTbl]
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
	
	IF @targetTable = 'tempCustomer'
		SET @IDString = 'customerID'
	IF @targetTable = 'tempSecondaryCustomer'
		SET @IDString = 'secondaryCustomerID'
	IF @targetTable = 'tempProduct'
		SET @IDString = 'productID'

	IF @targetTable = 'tempCopaMonthly' AND @countryID IN (101,103)
	BEGIN
		-- update monthDate as file date
		SET @SQL = 'UPDATE ' + @targetTable + ' SET monthDate = (
				SELECT TOP 1 200000+ LEFT(imlFilePeriod,4)
				FROM tblImportLog a
				INNER JOIN ' + @targetTable + ' b ON a.importLogID = b.importLogID) WHERE countryID = ' + CAST(@countryID AS VARCHAR(200)) 

		EXEC sp_executesql @SQL
	END
	ELSE
	BEGIN
		-- update ValidFrom as file date
		SET @SQL = 'UPDATE ' + @targetTable + ' SET validFrom = (
				SELECT TOP 1 CASE ISDATE(SUBSTRING(a.imlFileName,3,2)+''-''+SUBSTRING(a.imlFileName,5,2)+''-20''+LEFT(a.imlFileName,2)) WHEN 1 THEN
				CAST(SUBSTRING(a.imlFileName,3,2)+''-''+SUBSTRING(a.imlFileName,5,2)+''-20''+LEFT(a.imlFileName,2) AS DATETIME) END
				FROM tblImportLog a
				INNER JOIN ' + @targetTable + ' b ON a.importLogID = b.importLogID) WHERE countryID = ' + CAST(@countryID AS VARCHAR(200)) + '
				AND ' + @IDString + ' IN (SELECT ' + @IDString + ' FROM ' + REPLACE(@targetTable,'temp','tbl') + ' WHERE countryID = ' + CAST(@countryID AS VARCHAR(200)) + ')' 

		EXEC sp_executesql @SQL
	END
END

