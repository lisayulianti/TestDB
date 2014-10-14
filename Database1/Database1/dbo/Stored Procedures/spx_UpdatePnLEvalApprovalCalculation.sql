-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdatePnLEvalApprovalCalculation]
@promotionID int,
@CountryID int = 102
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE	@return_value int,
			@Result int

	EXEC	@return_value = [dbo].[spx_InsertPromotionApprovalTarget]
			@PromotionID = @promotionID,
			@Result = @Result OUTPUT							

	EXEC	[dbo].spx_InsertPromoProfitAndLost
			@promotionID, @CountryID

	EXEC	[dbo].spx_InsertPromoProfitAndLostTwo
			@promotionID, @CountryID

	EXEC	[dbo].spx_InsertPromotionApproval
			@promotionID
END



