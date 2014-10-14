-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Localized Promo Cost (Promo Amount) based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateLocPromoCostPromoAmountByPromotion]
	@promotionId INT	
AS
BEGIN

	Declare @sysAmount as table
	(
		productID int,
		sysAmount float,
		sysUOMClientCode varchar(10),
		combinationID int
	)
	insert into @sysAmount
	select * from dbo.fn_GetSysAmountValueByPromotionID(@promotionID)
	
	Declare @fee FLOAT
	Declare @sellOutFee FLOAT
	Declare @freeGoodsCapFee FLOAT
	
	SET NOCOUNT ON;    

	SET @fee = (SELECT Top 1 isnull(y.detPromotionAmount,0)
    from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y WITH (NOLOCK)  on x.promotionID = y.promotionID
    where x.promotionID = @promotionId)

	
	
	if @fee = 0
	BEGIN
		
		exec spx_GenerateSellOutReimbursementsByPromotion 
		        @promotionId = @promotionId, 
				@resultFee = @sellOutFee OUTPUT

		exec spx_GenerateFreeGoodsCapCostByPromotion
		        @promotionId = @promotionId, 
				@resultFee = @freeGoodsCapFee OUTPUT
		--execute @sellOutFee = spx_GenerateSellOutReimbursementsByPromotion 
		  --      @promotionId = @promotionId
		 
		--execute @freeGoodsCapFee = spx_GenerateFreeGoodsCapCostByPromotion
		  --      @promotionId = @promotionId
		SET @fee = @sellOutFee + @freeGoodsCapFee
	END

	SELECT(isnull(@fee,0))

	

END



