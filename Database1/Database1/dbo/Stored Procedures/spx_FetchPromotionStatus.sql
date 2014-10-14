-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Promotion Status (return -1 if not null)
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionStatus]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;

	select isnull(prmStatusID,-1)
	from tblPromotion  WITH (NOLOCK) 
	where promotionId=@promotionId
END



