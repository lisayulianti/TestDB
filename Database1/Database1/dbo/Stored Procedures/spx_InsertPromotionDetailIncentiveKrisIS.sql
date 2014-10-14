-- =============================================
-- Author:		Robert De Castro
-- Create date: 19 Sept 2014
-- Description:	Save KRIS IS KPI's in tblPromotionDetailsIncentive
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromotionDetailIncentiveKrisIS] 
	@promotionTypeID INT, 
	@promotionID INT,
	@detProductField NVARCHAR(50),
	@detProductValue INT,
	@productIDList ProductList READONLY,
	@detGrowthTargetPercentage FLOAT,
    @detGrowthTarget FLOAT,
    @detTargetPercentage FLOAT,
    @detPayoutPercentage FLOAT,
    @detPayout FLOAT,
	@detIncentiveTier INT,
	@detTargetType NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;   
	
	IF EXISTS (
		SELECT TOP 1 promotionid	
		FROM tblPromotionDetailsIncentive 
		WHERE promotionID = @PromotionID
		AND detTargetType = @detTargetType
		AND detIncentiveTier = @detIncentiveTier
		AND ISNULL(detProductField, 0) = ISNULL(@detProductField, 0)
		AND ISNULL(detProductValue, 0) = ISNULL(@detProductValue, 0))
	BEGIN
		DELETE FROM tblPromotionDetailsIncentive 
		WHERE promotionID = @PromotionID 
		AND detTargetType = @detTargetType
		AND detIncentiveTier = @detIncentiveTier
		AND ISNULL(detProductField, 0) = ISNULL(@detProductField, 0)
		AND ISNULL(detProductValue, 0) = ISNULL(@detProductValue, 0)
	END

	IF EXISTS (SELECT TOP 1 productID FROM @productIDList)
	BEGIN
		INSERT INTO tblPromotionDetailsIncentive (
			promotionTypeID
			, promotionID
			, ProductID
			, detGrowthTargetPercentage
			, detGrowthTarget
			, detTargetPercentage
			, detPayoutPercentage
			, detPayout
			, detIncentiveTier
			, detTargetType)
		SELECT @promotionTypeID
			, @PromotionID
			, productID
			, @detGrowthTargetPercentage
			, @detGrowthTarget
			, @detTargetPercentage
			, @detPayoutPercentage
			, @detPayout
			, @detIncentiveTier
			, @detTargetType
		FROM @productIDList
	END
	ELSE
	BEGIN
		INSERT INTO tblPromotionDetailsIncentive (
			promotionTypeID
			, promotionID
			, detProductField
			, detProductValue
			, detGrowthTargetPercentage
			, detGrowthTarget
			, detTargetPercentage
			, detPayoutPercentage
			, detPayout
			, detIncentiveTier
			, detTargetType)
		VALUES (
			@promotionTypeID
			, @PromotionID
			, @detProductField
			, @detProductValue
			, @detGrowthTargetPercentage
			, @detGrowthTarget
			, @detTargetPercentage
			, @detPayoutPercentage
			, @detPayout
			, @detIncentiveTier
			, @detTargetType)
	END
END



