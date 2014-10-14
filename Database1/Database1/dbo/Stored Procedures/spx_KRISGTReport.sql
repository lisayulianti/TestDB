
-- =============================================
-- Author:      Lin
-- Create date: 24/7/2014
-- Description: KRIST-GT report

CREATE PROCEDURE [dbo].[spx_KRISGTReport]
    @countryID int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @prmMonthDiff int;
    DECLARE @promotionMonthCounter int;
    DECLARE @promotionID int;
    DECLARE @monthName varchar(20);

    SET @promotionMonthCounter = 1;

    DECLARE cur CURSOR LOCAL for
        SELECT promotionID FROM dbo.tblPromotion WHERE countryID = @countryID AND promotionTypeID IN (102024) ORDER BY YEAR(prmDateStart) DESC, promotionID DESC;

        OPEN cur
        FETCH next FROM cur into  @promotionID
        WHILE @@FETCH_STATUS = 0 
        BEGIN
            SELECT @prmMonthDiff = DATEDIFF(MONTH, prmDateStart, prmDateEnd) FROM dbo.tblPromotion WHERE promotionID = @promotionID;

			SELECT  promotionCustomerSelectionID, 
					promotionID, 
					secondaryCustomerID, 
					customerID, 
					secCustomerName, 
					secCustomerClientCode,
					s04SecGroup4Desc, 
					detSaleTarget, 
					detDisplayRebatePercentage, 
					detRebate, 
					max(sctInvValByJAN) AS JAN, 
					max(sctInvValByFEB) AS FEB, 
					max(sctInvValByMAR) AS MAR, 
					max(sctInvValByAPR) AS APR, 
					max(sctInvValByMAY) AS MAY, 
					max(sctInvValByJun) AS JUN, 
					max(sctInvValByJUL) AS JUL, 
					max(sctInvValByAUG) AS AUG, 
					max(sctInvValBySEP) AS SEP, 
					max(sctInvValByOCT) AS OCT, 
					max(sctInvValByNOV) AS NOV, 
					max(sctInvValByDEC) AS [DEC],
					YEAR(dayDate) AS [year],
					secGroup4ID
			from
			(   
				SELECT DISTINCT pcs.promotionCustomerSelectionID
                    ,pcs.promotionID
                    ,sc.secondaryCustomerID
                    ,sc.customerID
                    ,sc.secCustomerName
                    ,sc.secCustomerClientCode
                    ,sg4.s04SecGroup4Desc
                    ,pdi.detSaleTarget
                    ,pdi.detDisplayRebatePercentage
                    ,pdi.detRebate
                    , CASE WHEN MONTH(st0.dayDate) = 1 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByJAN
					, CASE WHEN MONTH(st0.dayDate) = 2 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByFEB
					, CASE WHEN MONTH(st0.dayDate) = 3 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByMAR
					, CASE WHEN MONTH(st0.dayDate) = 4 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByAPR
					, CASE WHEN MONTH(st0.dayDate) = 5 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByMAY
					, CASE WHEN MONTH(st0.dayDate) = 6 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByJUN
					, CASE WHEN MONTH(st0.dayDate) = 7 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByJUL
					, CASE WHEN MONTH(st0.dayDate) = 8 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByAUG
					, CASE WHEN MONTH(st0.dayDate) = 9 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValBySEP
					, CASE WHEN MONTH(st0.dayDate) = 10 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByOCT
					, CASE WHEN MONTH(st0.dayDate) = 11 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByNOV
					, CASE WHEN MONTH(st0.dayDate) = 12 THEN SUM(sctInvValByMonth) ELSE NULL END AS sctInvValByDEC
                    , st0.dayDate
                    ,pcs.secGroup4ID
                FROM dbo.tblSecondaryCustomer AS sc
                INNER JOIN tblPromotionCustomerSelection AS pcs ON sc.secGroup4ID = pcs.secGroup4ID
                INNER JOIN tblSecGroup4 AS sg4 ON sg4.secGroup4ID = pcs.secGroup4ID
                INNER JOIN tblPromotionDetailsIncentive AS pdi ON sc.SecondaryCustomerID = pdi.SecondaryCustomerID
                INNER JOIN tblSecTrans st0 ON st0.secondaryCustomerID = sc.secondaryCustomerID
                INNER JOIN tblPromotion AS pro ON pro.promotionID = pcs.promotionID
                INNER JOIN (
                    SELECT secondaryCustomerID
                            ,YEAR(dayDate) * 100 + MONTH(dayDate) monthdate
                            ,SUM(sctInvVal) sctInvValByMonth 
                    FROM dbo.tblSecTrans 
                    GROUP BY secondaryCustomerID, YEAR(dayDate) * 100 + MONTH(dayDate)) AS st ON st.secondaryCustomerID = sc.secondaryCustomerID
                    WHERE st0.dayDate BETWEEN pro.prmDateStart AND pro.prmDateEnd
                GROUP BY pcs.promotionCustomerSelectionID
						,pcs.promotionID
						,sc.secondaryCustomerID
						,sc.customerID
						,sc.secCustomerName
						,sc.secCustomerClientCode
						,sg4.s04SecGroup4Desc
						,pdi.detSaleTarget
						,pdi.detDisplayRebatePercentage
						,pdi.detRebate
						,pdi.PromotionDetailsIncentiveID
						,st0.dayDate
						,pcs.secGroup4ID
                HAVING pcs.promotionID = @promotionID
                    AND pcs.secGroup4ID IS NOT NULL
			) a
			GROUP BY promotionCustomerSelectionID, 
					promotionID, 
					secondaryCustomerID, 
					customerID, 
					secCustomerName, 
					secCustomerClientCode, 
					s04SecGroup4Desc, 
					detSaleTarget,
					detDisplayRebatePercentage, 
					detRebate,
					YEAR(dayDate),
					secGroup4ID;
        FETCH NEXT FROM cur into @promotionID
        END
    CLOSE cur
END
