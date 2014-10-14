
CREATE PROCEDURE [dbo].[spx_PromoStatusUpdate]
AS
BEGIN
	UPDATE tblPromotion SET prmStatusID=9 WHERE prmStatusID=8 AND prmDateStart<= GETDATE()
	UPDATE tblPromotion SET prmStatusID=10 WHERE prmStatusID=9 AND prmDateEnd<= GETDATE() AND prmPromotionStructure<>'Parent' AND RIGHT(prmpromotionClientCode, 2) NOT IN ('E1','E2','E3','E4','E5')
	UPDATE tblPromotion SET prmStatusID=12 WHERE prmStatusID=9 AND prmDateEnd<= GETDATE() AND prmPromotionStructure='Parent'
	UPDATE tblPromotion SET prmStatusID=12 WHERE prmStatusID=9 AND DATEADD(DAY,31,prmDateEnd)<= GETDATE() AND RIGHT(prmpromotionClientCode, 2) IN ('E1','E2','E3','E4','E5')
END

