-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Insert / Update Table PromoVolumeSelection
-- =============================================
CREATE PROCEDURE [dbo].[spx_StoreVolume]
	@promotionId INT,
	@countryId INT,
	@productId INT,
	@volumeType INT,
	@p1base FLOAT,
	@p2base FLOAT,
	@p3base FLOAT,
	@p1plan FLOAT,
	@p2plan FLOAT,
	@p3plan FLOAT,
	@p1actual FLOAT,
	@p2actual FLOAT,
	@p3actual FLOAT,
	@p1actualSellOut FLOAT,
	@p2actualSellOut FLOAT,
    @p3actualSellOut FLOAT,
	@participationPlan FLOAT,
	@participationActual FLOAT,
	@cardSalesPlan FLOAT,
	@cardSalesActual FLOAT
	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	select @count = count(*) from tblPromoVolumeSelection where countryID=@countryId and promotionId=@promotionId and productId=@productId

	IF @count = 0
	BEGIN
		INSERT INTO tblPromoVolumeSelection(countryID,promotionID,productID,volPrdProductValue,volVolumeP1Base,volVolumeP2Base,volVolumeP3Base,
                                            volVolumeP1Plan,volVolumeP2Plan,volVolumeP3Plan,volVolumeP1Actual,volVolumeP2Actual,volVolumeP3Actual,volVolumeP1ActualSellOut,
                                            volVolumeP2ActualSellOut,volVolumeP3ActualSellOut,volParticipationpercentagePlan,volParticipationpercentageActual,
											volCardSalesPlan,volCardSalesActual)
                                            Values(@countryId,@promotionId,@productId,@volumeType,@p1base,@p2base,@p3base,@p1plan,@p2plan,@p3plan,@p1actual,@p2actual,
											@p3actual,@p1actualSellOut,@p2actualSellOut,
                                            @p3actualSellOut,@participationPlan,@participationActual,@cardSalesPlan,@cardSalesActual)
	END
	ELSE
	BEGIN
		UPDATE tblPromoVolumeSelection 
                                            SET countryID=@countryId,promotionID=@promotionId,productID=@productId,volPrdProductValue=@volumeType,volVolumeP1Base=@p1base,volVolumeP2Base=@p2base,volVolumeP3Base=@p3base,
                                            volVolumeP1Plan=@p1plan,volVolumeP2Plan=@p2plan,volVolumeP3Plan=@p3plan,volVolumeP1Actual=@p1actual,volVolumeP2Actual=@p2actual,volVolumeP3Actual=@p3actual,
                                            volVolumeP1ActualSellOut=@p1actualSellOut,volVolumeP2ActualSellOut=@p2actualSellOut,volVolumeP3ActualSellOut=@p3actualSellOut,
                                            volParticipationpercentagePlan=@participationPlan,volParticipationpercentageActual=@participationActual,
                                            volCardSalesPlan=@cardSalesPlan,volCardSalesActual=@cardSalesActual
											WHERE countryID=@countryId and promotionId=@promotionId and productID=@productId
	END
END



