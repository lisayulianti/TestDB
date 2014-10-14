-- =============================================
-- Author:		Lin
-- Create date: 29 SEP 2014
-- Description:	Fetch Promotion Product Detail Information
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromoProductDetail]
	@PromotionID int,
	@PrdGroupCol varchar(50),
	@PrdGroupID int
AS
BEGIN
	SELECT distinct prmD.*
	FROM dbo.fn_GetProdIDByPromoID (@PromotionID, @PrdGroupCol, @PrdGroupID) tbl
	INNER JOIN tblPromotionDetails prmD ON prmD.PromotionID = @PromotionID 
		AND prmD.productID = tbl.productID;
END
