

CREATE VIEW [dbo].[vw_PromoSecCust]
AS

Select p.promotionID, p.countryID, scust.customerID, sc.secondaryCustomerId 
from tblPromotionSecondaryCustomer sc
inner join tblPromotion p on p.promotionID = sc.promotionId
inner join tblSecondaryCustomer scust on scust.secondaryCustomerID = sc.secondaryCustomerId





