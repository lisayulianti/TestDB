-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Parent Promotion Id
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchParentPromotionId]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	select isnull(prmOriginalPromotionId,-1) from tblPromotion  WITH (NOLOCK)  where promotionId = @promotionId
END



