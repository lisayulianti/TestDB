-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Promotion Detail Costs
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionDetailCosts]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	select tpd.detPrintingAndStickering as PrintingAndStickeringCost, 	
	tpd.detDisplayAnP as DisplayAPCost, 
	tpd.detVoucher as VoucherCost, 
	tpd.detAgencyCosts as AgencyCosts, 
	tpd.detLuckyDraw as LuckyDrawCost
	from tblPromotionDetails tpd  WITH (NOLOCK) 
	 where tpd.promotionID = @promotionId
END



