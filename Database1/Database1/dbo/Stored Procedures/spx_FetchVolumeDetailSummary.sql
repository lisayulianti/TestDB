-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Volume Detail Summary
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchVolumeDetailSummary]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT x.promotionId as PromotionId, p.productId as ProductId, p.prdProductName as ProductName, x.volVolumeP1Base as BaselineP1  ,
                                     x.volVolumeP2Base  as BaselineP2, x.volVolumeP3Base  as BaselineP3
                                    , x.volVolumeP1Plan as PlanP1, x.volVolumeP2Plan as PlanP2, 
                                    x.volVolumeP3Plan as PlanP3, x.volVolumeP1Actual as ActualP1
                                    , x.volVolumeP2Actual as ActualP2, x.volVolumeP3Actual as ActualP3,
                                     x.volVolumeP1ActualSellOut as ActualSellOutP1, x.volVolumeP2ActualSellOut as ActualSellOutP2,
                                      x.volVolumeP3ActualSellOut as ActualSellOutP3
                                     from tblPromoVolumeSelection x   WITH (NOLOCK) inner join tblProduct p  WITH (NOLOCK) on x.productID = p.productID
									 where x.promotionId = @promotionId
END



