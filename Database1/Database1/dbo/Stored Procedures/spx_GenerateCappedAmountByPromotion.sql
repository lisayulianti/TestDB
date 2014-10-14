-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Capped Amount based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateCappedAmountByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	select Top 1 isnull(y.detCappedAmount,0)
    from tblPromotion x  WITH (NOLOCK) inner join tblPromotionDetails y  WITH (NOLOCK) on x.promotionID = y.promotionID
    where x.promotionID = @promotionId
END



