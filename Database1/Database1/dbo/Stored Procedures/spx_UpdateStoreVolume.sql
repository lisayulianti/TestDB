-- =============================================
-- Author:		Anthony Steven
-- Create date: 21 July 2014
-- Description:	Update Table PromoVolumeSelection (Because of Actual Date Change)
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdateStoreVolume]
	@promotionId INT,
	@countryId INT,
	@productId INT,
	@p1actual FLOAT,
	@p2actual FLOAT,
	@p3actual FLOAT,
	@p1actualSellOut FLOAT,
	@p2actualSellOut FLOAT,
    @p3actualSellOut FLOAT
	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	UPDATE tblPromoVolumeSelection 
    SET countryID=@countryId,promotionID=@promotionId,productID=@productId,
	volVolumeP1Actual=@p1actual,volVolumeP2Actual=@p2actual,volVolumeP3Actual=@p3actual,
    volVolumeP1ActualSellOut=@p1actualSellOut,volVolumeP2ActualSellOut=@p2actualSellOut,
	volVolumeP3ActualSellOut=@p3actualSellOut
	WHERE countryID=@countryId and promotionId=@promotionId and productID = @productId
	
END



