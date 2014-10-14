CREATE PROCEDURE [dbo].[spx_GeneratePromotionRCPHeader]
	@PromotionID int,
	@SecCustomerID int
AS
BEGIN
	SELECT sec.secRegNr, cn.ClaimClientCode
	FROM tblPromotion prm
	INNER JOIN tblPromotionCustomerSelection sel ON prm.promotionID = sel.promotionID
	INNER JOIN tblSecondaryCustomer sec ON sec.secondaryCustomerID = sel.secondarycustomerID AND sec.countryID = sel.countryID
	INNER JOIN tblClaimNoteGeneration cn ON cn.secondaryCustomerID = sel.secondarycustomerID AND cn.countryID = sel.countryID
	WHERE prm.promotionID = @PromotionID AND sel.secondarycustomerID = @SecCustomerID
END



