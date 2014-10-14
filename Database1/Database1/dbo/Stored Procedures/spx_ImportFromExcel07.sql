CREATE PROCEDURE [dbo].[spx_ImportFromExcel07]
   @SheetName varchar(200),
   @FilePath varchar(200),
   @TableName varchar(50)
AS
BEGIN
    DECLARE @SQL nvarchar(1000)
	DECLARE @SQLStr AS NVARCHAR(MAX)
     
    IF OBJECT_ID (@TableName,'U') IS NOT NULL
	BEGIN
		SET @SQL = 'DROP TABLE ' + @TableName
		EXEC sp_executesql @SQL
	END

    SET @SQL = 'SELECT * INTO ' + @TableName + ' FROM OPENDATASOURCE' 
	IF CHARINDEX(' ',@SheetName) > 0 
	BEGIN
		SET @SQL = @SQL + '(''Microsoft.ACE.OLEDB.12.0'',''Data Source=' 
			+ @FilePath + ';Extended Properties="Excel 12.0;HDR=No;IMEX=1"'')...[''' + @SheetName + ''']'
	END
	ELSE
	BEGIN
		SET @SQL = @SQL + '(''Microsoft.ACE.OLEDB.12.0'',''Data Source=' 
			+ @FilePath + ';Extended Properties="Excel 12.0;HDR=No;IMEX=1"'')...[' + @SheetName + ']'
	END
    EXEC sp_executesql @SQL

	/*
	IF @TableName = 'tempTable'
	BEGIN
		SELECT @SQLStr = COALESCE(@SQLStr + ' ', '') + ' ALTER TABLE ' + SYSOBJECTS.Name + ' ALTER COLUMN ' + SYSCOLUMNS.Name + ' ' + 
		CASE WHEN SYSTYPES.name = 'ntext' THEN 'nvarchar(max) ' ELSE 
			SYSTYPES.name + '(' + RTRIM(CONVERT(CHAR,SYSCOLUMNS.length)) + ') ' 
		END
		+ ' COLLATE Latin1_General_CI_AI' + CASE ISNULLABLE WHEN 0 THEN ' NOT NULL' ELSE ' NULL' End
		FROM SYSCOLUMNS , SYSOBJECTS , SYSTYPES
		WHERE SYSCOLUMNS.ID = SYSOBJECTS.ID
		AND SYSOBJECTS.TYPE = 'U'
		AND SYSTYPES.Xtype = SYSCOLUMNS.xtype
		AND SYSCOLUMNS.COLLATION IS NOT NULL
		AND SYSOBJECTS.NAME='tempTable'
		AND SYSTYPES.name <>'sysname'

		IF 	@SQLStr<>''
		BEGIN
			EXEC sp_executesql @SQLStr
		END
	END*/
END




