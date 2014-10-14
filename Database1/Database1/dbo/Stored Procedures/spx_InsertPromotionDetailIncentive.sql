-- =============================================
-- Author:		Robert de Castr0
-- Create date: 24/7/2014
-- Description:	Inserts in the tblPromotionDetailIncentive
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromotionDetailIncentive]
	-- Add the parameters for the stored procedure here
	@promotionTypeID int, 
	@promotionID int,
	@SecondaryCustomerID int,
	@detProductField varchar(50),
	@detProductValue int,
	@productID varchar(max),
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
	@detVolumeReqRetailer float,
	@detVolumeReqUnit int,
	@detOutletClass float,
	@detNonSalesTarget nvarchar(50),
	@detMaximumPayoutPercentage float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	
	IF EXISTS (
		SELECT TOP 1 promotionid	
		FROM tblPromotionDetailsIncentive 
		WHERE promotionID = @PromotionID 
		AND promotionTypeID = @PromotionTypeID 
		AND SecondaryCustomerID = @SecondaryCustomerID
		AND detIncentiveTier = @detIncentiveTier
		AND detTargetType = ISNULL(@detTargetType,'')
		AND detProductValue = @detProductValue)
	BEGIN
		DELETE FROM tblPromotionDetailsIncentive 
		WHERE promotionID = @PromotionID 
		AND promotionTypeID = @PromotionTypeID 
		AND SecondaryCustomerID = @SecondaryCustomerID
		AND detIncentiveTier = @detIncentiveTier
		AND detTargetType = ISNULL(@detTargetType,'')
		AND detProductValue = @detProductValue
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
		, detVolumeReqRetailer
		, detVolumeReqUnit
		, detOutletClass
		, detNonSalesTarget
		, detMaximumPayoutPercentage)
	SELECT @promotionTypeID
		, @PromotionID
		, @SecondaryCustomerID
		, @detProductField
		, @detProductValue
		, CAST([data] AS INT)
		, @detValue
		, @detUnit
		, @detGrowthTargetPercentage
		, @detGrowthTarget
		, @detTargetPercentage
		, @detPayoutPercentage
		, @detPayout
		, @detIncentiveTier
		, ISNULL(@detTargetType,'')
		, @detVolumeReq
		, @detRebate
		, @detRebatePerc
		, @detFreeGoodsAmount
		, @detFreegoodscap
		, @detFreeGoodsunit
		, @detVolumeReqRetailer
		, @detVolumeReqUnit
		, @detOutletClass
		, @detNonSalesTarget
		, @detMaximumPayoutPercentage
	FROM dbo.fn_split(@productID, ',')

END



