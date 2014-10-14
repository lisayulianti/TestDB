CREATE FUNCTION [dbo].[fFilterNumeric]
(
	@Src nvarchar(255)
)
RETURNS nvarchar(255)
AS 
BEGIN
	DECLARE @Res nvarchar(255)
	DECLARE @i int, @l int, @c char
	SELECT @i=1, @l=len(@Src)
	SET @Res = ''

	WHILE @i<=@l
	BEGIN
	   SET @c=upper(substring(@Src,@i,1))
		IF  (isnumeric(@c)=1 OR @c IN ('-','.')) AND @c NOT IN (',')
			SET @Res = @Res + @c
	   SET @i=@i+1
	END
	
	IF @res = '-'
	BEGIN
		SET @res = '-0'
	END

	RETURN(@res)
END



