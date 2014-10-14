-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Promotion Client Code
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionClientCode]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	select prmPromotionClientCode from tblPromotion  WITH (NOLOCK) where promotionId = @promotionId
END



