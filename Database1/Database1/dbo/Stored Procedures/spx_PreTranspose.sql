
CREATE PROCEDURE [dbo].[spx_PreTranspose]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100),
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN	
	DECLARE @SQL nvarchar(MAX)
	SET @SQL = ''

	IF @countryID = 102
	BEGIN
		IF @targetTable='tempCopaDaily' OR @targetTable='tempPriTrans' OR @targetTable='tempRecTypeDU'
		BEGIN
			SET @SQL = 'SELECT * INTO tempTable2 FROM (   
			SELECT F1,F2,F3,F4,F5,''Sales Quantity (CTN/CRT)'' AS F6,F6 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,F5,''Sales Quantity (EA)'' AS F6,F7 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,F5,''TA Cost'' AS F6,F8 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,F5,''Royalty Fee-Group Co'' AS F6,F9 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,F5,''Royalty Fee-3rd Paty'' AS F6,F10 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,F5,''Standard Product Costs'' AS F6,F11 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,F5,''Transporation related to sales'' AS F6,F12 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,F5,''Logistics costs other'' AS F6,F13 AS F7 FROM tempTable WHERE F1 NOT LIKE ''""%'') tbl  '
			EXEC sp_executesql @SQL	
		END
		IF @targetTable='tempCopaMonthly' OR @targetTable='tempAnP'
		BEGIN
			SET @SQL = 'SELECT * INTO tempTable2 FROM (   
			SELECT F1,F2,F3,F4,''Sales to group companies'' AS F5,F5 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,''Miscellaneous Selling cost'' AS F5,F6 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,''Result on bad debts'' AS F5,F7 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,''Variances to standard'' AS F5,F8 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,''Exchg Rate gain/loss'' AS F5,F9 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,''Advertising: Media Costs'' AS F5,F10 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,''Advertising: Production Costs'' AS F5,F11 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'' UNION
			SELECT F1,F2,F3,F4,''Promotion'' AS F5,F12 AS F6 FROM tempTable WHERE F1 NOT LIKE ''""%'') tbl '
			EXEC sp_executesql @SQL	
		END
	END
	
	IF @countryID = 103
	BEGIN
		IF @targetTable='tempCopaMonthly'
		BEGIN
			SET @SQL = 'SELECT * INTO tempTable2 FROM (   
			SELECT F1,F2,F3,F4,''Net Sales Quantity to 3rd (w/o Ovaltine)'' AS F5,F5 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Net Sales Quantity to BCC (UHT Ovaltine)'' AS F5,F6 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Net Sales Quantity to group companies'' AS F5,F7 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Net Sales Quantity to IC (ctn)'' AS F5,F8 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Free goods Quantity (ctn)'' AS F5,F9 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''NET SALES QUANTITY (CTN)'' AS F5,F10 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Gross sales to 3rd parties'' AS F5,F11 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Gross sales to group companies'' AS F5,F12 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Gross sales to BCC'' AS F5,F13 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''gross sales to intercompany'' AS F5,F14 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Gross sales free goods'' AS F5,F15 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Gross sales non-trade to IC'' AS F5,F16 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''GROSS SALES'' AS F5,F17 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''General Discount'' AS F5,F18 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Performance Rebates'' AS F5,F19 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Trade Support'' AS F5,F20 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Rebates'' AS F5,F21 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Returns'' AS F5,F22 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Free Goods'' AS F5,F23 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Cash Discount'' AS F5,F24 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Display'' AS F5,F25 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Trade discount & display'' AS F5,F26 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''TOTAL DIRECT SELLING COSTS'' AS F5,F27 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''NET SALES'' AS F5,F28 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Transportation fee to 3rd'' AS F5,F29 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Outbound logistics'' AS F5,F30 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Distribution and selling costs'' AS F5,F31 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Royalty cost'' AS F5,F32 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Material costs'' AS F5,F33 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Raw materials'' AS F5,F34 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Packing materials'' AS F5,F35 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Finished products from group companies'' AS F5,F36 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Finished products from IC'' AS F5,F37 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Conversion cost'' AS F5,F38 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Direct Labour'' AS F5,F39 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Direct Power'' AS F5,F40 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Depreciation of line'' AS F5,F41 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Maintenance/repair costs'' AS F5,F42 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Production/service overhead'' AS F5,F43 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Free goods - total cost'' AS F5,F44 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''COGS non-trade to IC'' AS F5,F45 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''TOTAL DIRECT COSTS OF SALES'' AS F5,F46 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''STANDARD GROSS PROFIT'' AS F5,F47 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''IC price variance'' AS F5,F48 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Price/exchange variance - Direct'' AS F5,F49 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Price/exchange variance - Indirect'' AS F5,F50 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Price/exchange variance'' AS F5,F51 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Recipe/efficiency variance - Direct'' AS F5,F52 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Recipe/efficiency variance - Indirect'' AS F5,F53 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Recipe/efficiency variance'' AS F5,F54 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Actual conversion cost variance'' AS F5,F55 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''STD conversion cost variance'' AS F5,F56 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Conversion cost variance'' AS F5,F57 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Stock revaluation - Direct'' AS F5,F58 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''stock revaluation - Indirect'' AS F5,F59 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Stock revaluation'' AS F5,F60 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''VARIANCES TO STANDARD'' AS F5,F61 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''GROSS PROFIT'' AS F5,F62 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Advertisement - advertising'' AS F5,F63 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Advertisement - prodution'' AS F5,F64 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Promotion'' AS F5,F65 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''TOTAL DIRECT PRODUCT EXPENSES'' AS F5,F66 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''CONTRIBUTION'' AS F5,F67 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''R&D overhead'' AS F5,F68 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Marketing overhead'' AS F5,F69 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Sales direct area overhead'' AS F5,F70 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''CDSM overhead'' AS F5,F71 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''General overhead'' AS F5,F72 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''IC overhead charges'' AS F5,F73 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''TOTAL OTHER OVERHEAD'' AS F5,F74 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''OPERATING RESULT'' AS F5,F75 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''BCC Charges'' AS F5,F76 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Scrap Sales'' AS F5,F77 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''Others'' AS F5,F78 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''OTHER RESULTS'' AS F5,F79 AS F6 FROM tempTable WHERE F1 LIKE ''4%'' UNION
			SELECT F1,F2,F3,F4,''EARNINGS BEFORE INTEREST/TAX'' AS F5,F80 AS F6 FROM tempTable WHERE F1 LIKE ''4%'') tbl '
			EXEC sp_executesql @SQL	
		END
	END

	IF @SQL<>''
	BEGIN
		SET @SQL = 'DROP TABLE tempTable'
		EXEC sp_executesql @SQL	 

		SET @SQL = 'SELECT * INTO tempTable FROM tempTable2'
		EXEC sp_executesql @SQL	 

		SET @SQL = 'DROP TABLE tempTable2'
		EXEC sp_executesql @SQL	 
	END
END

