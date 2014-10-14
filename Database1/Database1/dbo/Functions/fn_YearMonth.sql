CREATE FUNCTION [dbo].[fn_YearMonth](@YearMonthStart int, @YearMonthEnd int)
	RETURNS @Results TABLE (YearMonth int)
AS
BEGIN
	DECLARE @INDEX INT
	SELECT @INDEX = @YearMonthStart
	WHILE @INDEX <= @YearMonthEnd
	BEGIN
		IF RIGHT(@INDEX,2) IN (1,2,3,4,5,6,7,8,9,10,11,12)
		BEGIN
			INSERT INTO @Results(YearMonth) VALUES(@INDEX)
		END
		SET @INDEX = @INDEX + 1
	END
	RETURN
END



