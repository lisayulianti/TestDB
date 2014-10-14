CREATE PROCEDURE [dbo].[spx_PostDuplicateValue]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN	
	DECLARE @SQL nvarchar(MAX)=''	

	IF @targetTable = 'tempCopaMonthly' AND @countryID = 101
	BEGIN
		-- Duplicate insertion to other PnL
		INSERT INTO tempCopaMonthly
		SELECT [countryID],[monthDate],[pnlID],'Logistics Cost Other',[customerID],[bwcCustomerClientCode]
			  ,[productID],[bwcProductClientCode],[bwcAmount],[importLogID]
		FROM tempCopaMonthly
		WHERE bwcPnlDesc= 'Total Variances'

		INSERT INTO tempCopaMonthly
		SELECT [countryID],[monthDate],[pnlID],'Total Promotion',[customerID],[bwcCustomerClientCode]
			  ,[productID],[bwcProductClientCode],[bwcAmount],[importLogID]
		FROM tempCopaMonthly
		WHERE bwcPnlDesc= 'Total Variances'
		
		-- update monthDate as file date
		SET @SQL = 'EXEC spx_PostTempTbl ' + CAST(@countryID AS VARCHAR(200)) + ', ''' + @targetTable + ''', ''' + @sourceTable + ''', ''' + @importLogId + ''''
		EXEC sp_executesql @SQL
		
	END
END




