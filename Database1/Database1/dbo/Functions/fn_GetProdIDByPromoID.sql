
CREATE FUNCTION [dbo].[fn_GetProdIDByPromoID](
	@PromotionID int, 
	@PrdGroupCol varchar(50), 
	@PrdGroupID int
)

RETURNS @Results TABLE (productID int)
AS
BEGIN
	INSERT INTO @Results
	SELECT prd.productID
	FROM tblPromotion prm
	INNER JOIN tblPromotionProductSelection psel ON prm.promotionID = psel.promotionID
	INNER JOIN tblProduct prd ON psel.prdProductID = prd.productID
	WHERE prm.promotionID=@PromotionID	
		AND (
		    (@PrdGroupCol='0' AND (@PrdGroupID = 0 or prd.productID = @PrdGroupID))
		    OR (@PrdGroupCol='productID' AND (@PrdGroupID = 0 or prd.productID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup1ID' AND (@PrdGroupID = 0 or prd.prdGroup1ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup2ID' AND (@PrdGroupID = 0 or prd.prdGroup2ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup3ID' AND (@PrdGroupID = 0 or prd.prdGroup3ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup4ID' AND (@PrdGroupID = 0 or prd.prdGroup4ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup5ID' AND (@PrdGroupID = 0 or prd.prdGroup5ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup6ID' AND (@PrdGroupID = 0 or prd.prdGroup6ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup7ID' AND (@PrdGroupID = 0 or prd.prdGroup7ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup8ID' AND (@PrdGroupID = 0 or prd.prdGroup8ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup9ID' AND (@PrdGroupID = 0 or prd.prdGroup9ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup10ID' AND (@PrdGroupID = 0 or prd.prdGroup10ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup11ID' AND (@PrdGroupID = 0 or prd.prdGroup11ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup12ID' AND (@PrdGroupID = 0 or prd.prdGroup12ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup13ID' AND (@PrdGroupID = 0 or prd.prdGroup13ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup14ID' AND (@PrdGroupID = 0 or prd.prdGroup14ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup15ID' AND (@PrdGroupID = 0 or  prd.prdGroup15ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup16ID' AND (@PrdGroupID = 0 or prd.prdGroup16ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup17ID' AND (@PrdGroupID = 0 or prd.prdGroup17ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup18ID' AND (@PrdGroupID = 0 or prd.prdGroup18ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup19ID' AND (@PrdGroupID = 0 or prd.prdGroup19ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup20ID' AND (@PrdGroupID = 0 or prd.prdGroup20ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup21ID' AND (@PrdGroupID = 0 or prd.prdGroup21ID = @PrdGroupID))
			OR (@PrdGroupCol='prdGroup22ID' AND (@PrdGroupID = 0 or prd.prdGroup22ID = @PrdGroupID))
			OR (@PrdGroupCol='prdProductParentID' AND (@PrdGroupID = 0 or prd.prdProductParentID = @PrdGroupID))
		)
	RETURN
END

