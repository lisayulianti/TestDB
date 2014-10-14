-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 10 July 2014
-- Description:	Get the list of all CustomerIDs of a promotion
-- =============================================
CREATE FUNCTION [dbo].[fn_GetCustomerIDsByPromotionID]
(	
@PromotionID int
)
RETURNS TABLE 
AS
RETURN 
(
with tbl as
(
	select max(cusGST) cusGST
	from 
	(select customerID from tblPromotionCustomer2 where promotionID = @promotionID
	) pcust 
	inner join tblCustomer cust on cust.customerID = pcust.customerId
)
select
@PromotionID promotionID, prmcust.customerID, null secondaryCustomerID,
cust.cusGroup1ID, cust.cusGroup2ID, 
cust.cusGroup3ID, cust.cusGroup4ID, 
cust.cusGroup5ID, cust.cusGroup6ID,
cust.cusGroup7ID, --cust.cusGroup8ID,
null secGroup2ID,
tbl.cusGST
from tblCustomer cust WITH (NOLOCK) 
inner join vw_PromoCust prmcust WITH (NOLOCK) on prmcust.customerID = cust.customerID, tbl
where promotionID = @PromotionID
union
select
@PromotionID promotionID, cust.customerID, sec.secondaryCustomerID secondaryCustomerID,
cust.cusGroup1ID, cust.cusGroup2ID, 
cust.cusGroup3ID, cust.cusGroup4ID, 
cust.cusGroup5ID, cust.cusGroup6ID,
cust.cusGroup7ID, --cust.cusGroup8ID,
sec.secGroup2ID secGroup2ID,
tbl.cusGST
from tblPromotionSecondaryCustomer prmcust WITH (NOLOCK) 
inner join tblSecondaryCustomer sec WITH (NOLOCK) on sec.secondaryCustomerID = prmcust.secondaryCustomerID
inner join tblCustomer cust WITH (NOLOCK) on sec.customerID = cust.customerID, tbl
where promotionID = @PromotionID

--select
--@PromotionID promotionID, prmcust.customerID, prmcust.secondaryCustomerID,
--cust.cusGroup1ID, cust.cusGroup2ID, 
--cust.cusGroup3ID, cust.cusGroup4ID, 
--cust.cusGroup5ID, cust.cusGroup6ID,
--cust.cusGroup7ID, cust.cusGroup8ID,
--prmcust.secGroup2ID
--from tblCustomer cust
--inner join
--(
--select cus1.customerID, cus2.secondaryCustomerID, cus2.secGroup2ID
--from
--(
--select customerID ,NULL secGroup2ID
--from vw_PromoCust
--where promotionID = @PromotionID 
--) cus1 
--left join
--(
--select cust.customerID, seccust.secondaryCustomerID, secGroup2ID
--from vw_PromoSecCust cust
--inner join tblSecondaryCustomer seccust on cust.secondaryCustomerID = seccust.secondaryCustomerID
--where promotionID = @PromotionID 
--) cus2 on cus1.customerID = cus2.customerID
--) prmcust on cust.customerID = prmcust.customerID

	
--select @PromotionID promotionID, prmcust.customerID, cusGroup4ID, cusGroup7ID, cusGroup1ID from
--(
--select distinct cust.customerID, cust.cusGroup4ID, cust.cusGroup7ID, cust.cusGroup1ID
--from tblPromotionCustomerSelection prmcust 
--inner join tblCustomer cust on 
--	(prmcust.cusGroup1ID is null or prmcust.cusGroup1ID = cust.cusGroup1ID)
--	and (prmcust.cusGroup2ID is null or prmcust.cusGroup2ID = cust.cusGroup2ID)
--	and (prmcust.cusGroup3ID is null or prmcust.cusGroup3ID = cust.cusGroup3ID)
--	and (prmcust.cusGroup4ID is null or prmcust.cusGroup4ID = cust.cusGroup4ID)
--	and (prmcust.cusGroup5ID is null or prmcust.cusGroup5ID = cust.cusGroup5ID)
--	and (prmcust.cusGroup6ID is null or prmcust.cusGroup6ID = cust.cusGroup6ID)
--	and (prmcust.cusGroup7ID is null or prmcust.cusGroup7ID = cust.cusGroup7ID)
--	and (prmcust.customerID is null or prmcust.customerID = cust.customerID)
--where prmcust.promotionID = @promotionID and secGroup2ID is null
--union
--select distinct cust.customerID, cust.cusGroup4ID, cust.cusGroup7ID, cust.cusGroup1ID
--from tblPromotionCustomerSelection prmcust 
--inner join tblCustomer cust on 
--	(prmcust.cusGroup1ID is null or prmcust.cusGroup1ID = cust.cusGroup1ID)
--	and (prmcust.cusGroup2ID is null or prmcust.cusGroup2ID = cust.cusGroup2ID)
--	and (prmcust.cusGroup3ID is null or prmcust.cusGroup3ID = cust.cusGroup3ID)
--	and (prmcust.cusGroup4ID is null or prmcust.cusGroup4ID = cust.cusGroup4ID)
--	and (prmcust.cusGroup5ID is null or prmcust.cusGroup5ID = cust.cusGroup5ID)
--	and (prmcust.cusGroup6ID is null or prmcust.cusGroup6ID = cust.cusGroup6ID)
--	and (prmcust.cusGroup7ID is null or prmcust.cusGroup7ID = cust.cusGroup7ID)
--	and (prmcust.customerID is null or prmcust.customerID = cust.customerID)
--inner join tblSecondaryCustomer seccust on 
--	(prmcust.customerID is null or prmcust.customerID = seccust.customerID)
--	and (prmcust.secGroup2ID is null or prmcust.secGroup2ID = seccust.secGroup2ID)
--where prmcust.promotionID = @promotionID and prmcust.secGroup2ID is not null
--) prmcust


)

