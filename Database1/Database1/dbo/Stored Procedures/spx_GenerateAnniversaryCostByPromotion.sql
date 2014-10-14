-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Anniversary Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateAnniversaryCostByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @anniversarySponsorAmount INT
	--DECLARE @scanDataLightBoxAmount INT

	SET NOCOUNT ON;    
	SET @anniversarySponsorAmount = (select Top 1 isnull(y.detAnniversarySponsorAmount,0)
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y WITH (NOLOCK)  on x.promotionID = y.promotionID
    where x.promotionID = @promotionId)

	--SET @scanDataLightBoxAmount = (select Top 1 isnull(y.detScanDataLightboxAmount,0)
 --   from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y  WITH (NOLOCK) on x.promotionID = y.promotionID
 --   where x.promotionID = @promotionId)

	select isnull(@anniversarySponsorAmount,0)--+isnull(@scanDataLightBoxAmount,0)
END



