-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Details Incentive Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateDetailsIncentiveCostByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	SELECT	
	SUM(
	CASE
		WHEN prd.prdGroup6ID = 102000002 
		THEN	 
			 isnull(dinc.detOutletClass,0)*(isnull(dinc.detMaximumPayoutPercentage,0)/100)
			*(isnull(dinc.detVolumeReqRetailer,0)/(case when prd.prdNetWeight is null or prd.prdNetWeight = 0 then 1 else prd.prdNetWeight end))
			*sa.saAmount
	
		WHEN prd.prdGroup6ID = 102000003 
		THEN	 
			 isnull(dinc.detOutletClass,0)*(isnull(dinc.detMaximumPayoutPercentage,0)/100)
			*((isnull(dinc.detVolumeReqRetailer,0)/(case when prd.prdNetWeight is null or prd.prdNetWeight = 0 then 1 else prd.prdNetWeight end))
			/ case when prd.prdConversionFactor is null or prd.prdConversionFactor = 0 then 1 else prd.prdConversionFactor end)
			*sa.saAmount
	END
	)	
	       from tblPromotionDetailsIncentive dinc  WITH (NOLOCK) 
		   inner join tblPromotion promo  WITH (NOLOCK) on dinc.promotionID = promo.promotionID
		   inner join tblProduct prd  WITH (NOLOCK) on dinc.productId = prd.productID
		   inner join (select tsa.productID saProductId, max(tsa.sysAmount) saAmount 
					   from tblSystemAccrual tsa  WITH (NOLOCK) 
					   where (tsa.sysDelete = '' or tsa.sysDelete is null) and tsa.sysUomClientCode = 'CTN'
					   group by tsa.productID) sa on dinc.productId = sa.saProductId		   
           and promo.promotionID = @promotionId
END



