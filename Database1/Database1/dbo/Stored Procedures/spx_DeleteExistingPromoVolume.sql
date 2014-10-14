-- =============================================
-- Author:		Anthony Steven	
-- Create date: 23th July 2014
-- Description:	Delete Existing Promo Volume Selection
-- =============================================
CREATE PROCEDURE [dbo].[spx_DeleteExistingPromoVolume]
	@promotionId INT,
	@productInputType NVARCHAR(50)
AS
BEGIN
	
	DECLARE @currentInputType NVARCHAR(50)

	select @currentInputType = x.prmProductfield
	from tblPromotion x
	where x.promotionID = @promotionID

	if @currentInputType <> @productInputType OR @productInputType = 'all'
	begin
		delete tblPromoVolumeSelection 
		where promotionID = @promotionId	
	end


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	--DELETE tblPromoVolumeSelection
	--where promotionID = @promotionId
   
END



