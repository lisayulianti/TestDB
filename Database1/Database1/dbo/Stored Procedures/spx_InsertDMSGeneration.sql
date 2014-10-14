CREATE PROCEDURE [dbo].[spx_InsertDMSGeneration]	
	@countryId int,
	@PromotionID int,
	@FileName nvarchar(100),
	@dgDMSgeneration int,
	@Creator nvarchar(50),
	@customerID int
AS
BEGIN
	INSERT INTO tblDMSGeneration (countryID, promotionID, dgfileName, dgDMSgeneration, dgDMScreationDate, dgCreator, customerID)
	VALUES(@countryId,@PromotionID,@FileName,@dgDMSgeneration,GETDATE(),@Creator, @customerID)
END



