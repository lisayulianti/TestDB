CREATE PROCEDURE [dbo].[spx_PostExtTrans]
	-- Takes targetTable, id Field, comma deliminated field names for both source and 
	-- target fields
	@countryID int = 0,
	@targetTable varchar(100)='',
	@sourceTable varchar(100) = 'tempTable',
	@importLogId varchar(10) = '0'
AS
BEGIN
	IF EXISTS (SELECT 1 FROM tempExtTrans)
	BEGIN	
		DECLARE @SQL nvarchar(1000)='',@SQL0 varchar(1000)=''
		DECLARE @path VARCHAR(100),@filename VARCHAR(100),@sheetname VARCHAR(100),@dataQuery VARCHAR(1000),@period VARCHAR(255)=''

		DECLARE _cursor CURSOR FOR
		SELECT imsTemplateFilePath,imsTemplateFileName,imsTemplateSheet,imsDataQuery FROM [tblImportOutput] WHERE countryID = @countryID

		OPEN _cursor;

		FETCH NEXT FROM _cursor INTO  @path,@filename,@sheetname,@dataQuery

		-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Set Period
			SELECT @period = imlFilePeriod FROM tblImportLog WHERE importLogID = @importLogId

			-- Concatenate and display the current values in the variables.
			SET @SQL0 = 'copy '+ @path + '\' + @filename + ' ' + @path + '\' + @period + REPLACE(@filename,'_Template','')
			exec master..xp_cmdshell @SQL0

			SET ANSI_NULLS ON 
			SET ANSI_WARNINGS ON

			SET @SQL = 'INSERT INTO OPENROWSET
			(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;Database=' + @path + '\' + @period + REPLACE(@filename,'_Template','') + ';Extended Properties=Excel 12.0 XML;HDR=YES'',''SELECT * FROM [' + @sheetname + '$]'')
			' + @dataQuery + ' WHERE countryID = ' + CAST(@countryID AS VARCHAR(200))
			EXEC sp_executesql @SQL 

			SET @SQL = 'TRUNCATE TABLE ' + @sourceTable
			EXEC sp_executesql @SQL 

			SET ANSI_NULLS OFF 
			SET ANSI_WARNINGS OFF

			-- This is executed as long as the previous fetch succeeds.
			FETCH NEXT FROM _cursor INTO  @path,@filename,@sheetname,@dataQuery;
		END

		CLOSE _cursor;
		DEALLOCATE _cursor;
	END	
END




