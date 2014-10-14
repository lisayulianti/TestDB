-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Listing Fee based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateListingFeeByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	select Top 1 isnull(y.detListingFeeAmount,0)
    from tblPromotion x join tblPromotionDetails y on x.promotionID = y.promotionID
    where x.promotionID = @promotionId
END



