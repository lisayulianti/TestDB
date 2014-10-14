-- =============================================
-- Author:		Anthony Steven
-- Create date: 15 September 2014
-- Description:	Fetch Free Goods
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchFreeGoods]
	@promotionId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT tpfg.productID, tpfg.freeProductID, prod.prdGroup7ID,prod.prdGroup9ID,
	prod.prdGroup4ID,prdGroup21ID,prdGroup14ID,prdGroup15ID from 
	tblPromotionFreeGoods tpfg  WITH (NOLOCK) 
	inner join tblProduct prod  WITH (NOLOCK) 
	ON tpfg.productID = prod.productID
	WHERE promotionId = @promotionId
END

