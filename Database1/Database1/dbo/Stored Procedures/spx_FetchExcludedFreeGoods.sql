-- =============================================
-- Author:		Anthony Steven
-- Create date: 16 September 2014
-- Description:	Fetch Free Goods
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchExcludedFreeGoods]
	@promotionId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT tpeg.productID, tpeg.exclfreeProductID, prod.prdGroup7ID,prod.prdGroup9ID,
	prod.prdGroup4ID,prdGroup21ID,prdGroup14ID,prdGroup15ID from 
	tblPromotionExclusionProduct tpeg  WITH (NOLOCK) 
	inner join tblProduct prod  WITH (NOLOCK) 
	ON tpeg.productID = prod.productID
	WHERE promotionId = @promotionId
END

