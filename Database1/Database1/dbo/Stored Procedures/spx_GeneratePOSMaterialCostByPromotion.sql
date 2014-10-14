-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate POS Material Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GeneratePOSMaterialCostByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	select TOP 1 isnull(y.detPOSMaterialCost,0)
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y  WITH (NOLOCK)  on x.promotionID = y.promotionID
    where x.promotionID = @promotionId
END



