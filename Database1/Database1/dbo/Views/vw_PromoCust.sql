
CREATE VIEW [dbo].[vw_PromoCust]
AS
select p.promotionID, p.countryID, pc.customerId
from tblPromotionCustomer pc
inner join tblpromotion	p on p.promotionID = pc.promotionId





