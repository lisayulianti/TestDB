-- =============================================
-- Author: Sweta Sadhya		
-- Create date: 29-Jul-2014
-- Description:	generates gross sales for KRIS promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetGrossSalesKRIS]

@PromotionID int

AS

BEGIN

SELECT 
	CASE sysacc.sysUomClientCode WHEN 'CTN' 
		THEN (sum(sec.sctInvQtyEa) / prd.prdConversionFactor) * sysacc.sysAmount
		ELSE sum(sec.sctInvQtyEa)  * sysacc.sysAmount
	END tQTY, 
	sec.productID, 
	prd.prdGroup7ID, 
	prd.prdGroup9ID, 
	prd.prdGroup4ID, 
	prd.prdGroup21ID, 
	prd.prdGroup14ID, 
	prd.prdParentCode
FROM tblSecTrans AS sec
INNER JOIN tblProduct AS prd ON sec.productID = prd.productID
INNER JOIN dbo.fn_GetSysAmountValueByPromotionID(@PromotionID) AS sysacc ON sec.productID = sysacc.productid
WHERE sec.secondaryCustomerID in (
	SELECT secondaryCustomerID 
	FROM tblSecondaryCustomer 
	WHERE secGroup4ID IN (
		SELECT secGroup4ID 
		FROM tblPromotionCustomerSelection 
		WHERE promotionID = @PromotionID))
AND sec.productID IN (
	SELECT prdProductID 
	FROM tblPromotionProductSelection 
	WHERE promotionID = @PromotionID)
GROUP BY sec.productID , prd.prdConversionFactor , sysacc.sysUomClientCode ,sysacc.sysAmount , prd.prdGroup7ID , prd.prdGroup9ID , prd.prdGroup4ID, prd.prdGroup21ID, prd.prdGroup14ID, prd.prdParentCode

END



