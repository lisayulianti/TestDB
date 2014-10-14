-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Get Products Based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionProducts]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	select distinct (case when parentMapping.parentProductId is null then p.productID
	       when parentMapping.parentProductId is not null then parentMapping.parentProductId end) as productID, p.prdConversionFactor, p.prdGroup7ID, 
           p.prdGroup21ID,  p.prdGroup4ID,  p.prdGroup9ID
           from tblProduct p  WITH (NOLOCK) inner join tblPromotionProductSelection s  WITH (NOLOCK) 
           on p.productID = s.prdProductID 
		   left join vw_ProductParentMapping parentMapping  WITH (NOLOCK)  on p.productID = parentMapping.productID		   
           where s.promotionID = @promotionId
END



