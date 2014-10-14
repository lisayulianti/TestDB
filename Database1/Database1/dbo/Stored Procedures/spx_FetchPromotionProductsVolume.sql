
-- =============================================
-- Author:		Anthony Steven
-- Create date: 8 October 2014
-- Description:	Get Products Based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionProductsVolume]
	@products ProductList ReadOnly
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	select distinct (case when parentMapping.parentProductId is null then p.productID
	       when parentMapping.parentProductId is not null then parentMapping.parentProductId end) as productID, p.prdConversionFactor, p.prdGroup7ID, 
           p.prdGroup21ID,  p.prdGroup4ID,  p.prdGroup9ID 
			from tblProduct p WITH (NOLOCK)
			left join vw_ProductParentMapping parentMapping  WITH (NOLOCK)  on p.productID = parentMapping.productID	
			inner join @products prod on p.productID = prod.productID			

END




