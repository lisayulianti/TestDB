-- =============================================
-- Author:		Sweta Sadhya
-- Edited:		Anthony Steven (16 Sept 2014)
-- Create date: 18 July 2014
-- Description:	Promotion Detail Table
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromotionDetail]
	@countryID int,
	@PromotionID int,
	@PromotionTypeID int,
	@detPrdProductField nvarchar(max) = '',
	@detPrdProductValue nvarchar(max) = '',
	@productID ProductList ReadOnly,
	@detStepNr int,
	@detGroupNr int,
	@detPercentageOfBudget int,
	@detProductClientCode int,
	@detVolumeReq int,
	@detVolumeReqTargetIncentive int,
	@detRebate float,
	@detRebatepercentage float,
	@detRebateLumpsum float,
	@detTradediscount float,
	@detTradediscountPercentage float,
	@detConsumerDiscount float,
	@detConsumerDiscountPercentage float,
	@detCustomerpoints int,
	@detCustomerpointsrequirement int,
	@detPremiumMechanic float,
	@detPremiumCost float,
	@detPremiumQuantity int,
	@detSpaceBuyFee float,
	@detShelfSpaceFee float,
	@detGondolaFee float,
	@detDisplayFee float,
	@detDisplayNumber int,
	@detNumberofFreeUOMs int,
	@detFreeUOM int,
	@detAgencyfees float,
	@FreegoodsPrdID ProductList ReadOnly,
	@ExclFreegoodsPrdID ProductList ReadOnly,
	@detFreegoodsamount int,
	@detFreegoodsunit int,
	@detFreegoodscap int,
	@detFreegoodscapunit int,
	@detStoreRevampingAmount float,
	@detNewStoreOpeningAmount float,
	@detListingFeeAmount float,
	@detAnniversarySponsorAm float,
	@detScanDataLightboxAmount float,
	@detIncentiveAmount float,
	@detLocPromoLumpSum float,
	@detDiscountInvoice float,
	@detCTNFrom float,
	@detDCTNTo float,
	@detNTT float,
	@detInvoiceDiscount float,
	@detPromotionAmount float,
	@detMailcost float,
	@detPOSMaterialcost float,
	@detOutlet int,
	@detOutletClass int,
	@detTargetType int,
	@detIncentiveTier int,
	@detGrowthTargetPercentage float,
	@detGrowthTarget float,
	@detPayoutPercentage float,
	@detPayout float,
	@detNonSalesTarget nvarchar(max) = '',
	@detCappedAmount float,
	@detPrintingAndStickering float,
	@detDisplayAnP float,
	@detVoucher float,
	@detAgencyCosts float,
	@detLuckyDraw float,
	@detLocalisedRebate float,
	@detLocalisedRebatepercentage float,
	@detLocalisedRebateLumpsum float

AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
-- if promotion id , type and product selector is equal then update
SET NOCOUNT ON;

Set @detPrdProductField = isnull(@detPrdProductField,'0')

if exists (SELECT Top 1 promotionid	FROM tblPromotionDetails WHERE promotionID = @PromotionID  
	AND (PromotionTypeID <> @PromotionTypeID OR detPrdProductField <> @detPrdProductField))
begin
-- delete
	DELETE FROM tblPromotionDetails WHERE promotionID = @PromotionID 
	DELETE FROM tblPromotionFreeGoods WHERE promotionID = @PromotionID 
end

-- to delete any existing records in tblPromotionDetails and tblPromotionFreeGoods 
-- of the productIDs that is about to be re-inserted 
 if exists (SELECT Top 1 promotionid	FROM tblPromotionDetails WHERE promotionID = @PromotionID  
	AND PromotionTypeID = @PromotionTypeID and detPrdProductField = @detPrdProductField 
	--and detPrdProductValue = @detPrdProductValue
	)
begin
	DELETE FROM tblPromotionDetails WHERE promotionID = @PromotionID and PromotionTypeID = @PromotionTypeID 
		and detPrdProductField = @detPrdProductField --and detPrdProductValue = @detPrdProductValue
		and productID in (select productID from dbo.fn_GetProdIDByPromoID(@PromotionID,@detPrdProductField,@detPrdProductValue))
	DELETE FROM tblPromotionFreeGoods WHERE promotionID = @PromotionID 
		and productID in (select productID from dbo.fn_GetProdIDByPromoID(@PromotionID,@detPrdProductField,@detPrdProductValue))
end


	

		-- insert
		INSERT INTO tblPromotionDetails
		(
		countryID, PromotionID, PromotionTypeID, detPrdProductField, detPrdProductValue, productID, detStepNr, detGroupNr, 
        detPercentageOfBudget, detProductClientCode, detVolumeReq, detVolumeReqTargetIncentive, detRebate, detRebatepercentage, detRebateLumpsum, detTradediscount, 
        detTradediscountPercentage, detConsumerDiscount, detConsumerDiscountPercentage, detCustomerpoints, detCustomerpointsrequirement, detPremiumMechanic, 
        detPremiumCost, detPremiumQuantity, detSpaceBuyFee, detShelfSpaceFee, detGondolaFee, detDisplayFee, detDisplayNumber, detNumberofFreeUOMs, detFreeUOM, 
        detAgencyfees, detFreegoodsamount, detFreegoodsunit, detFreegoodscap,detFreegoodscapunit , detStoreRevampingAmount, detNewStoreOpeningAmount, detListingFeeAmount, 
        detAnniversarySponsorAmount, detScanDataLightboxAmount, detIncentiveAmount, detLocPromoLumpSum, detDiscountInvoice, detCTNFrom, detDCTNTo, detNTT, 
        detInvoiceDiscount, detPromotionAmount, detMailcost, detPOSMaterialcost, detOutlet, detOutletClass, detTargetType, detIncentiveTier, detGrowthTargetPercentage, 
        detGrowthTarget, detPayoutPercentage, detPayout, detNonSalesTarget, detCappedAmount, detPrintingAndStickering, detDisplayAnP, detVoucher, 
        detAgencyCosts, detLuckyDraw, detLocalisedRebate,detLocalisedRebatepercentage, detLocalisedRebateLumpsum
		)
		SELECT @countryID,
		@PromotionID,
		@PromotionTypeID,
		@detPrdProductField,
		@detPrdProductValue,
		[productID],
		@detStepNr,
		@detGroupNr,
		@detPercentageOfBudget ,
		@detProductClientCode ,
		@detVolumeReq ,
		@detVolumeReqTargetIncentive ,
		@detRebate ,
		@detRebatepercentage ,
		@detRebateLumpsum ,
		@detTradediscount ,
		@detTradediscountPercentage ,
		@detConsumerDiscount ,
		@detConsumerDiscountPercentage ,
		@detCustomerpoints ,
		@detCustomerpointsrequirement,
		@detPremiumMechanic ,
		@detPremiumCost ,
		@detPremiumQuantity ,
		@detSpaceBuyFee ,
		@detShelfSpaceFee ,
		@detGondolaFee ,
		@detDisplayFee ,
		@detDisplayNumber ,
		@detNumberofFreeUOMs ,
		@detFreeUOM ,
		@detAgencyfees ,
		@detFreegoodsamount ,
		@detFreegoodsunit ,
		@detFreegoodscap ,
		@detFreegoodscapunit ,
		@detStoreRevampingAmount ,
		@detNewStoreOpeningAmount ,
		@detListingFeeAmount ,
		@detAnniversarySponsorAm ,
		@detScanDataLightboxAmount ,
		@detIncentiveAmount ,
		@detLocPromoLumpSum ,
		@detDiscountInvoice ,
		@detCTNFrom ,
		@detDCTNTo ,
		@detNTT ,
		@detInvoiceDiscount ,
		@detPromotionAmount ,
		@detMailcost ,
		@detPOSMaterialcost ,
		@detOutlet ,
		@detOutletClass ,
		@detTargetType ,
		@detIncentiveTier ,
		@detGrowthTargetPercentage ,
		@detGrowthTarget ,
		@detPayoutPercentage ,
		@detPayout ,
		@detNonSalesTarget ,
		@detCappedAmount,
		@detPrintingAndStickering, 
		@detDisplayAnP, 
		@detVoucher, 
        @detAgencyCosts, 
		@detLuckyDraw,
		@detLocalisedRebate,
		@detLocalisedRebatepercentage,
		@detLocalisedRebateLumpsum
		FROM dbo.fn_GetProdIDByPromoID(@PromotionID,@detPrdProductField,@detPrdProductValue)

		UPDATE tblPromotionDetails
		SET
			detRebateLumpsum = @detRebateLumpsum,
			detPremiumCost = @detPremiumCost,
			detPremiumQuantity = @detPremiumQuantity,
			detPOSMaterialcost = @detPOSMaterialcost,
			detMailcost = @detMailcost,
			detSpaceBuyFee = @detSpaceBuyFee,
			detShelfSpaceFee = @detShelfSpaceFee,
			detGondolaFee = @detGondolaFee,
			detDisplayNumber = @detDisplayNumber,
			--,detFreegoodscap = @detFreegoodscap,
			detPromotionAmount = @detPromotionAmount
		WHERE promotionID = @PromotionID

		Declare @selectedProductId TABLE
		( 
			productID INT
		)
		insert into @selectedProductId 
		select productID from dbo.fn_GetProdIDByPromoID(@PromotionID,@detPrdProductField,@detPrdProductValue)

		DELETE FROM tblPromotionFreeGoods WHERE promotionID = @PromotionID
		and productID in (select productID from dbo.fn_GetProdIDByPromoID(@PromotionID,@detPrdProductField,@detPrdProductValue)) 

		insert into tblPromotionFreeGoods(countryId,promotionID,productID,freeProductID)
		select @countryID, @promotionID, prod.productId, freeGoods.productID
		from @selectedProductId prod, @FreegoodsPrdID freeGoods

		DELETE FROM tblPromotionExclusionProduct WHERE promotionID = @PromotionID 
		and productID in (select productID from dbo.fn_GetProdIDByPromoID(@PromotionID,@detPrdProductField,@detPrdProductValue)) 

		insert into tblPromotionExclusionProduct(countryId,promotionID,productID,exclfreeProductID)
		select @countryID, @promotionID, prod.productId, excl.productID
		from @selectedProductId prod, @ExclFreegoodsPrdID excl


	
End



