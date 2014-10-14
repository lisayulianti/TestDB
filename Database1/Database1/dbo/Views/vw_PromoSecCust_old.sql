

CREATE VIEW [dbo].[vw_PromoSecCust_old]
AS

--Select p.promotionID, p.countryID, sc.secondaryCustomerId 
--from tblPromotionSecondaryCustomer sc
--inner join tblPromotion p on p.promotionID = sc.promotionId

select 
psg0.countryID,
psg0.promotionID, 
--psg0.secGroup1ID, psg0.secGroup2ID, psg0.secGroup3ID ,
sec.secondaryCustomerID, sec.customerID
from
(select isnull(isnull(isnull(isnull(psg1.countryID, psg2.countryID), psg3.countryID), psg4.countryID), psg5.countryID) countryID,
isnull(isnull(isnull(isnull(psg1.promotionID, psg2.promotionID), psg3.promotionID), psg4.promotionID), psg5.promotionID) promotionID, psg1.secGroup1ID, psg2.secGroup2ID, psg3.secGroup3ID,
psg4.secGroup4ID, psg5.secFPercentage 
from
(
(select promotionID, countryID, secGroup1ID, secGroup2ID, secGroup3ID, secGroup4ID, secFPercentage 
from tblPromotionCustomerSelection where (secGroup1ID>0 or secGroup2ID>0 or secGroup3ID>0 or secGroup4ID>0 or secFPercentage>0) 
	and secondarycustomerID is null) psg 
left join
(
SELECT DISTINCT countryID, promotionID, secGroup1ID
FROM      tblPromotionCustomerSelection 
WHERE   secGroup1ID > 0) psg1 on psg.countryID = psg1.countryID and psg.promotionID = psg1.promotionID and psg.secGroup1ID = psg1.secGroup1ID
left join 
(SELECT DISTINCT countryID, promotionID, secGroup2ID
FROM      tblPromotionCustomerSelection
WHERE   secGroup2ID > 0) psg2 ON psg.countryID = psg2.countryID AND psg.promotionID = psg2.promotionID and psg.secGroup2ID = psg2.secGroup2ID
left join
(SELECT DISTINCT countryID, promotionID, secGroup3ID
FROM      tblPromotionCustomerSelection
WHERE   secGroup3ID > 0) psg3 ON psg.countryID = psg2.countryID AND psg.promotionID = psg3.promotionID and psg.secGroup3ID = psg3.secGroup3ID
left join
(SELECT DISTINCT countryID, promotionID, secGroup4ID
FROM      tblPromotionCustomerSelection
WHERE   secGroup4ID > 0) psg4 ON psg.countryID = psg4.countryID AND psg.promotionID = psg4.promotionID and psg.secGroup4ID = psg4.secGroup4ID
left join
(SELECT DISTINCT countryID, promotionID, secFPercentage
FROM      tblPromotionCustomerSelection
WHERE   secFPercentage > 0) psg5 ON psg.countryID = psg5.countryID AND psg.promotionID = psg5.promotionID and psg.secFPercentage = psg5.secFPercentage
)) psg0 
INNER JOIN
     tblSecondaryCustomer sec ON psg0.countryID = sec.countryID AND 
	(psg0.secGroup1ID IS NULL OR ISNULL(psg0.secGroup1ID, 0) = sec.secGroup1ID) AND 
	(psg0.secGroup2ID IS NULL OR ISNULL(psg0.secGroup2ID, 0) = sec.secGroup2ID) AND 
	(psg0.secGroup3ID IS NULL OR ISNULL(psg0.secGroup3ID, 0) = sec.secGroup3ID) AND 
	(psg0.secGroup4ID IS NULL OR ISNULL(psg0.secGroup4ID, 0) = sec.secGroup4ID) AND 
	(psg0.secFPercentage IS NULL OR ISNULL(psg0.secFPercentage, 0) = sec.secFPercentage) AND
	psg0.promotionID IN
        (SELECT promotionID
        FROM      tblPromotionCustomerSelection
        WHERE   countryID = psg0.countryID AND secondaryCustomerID IS NULL)
inner join vw_PromoCust v on v.customerID = sec.customerID and v.promotionID = psg0.promotionID
UNION
SELECT DISTINCT psec.countryID, psec.promotionID, sec.secondaryCustomerID, sec.customerID
FROM     tblPromotionCustomerSelection psec INNER JOIN
                  tblSecondaryCustomer sec ON psec.secondaryCustomerID = sec.secondaryCustomerID





