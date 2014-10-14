-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Store Revamping Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateStoreRevampingCostByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @storeRevampingAmount INT
	
	SET NOCOUNT ON;    

	SET @storeRevampingAmount = (select Top 1 isnull(y.detStoreRevampingAmount,0)
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y  WITH (NOLOCK) on x.promotionID = y.promotionID
    where x.promotionID = @promotionId)	

	select isnull(@storeRevampingAmount,0)
END



