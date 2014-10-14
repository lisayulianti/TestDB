-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Product Detail Summary
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchProductDetailSummary]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;

	select tpd.detProductClientCode as ClientCode, prod.prdProductName as Name
                , tpd.detVolumeReq as VolumeReq, tpd.detRebate as SellOutRebate
				, tpd.detRebatepercentage as SellOutRebatePercentage , tpd.detPremiumMechanic as AmountOfPremiums
				, tpd.detFreegoodsamount as AmountOfFreeGoods , tpd.detDisplayFee as DisplayFee
				, tpd.detGondolaFee as GondolaFee, tpd.detShelfSpaceFee as ShelfSpaceFee
				, tpd.detSpaceBuyFee as SpaceBuyFee, tpd.detFreegoodscap as FreeGoodsCap
				, tpd.detNewStoreOpeningAmount as NewStoreOpeningFee
				, tpd.detStoreRevampingAmount as StoreRevampingFee
				, tpd.detAnniversarySponsorAmount as AnniversarySponsorAmount 
				, tpd.detScanDataLightboxAmount as ScandataLightboxAmount
				, tpd.detPOSMaterialcost as POSMaterialCosts
				, tpd.detPrintingAndStickering as PrintingAndStickering
				, tpd.detDisplayAnP as DisplayAP
				, tpd.detVoucher as Voucher
				, tpd.detAgencyCosts as Contest
				, tpd.detLuckyDraw as CostOfDemonstration
                from tblPromotionDetails tpd  WITH (NOLOCK)  inner join tblProduct prod  WITH (NOLOCK) 
                on tpd.productID = prod.productID  where tpd.promotionID = @promotionId
END



