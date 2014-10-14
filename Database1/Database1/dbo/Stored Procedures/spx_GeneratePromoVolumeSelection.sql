-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <15 July 2014>
-- Description:	<Generate Promo Volume Selection>
-- =============================================
CREATE PROCEDURE [dbo].[spx_GeneratePromoVolumeSelection]
	@promotionId int,
	@productId int,
	@p1Baseline float,
	@p2Baseline float,
	@p3Baseline float,
	@p1Plan float,
	@p2Plan float,
	@p3Plan float,
	@p1Actual float,
	@p2Actual float,
	@p3Actual float,
	@volType int,
	@participationPercentagePlan float,
	@participationPercentageActual float,
	@cardSalesPlan float,
	@cardSalesActual float
AS
BEGIN
	
	DECLARE @currentPVS INT	
	SET NOCOUNT ON;
	
    SELECT @currentPVS = COUNT(*) 
	FROM tblPromoVolumeSelection pvs 
	WHERE  pvs.promotionID = promotionID and pvs.productID = productId

	if @currentPVS = 1
	BEGIN
		UPDATE tblPromoVolumeSelection
		SET volParticipationpercentagePlan = @participationPercentagePlan,
		    volParticipationpercentageActual = @participationPercentageActual,
			volCardSalesPlan = @cardSalesPlan,
			volCardSalesActual = @cardSalesActual,
		    volVolumeP1Base = @p1Baseline,
			volVolumeP2Base = @p2Baseline,
			volVolumeP3Base = @p3Baseline,
			volVolumeP1Actual = @p1Actual,
			volVolumeP2Actual = @p2Actual,
			volVolumeP3Actual = @p3Actual,
			volVolumeP1Plan = @p1Plan,
			volVolumeP2Plan = @p2Plan,
			volVolumeP3Plan = @p3Plan,
			volPrdProductValue = @volType			
		WHERE promotionID = @promotionId AND productID = @productId		    
	END
	ELSE
	BEGIN
		INSERT INTO tblPromoVolumeSelection (promotionID,productID,volParticipationPercentagePlan,
		volParticipationpercentageActual,volCardSalesPlan,volCardSalesActual,
		volVolumeP1Base,volVolumeP2Base,volVolumeP3Base,
		volVolumeP1Actual,volVolumeP2Actual,volVolumeP3Actual,
		volVolumeP1Plan,volVolumeP2Plan,volVolumeP3Plan,volPrdProductValue)
		VALUES(@promotionId,@productId,@participationPercentagePlan,
		@participationPercentageActual,@cardSalesPlan,@cardSalesActual,
		@p1Baseline,@p2Baseline,@p3Baseline,
		@p1Actual,@p2Actual,@p3Actual,@p1Plan,@p2Plan,@p3plan,@volType)
	END
END



