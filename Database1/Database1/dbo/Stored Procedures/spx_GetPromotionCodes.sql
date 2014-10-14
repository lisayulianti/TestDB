-- =============================================
-- Author: Sweta Sadhya		
-- Create date: 21-Jul-2014
-- Description:	generates promotion codes
-- Modified By: Lisa Yulianti
-- Reason to modify: optimize query
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromotionCodes]

@countryID int,
@PromotionID int,
@department int

AS
BEGIN


Declare @PromotionClientCode as nvarchar(50)

select
top 1 @PromotionClientCode = abbr.PromotionClientCode
from tblPromotion prm
inner join tblPromotionSecondaryCustomer cust WITH (NOLOCK) on prm.promotionID = @promotionID and prm.promotionID = cust.promotionID
inner join tblSecondaryCustomer seccust WITH (NOLOCK) on seccust.secondaryCustomerID = cust.secondaryCustomerID
inner join tblCustomer cus WITH (NOLOCK) on cus.customerID = seccust.customerID
inner join tblPromotionProductSelection prmprd WITH (NOLOCK) on prm.promotionID = prmprd.promotionID
inner join tblProduct prd WITH (NOLOCK) on prd.productID = prmprd.prdProductID
inner join tblPromotionCodeAbbreviation abbr WITH (NOLOCK) on (abbr.secGroup2ID is null OR abbr.secGroup2ID = seccust.secGroup2ID)
	and abbr.cusGroup6ID = cus.cusGroup6ID
	and abbr.prdGroup7ID = prd.prdGroup7ID
	and abbr.departmentID = @department
--inner join tblDepartment dept on dept.departmentID = @Department and dept.= abbr.pcaDepartment

if isnull (@promotionClientCode,'') = ''
begin
	select
	top 1 @PromotionClientCode = abbr.PromotionClientCode
	from tblPromotion prm
	inner join vw_PromoCust cust WITH (NOLOCK) on prm.promotionID = @promotionID and prm.promotionID = cust.promotionID
	inner join tblCustomer seccust WITH (NOLOCK) on seccust.customerID = cust.customerID
	inner join tblPromotionProductSelection prmprd WITH (NOLOCK) on prm.promotionID = prmprd.promotionID
	inner join tblProduct prd WITH (NOLOCK) on prd.productID = prmprd.prdProductID
	inner join tblPromotionCodeAbbreviation abbr WITH (NOLOCK) on abbr.cusGroup6ID = seccust.cusGroup6ID 
		and abbr.prdGroup7ID = prd.prdGroup7ID and abbr.departmentID = @department
	--inner join tblBudgetOwner budget on budget.BudgetOwnerID = @Department and budget.bdoBudgetOwnerClientName = abbr.pcaDepartment
end

-- If can't find the PromotionClientCode in tblPromotionCodeAbbreviation table should return AAA
select isnull(@PromotionClientCode, cast('AAA' as nvarchar(50))) as PromotionClientCode


--SELECT TOp 1 abbr.* 
--FROM tblPromotionCodeAbbreviation abbr
--INNER JOIN
--(
--SELECT DISTINCT prm.promotionID, cus.cusGroup5ID,cus.cusGroup6ID, sec.secGroup2ID,prd.prdGroup7ID
--FROm tblPromotion prm
--LEFT JOIN (SELECT vcus0.countryID, vcus0.promotionID, vcus0.customerID, cus.cusGroup5ID, cus.cusGroup6ID
--	FROM vw_PromoCust vcus0 INNER JOIN tblCustomer cus ON vcus0.countryID = cus.countryID AND vcus0.customerID = cus.customerID WHERE vcus0.promotionID = @PromotionID) cus 
--	ON prm.countryID = cus.countryID AND prm.promotionID = cus.promotionID
--LEFT JOIN (SELECT vsec0.countryID, vsec0.promotionID, vsec0.customerID, vsec0.secondaryCustomerID, sec.secGroup2ID
--	FROM vw_PromoSecCust vsec0 INNER JOIN tblSecondaryCustomer sec ON vsec0.countryID = sec.countryID AND vsec0.secondaryCustomerID = sec.secondaryCustomerID WHERE vsec0.promotionID = @PromotionID) sec
--	ON prm.countryID = sec.countryID AND prm.promotionID = sec.promotionID
--INNER JOIN (SELECT sel.promotionID, sel.prdProductID, prod.prdGroup7ID 
--	FROm tblPromotionProductSelection sel INNER JOIN tblProduct prod ON sel.prdProductID = prod.productID) prd ON prm.promotionID = prd.promotionID 
--WHERE prm.promotionID = @PromotionID
--) tblSel ON (((abbr.cusGroup5ID = tblSel.cusGroup5ID AND abbr.cusGroup6ID = tblSel.cusGroup6ID) OR (abbr.secGroup2ID = tblSel.secGroup2ID))) AND abbr.prdGroup7ID = tblSel.prdGroup7ID  
--WHERE abbr.pcaDepartment =  (SELECT bdoBudgetOwnerClientName FROM tblBudgetOwner WHERE BudgetOwnerID = @department)

END
