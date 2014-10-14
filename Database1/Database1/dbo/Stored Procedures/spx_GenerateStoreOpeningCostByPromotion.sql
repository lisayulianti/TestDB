-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate NEW STORE Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateStoreOpeningCostByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @newStoreOpeningAmount INT

	SET NOCOUNT ON;

	SET @newStoreOpeningAmount = (select Top 1 isnull(y.detNewStoreOpeningAmount,0)
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y WITH (NOLOCK)  on x.promotionID = y.promotionID
    where x.promotionID = @promotionId)

	select isnull(@newStoreOpeningAmount,0)
END



