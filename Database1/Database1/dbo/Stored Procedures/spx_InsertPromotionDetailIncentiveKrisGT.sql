-- =============================================
-- Author:		Lin
-- Create date: 24/7/2014
-- Description:	Inserts in the tblPromotionDetailIn
CREATE PROCEDURE [dbo].[spx_InsertPromotionDetailIncentiveKrisGT]
	-- Add the parameters for the stored procedure here
	@promotionTypeID int, 
	@promotionID int,
	@SecondaryCustomerID int,
	@detProductField varchar(50),
	@detProductValue int,
	@productID int,
	@detValue float,
	@detUnit int,
	@detGrowthTargetPercentage float,
    @detGrowthTarget float,
    @detTargetPercentage float,
    @detPayoutPercentage float,
    @detPayout float,
	@detIncentiveTier int,
	@detTargetType varchar(50),
	@detVolumeReq int, 
	@detRebate float,
	@detRebatePerc float,
	@detFreeGoodsAmount float,
	@detFreegoodscap int,
	@detFreeGoodsunit int,
	@detDisplayRebatePercentage float,
	@detSaleTarget float
AS
BEGIN
SET NOCOUNT ON;
	IF EXISTS (
		SELECT TOP 1 promotionid	
		FROM tblPromotionDetailsIncentive 
		WHERE promotionID = @PromotionID 
		AND promotionTypeID = @PromotionTypeID 
		AND SecondaryCustomerID = @SecondaryCustomerID)
	BEGIN
		DELETE FROM tblPromotionDetailsIncentive 
		WHERE promotionID = @PromotionID 
		AND promotionTypeID = @PromotionTypeID 
		AND SecondaryCustomerID = @SecondaryCustomerID
	END

	INSERT INTO tblPromotionDetailsIncentive (
		promotionTypeID
		, promotionID
		, SecondaryCustomerID
		, detProductField
		, detProductValue
		, ProductID
		, detValue
		, detUnit
		, detGrowthTargetPercentage
		, detGrowthTarget
		, detTargetPercentage
		, detPayoutPercentage
		, detPayout
		, detIncentiveTier
		, detTargetType
		, detVolumeReq
		, detRebate
		, detRebatePerc
		, detFreeGoodsAmount
		, detFreegoodscap
		, detFreeGoodsunit
		, detDisplayRebatePercentage
		, detSaleTarget)
	VALUES( @promotionTypeID
		, @PromotionID
		, @SecondaryCustomerID
		, @detProductField
		, @detProductValue
		, @productID
		, @detValue
		, @detUnit
		, @detGrowthTargetPercentage
		, @detGrowthTarget
		, @detTargetPercentage
		, @detPayoutPercentage
		, @detPayout
		, @detIncentiveTier
		, @detTargetType
		, @detVolumeReq
		, @detRebate
		, @detRebatePerc
		, @detFreeGoodsAmount
		, @detFreegoodscap
		, @detFreeGoodsunit
		, @detDisplayRebatePercentage
		, @detSaleTarget)
END



