-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Child Promotion Id
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchChildPromotionId]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	select isnull(promotionId,-1) from tblPromotion  WITH (NOLOCK) where prmOriginalPromotionId = @promotionId
END



