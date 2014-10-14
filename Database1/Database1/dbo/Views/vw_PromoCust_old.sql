
CREATE VIEW [dbo].[vw_PromoCust_old]
AS
SELECT DISTINCT pcg.countryID, pcg.promotionID,cus.customerID
FROM tblPromotionCustomerSelection pcg
INNER JOIN (SELECT * FROM tblPromotion WHERE isDeleted=0) prm ON prm.promotionID = pcg.promotionID
LEFT JOIN (SELECT DISTINCT countryID,promotionID,cusGroup1ID FROM tblPromotionCustomerSelection WHERE cusGroup1ID>0) pcg1 ON pcg.countryID = pcg1.countryID AND pcg.promotionID = pcg1.promotionID
LEFT JOIN (SELECT DISTINCT countryID,promotionID,cusGroup2ID FROM tblPromotionCustomerSelection WHERE cusGroup2ID>0) pcg2 ON pcg.countryID = pcg2.countryID AND pcg.promotionID = pcg2.promotionID
LEFT JOIN (SELECT DISTINCT countryID,promotionID,cusGroup3ID FROM tblPromotionCustomerSelection WHERE cusGroup3ID>0) pcg3 ON pcg.countryID = pcg3.countryID AND pcg.promotionID = pcg3.promotionID
LEFT JOIN (SELECT DISTINCT countryID,promotionID,cusGroup4ID FROM tblPromotionCustomerSelection WHERE cusGroup4ID>0) pcg4 ON pcg.countryID = pcg4.countryID AND pcg.promotionID = pcg4.promotionID
LEFT JOIN (SELECT DISTINCT countryID,promotionID,cusGroup5ID FROM tblPromotionCustomerSelection WHERE cusGroup5ID>0) pcg5 ON pcg.countryID = pcg5.countryID AND pcg.promotionID = pcg5.promotionID
LEFT JOIN (SELECT DISTINCT countryID,promotionID,cusGroup6ID FROM tblPromotionCustomerSelection WHERE cusGroup6ID>0) pcg6 ON pcg.countryID = pcg6.countryID AND pcg.promotionID = pcg6.promotionID
LEFT JOIN (SELECT DISTINCT countryID,promotionID,cusGroup7ID FROM tblPromotionCustomerSelection WHERE cusGroup7ID>0) pcg7 ON pcg.countryID = pcg7.countryID AND pcg.promotionID = pcg7.promotionID
INNER JOIN tblCustomer cus ON pcg.countryID = cus.countryID 
AND (pcg1.cusGroup1ID IS NULL OR ISNULL(pcg1.cusGroup1ID,0)=cus.cusGroup1ID)
AND (pcg2.cusGroup2ID IS NULL OR ISNULL(pcg2.cusGroup2ID,0)=cus.cusGroup2ID)
AND (pcg3.cusGroup3ID IS NULL OR ISNULL(pcg3.cusGroup3ID,0)=cus.cusGroup3ID)
AND (pcg4.cusGroup4ID IS NULL OR ISNULL(pcg4.cusGroup4ID,0)=cus.cusGroup4ID)
AND (pcg5.cusGroup5ID IS NULL OR ISNULL(pcg5.cusGroup5ID,0)=cus.cusGroup5ID)
AND (pcg6.cusGroup6ID IS NULL OR ISNULL(pcg6.cusGroup6ID,0)=cus.cusGroup6ID)
AND (pcg7.cusGroup7ID IS NULL OR ISNULL(pcg7.cusGroup7ID,0)=cus.cusGroup7ID)
AND pcg.promotionID NOT IN (SELECT promotionID FROM tblPromotionCustomerSelection WHERE countryID = pcg.countryID AND customerID>0)
UNION
SELECT DISTINCT pcus.countryID,pcus.promotionID,cus.customerID 
FROM tblPromotionCustomerSelection pcus
INNER JOIN (SELECT * FROM tblPromotion WHERE isDeleted=0) prm ON prm.promotionID = pcus.promotionID
INNER JOIN tblCustomer cus ON pcus.customerID>0 AND pcus.customerID=cus.customerID





