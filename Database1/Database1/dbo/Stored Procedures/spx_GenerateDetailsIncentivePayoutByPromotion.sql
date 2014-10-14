-- =============================================
-- Author:		Anthony Steven
-- Create date: 29 July 2014
-- Description:	Generate Details Incentive Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateDetailsIncentivePayoutByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    
	select sum(payout)
	from (
	select dinc.detTargetType, max(dinc.detPayout) as payout
           from tblPromotionDetailsIncentive dinc  WITH (NOLOCK) 
		   inner join tblPromotion promo  WITH (NOLOCK) on dinc.promotionID = promo.promotionID
           and promo.promotionID = @promotionId
		   where dinc.detIncentiveTier = (select max(detIncentiveTier) from tblPromotionDetailsIncentive)
		   group by dinc.detTargetType) sourceTable
		   
END



