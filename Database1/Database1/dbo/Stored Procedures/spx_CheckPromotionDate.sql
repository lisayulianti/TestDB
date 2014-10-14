CREATE PROCEDURE [dbo].[spx_CheckPromotionDate]
	@promotionId int = 0	
AS
BEGIN
	SELECT tp.prmDateStart, tp.prmDateEnd 
	FROM tblPromotion tp WITH (NOLOCK)
	WHERE tp.promotionID = @promotionId	
END



