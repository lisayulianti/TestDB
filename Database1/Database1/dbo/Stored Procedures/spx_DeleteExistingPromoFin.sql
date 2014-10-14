-- =============================================
-- Author:		Anthony Steven	
-- Create date: 23th July 2014
-- Description:	Delete Existing Promo Financial Record
-- =============================================
CREATE PROCEDURE [dbo].[spx_DeleteExistingPromoFin]
	@promotionId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DELETE tblPromoFinancial
	where promotionID = @promotionId
	and (finCostTypeID = 1 or finCostTypeID = 3)
   
END



