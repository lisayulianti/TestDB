
-- =============================================
-- Author:		Anthony Steven
-- Create date: 26 August 2014
-- Description:	Generate KRIS GT Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateKRISGTByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;    	

	select sum((isnull(detRebatePerc,0)+isnull(detDisplayRebatePercentage,0))*isnull(detSaleTarget,0))
	from tblPromotionDetailsIncentive
	where promotionId = @promotionId
END




