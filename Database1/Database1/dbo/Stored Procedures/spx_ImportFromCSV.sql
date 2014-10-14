CREATE PROCEDURE [dbo].[spx_ImportFromCSV]
   @SheetName varchar(20),
   @FilePath varchar(200),
   @TableName varchar(50)
AS
BEGIN
    DECLARE @SQL nvarchar(1000)
    DECLARE @reversed nvarchar(200)
	DECLARE @colCount AS INT,@i AS INT,@colNames AS NVARCHAR(1000)
	set @reversed = REVERSE(@FilePath)

	IF OBJECT_ID ('TempCSV','U') IS NOT NULL
	BEGIN
		-- drop temp table
		SET @SQL = 'DROP TABLE TempCSV'
		EXEC sp_executesql @SQL
	END

	IF OBJECT_ID (@TableName,'U') IS NOT NULL
	BEGIN
		-- drop temp table
		SET @SQL = 'DROP TABLE ' + @TableName
		EXEC sp_executesql @SQL
	END

	-- get column count
	SET @SQL = 'SELECT TOP 1 * INTO TempCSV FROM OPENROWSET 
				(''MICROSOFT.ACE.OLEDB.12.0'',''Text;Database='+ REVERSE(SUBSTRING(@reversed, CHARINDEX('\', @reversed)+1, 100)) + ';HDR=No;IMEX=1'', 
				''SELECT * FROM ['+ REVERSE(SUBSTRING(@reversed, 1,CHARINDEX('\', @reversed)-1)) + ']'')'
    EXEC sp_executesql @SQL	
	SELECT @colCount = count(*),@i=1 FROM information_schema.columns WHERE table_name = 'TempCSV'

	-- create table
	SET @colNames=''
	WHILE @i<=@colCount
	BEGIN
		IF @colNames=''
		BEGIN
			SET @colNames = 'F' + CAST(@i AS NVARCHAR(10)) + ' VARCHAR(2000)'
		END
		ELSE
		BEGIN
			SET @colNames += ', F' + CAST(@i AS NVARCHAR(10)) + ' VARCHAR(2000)'
		END
		SET @i=@i+1
	END
	SET @SQL = 'CREATE TABLE ' + @TableName + '(' + @colNames + ')'
	EXEC sp_executesql @SQL

	-- insert data
	SET @SQL = 'BULK INSERT ' + @TableName + '
				FROM ''' + @FilePath + ''' 
				WITH (FIELDTERMINATOR = '';'',ROWTERMINATOR = ''\n'')'
	EXEC sp_executesql @SQL	

	IF OBJECT_ID ('TempCSV','U') IS NOT NULL
	BEGIN
		-- drop temp table
		SET @SQL = 'DROP TABLE TempCSV'
		EXEC sp_executesql @SQL
	END
	
END




