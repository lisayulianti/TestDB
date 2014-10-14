CREATE PROCEDURE [dbo].[spx_GeneratePromotionRDCNDetail]
	@PromotionID int,
	@CustomerID int
AS
BEGIN

	SELECT DISTINCT prm.promotionID,psec.customerID,fin.finConditionType,
	'I' AS I,'40' AS Postingkey,fin.finGeneralLedgerCodeBSh AS GLAccNo,
	CAST(SUM(sct.sctFOCQtyEA)
		* CASE WHEN sac.sysUomClientCode='EA' THEN sac.sysAmount 
			ELSE sac.sysAmount/prd.prdConversionFactor END
		+ CASE WHEN SUM(sct.sctFOCQtyEA)=0 THEN  SUM(sct.sctPrmVal) ELSE 0
		END AS DECIMAL(18,2)) AS TotalRm, -- the result calculated above should appear here
	'' AS TaxCode,'' AS CostCenter,'' AS [Order],'' AS Assignment,
	fin.finGeneralLedgerCodeBShDesc+'-'+UPPER((CONVERT(CHAR(4), prm.prmDateStart, 100)))+'-'+RIGHT((CONVERT(CHAR(4), prm.prmDateStart, 102)),2) AS ItemText,
	cus.cusCustomerClientCode AS Customer, prd.prdProductClientCode AS Product,'' AS Plant,
	'2000' AS SalesOrg,'0'+CAST(cgr1.c01CusGroup1ClientCode AS varchar(10)) AS DistrCh,'10' AS Division,
	'' AS BillingType,'' AS SalesOrder,'' AS SalesOrderItem,'' AS COOrder,'' AS IndustryKey,'' AS SalesDistrict,
	'' AS SalesOffice,'' AS SalesGroup,'' AS Country,'' AS ProductHierarchy,'' AS PPOrder,'' AS MaterialGroup,
	'' AS CustomerGroup,'' AS SalesEmployee,'' AS CostCenter1,'' AS ProductGroup,'' AS SubGroup,
	'' AS ProductFlavour,'' AS PackagingSize,'' AS ProductSegment,'' AS BrandH
	FROM tblPromotion AS prm 
	INNER JOIN vw_PromoSecCust psec ON psec.customerID = @CustomerID AND 
		prm.countryID = psec.countryID AND prm.promotionID = psec.promotionID and prm.promotionID = @PromotionID
	INNER JOIN tblCustomer AS cus ON cus.customerID = psec.customerID AND cus.countryID = psec.countryID 
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
	INNER JOIN tblPromotionProductSelection AS prs ON prs.promotionID=prm.promotionID 
	INNER JOIN tblProduct AS prd ON prd.productID = prs.prdProductID AND prd.countryID = prm.countryID 
	INNER JOIN tblCusGroup1 AS cgr1 ON cgr1.cusGroup1ID = cus.cusGroup1ID AND cgr1.countryID = cus.countryID
	INNER JOIN tblSecTrans AS sct ON sct.productID=prd.productID AND sct.countryID=prd.countryID
	AND sct.customerID=cus.customerID 
	AND sct.secondaryCustomerID=psec.secondaryCustomerID
	left join dbo.fn_GetSysAmountByPromotionIDAndCustomerID(@PromotionID,0,@customerID) sac on sac.productid IS NULL OR sac.productid = prd.productID
	--INNER JOIN dbo.fn_GetSysAmount() sac 
	--	ON sac.productID=prd.productID AND (sac.customerID is null or (sac.customerID = cus.customerID)) and 
	--	(sac.cusGroup1ID is null or (cus.cusGroup1ID = sac.cusGroup1ID)) and 
	--	(sac.cusGroup4ID is null or (cus.cusGroup4ID = sac.cusGroup4ID)) and 
--		(sac.cusGroup7ID is null or (cus.cusGroup7ID = sac.cusGroup7ID))
	--(SELECT countryID, customerID, productID, sysAmount, cusGroup1ID,cusGroup4ID,cusGroup7ID, validFrom, validTo, Max(combinationID) AS combinationID
	--	FROM tblSystemAccrual 
	--	GROUP BY countryID, customerID, productID, pnlID, sysCurrency, validFrom, validTo, sysAmount, sysUomClientCode, cusGroup1ID,cusGroup4ID,cusGroup7ID
	--	HAVING pnlID=102012 AND sysCurrency='MYR' AND sysUomClientCode='CTN'
	--)
	--AS sac ON sac.productID=prd.productID AND sac.customerID=cus.customerID AND sac.countryID = prm.countryID
	WHERE 
	--prm.promotionID = @PromotionID AND psec.customerID = @CustomerID
	--AND ISNULL(sac.cusGroup1ID,0)=ISNULL(cus.cusGroup1ID,0)
	--AND ISNULL(sac.cusGroup4ID,0)=ISNULL(cus.cusGroup4ID,0)
	--AND ISNULL(sac.cusGroup7ID,0)=ISNULL(cus.cusGroup7ID,0)
	--AND prm.prmDateStart BETWEEN sac.ValidFrom AND sac.ValidTo
	fin.finCostTypeID = 1 AND 
	sct.dayDate BETWEEN prm.prmDateStart AND prm.prmDateEnd
	GROUP BY prm.promotionID,psec.customerID,fin.finConditionType,fin.finGeneralLedgerCodeBSh
	,prd.prdGroup6ID,sac.sysAmount,prd.prdConversionFactor
	,fin.finGeneralLedgerCodeBShDesc,prm.prmDateStart,prm.prmDateStart
	,cus.cusCustomerClientCode, prd.prdProductClientCode,cgr1.c01CusGroup1ClientCode,sysAmount, sysUomClientCode
	ORDER BY prm.promotionID,psec.customerID

	--SELECT DISTINCT prm.promotionID,psec.customerID,fin.finConditionType,
	--'I' AS I,'40' AS Postingkey,fin.finGeneralLedgerCodeBSh AS GLAccNo,
	--CAST(SUM(sct.sctFOCQtyEA)
	--	* CASE WHEN sac.sysUomClientCode='EA' THEN sac.sysAmount 
	--		ELSE sac.sysAmount/prd.prdConversionFactor END
	--	+ CASE WHEN SUM(sct.sctFOCQtyEA)=0 THEN  SUM(sct.sctPrmVal) ELSE 0
	--	END AS DECIMAL(18,2)) AS TotalRm, -- the result calculated above should appear here
	--'' AS TaxCode,'' AS CostCenter,'' AS [Order],'' AS Assignment,
	--fin.finGeneralLedgerCodeBShDesc+'-'+UPPER((CONVERT(CHAR(4), prm.prmDateStart, 100)))+'-'+RIGHT((CONVERT(CHAR(4), prm.prmDateStart, 102)),2) AS ItemText,
	--cus.cusCustomerClientCode AS Customer, prd.prdProductClientCode AS Product,'' AS Plant,
	--'2000' AS SalesOrg,'0'+CAST(cgr1.c01CusGroup1ClientCode AS varchar(10)) AS DistrCh,'10' AS Division,
	--'' AS BillingType,'' AS SalesOrder,'' AS SalesOrderItem,'' AS COOrder,'' AS IndustryKey,'' AS SalesDistrict,
	--'' AS SalesOffice,'' AS SalesGroup,'' AS Country,'' AS ProductHierarchy,'' AS PPOrder,'' AS MaterialGroup,
	--'' AS CustomerGroup,'' AS SalesEmployee,'' AS CostCenter1,'' AS ProductGroup,'' AS SubGroup,
	--'' AS ProductFlavour,'' AS PackagingSize,'' AS ProductSegment,'' AS BrandH
	--FROM tblPromotion AS prm 
	--INNER JOIN vw_PromoSecCust psec ON prm.countryID = psec.countryID AND prm.promotionID = psec.promotionID
	--INNER JOIN tblCustomer AS cus ON cus.customerID = psec.customerID AND cus.countryID = psec.countryID 
	--INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
	--INNER JOIN tblPromotionProductSelection AS prs ON prs.promotionID=prm.promotionID 
	--INNER JOIN tblProduct AS prd ON prd.productID = prs.prdProductID AND prd.countryID = prm.countryID 
	--INNER JOIN tblCusGroup1 AS cgr1 ON cgr1.cusGroup1ID = cus.cusGroup1ID AND cgr1.countryID = cus.countryID
	--INNER JOIN tblSecTrans AS sct ON sct.productID=prd.productID AND sct.countryID=prd.countryID
	--AND sct.customerID=cus.customerID 
	--AND sct.secondaryCustomerID=psec.secondaryCustomerID
	--INNER JOIN dbo.fn_GetSysAmount() sac 
	--	ON sac.productID=prd.productID AND (sac.customerID is null or (sac.customerID = cus.customerID)) and 
	--	(sac.cusGroup1ID is null or (cus.cusGroup1ID = sac.cusGroup1ID)) and 
	--	(sac.cusGroup4ID is null or (cus.cusGroup4ID = sac.cusGroup4ID)) and 
	--	(sac.cusGroup7ID is null or (cus.cusGroup7ID = sac.cusGroup7ID))
	----(SELECT countryID, customerID, productID, sysAmount, cusGroup1ID,cusGroup4ID,cusGroup7ID, validFrom, validTo, Max(combinationID) AS combinationID
	----	FROM tblSystemAccrual 
	----	GROUP BY countryID, customerID, productID, pnlID, sysCurrency, validFrom, validTo, sysAmount, sysUomClientCode, cusGroup1ID,cusGroup4ID,cusGroup7ID
	----	HAVING pnlID=102012 AND sysCurrency='MYR' AND sysUomClientCode='CTN'
	----)
	----AS sac ON sac.productID=prd.productID AND sac.customerID=cus.customerID AND sac.countryID = prm.countryID
	--WHERE prm.promotionID = @PromotionID AND psec.customerID = @CustomerID
	--AND ISNULL(sac.cusGroup1ID,0)=ISNULL(cus.cusGroup1ID,0)
	--AND ISNULL(sac.cusGroup4ID,0)=ISNULL(cus.cusGroup4ID,0)
	--AND ISNULL(sac.cusGroup7ID,0)=ISNULL(cus.cusGroup7ID,0)
	--AND prm.prmDateStart BETWEEN sac.ValidFrom AND sac.ValidTo
	--AND sct.dayDate BETWEEN prm.prmDateStart AND prm.prmDateEnd
	--GROUP BY prm.promotionID,psec.customerID,fin.finConditionType,fin.finGeneralLedgerCodeBSh
	--,prd.prdGroup6ID,sac.sysAmount,prd.prdConversionFactor
	--,fin.finGeneralLedgerCodeBShDesc,prm.prmDateStart,prm.prmDateStart
	--,cus.cusCustomerClientCode, prd.prdProductClientCode,cgr1.c01CusGroup1ClientCode,sysAmount, sysUomClientCode
	--ORDER BY prm.promotionID,psec.customerID
END



