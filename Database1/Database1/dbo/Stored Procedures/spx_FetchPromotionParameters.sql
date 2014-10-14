CREATE PROCEDURE [dbo].[spx_FetchPromotionParameters]
	@promotionId int = 0	
AS
BEGIN
	SELECT tp.prmDateStart, tp.prmDateEnd, tp.prmUnitID, tp.prmProductfield, tp.prmPromotionClientCode, tp.prmPromotionStructure, tp.prmStatusID
	FROM tblPromotion tp  WITH (NOLOCK) 
	WHERE tp.promotionID = @promotionId	
END



