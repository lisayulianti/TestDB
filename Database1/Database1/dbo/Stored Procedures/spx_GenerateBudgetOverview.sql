-- =============================================
-- Author:		Robert de Castro
-- Create date: 17 July 2014
-- Description:	Generate the budget overview for the promotion creator
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateBudgetOverview]
	-- Add the parameters for the stored procedure here
	@cusGroup5ID int, 
	@cusGroup6ID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Create temporary table for pivot
	CREATE TABLE #tempTable
	(
		RowName varchar(50),
		Month varchar(3),
		Amount int
	)

	-- GSV budget row - step 5
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Budget' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) AS Month, budGrossSales AS Amount 
	FROM tblBudgetAndForecast 
	WHERE cusGroup5ID=@cusGroup5ID AND cusGroup6ID=@cusGroup6ID AND budYear=DATEPART(YEAR,GETDATE())

	-- GSV Lastest RF - step 7
	DECLARE @maxBudgetNumber INT
	SELECT @maxBudgetNumber = MAX(budBudgetNr) FROM tblBudgetAndForecast
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Latest RF' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, budGrossSales AS Amount 
	FROM tblBudgetAndForecast 
	WHERE cusGroup5ID=@cusGroup5ID AND cusGroup6ID=@cusGroup6ID AND budBudgetNr=@maxBudgetNumber AND budYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Rebates - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Rebates' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.ConRebF IS NULL THEN 0 ELSE ftp.ConRebF END + 
		baf.budGrossSales* CASE WHEN ftp.DistTargetF IS NULL THEN 1 ELSE ftp.DistTargetF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Sell-Out Reimbursements - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Sell-Out Reimbursements' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.LightF IS NULL THEN 0 ELSE ftp.LightF END + 
		baf.budGrossSales* CASE WHEN ftp.CdisDistDevF IS NULL THEN 1 ELSE ftp.CdisDistDevF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Displays - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Displays' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.DistTargetF IS NULL THEN 0 ELSE ftp.DistTargetF END + 
		baf.budGrossSales* CASE WHEN ftp.SpaceBuyGtF IS NULL THEN 1 ELSE ftp.SpaceBuyGtF END +
		baf.budGrossSales* CASE WHEN ftp.ComAssortF IS NULL THEN 1 ELSE ftp.ComAssortF END +
		baf.budGrossSales* CASE WHEN ftp.CatManF IS NULL THEN 1 ELSE ftp.CatManF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Promotions - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Promotions' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.AnnivF IS NULL THEN 0 ELSE ftp.AnnivF END + 
		baf.budGrossSales* CASE WHEN ftp.TprF IS NULL THEN 1 ELSE ftp.TprF END +
		baf.budGrossSales* CASE WHEN ftp.EdlpDiscountF IS NULL THEN 1 ELSE ftp.EdlpDiscountF END +
		baf.budGrossSales* CASE WHEN ftp.FeatureCostF IS NULL THEN 1 ELSE ftp.FeatureCostF END +
		baf.budGrossSales* CASE WHEN ftp.LocPromoF IS NULL THEN 1 ELSE ftp.LocPromoF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Advertising - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Advertising' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.MailAdvF IS NULL THEN 0 ELSE ftp.MailAdvF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Sell in Rebates - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Sell in Rebates' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.UnconRebateF IS NULL THEN 0 ELSE ftp.UnconRebateF END +
		baf.budGrossSales* CASE WHEN ftp.UllagesF IS NULL THEN 0 ELSE ftp.UllagesF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Assets Management - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Assets Management' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.NewStoreF IS NULL THEN 0 ELSE ftp.NewStoreF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Distribution - step 9a
	INSERT INTO #tempTable (RowName, Month, Amount)
	SELECT 'Distribution' AS RowName, LEFT(DATENAME( MONTH , DATEADD( MONTH , monthDate , -1 ) ),3) as Month, 
		baf.budGrossSales* CASE WHEN ftp.DcAllowF IS NULL THEN 0 ELSE ftp.DcAllowF END AS Amount
	FROM tblFixedTradeTermPercentages ftp join tblBudgetAndForecast baf ON ftp.CusGroup5ID=baf.cusGroup5ID AND ftp.CusGroup6ID=baf.cusGroup6ID
	WHERE ftp.CusGroup5ID=@cusGroup5ID and ftp.CusGroup6ID=@cusGroup6ID AND ftp.fftYear=DATEPART(YEAR,GETDATE()) AND DATEPART(MONTH,GETDATE()) <= monthDate

	-- Main pivot
	SELECT * FROM #tempTable AS s 
	PIVOT (SUM(amount) FOR month IN ([Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sep],[Oct],[Nov],[Dec],[Full Year],[YTD],[YTG])) AS p

	DROP TABLE #tempTable
END



