
-- =============================================
-- Author:		Anthony Steven
-- Create date: 24th July 2014
-- Description:	Create Additional Budget
-- =============================================
CREATE PROCEDURE [dbo].[spx_CreateAdditionalBudget]
	@promotionId INT
    
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @newPromotionIdTable TABLE (promotionID int)
	
	DECLARE @newPromotionId INT, @desc NVARCHAR(50), @newDesc NVARCHAR(50)
	

	select @desc = CASE WHEN prmPromotionClientCode IS NOT NULL 
	AND LEN(prmPromotionClientCode) > 2
	THEN prmPromotionClientCode
	ELSE NULL
	END
	from tblPromotion  WITH (NOLOCK) where promotionId = @promotionId

	
	IF @desc is not NULL	
		IF RIGHT(@desc,2) = 'E1'
		SET @newDesc = LEFT(@desc,LEN(@desc)-2)+'E2'
		ELSE IF RIGHT(@desc,2) = 'E2'
		SET @newDesc = LEFT(@desc,LEN(@desc)-2)+'E3'
		ELSE IF RIGHT(@desc,2) = 'E3'
		SET @newDesc = LEFT(@desc,LEN(@desc)-2)+'E4'
		ELSE IF RIGHT(@desc,2) = 'E4'
		SET @newDesc = LEFT(@desc,LEN(@desc)-2)+'E5'
		ELSE
		SET @newDesc = LEFT(@desc,LEN(@desc))+'E1'
	ELSE
	SET @newDesc = 'OVER';
	


	IF @newDesc = 'OVER'
	BEGIN
	SET @newPromotionId = -1
	SELECT @newPromotionId 
	END
	ELSE
	BEGIN
	-- copy tblPromotion Record
	
	insert into tblPromotion(countryID,prmPromotionClientCode,prmPromotionName,prmPromotionDescription,
	promotionTypeID,prmPromotionStructure,prmParentSelectionID,ObjectiveID,ActivityID,ActivityTwoID,prmSupport,
	prmInvoice,prmStatusID,prmUnitID,prmBudgetOwnerID,isActive,prmIOnumber,
	prmDateStart,prmDateEnd,prmDateFirstOrder,prmDateLastOrder,prmCreator,prmProductfield,prmCustomerfield,
	prmDateCreated,prmDateSubmitted,prmDateApproved,prmDateActualStart,prmDateActualEnd,prmBudgetNr,prmGrossSales,
	prmTotalExpenses,prmGP,prmGPPerc,prmProductGrouping,prmSelectedProductGroup,prmOriginalPromotionID)
	OUTPUT inserted.promotionID into @newPromotionIdTable
		select countryID,@newDesc,prmPromotionName,prmPromotionDescription,
	promotionTypeID,prmPromotionStructure,prmParentSelectionID,ObjectiveID,ActivityID,ActivityTwoID,prmSupport,
	prmInvoice,0,prmUnitID,prmBudgetOwnerID,isActive,prmIOnumber,
	prmDateStart,prmDateEnd,prmDateFirstOrder,prmDateLastOrder,prmCreator,prmProductfield,prmCustomerfield,
	prmDateCreated,prmDateSubmitted,prmDateApproved,prmDateActualStart,prmDateActualEnd,prmBudgetNr,prmGrossSales,
	prmTotalExpenses,prmGP,prmGPPerc,prmProductGrouping,prmSelectedProductGroup,promotionID from tblPromotion WITH (NOLOCK)  where promotionID = @promotionId;

	select @newPromotionId = promotionID 
	from @newPromotionIdTable

	-- copy tblPromotionCustomer

	INSERT INTO tblPromotionCustomer(promotionId,customerId)
    SELECT @newPromotionId, customerId from tblPromotionCustomer  WITH (NOLOCK)
	where promotionId = @promotionId

	-- copy tblPromotionSecondaryCustomer

	INSERT INTO tblPromotionSecondaryCustomer(promotionId,secondaryCustomerId)
    SELECT @newPromotionId, secondaryCustomerId from tblPromotionSecondaryCustomer  WITH (NOLOCK)
	where promotionId = @promotionId

	-- copy tblPromotionDetails

	insert into tblPromotionDetails (countryID,PromotionID,PromotionTypeID,detPrdProductField,detPrdProductValue,
	productID,detStepNr,detGroupNr,detPercentageOfBudget,detProductClientCode,detVolumeReq,detVolumeReqTargetIncentive,
	detRebate,detRebatePercentage,detRebateLumpsum,detTradeDiscount,detTradediscountPercentage,detConsumerDiscount,
	detConsumerDiscountPercentage,detCustomerpoints,detCustomerpointsrequirement,detpremiummechanic,detpremiumcost,
	detpremiumquantity,	detspacebuyfee,detshelfspacefee,detgondolafee,detdisplayfee,detdisplaynumber,detNumberofFreeUOMs,
	detfreeuom,detAgencyfees,detFreegoodsamount,detfreegoodsunit,detfreegoodscap,detStoreRevampingAmount,detNewStoreOpeningAmount,
	detListingFeeAmount,detAnniversarySponsorAmount,detScanDataLightboxAmount,detincentiveamount,detLocPromoLumpSum,
	detDiscountInvoice,detCTNFrom,detDCTNTo,detntt,detInvoiceDiscount,detPromotionAmount,detMailcost,detPOSMaterialcost,
	detOutlet,detOutletClass,detTargetType,detIncentiveTier,detGrowthTargetPercentage,detGrowthTarget,detPayoutPercentage,
	detPayout,detNonSalesTarget,detCappedAmount)
	select countryID,@newPromotionid,PromotionTypeID,detPrdProductField,detPrdProductValue,
	productID,detStepNr,detGroupNr,detPercentageOfBudget,detProductClientCode,detVolumeReq,detVolumeReqTargetIncentive,
	detRebate,detRebatePercentage,detRebateLumpsum,detTradeDiscount,detTradediscountPercentage,detConsumerDiscount,
	detConsumerDiscountPercentage,detCustomerpoints,detCustomerpointsrequirement,detpremiummechanic,detpremiumcost,
	detpremiumquantity,	detspacebuyfee,detshelfspacefee,detgondolafee,detdisplayfee,detdisplaynumber,detNumberofFreeUOMs,
	detfreeuom,detAgencyfees,detFreegoodsamount,detfreegoodsunit,detfreegoodscap,detStoreRevampingAmount,detNewStoreOpeningAmount,
	detListingFeeAmount,detAnniversarySponsorAmount,detScanDataLightboxAmount,detincentiveamount,detLocPromoLumpSum,
	detDiscountInvoice,detCTNFrom,detDCTNTo,detntt,detInvoiceDiscount,detPromotionAmount,detMailcost,detPOSMaterialcost,
	detOutlet,detOutletClass,detTargetType,detIncentiveTier,detGrowthTargetPercentage,detGrowthTarget,detPayoutPercentage,
	detPayout,detNonSalesTarget,detCappedAmount from tblPromotionDetails WITH (NOLOCK)  where promotionID = @promotionId 

	-- copy tblPromotionDetailsIncentive

	insert into tblPromotionDetailsIncentive (promotionTypeID,promotionID,SecondaryCustomerID,detOutletClass,ProductID,
	detProductField,detProductValue,detTargetType,detNonSalesTarget,detNumberOfTiers,detIncentiveTier,detGrowthTargetPercentage,
	detGrowthTarget,detTargetPercentage,detPayoutPercentage,detPayout,detVolumeReqRetailer,detVolumeReqUnit,detMaximumPayoutPercentage,
	detNumberOfDisplays,displayfee,detRebatePerc,detFreeGoodsAmount,detFreeGoodsunit)
	select promotionTypeID,@newPromotionId,SecondaryCustomerID,detOutletClass,ProductID,
	detProductField,detProductValue,detTargetType,detNonSalesTarget,detNumberOfTiers,detIncentiveTier,detGrowthTargetPercentage,
	detGrowthTarget,detTargetPercentage,detPayoutPercentage,detPayout,detVolumeReqRetailer,detVolumeReqUnit,detMaximumPayoutPercentage,
	detNumberOfDisplays,displayfee,detRebatePerc,detFreeGoodsAmount,detFreeGoodsunit from tblPromotionDetailsIncentive  WITH (NOLOCK) where promotionID = @promotionId

	-- copy tblPromotionProductSelection
	insert into tblPromotionProductSelection (promotionID,prdProductID)
	select @newPromotionID,prdProductID from tblPromotionProductSelection  WITH (NOLOCK) where promotionID = @promotionID

	-- copy tblPromotionCustomerSelection
	INSERT INTO [dbo].[tblPromotionCustomerSelection]
           ([promotionID]
           ,[pslSelAllCusGroup1]
           ,[pslSelAllCusGroup2]
           ,[pslSelAllCusGroup3]
           ,[pslSelAllCusGroup4]
           ,[pslSelAllCusGroup5]
           ,[pslSelAllCusGroup6]
           ,[pslSelAllCusGroup7]
           ,[pslSelAllSecGroup1]
           ,[pslSelAllSecGroup2]
           ,[pslSelAllSecGroup3]
           ,[cusGroup1ID]
           ,[cusGroup2ID]
           ,[cusGroup3ID]
           ,[cusGroup4ID]
           ,[cusGroup5ID]
           ,[cusGroup6ID]
           ,[cusGroup7ID]
           ,[customerID]
           ,[secGroup1ID]
           ,[secGroup2ID]
           ,[secGroup3ID]
           ,[secondarycustomerID]
           ,[countryID]
           ,[pslSelAllSecGroup4]
           ,[secGroup4ID]
           ,[secFPercentage]
           ,[pslSelAllFPercentage])
	select @newPromotionId
           ,[pslSelAllCusGroup1]
           ,[pslSelAllCusGroup2]
           ,[pslSelAllCusGroup3]
           ,[pslSelAllCusGroup4]
           ,[pslSelAllCusGroup5]
           ,[pslSelAllCusGroup6]
           ,[pslSelAllCusGroup7]
           ,[pslSelAllSecGroup1]
           ,[pslSelAllSecGroup2]
           ,[pslSelAllSecGroup3]
           ,[cusGroup1ID]
           ,[cusGroup2ID]
           ,[cusGroup3ID]
           ,[cusGroup4ID]
           ,[cusGroup5ID]
           ,[cusGroup6ID]
           ,[cusGroup7ID]
           ,[customerID]
           ,[secGroup1ID]
           ,[secGroup2ID]
           ,[secGroup3ID]
           ,[secondarycustomerID]
           ,[countryID]
           ,[pslSelAllSecGroup4]
           ,[secGroup4ID]
           ,[secFPercentage]
           ,[pslSelAllFPercentage]
	from tblPromotionCustomerSelection  WITH (NOLOCK) where promotionID = @promotionId
	-- copy tblPromoVolumeSelection
	INSERT INTO [dbo].[tblPromoVolumeSelection]
           ([countryID]
           ,[promotionID]
           ,[volCusCustomerValue]
           ,[volPrdProductValue]
           ,[productID]
           ,[volVolumeP1Base]
           ,[volVolumeP2Base]
           ,[volVolumeP3Base]
           ,[volVolumeP1Plan]
           ,[volVolumeP2Plan]
           ,[volVolumeP3Plan]
           ,[volVolumeP1Actual]
           ,[volVolumeP2Actual]
           ,[volVolumeP3Actual]
           ,[volVolumeP1ActualSellOut]
           ,[volVolumeP2ActualSellOut]
           ,[volVolumeP3ActualSellOut]
           ,[volParticipationpercentagePlan]
           ,[volParticipationpercentageActual]
           ,[volCouponRedemptionPlan]
           ,[volCouponRedemptionActual]
           ,[volCardSalesPlan]
           ,[volCardSalesActual])
	select [countryID]
           ,@newPromotionId
           ,[volCusCustomerValue]
           ,[volPrdProductValue]
           ,[productID]
           ,[volVolumeP1Base]
           ,[volVolumeP2Base]
           ,[volVolumeP3Base]
           ,[volVolumeP1Plan]
           ,[volVolumeP2Plan]
           ,[volVolumeP3Plan]
           ,[volVolumeP1Actual]
           ,[volVolumeP2Actual]
           ,[volVolumeP3Actual]
           ,[volVolumeP1ActualSellOut]
           ,[volVolumeP2ActualSellOut]
           ,[volVolumeP3ActualSellOut]
           ,[volParticipationpercentagePlan]
           ,[volParticipationpercentageActual]
           ,[volCouponRedemptionPlan]
           ,[volCouponRedemptionActual]
           ,[volCardSalesPlan]
           ,[volCardSalesActual]
	from tblPromoVolumeSelection  WITH (NOLOCK) where promotionID = @promotionId

	-- copy tblPromoFinancial
	INSERT INTO [dbo].[tblPromoFinancial]
           ([promotionID]
           ,[countryID]
           ,[finPromotionTypeID]
           ,[finCostTypeID]
           ,[pnlID]
           ,[finConditionType]
           ,[finGeneralLedgerCode]
           ,[finGeneralLedgerCodeDesc]
           ,[finGeneralLedgerCodeBSh]
           ,[finGeneralLedgerCodeBShDesc]
           ,[finSpendType]
           ,[finAmount]
           ,[finBuildingBLockID])
	select @newPromotionId
           ,[countryID]
           ,[finPromotionTypeID]
           ,4
           ,[pnlID]
           ,[finConditionType]
           ,[finGeneralLedgerCode]
           ,[finGeneralLedgerCodeDesc]
           ,[finGeneralLedgerCodeBSh]
           ,[finGeneralLedgerCodeBShDesc]
           ,[finSpendType]
           ,[finAmount]
           ,[finBuildingBLockID]
	from tblPromoFinancial  WITH (NOLOCK) where promotionID = @promotionId

	-- copy tblPromotionCustomer2
	INSERT INTO tblPromotionCustomer2 (promotionId, customerId)
	select @newPromotionId, customerid 
	from tblPromotionCustomer2 where promotionId = @promotionId


	select @newPromotionId
	END
	
	
   
END




