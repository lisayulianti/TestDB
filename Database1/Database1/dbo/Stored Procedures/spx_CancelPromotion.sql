-- =============================================
-- Author:		Anthony Steven
-- Create date: 25th September 2014
-- Description:	Cancel Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_CancelPromotion]
	@promotionId int,
	@userId int, 
	@promoNewEndDate Date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @dateStart date
	DECLARE @originalDateEnd date	
	DECLARE @status int
	DECLARE @isAdmin bit
	DECLARE @originalPeriod int
	DECLARE @newPeriod int


	SELECT @isAdmin = useMasterProfitTool FROM tblUser WHERE userID = @userID

	SELECT @dateStart = prmDateStart, @originalDateEnd = prmDateEnd, @status = prmStatusID
	from tblPromotion
	where promotionId=@promotionId

	IF @isAdmin = 1
	BEGIN
		IF @status = 8 
			BEGIN
			UPDATE tblPromotion
			SET prmStatusID = 0 		
			WHERE promotionId = @promotionId
			SELECT 1					
		END
		ELSE IF @status = 9
			BEGIN
			UPDATE tblPromotion
			SET prmDateEnd = @promoNewEndDate, 
			prmStatusID = 10
			WHERE promotionId = @promotionId

			SET @originalPeriod = DATEDIFF(day,@dateStart,@originalDateEnd)+1
			SET @newPeriod = DATEDIFF(day,@dateStart,@promoNewEndDate)+1
	
			UPDATE tblPromoFinancial
			SET finAmount = (CAST(@newPeriod as FLOAT)/CAST(@originalPeriod as FLOAT)) * finAmount
			WHERE promotionId = @promotionId
	
			SELECT 2
		END
		ELSE
			BEGIN
		SELECT 0
		END	
	END
	ELSE
	SELECT -1
END

	


	
	
	


