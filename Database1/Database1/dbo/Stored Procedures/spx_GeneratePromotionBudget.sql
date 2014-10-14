
CREATE PROCEDURE [dbo].[spx_GeneratePromotionBudget]	
	@PromotionID varchar(250)	,
	@CustomerPromotionList CustomerPromotionList READONLY	
AS
BEGIN		

	SELECT DISTINCT 'HQ' AS DistributorCode,
	CASE WHEN pty.promotionTypeID IN (102007,102025,102026) AND ISNULL(pdi.detValue,0)<>0 THEN
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) + '_' + CAST(pdi.detValue AS VARCHAR(50))
	ELSE
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) 
	END AS PromotionCode,
	'3' AS AssignmentLevel,cus.cusCustomerClientCode AS AssignmentCode,'' AS ParentCode,																											
	CASE WHEN prm.promotionTypeID = 102023 THEN NULL ELSE	
		CASE WHEN pty.promotionTypeID IN (102007,102025,102026) THEN pdi.detValue ELSE
			CASE WHEN ISNULL(tbl.totalGrossSalesPerPromo,0)<>0 THEN
				CAST((fin.finAmount * (pnl.GrossSales / tbl.totalGrossSalesPerPromo)) AS DECIMAL(18,2))-- if it's space buy, mailer, listing fee get from tblpromotiondetailsincentive.detvalue
			ELSE NULL END
		END
	END AS Budget
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm	
	INNER JOIN tblPromotionType AS pty ON pty.promotionTypeId = prm.promotionTypeId
	LEFT JOIN tblPromotionDetailsIncentive pdi ON prm.promotionID = pdi.promotionID
	INNER JOIN tblPromotionDetails prd ON prm.promotionID = prd.PromotionID
	INNER JOIN tblPromotionProductSelection AS prs ON prm.promotionID = prs.promotionId		
	INNER JOIN tblProduct AS prod ON prod.productID=prs.prdProductID AND prod.countryID = prm.countryID
	LEFT JOIN tblPrdGroup21 AS prg ON prg.prdGroup21ID = prod.prdGroup21ID AND prod.countryID = prg.countryID		
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.countryID = prm.countryID AND cus.customerID = vcus.customerID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN (SELECT countryID, promotionID,SUM(finAmount) AS finAmount
		FROM tblPromoFinancial WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))
		GROUP BY countryID, promotionID,finCostTypeID,finSpendType
		HAVING finCostTypeID=1 AND finSpendType = 'Trade spend')
		AS fin ON fin.promotionId = prm.promotionId
	INNER JOIN tbldistributorNames AS dms ON dms.countryID = cus.countryID AND dms.dinCustomerClientCode = cus.cusCustomerClientCode
	INNER JOIN (SELECT promotionID,customerID,sum(GrossSales) as GrossSales
				FROM (
				SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID,GrossSales
				FROM tblInAcrPnL as pnl 
				INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
				INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
				inner join (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID
				WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))) a
				GROUP BY  promotionID,customerID)	
	 AS pnl ON pnl.customerID=vcus.customerID AND pnl.promotionID = prm.promotionID
	INNER JOIN (SELECT promotionID,SUM(GrossSales) AS totalGrossSalesPerPromo 
		FROM (
		SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID,GrossSales
		FROM tblInAcrPnL as pnl 
		INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
		INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
		inner join tblPromotion AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID
		WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
		 ) a
		GROUP BY promotionID) as  tbl on  tbl.promotionID = prm.promotionID
	WHERE prm.countryId = 102 
	ORDER BY CASE WHEN pty.promotionTypeID IN (102007,102025,102026) AND ISNULL(pdi.detValue,0)<>0 THEN
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) + '_' + CAST(pdi.detValue AS VARCHAR(50))
	ELSE
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) 
	END
END

