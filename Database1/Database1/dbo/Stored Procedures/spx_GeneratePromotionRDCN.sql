CREATE PROCEDURE [dbo].[spx_GeneratePromotionRDCN] --10665, 102102553
	@PromotionID int,
	@CustomerID int
AS
BEGIN

	select 
	prmprd.promotionID,prmprd.customerID,prmprd.productID,'DLMI Finance Department' AS [To],
	prmprd.cusCustomerName AS [From],
	CAST(fin.finGeneralLedgerCodeBSh AS varchar(50))+'-'+ISNULL(fin.finGeneralLedgerCodeBShDesc,'') AS Account,
	CONVERT(VARCHAR(50),GETDATE(),101) AS RequestDate,
	prmprd.prmPromotionClientCode+ '_' + CAST(prmprd.cusCustomerClientCode AS VARCHAR(20)) AS RDCNNo,
	prmprd.cusCustomerClientCode AS DistributorSAPCode,
	fin.finConditionType AS Conditiontype,
	prmprd.prmPromotionClientCode,
	prd.prdProductClientCode,
	prd.prdProductName,
	UPPER(CONVERT(CHAR(4), prmprd.prmDateStart, 100))+'-'+RIGHT((CONVERT(CHAR(4), prmprd.prmDateStart, 102)),2) AS PromoMonth,
	'' AS QuantityCtn,
	CASE WHEN prmprd.isFOC=1 THEN SUM(prmprd.sctFOCQtyEA) ELSE 0 END AS Quantity_Unit,
	CAST(CASE WHEN sac.sysUomClientCode='EA' THEN sac.sysAmount ELSE sac.sysAmount/prd.prdConversionFactor END AS DECIMAL(18,2)) AS Unit_Price_RM,
	CASE WHEN prmprd.isFOC=1 THEN CAST(SUM(prmprd.sctFOCQtyEA)
		* CASE WHEN sac.sysUomClientCode='EA' THEN sac.sysAmount 
				ELSE sac.sysAmount/prd.prdConversionFactor
		  END  AS DECIMAL(18,2))
	ELSE CAST(
		  CASE WHEN SUM(prmprd.sctFOCQtyEA)=0 THEN  SUM(prmprd.sctPrmVal) ELSE 0
		END AS DECIMAL(18,2))
	END AS TotalRm
	from
	(
		select prm.promotionID, prmPromotionClientCode, prmDateStart, cus.customerID, 
		cus.cusCustomerClientCode, cus.cusCustomerName,
		sct.productID, sum(sct.sctFOCQtyEA) sctFOCQtyEA, sum(sct.sctPrmVal) sctPrmVal,prmdet.isFOC
		FROM
		tblPromotion AS prm 
		INNER JOIN
		(
			SELECT customerID, secondaryCustomerId FROM vw_PromoSecCust where promotionID = @PromotionID
			UNION 
			SELECT b.customerID, b.secondaryCustomerID FROM 
			(SELECT * FROM tblPromotionCustomer2
			WHERE promotionId = @PromotionID AND customerId NOT IN (SELECT customerId FROM vw_PromoSecCust where promotionId = @PromotionID) ) a
			INNER JOIN tblSecondaryCustomer b ON a.customerId = b.customerID
		) prmcust on prmcust.customerID = @CustomerID and prm.promotionID = @promotionID
		--INNER JOIN tblPromotionSecondaryCustomer vcus ON prm.promotionID = @PromotionID and vcus.promotionID=prm.promotionID 
		--INNER JOIN tblSecondaryCustomer AS sec ON sec.countryID = prm.countryID AND sec.secondaryCustomerID = vcus.secondaryCustomerId
		INNER JOIN tblCustomer AS cus on cus.customerId = @CustomerID and cus.customerID=prmcust.customerID AND cus.countryID=prm.countryID
		INNER JOIN tblPromotionProductSelection AS prs ON prs.promotionID=prm.promotionID 
		INNER JOIN tblSecTrans AS sct ON sct.productID=prs.prdProductID 
			AND sct.customerID=cus.customerID AND sct.secondaryCustomerID=prmcust.secondaryCustomerID
		INNER JOIN (SELECT DISTINCT PromotionID,1 AS isFOC
		  FROM tblPromotionDetails
		  WHERE detFreeUOM IS NOT NULL OR detFreegoodsamount IS NOT NULL
		UNION
		SELECT DISTINCT PromotionID,0 AS isFOC
		  FROM tblPromotionDetails
		  WHERE PromotionID NOT IN (SELECT DISTINCT PromotionID
		  FROM tblPromotionDetails
		  WHERE detFreeUOM IS NOT NULL OR detFreegoodsamount IS NOT NULL)) prmdet ON prm.promotionID = prmdet.PromotionID
		where sct.dayDate BETWEEN prm.prmDateStart AND prm.prmDateEnd
		group by prm.promotionID, prmPromotionClientCode, prmDateStart, cus.customerID, sct.productID,
		cus.cusCustomerClientCode, cus.cusCustomerName,prmdet.isFOC
	) prmprd 
	LEFT join dbo.fn_GetSysAmountByPromotionIDAndCustomerID(@PromotionID,0,@customerID) sac on sac.productid IS NULL OR sac.productid = prmprd.productID
	--INNER JOIN dbo.fn_GetSysAmount() sac 
	--	ON sac.productID=prmprd.productID AND (sac.customerID is null or (sac.customerID = cust.customerID)) and 
	--	(sac.cusGroup1ID is null or (cust.cusGroup1ID = sac.cusGroup1ID)) and 
	--	(sac.cusGroup4ID is null or (cust.cusGroup4ID = sac.cusGroup4ID)) and 
	--	(sac.cusGroup7ID is null or (cust.cusGroup7ID = sac.cusGroup7ID))
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prmprd.promotionID 
	inner join tblProduct prd on prd.productID = prmprd.productID
	WHERE fin.finCostTypeID = 1
	group by prmprd.promotionID, prmprd.customerID, prmprd.productID,
	prmprd.cusCustomerName, fin.finGeneralLedgerCodeBSh, fin.finGeneralLedgerCodeBShDesc,
	prmprd.prmPromotionClientCode, prmprd.cusCustomerClientCode,
	fin.finConditionType, prd.prdConversionFactor, prd.prdProductClientCode,
	prd.prdProductName, prmprd.prmDateStart, sac.sysUomClientCode, sac.sysAmount,prmprd.isFOC

	--SELECT prm.promotionID,vcus.customerID,prd.productID,'DLMI Finance Department' AS [To],
	--cus.cusCustomerName AS [From],
	--CAST(fin.finGeneralLedgerCodeBSh AS varchar(50))+'-'+ISNULL(fin.finGeneralLedgerCodeBShDesc,'') AS Account,
	--CONVERT(VARCHAR(50),GETDATE(),101) AS RequestDate,
	--prm.prmPromotionClientCode+ '_' + CAST(cus.cusCustomerClientCode AS VARCHAR(20)) AS RDCNNo,
	--cus.cusCustomerClientCode AS DistributorSAPCode,
	--fin.finConditionType AS Conditiontype,
	--prm.prmPromotionClientCode,
	--prd.prdProductClientCode,
	--prd.prdProductName,
	--UPPER(CONVERT(CHAR(4), prm.prmDateStart, 100))+'-'+RIGHT((CONVERT(CHAR(4), prm.prmDateStart, 102)),2) AS PromoMonth,
	--'' AS QuantityCtn,
	--SUM(sct.sctFOCQtyEA) AS Quantity_Unit,
	--CAST(CASE WHEN sac.sysUomClientCode='EA' THEN sac.sysAmount ELSE sac.sysAmount/prd.prdConversionFactor END AS DECIMAL(18,2)) AS Unit_Price_RM,
	--CAST(SUM(sct.sctFOCQtyEA)
	--	* CASE WHEN sac.sysUomClientCode='EA' THEN sac.sysAmount 
	--			ELSE sac.sysAmount/prd.prdConversionFactor
	--	  END + 
	--	  CASE WHEN SUM(sct.sctFOCQtyEA)=0 THEN  SUM(sct.sctPrmVal) ELSE 0
	--	END AS DECIMAL(18,2)) AS TotalRm
	--FROM
	--tblPromotion AS prm 
	--INNER JOIN vw_PromoCust vcus ON vcus.promotionID=prm.promotionID
	--INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID AND cus.countryID=vcus.countryID
	--LEFT JOIN tblSecondaryCustomer AS sec ON sec.countryID = vcus.countryID AND sec.customerID = vcus.customerID
	--INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
	--INNER JOIN tblPromotionProductSelection AS prs ON prs.promotionID=prm.promotionID 
	--INNER JOIN tblProduct AS prd ON prd.productID = prs.prdProductID AND prd.countryID = prm.countryID
	--INNER JOIN tblSecTrans AS sct ON sct.productID=prd.productID AND sct.countryID=prd.countryID
	--	AND sct.customerID=cus.customerID AND (sct.secondaryCustomerID is null or sct.secondaryCustomerID=sec.secondaryCustomerID)
	--INNER JOIN dbo.fn_GetSysAmount() sac 
	--	ON sac.productID=prd.productID AND (sac.customerID is null or (sac.customerID = cus.customerID)) and 
	--	(sac.cusGroup1ID is null or (cus.cusGroup1ID = sac.cusGroup1ID)) and 
	--	(sac.cusGroup4ID is null or (cus.cusGroup4ID = sac.cusGroup4ID)) and 
	--	(sac.cusGroup7ID is null or (cus.cusGroup7ID = sac.cusGroup7ID))
	--WHERE prm.promotionID = @PromotionID AND vcus.customerID = @CustomerID
	--AND fin.finCostTypeID = 1
	--AND prm.prmDateStart BETWEEN sac.ValidFrom AND sac.ValidTo
	--AND sct.dayDate BETWEEN prm.prmDateStart AND prm.prmDateEnd
	--GROUP BY prm.promotionID,prm.prmPromotionClientCode,vcus.customerID,cus.cusCustomerClientCode,cus.cusCustomerName,fin.finGeneralLedgerCodeBSh,
	--fin.finGeneralLedgerCodeBShDesc,prd.productID, prd.prdGroup6ID,prd.prdConversionFactor,fin.finConditionType,prd.prdProductClientCode,prd.prdProductName,
	--prm.prmDateStart,prm.prmUnitID,cus.cusCustomerClientCode,sysAmount, sysUomClientCode
	--ORDER BY  cus.cusCustomerClientCode
END



