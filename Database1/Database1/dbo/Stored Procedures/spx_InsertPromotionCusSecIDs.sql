-- =============================================
-- Author:           LIN
-- Create date: 27/08/2014
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromotionCusSecIDs] 
       @promotionID int
AS
BEGIN

        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @cusID int ;
        DECLARE @secID int ;
        DECLARE @secCusID int ;
        DECLARE @countryId int ;

        SELECT
              @cusID = ISNULL (MAX( customerID), 0 ),
              @secID = ISNULL (MAX( secondarycustomerID), 0 )
        FROM tblPromotionCustomerSelection WHERE promotionID = @promotionID ;

        DECLARE @temp AS TABLE(promotionID INT, customerID INT);

        DELETE tblPromotionSecondaryCustomer WHERE promotionID = @promotionID;
        DELETE tblPromotionCustomer WHERE promotionID = @promotionID;
		DELETE tblPromotionCustomer2 WHERE promotionId = @promotionID;

        IF @cusID = 0
            BEGIN
				PRINT 'customer if';
                -- SAVE INTO tblPromotionCustomer
                INSERT INTO @temp
                SELECT DISTINCT
                   pcg .promotionID,
                   cus .customerID
                    FROM tblPromotionCustomerSelection pcg
                    INNER JOIN (SELECT * FROM tblPromotion WHERE isDeleted=0) prm ON prm .promotionID = pcg.promotionID
                    LEFT JOIN (SELECT DISTINCT countryID,promotionID, cusGroup1ID FROM tblPromotionCustomerSelection WHERE cusGroup1ID>0) pcg1 ON pcg.countryID = pcg1.countryID AND pcg. promotionID = pcg1.promotionID
                    LEFT JOIN (SELECT DISTINCT countryID,promotionID, cusGroup2ID FROM tblPromotionCustomerSelection WHERE cusGroup2ID>0) pcg2 ON pcg.countryID = pcg2.countryID AND pcg. promotionID = pcg2.promotionID
                    LEFT JOIN (SELECT DISTINCT countryID,promotionID, cusGroup3ID FROM tblPromotionCustomerSelection WHERE cusGroup3ID>0) pcg3 ON pcg.countryID = pcg3.countryID AND pcg. promotionID = pcg3.promotionID
                    LEFT JOIN (SELECT DISTINCT countryID,promotionID, cusGroup4ID FROM tblPromotionCustomerSelection WHERE cusGroup4ID>0) pcg4 ON pcg.countryID = pcg4.countryID AND pcg. promotionID = pcg4.promotionID
                    LEFT JOIN (SELECT DISTINCT countryID,promotionID, cusGroup5ID FROM tblPromotionCustomerSelection WHERE cusGroup5ID>0) pcg5 ON pcg.countryID = pcg5.countryID AND pcg. promotionID = pcg5.promotionID
                    LEFT JOIN (SELECT DISTINCT countryID,promotionID, cusGroup6ID FROM tblPromotionCustomerSelection WHERE cusGroup6ID>0) pcg6 ON pcg.countryID = pcg6.countryID AND pcg. promotionID = pcg6.promotionID
                    LEFT JOIN (SELECT DISTINCT countryID,promotionID, cusGroup7ID FROM tblPromotionCustomerSelection WHERE cusGroup7ID>0) pcg7 ON pcg.countryID = pcg7.countryID AND pcg. promotionID = pcg7.promotionID
                    INNER JOIN tblCustomer cus ON pcg .countryID = cus.countryID
                    AND ( pcg1.cusGroup1ID IS NULL OR pcg1.cusGroup1ID=cus .cusGroup1ID)
                    AND ( pcg2.cusGroup2ID IS NULL OR pcg2.cusGroup2ID=cus .cusGroup2ID)
                    AND ( pcg3.cusGroup3ID IS NULL OR pcg3.cusGroup3ID=cus .cusGroup3ID)
                    AND ( pcg4.cusGroup4ID IS NULL OR pcg4.cusGroup4ID=cus .cusGroup4ID)
                    AND ( pcg5.cusGroup5ID IS NULL OR pcg5.cusGroup5ID=cus .cusGroup5ID)
                    AND ( pcg6.cusGroup6ID IS NULL OR pcg6.cusGroup6ID=cus .cusGroup6ID)
                    AND ( pcg7.cusGroup7ID IS NULL OR pcg7.cusGroup7ID=cus .cusGroup7ID)
                    AND pcg. promotionID = @promotionID
                    AND cus. customerID IS NOT NULL
					INNER JOIN tblPromotion promotion on pcg.promotionID = promotion.promotionId and isnull(promotion.prmDateStart,GetDate()) between cus.validFrom and cus.validTo;
            END
   ELSE
            BEGIN
				PRINT 'else customer';
                  INSERT INTO @temp
                  SELECT promotionID, customerID FROM tblPromotionCustomerSelection WHERE promotionID = @promotionID AND customerID IS NOT NULL;
            END

	IF NOT EXISTS (select top 1 promotionID from tblPromotionCustomerSelection where promotionID = @promotionID
		and (secGroup1ID is not null or secGroup2ID is not null or secGroup3ID is not null or 
		secGroup4ID is not null or secGroup5ID is not null or secGroup6ID is not null or
		secondarycustomerID is not null))
	BEGIN
		INSERT INTO tblPromotionCustomer
		SELECT * FROM @temp;
		INSERT INTO tblPromotionCustomer2
		SELECT * FROM @temp;
	END
	ELSE
	BEGIN
        IF @secID = 0
            BEGIN
				PRINT 'SECID = 0'
                IF EXISTS(SELECT TOP 1 * FROM @temp)
                BEGIN
					PRINT 'SECID = 0 WITH CUSTOMER ID'
                    -- SAVE INTO tblPromotionSecondaryCustomer Table
                    INSERT INTO tblPromotionSecondaryCustomer
                    SELECT DISTINCT
                       pcg.promotionID,
                       secCust.secondaryCustomerID
                    FROM tblPromotionCustomerSelection pcg
                        INNER JOIN (SELECT * FROM tblPromotion WHERE isDeleted=0) prm ON prm.promotionID = pcg.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup1ID FROM tblPromotionCustomerSelection WHERE secGroup1ID>0) pcg1 ON pcg.countryID = pcg1.countryID AND pcg.promotionID = pcg1.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup2ID FROM tblPromotionCustomerSelection WHERE secGroup2ID>0) pcg2 ON pcg.countryID = pcg2.countryID AND pcg.promotionID = pcg2.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup3ID FROM tblPromotionCustomerSelection WHERE secGroup3ID>0) pcg3 ON pcg.countryID = pcg3.countryID AND pcg.promotionID = pcg3.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup4ID FROM tblPromotionCustomerSelection WHERE secGroup4ID>0) pcg4 ON pcg.countryID = pcg4.countryID AND pcg.promotionID = pcg4.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup5ID FROM tblPromotionCustomerSelection WHERE secGroup5ID>0) pcg5 ON pcg.countryID = pcg5.countryID AND pcg.promotionID = pcg5.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup6ID FROM tblPromotionCustomerSelection WHERE secGroup6ID>0) pcg6 ON pcg.countryID = pcg6.countryID AND pcg.promotionID = pcg6.promotionID
                        INNER JOIN tblSecondaryCustomer secCust ON pcg.countryID = secCust.countryID
                        INNER JOIN @temp t on t.customerID = secCust.customerID
                        AND ( pcg1.secGroup1ID IS NULL OR pcg1.secGroup1ID=secCust.secGroup1ID)
                        AND ( pcg2.secGroup2ID IS NULL OR pcg2.secGroup2ID=secCust.secGroup2ID)
                        AND ( pcg3.secGroup3ID IS NULL OR pcg3.secGroup3ID=secCust.secGroup3ID)
                        AND ( pcg4.secGroup4ID IS NULL OR pcg4.secGroup4ID=secCust.secGroup4ID)
                        AND ( pcg5.secGroup5ID IS NULL OR pcg5.secGroup5ID=secCust.secGroup5ID)
                        AND ( pcg6.secGroup6ID IS NULL OR pcg6.secGroup6ID=secCust.secGroup6ID)
                        AND pcg. promotionID = @promotionID
                        AND secCust. secondaryCustomerID IS NOT NULL
						INNER JOIN tblPromotion promotion on pcg.promotionID = promotion.promotionId and isnull(promotion.prmDateStart,GetDate()) between secCust.validFrom and secCust.validTo;

 					INSERT INTO tblPromotionCustomer2
					select promotionID, customerID from tblPromotionSecondaryCustomer psc
					inner join tblSecondaryCustomer sc on sc.secondaryCustomerID = psc.secondaryCustomerId where promotionId = @promotionID
					group by promotionId, customerID
                END
                ELSE
                BEGIN
					PRINT 'SECID = 0 WITHOUT CUSTOMER ID'
                    INSERT INTO tblPromotionSecondaryCustomer
                    SELECT DISTINCT
                       pcg.promotionID,
                       secCust.secondaryCustomerID
                    FROM tblPromotionCustomerSelection pcg
                        INNER JOIN (SELECT * FROM tblPromotion WHERE isDeleted=0) prm ON prm .promotionID = pcg.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup1ID FROM tblPromotionCustomerSelection WHERE secGroup1ID>0) pcg1 ON pcg.countryID = pcg1.countryID AND pcg.promotionID = pcg1.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup2ID FROM tblPromotionCustomerSelection WHERE secGroup2ID>0) pcg2 ON pcg.countryID = pcg2.countryID AND pcg.promotionID = pcg2.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup3ID FROM tblPromotionCustomerSelection WHERE secGroup3ID>0) pcg3 ON pcg.countryID = pcg3.countryID AND pcg.promotionID = pcg3.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup4ID FROM tblPromotionCustomerSelection WHERE secGroup4ID>0) pcg4 ON pcg.countryID = pcg4.countryID AND pcg.promotionID = pcg4.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup5ID FROM tblPromotionCustomerSelection WHERE secGroup5ID>0) pcg5 ON pcg.countryID = pcg5.countryID AND pcg.promotionID = pcg5.promotionID
                        LEFT JOIN (SELECT DISTINCT countryID,promotionID, secGroup6ID FROM tblPromotionCustomerSelection WHERE secGroup6ID>0) pcg6 ON pcg.countryID = pcg6.countryID AND pcg.promotionID = pcg6.promotionID
                        INNER JOIN tblSecondaryCustomer secCust ON pcg.countryID = secCust.countryID
                        AND ( pcg1.secGroup1ID IS NULL OR pcg1.secGroup1ID = secCust.secGroup1ID)
                        AND ( pcg2.secGroup2ID IS NULL OR pcg2.secGroup2ID = secCust.secGroup2ID)
                        AND ( pcg3.secGroup3ID IS NULL OR pcg3.secGroup3ID = secCust.secGroup3ID)
                        AND ( pcg4.secGroup4ID IS NULL OR pcg4.secGroup4ID = secCust.secGroup4ID)
                        AND ( pcg5.secGroup5ID IS NULL OR pcg5.secGroup5ID = secCust.secGroup5ID)
                        AND ( pcg6.secGroup6ID IS NULL OR pcg6.secGroup6ID = secCust.secGroup6ID)
                        AND pcg. promotionID = @promotionID
                        AND secCust. secondaryCustomerID IS NOT NULL
						INNER JOIN tblPromotion promotion on pcg.promotionID = promotion.promotionId and isnull(promotion.prmDateStart,GetDate()) between secCust.validFrom and secCust.validTo;
						
						INSERT INTO tblPromotionCustomer2 (customerId, promotionId)
						SELECT distinct customerId, promotionId FROM tblPromotionSecondaryCustomer s 
						INNER JOIN tblSecondaryCustomer sec ON sec.secondaryCustomerID = s.secondaryCustomerId
						WHERE promotionId = @promotionID;
                END
            END
        ELSE
            BEGIN
            IF EXISTS (SELECT TOP 1 * FROM @temp)
            BEGIN
				PRINT 'SECID <> 0 WITH CUSTOMER ID'
                INSERT INTO tblPromotionSecondaryCustomer
                 SELECT pcs.promotionID, pcs.secondarycustomerID FROM tblPromotionCustomerSelection pcs
				 INNER JOIN tblSecondaryCustomer tsc on pcs.secondaryCustomerId = tsc.secondaryCustomerID
				 INNER JOIN @temp t 
				 ON t.customerID = tsc.customerID 
				 INNER JOIN tblPromotion promotion on pcs.promotionId = promotion.promotionID
				 WHERE 
				 isnull(promotion.prmDateStart,GetDate()) between tsc.validFrom and tsc.validTo and  pcs.promotionID = @promotionID AND pcs.secondarycustomerID IS NOT NULL;

 				INSERT INTO tblPromotionCustomer2 (customerId, promotionId)
					SELECT distinct customerId, promotionId FROM tblPromotionSecondaryCustomer s 
					INNER JOIN tblSecondaryCustomer sec ON sec.secondaryCustomerID = s.secondaryCustomerId
					WHERE promotionId = @promotionID;

            END
            ELSE
            BEGIN
				PRINT 'SECID <> 0 WITHOUT CUSTOMER ID'
                INSERT INTO tblPromotionSecondaryCustomer
                SELECT pcs.promotionID, pcs.secondarycustomerID FROM tblPromotionCustomerSelection pcs
				 INNER JOIN tblSecondaryCustomer tsc on pcs.secondaryCustomerId = tsc.secondaryCustomerID
				 INNER JOIN tblPromotion promotion on pcs.promotionId = promotion.promotionID	
				 WHERE isnull(promotion.prmDateStart,GetDate()) between tsc.validFrom and tsc.validTo and  pcs.promotionID = @promotionID  AND pcs.secondarycustomerID IS NOT NULL;

				INSERT INTO tblPromotionCustomer2 (customerId, promotionId)
					SELECT distinct customerId, promotionId FROM tblPromotionSecondaryCustomer s 
					INNER JOIN tblSecondaryCustomer sec ON sec.secondaryCustomerID = s.secondaryCustomerId
					WHERE promotionId = @promotionID;
            END
        END
	END
END

