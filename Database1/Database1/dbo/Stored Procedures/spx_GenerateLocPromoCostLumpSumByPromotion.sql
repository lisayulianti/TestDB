-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Localized Promo Cost (Lump Sum) based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateLocPromoCostLumpSumByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	select top 1 isnull(y.detLocPromoLumpSum,0)
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y WITH (NOLOCK)  on x.promotionID = y.promotionID
    where x.promotionID = @promotionId
END



