-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Mailer Advertising Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateMailerAdvertisingCostByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	select TOP 1 isnull(y.detMailCost,0)
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y  WITH (NOLOCK) on x.promotionID = y.promotionID
    where x.promotionID = @promotionId
END



