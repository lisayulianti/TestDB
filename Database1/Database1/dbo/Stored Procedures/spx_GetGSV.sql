CREATE PROCEDURE [dbo].[spx_GetGSV]
	@PromotionID int, 
	@PrdGroupCol varchar(50), 
	@PrdGroupID int
AS
BEGIN

SELECT (SUM(prt.prtGrossQuantityEa) + SUM(prt.prtGrossQuantityCtn)*prd.prdConversionFactor)*
	CASE WHEN sys0.sysUomClientCode='EA' THEN sys0.sysAmount ELSE (sys0.sysAmount/prd.prdConversionFactor) END 
FROM tblPriTrans prt
INNER JOIN tblPromotionProductSelection pprd ON pprd.promotionID = @PromotionID AND pprd.prdProductID = prt.productID
INNER JOIN tblProduct prd ON pprd.prdProductID = prd.productID
INNER JOIN vw_PromoCust pcus ON pcus.promotionID = @PromotionID AND prt.customerID = pcus.customerID
INNER JOIN tblCustomer cus ON pcus.countryID = cus.countryID AND pcus.customerID = cus.customerID
INNER JOIN (SELECT sys.* 
FROm tblSystemAccrual sys
INNER JOIN tblCustomer cus ON (sys.customerID IS NULL OR sys.customerID=cus.customerID)
	AND (sys.cusGroup1ID IS NULL OR sys.cusGroup1ID=cus.cusGroup1ID)
	AND (sys.cusGroup4ID IS NULL OR sys.cusGroup4ID=cus.cusGroup4ID)
	AND (sys.cusGroup7ID IS NULL OR sys.cusGroup7ID=cus.cusGroup7ID)
INNER JOIN tblSetCombination com ON sys.combinationID = com.combinationID
INNER JOIN (SELECT sys.countryID,sys.productID,sys.customerID,sys.cusGroup1ID,sys.cusGroup4ID,sys.cusGroup7ID,MIN(com.comPriority) comPriority
			FROM tblSystemAccrual sys
			INNER JOIN tblSetCombination com ON sys.countryID=com.countryID AND sys.combinationID=com.combinationID
			GROUP BY sys.countryID,sys.productID,sys.customerID,sys.cusGroup1ID,sys.cusGroup4ID,sys.cusGroup7ID) syscom 
	ON sys.countryID=syscom.countryID AND ISNULL(sys.customerID,0)=ISNULL(syscom.customerID,0) AND sys.productID=syscom.productID
	 AND ISNULL(sys.cusGroup1ID,0)=ISNULL(syscom.cusGroup1ID,0) AND ISNULL(sys.cusGroup4ID,0)=ISNULL(syscom.cusGroup4ID,0) AND ISNULL(sys.cusGroup7ID,0)=ISNULL(syscom.cusGroup7ID,0)
	  AND syscom.comPriority = com.comPriority
WHERE GETDATE() BETWEEN sys.validFrom AND sys.validTo
	AND sys.pnlID=102012
	AND sys.sysCurrency='MYR') sys0  ON prd.productID = sys0.productID
GROUP BY prt.dayDate,prd.productID,
prd.prdGroup1ID,prd.prdGroup2ID,prd.prdGroup3ID,prd.prdGroup4ID,prd.prdGroup5ID,prd.prdGroup6ID,prd.prdGroup7ID,prd.prdGroup8ID,prd.prdGroup9ID,prd.prdGroup10ID,
prd.prdGroup11ID,prd.prdGroup12ID,prd.prdGroup13ID,prd.prdGroup14ID,prd.prdGroup15ID,prd.prdGroup16ID,prd.prdGroup17ID,prd.prdGroup18ID,prd.prdGroup19ID,prd.prdGroup20ID,
prd.prdGroup21ID,prd.prdGroup22ID,prd.prdConversionFactor, sys0.sysUomClientCode, sys0.sysAmount,sys0.customerID,cus.customerID,
sys0.cusGroup1ID,cus.cusGroup1ID,sys0.cusGroup4ID,cus.cusGroup4ID,sys0.cusGroup7ID,cus.cusGroup7ID
HAVING prt.dayDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETDATE()) AS VARCHAR(10)) +'/1/' + CAST(YEAR(GETDATE()) AS VARCHAR(10)) AS DATETIME))
		AND DATEADD(DAY,-1,DATEADD(MONTH,-1,CAST(CAST(MONTH(GETDATE()) AS VARCHAR(10)) +'/1/' + CAST(YEAR(GETDATE()) AS VARCHAR(10)) AS DATETIME)))
	AND (sys0.customerID IS NULL OR sys0.customerID=cus.customerID)
	AND (sys0.cusGroup1ID IS NULL OR sys0.cusGroup1ID=cus.cusGroup1ID)
	AND (sys0.cusGroup4ID IS NULL OR sys0.cusGroup4ID=cus.cusGroup4ID)
	AND (sys0.cusGroup7ID IS NULL OR sys0.cusGroup7ID=cus.cusGroup7ID)
	AND ((@PrdGroupCol='productID' AND prd.productID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup1ID' AND prd.prdGroup1ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup2ID' AND prd.prdGroup2ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup3ID' AND prd.prdGroup3ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup4ID' AND prd.prdGroup4ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup5ID' AND prd.prdGroup5ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup6ID' AND prd.prdGroup6ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup7ID' AND prd.prdGroup7ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup8ID' AND prd.prdGroup8ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup9ID' AND prd.prdGroup9ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup10ID' AND prd.prdGroup10ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup11ID' AND prd.prdGroup11ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup12ID' AND prd.prdGroup12ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup13ID' AND prd.prdGroup13ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup14ID' AND prd.prdGroup14ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup15ID' AND prd.prdGroup15ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup16ID' AND prd.prdGroup16ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup17ID' AND prd.prdGroup17ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup18ID' AND prd.prdGroup18ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup19ID' AND prd.prdGroup19ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup20ID' AND prd.prdGroup20ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup21ID' AND prd.prdGroup21ID = @PrdGroupID)
		OR (@PrdGroupCol='prdGroup22ID' AND prd.prdGroup22ID = @PrdGroupID)
	)
END



