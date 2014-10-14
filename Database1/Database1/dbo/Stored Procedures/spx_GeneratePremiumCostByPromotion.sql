-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Premium Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GeneratePremiumCostByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	select TOP 1 (isnull(y.detPremiumCost,0) * isnull(y.detPremiumQuantity,0))
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y  WITH (NOLOCK) on x.promotionID = y.promotionID
    where x.promotionID = @promotionId
END



