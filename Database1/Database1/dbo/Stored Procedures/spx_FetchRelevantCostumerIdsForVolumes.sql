
-- =============================================
-- Author:           Anthony Steven
-- Create date: 07/10/2014
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchRelevantCostumerIdsForVolumes]
      
	   @customerSelection CustSelectionList ReadOnly	   
AS
BEGIN

        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @cusID int 
        DECLARE @secID int 
        DECLARE @secCusID int 
        DECLARE @countryId int 
		DECLARE @outletId int

        SELECT
              @cusID = ISNULL (MAX( customerID), 0 ),
              @secID = ISNULL (MAX( secondarycustomerID), 0 ),
			  @outletId  = ISNULL (MAX( outletID), 0 )
        FROM @customerSelection 

        DECLARE @temp AS TABLE(customerID INT);
	
	IF @outletId <> 0
	BEGIN
		INSERT INTO @temp
		SELECT outletID
		FROM @customerSelection 
		
	END
	ELSE	
	BEGIN

	IF EXISTS (select * from @customerSelection 
	where (secGroup1ID is not null or secGroup2ID is not null or secGroup3ID is not null or 
	secGroup4ID is not null or secGroup5ID is not null or secGroup6ID is not null or
	secondarycustomerID is not null))	
	
	BEGIN
		IF @secID = 0
			BEGIN
				PRINT 'SECID = 0'
                IF EXISTS(SELECT TOP 1 * FROM @temp)
                BEGIN
					PRINT 'SECID = 0 WITH CUSTOMER ID'
                    --INSERT INTO tblPromotionSecondaryCustomer
					INSERT INTO @temp
                    SELECT DISTINCT
                       --pcg.promotionID,
                       secCust.secondaryCustomerID
                    FROM @customerSelection pcg
                        --INNER JOIN (SELECT * FROM tblPromotion WHERE isDeleted=0) prm ON prm.promotionID = pcg.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup1ID FROM @customerSelection WHERE secGroup1ID>0) pcg1 ON pcg.countryID = pcg1.countryID AND pcg.promotionID = pcg1.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup2ID FROM @customerSelection WHERE secGroup2ID>0) pcg2 ON pcg.countryID = pcg2.countryID AND pcg.promotionID = pcg2.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup3ID FROM @customerSelection WHERE secGroup3ID>0) pcg3 ON pcg.countryID = pcg3.countryID AND pcg.promotionID = pcg3.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup4ID FROM @customerSelection WHERE secGroup4ID>0) pcg4 ON pcg.countryID = pcg4.countryID AND pcg.promotionID = pcg4.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup5ID FROM @customerSelection WHERE secGroup5ID>0) pcg5 ON pcg.countryID = pcg5.countryID AND pcg.promotionID = pcg5.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup6ID FROM @customerSelection WHERE secGroup6ID>0) pcg6 ON pcg.countryID = pcg6.countryID AND pcg.promotionID = pcg6.promotionID
                        INNER JOIN tblSecondaryCustomer secCust ON --pcg.countryID = secCust.countryID
                        --INNER JOIN @temp t on t.customerID = secCust.customerID
                        ( pcg.secGroup1ID IS NULL OR pcg.secGroup1ID=secCust.secGroup1ID)
                        AND ( pcg.secGroup2ID IS NULL OR pcg.secGroup2ID=secCust.secGroup2ID)
                        AND ( pcg.secGroup3ID IS NULL OR pcg.secGroup3ID=secCust.secGroup3ID)
                        AND ( pcg.secGroup4ID IS NULL OR pcg.secGroup4ID=secCust.secGroup4ID)
                        AND ( pcg.secGroup5ID IS NULL OR pcg.secGroup5ID=secCust.secGroup5ID)
                        AND ( pcg.secGroup6ID IS NULL OR pcg.secGroup6ID=secCust.secGroup6ID)                       
                        AND secCust. secondaryCustomerID IS NOT NULL
						--INNER JOIN tblPromotion promotion on pcg.promotionID = promotion.promotionId and isnull(promotion.prmDateStart,GetDate()) between secCust.validFrom and secCust.validTo;

 					--INSERT INTO tblPromotionCustomer2
					--select promotionID, customerID from tblPromotionSecondaryCustomer psc
					--inner join tblSecondaryCustomer sc on sc.secondaryCustomerID = psc.secondaryCustomerId
					--group by promotionId, customerID
                END
                ELSE
                BEGIN
					PRINT 'SECID = 0 WITHOUT CUSTOMER ID'
                    --INSERT INTO tblPromotionSecondaryCustomer
					INSERT INTO @temp
                    SELECT DISTINCT
                       --pcg.promotionID,
                       secCust.secondaryCustomerID
                    FROM @customerSelection pcg
                        --INNER JOIN (SELECT * FROM tblPromotion WHERE isDeleted=0) prm ON prm .promotionID = pcg.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup1ID FROM @customerSelection WHERE secGroup1ID>0) pcg1 ON pcg.countryID = pcg1.countryID AND pcg.promotionID = pcg1.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup2ID FROM @customerSelection WHERE secGroup2ID>0) pcg2 ON pcg.countryID = pcg2.countryID AND pcg.promotionID = pcg2.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup3ID FROM @customerSelection WHERE secGroup3ID>0) pcg3 ON pcg.countryID = pcg3.countryID AND pcg.promotionID = pcg3.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup4ID FROM @customerSelection WHERE secGroup4ID>0) pcg4 ON pcg.countryID = pcg4.countryID AND pcg.promotionID = pcg4.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup5ID FROM @customerSelection WHERE secGroup5ID>0) pcg5 ON pcg.countryID = pcg5.countryID AND pcg.promotionID = pcg5.promotionID
                        --LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup6ID FROM @customerSelection WHERE secGroup6ID>0) pcg6 ON pcg.countryID = pcg6.countryID AND pcg.promotionID = pcg6.promotionID
                        INNER JOIN tblSecondaryCustomer secCust ON --pcg.countryID = secCust.countryID
                        ( pcg.secGroup1ID IS NULL OR pcg.secGroup1ID = secCust.secGroup1ID)
                        AND ( pcg.secGroup2ID IS NULL OR pcg.secGroup2ID = secCust.secGroup2ID)
                        AND ( pcg.secGroup3ID IS NULL OR pcg.secGroup3ID = secCust.secGroup3ID)
                        AND ( pcg.secGroup4ID IS NULL OR pcg.secGroup4ID = secCust.secGroup4ID)
                        AND ( pcg.secGroup5ID IS NULL OR pcg.secGroup5ID = secCust.secGroup5ID)
                        AND ( pcg.secGroup6ID IS NULL OR pcg.secGroup6ID = secCust.secGroup6ID)
                      
                        AND secCust. secondaryCustomerID IS NOT NULL
						--INNER JOIN tblPromotion promotion on pcg.promotionID = promotion.promotionId and isnull(promotion.prmDateStart,GetDate()) between secCust.validFrom and secCust.validTo;
						
						--INSERT INTO tblPromotionCustomer2 (customerId, promotionId)
						--SELECT distinct customerId, promotionId FROM tblPromotionSecondaryCustomer s 
						--INNER JOIN tblSecondaryCustomer sec ON sec.secondaryCustomerID = s.secondaryCustomerId
						
                END
            END
		ELSE
			BEGIN
            IF EXISTS (SELECT TOP 1 * FROM @temp)
            BEGIN
				PRINT 'SECID <> 0 WITH CUSTOMER ID'
				INSERT INTO @temp
                --INSERT INTO tblPromotionSecondaryCustomer
                 SELECT pcs.secondarycustomerID FROM @customerSelection pcs
				 INNER JOIN tblSecondaryCustomer tsc on pcs.secondaryCustomerId = tsc.secondaryCustomerID
				 --INNER JOIN @temp t 
				 --ON t.customerID = tsc.customerID 
				 --INNER JOIN tblPromotion promotion on pcs.promotionId = promotion.promotionID
				 WHERE 
				 --isnull(promotion.prmDateStart,GetDate()) between tsc.validFrom and tsc.validTo  AND 
				 pcs.secondarycustomerID IS NOT NULL;

 				--INSERT INTO tblPromotionCustomer2 (customerId, promotionId)
					--SELECT distinct customerId, promotionId FROM tblPromotionSecondaryCustomer s 
					--INNER JOIN tblSecondaryCustomer sec ON sec.secondaryCustomerID = s.secondaryCustomerId
					

            END
            ELSE
            BEGIN
				PRINT 'SECID <> 0 WITHOUT CUSTOMER ID'
                --INSERT INTO tblPromotionSecondaryCustomer
				INSERT INTO @temp
                SELECT pcs.secondarycustomerID FROM @customerSelection pcs
				 INNER JOIN tblSecondaryCustomer tsc on pcs.secondaryCustomerId = tsc.secondaryCustomerID
				-- INNER JOIN tblPromotion promotion on pcs.promotionId = promotion.promotionID	
				 WHERE --isnull(promotion.prmDateStart,GetDate()) between tsc.validFrom and tsc.validTo  AND 
				 pcs.secondarycustomerID IS NOT NULL;

				--INSERT INTO tblPromotionCustomer2 (customerId, promotionId)
					--SELECT distinct customerId, promotionId FROM tblPromotionSecondaryCustomer s 
					--INNER JOIN tblSecondaryCustomer sec ON sec.secondaryCustomerID = s.secondaryCustomerId
					
            END
        END
	END
	ELSE
	BEGIN
		IF @cusID = 0
            BEGIN
				PRINT 'customer if';
                -- SAVE INTO tblPromotionCustomer
                INSERT INTO @temp
                SELECT DISTINCT
                  
                   cus .customerID
                    FROM @customerSelection pcg                    
                    --LEFT JOIN (SELECT cusGroup1ID FROM @customerSelection WHERE cusGroup1ID>0) pcg1 ON pcg.countryID = pcg1.countryID AND pcg. promotionID = pcg1.promotionID
                    --LEFT JOIN (SELECT cusGroup2ID FROM @customerSelection WHERE cusGroup2ID>0) pcg2 ON pcg.countryID = pcg2.countryID AND pcg. promotionID = pcg2.promotionID
                    --LEFT JOIN (SELECT cusGroup3ID FROM @customerSelection WHERE cusGroup3ID>0) pcg3 ON pcg.countryID = pcg3.countryID AND pcg. promotionID = pcg3.promotionID
                    --LEFT JOIN (SELECT cusGroup4ID FROM @customerSelection WHERE cusGroup4ID>0) pcg4 ON pcg.countryID = pcg4.countryID AND pcg. promotionID = pcg4.promotionID
                    --LEFT JOIN (SELECT cusGroup5ID FROM @customerSelection WHERE cusGroup5ID>0) pcg5 ON pcg.countryID = pcg5.countryID AND pcg. promotionID = pcg5.promotionID
                    --LEFT JOIN (SELECT cusGroup6ID FROM @customerSelection WHERE cusGroup6ID>0) pcg6 ON pcg.countryID = pcg6.countryID AND pcg. promotionID = pcg6.promotionID
                    --LEFT JOIN (SELECT cusGroup7ID FROM @customerSelection WHERE cusGroup7ID>0) pcg7 ON pcg.countryID = pcg7.countryID AND pcg. promotionID = pcg7.promotionID
                    INNER JOIN tblCustomer cus ON 
					(pcg.cusGroup1ID IS NULL OR pcg.cusGroup1ID=cus .cusGroup1ID)
                    AND ( pcg.cusGroup2ID IS NULL OR pcg.cusGroup2ID=cus .cusGroup2ID)
                    AND ( pcg.cusGroup3ID IS NULL OR pcg.cusGroup3ID=cus .cusGroup3ID)
                    AND ( pcg.cusGroup4ID IS NULL OR pcg.cusGroup4ID=cus .cusGroup4ID)
                    AND ( pcg.cusGroup5ID IS NULL OR pcg.cusGroup5ID=cus .cusGroup5ID)
                    AND ( pcg.cusGroup6ID IS NULL OR pcg.cusGroup6ID=cus .cusGroup6ID)
                    AND ( pcg.cusGroup7ID IS NULL OR pcg.cusGroup7ID=cus .cusGroup7ID)                    
                    AND cus. customerID IS NOT NULL
					--INNER JOIN tblPromotion promotion on pcg.promotionID = promotion.promotionId and isnull(promotion.prmDateStart,GetDate()) between cus.validFrom and cus.validTo;
            END
		ELSE
            BEGIN
				PRINT 'else customer';
                  INSERT INTO @temp
                  SELECT customerID FROM @customerSelection WHERE customerID IS NOT NULL;
            END
	END

	END
	SELECT * FROM @temp

END


