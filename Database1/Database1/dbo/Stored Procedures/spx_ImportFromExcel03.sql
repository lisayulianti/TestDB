CREATE PROCEDURE [dbo].[spx_ImportFromExcel03]
    @SheetName varchar(20),
    @FilePath varchar(200),
    @TableName varchar(50)
AS
BEGIN
    DECLARE @SQL nvarchar(1000)
           
    IF OBJECT_ID (@TableName,'U') IS NOT NULL
		BEGIN
			SET @SQL = 'INSERT INTO ' + @TableName + ' SELECT * FROM OPENDATASOURCE'
			EXEC sp_executesql @SQL
		END

	SET @SQL = 'SELECT * INTO ' + @TableName + ' FROM OPENDATASOURCE'
	IF CHARINDEX(' ',@SheetName) > 0 
	BEGIN
 		SET @SQL = @SQL + '(''Microsoft.Jet.OLEDB.4.0'',''Data Source=' 
		+ @FilePath + ';Extended Properties="Excel 8.0;HDR=No;IMEX=1"'')...[''' + @SheetName + ''']'
	END
	ELSE
	BEGIN
 		SET @SQL = @SQL + '(''Microsoft.Jet.OLEDB.4.0'',''Data Source=' 
		+ @FilePath + ';Extended Properties="Excel 8.0;HDR=No;IMEX=1"'')...[' + @SheetName + ']'
	END

    EXEC sp_executesql @SQL
END




