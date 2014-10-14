

CREATE PROCEDURE [dbo].[spx_GeneratePromotionHeader]
	@PromotionID varchar(250) = '0',
	@CustomerPromotionList CustomerPromotionList READONLY
 AS

 BEGIN

	SELECT DISTINCT 'HQ' AS DistributorCode, 
	CASE WHEN pty.promotionTypeID IN (102007,102025,102026) AND ISNULL(pdi.detValue,0)<>0 THEN
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) + '_' + CAST(pdi.detValue AS VARCHAR(50))
	ELSE
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) 
	END AS PromotionCode,
	CAST(prm.prmPromotionDescription AS varchar(MAX)) AS prmPromotionDescription,'A' AS PromotionStatus,
	CONVERT(VARCHAR(100),prmDateStart,111) AS StartDate,
	CASE WHEN pty.ptyDMSCode = 'S' THEN CONVERT(VARCHAR(100),prmDateStart,111) ELSE CONVERT(VARCHAR(100),prmDateEnd,111) END AS EndDate
	,'1' AS ClaimableInd,
	CONVERT(VARCHAR(100),DATEADD(DAY,setExtClaimDays,prm.prmDateEnd),111) AS ClaimEndDay,
	jgen.jgHeader AS TplanNumber, pty.ptyDMSCode AS [Type], 
	CASE WHEN pty.ptyDMSCode = 'S' THEN '' ELSE 
		ISNULL(prm.prmPromotionCategory,'') END AS PromotionCategory,
	CASE WHEN pty.ptyDMSCode = 'S' THEN ds.setSpaceBuyType ELSE NULL END AS SpaceBuyType,	
	CASE WHEN prm.promotionTypeID = 102023 THEN NULL ELSE
		CASE WHEN pty.promotionTypeID IN (102007,102025,102026) THEN pdi.detValue ELSE
			CASE WHEN ISNULL(tbl.totalGrossSalesPerPromo,0)<>0 THEN
				CAST((fin.finAmount * (pnl.GrossSales / tbl.totalGrossSalesPerPromo)) AS DECIMAL(18,2)) 
			ELSE NULL END
		END
	END AS Budget,	
	'' AS ReferenceNumber,
	CASE WHEN pty.ptyDMSCode = 'S' THEN '' ELSE
		CASE WHEN prm.prmUnitID = 102000006 THEN 'A' ELSE 'Q' END
	END AS DetailType ,	
	CASE WHEN pty.ptyDMSCode = 'S' THEN '' ELSE
		CASE WHEN prm.prmUnitID = 102000002 THEN 'CTN' ELSE 
			CASE WHEN prm.prmUnitID = 102000003 THEN 'EA' ELSE '' END
		END 
	END AS TotalBuyUOMCode ,
	CASE WHEN prm.promotionTypeID = 102019 OR prm.promotionTypeID = 102022 THEN 'ZZLP' ELSE
		CASE WHEN fin.finBuildingBLockID = 102024 THEN 'ZLF2' ELSE
			CASE WHEN fin.finBuildingBLockID = 102003 THEN 'ZMF1' ELSE
				CASE WHEN fin.finBuildingBLockID = 102004 THEN 'ZNSF' END
			END
		END
	END AS ClaimType,	
	'N' AS TaxableInd,'0' AS AutoChecked,
	CASE WHEN pty.ptyDMSCode = 'S' THEN CONVERT(VARCHAR(100),prm.prmDateEnd,111) ELSE NULL END AS SpacebuyEndDate
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionProductSelection prd ON prm.promotionID = prd.promotionId
	INNER JOIN 
		(SELECT countryID, promotionID,SUM(finAmount) AS finAmount,finBuildingBLockID
		FROM tblPromoFinancial
		GROUP BY countryID, promotionID,finCostTypeID,finSpendType,finBuildingBLockID
		HAVING finCostTypeID=1 AND finSpendType = 'Trade spend')
		AS fin ON fin.promotionId = prm.promotionId
	INNER JOIN tblPromotionType AS pty ON pty.promotionTypeId = prm.promotionTypeId
	LEFT JOIN tblPromotionDetailsIncentive pdi ON prm.promotionID = pdi.promotionID
	INNER JOIN tblDMSsettings AS ds ON ds.countryId = prm.countryId
	INNER JOIN tblProduct AS prod ON prod.productID =  prd.prdProductID AND prod.countryID=prm.countryID
	LEFT JOIN tblPrdGroup21 AS prg ON prg.prdGroup21ID = prod.prdGroup21ID AND prod.countryID=prg.countryID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.promotionID = prm.promotionID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=cusprm.promotionID AND vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.customerID = cusprm.customerID AND cus.countryID = prm.countryID 
	INNER JOIN tbldistributorNames AS dms ON dms.dinCustomerClientCode = cus.cusCustomerClientCode AND dms.countryID = cus.countryID
	INNER JOIN tblPromotionDetails AS pd ON pd.PromotionID = prm.promotionID
	LEFT JOIN tblAccrualGeneration AS jgen ON jgen.promotionID = prm.promotionID	
	INNER JOIN (SELECT promotionID,customerID,sum(GrossSales) as GrossSales
				FROM (
				SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID,GrossSales
				FROM tblInAcrPnL as pnl 
				INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
				INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
				inner join tblPromotion AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID AND prm.countryID = pnl.countryID
				WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME))) 
				AND prm.PromotionID IN (SELECT promotionID FROm @CustomerPromotionList) ) a
				GROUP BY  promotionID,customerID)	
	 AS pnl ON pnl.customerID=vcus.customerID AND pnl.promotionID = prm.promotionID
	INNER JOIN (SELECT promotionID,SUM(GrossSales) AS totalGrossSalesPerPromo 
		FROM (
		SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID,GrossSales
		FROM tblInAcrPnL as pnl 
		INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
		INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
		inner join tblPromotion AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID AND prm.countryID = pnl.countryID
		WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
		 ) a
		GROUP BY promotionID) as  tbl on  tbl.promotionID = prm.promotionID
	WHERE prm.countryId=102
	ORDER BY CASE WHEN pty.promotionTypeID IN (102007,102025,102026) AND ISNULL(pdi.detValue,0)<>0 THEN
				ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) + '_' + CAST(pdi.detValue AS VARCHAR(50))
			ELSE
				ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) 
			END
END

