
CREATE PROCEDURE [dbo].[spx_GeneratePromotionAccrualTopup]	
	@Bookmonth int,
	@Bookyear int,
	@PromoIds varchar(max)='0'
AS
BEGIN	
	declare @Firstday as datetime
	declare @Lastday as datetime
	declare @hldPromoIds as table(promoid int)
	set @Firstday=(DATEADD(month,(@Bookmonth-1),DATEADD(year,@Bookyear-1900,0))) /*First*/
	set @Lastday=(select DATEADD(day,-1,DATEADD(month,@Bookmonth,DATEADD(year,@Bookyear-1900,0))))
	insert into @hldPromoIds  select * from dbo.fn_split(@PromoIds,',')	 

	select DISTINCT * from	(
	SELECT
	prm.prmPromotionClientCode + '_' + UPPER(LEFT(DATENAME(MONTH, CAST('1900-'+CAST(@Bookmonth AS VARCHAR(2))+'-01' AS datetime)),2)) + CAST(RIGHT(@Bookyear,2) AS VARCHAR(2)) prmPromotionBookMonth,
	'I' as col1,
	'40' as col2,
	fin.finGeneralLedgerCode,
	fin.finGeneralLedgerCodeDesc,
	cast(fin.finAmount * (pnl.GrossSales/tbl.totalGrossSalesPerPromo) as DECIMAL(18,2))  as col3,
	'' as col4,
	CASE WHEN fin.finSpendType='A&P' THEN ISNULL(prm.prmCostCenter,'') ELSE '' END as col5,
	'' as col6,
	CASE WHEN fin.finSpendType='A&P' THEN ISNULL(prm.prmIOnumber,'') ELSE '' END as col7,
	CASE WHEN fin.finSpendType='A&P' THEN ISNULL(prm.prmIOnumber,'') ELSE '' END as col8,
	'' as col9,
	'ACR' + '_' + ISNULL(pg9Abbr.jtaAbbreviation,'') + '_' + ISNULL(glAbbr.jtaAbbreviation,'') + '_' + ISNULL(cg5Abbr.jtaAbbreviation,'') + '_' + ISNULL(cg6Abbr.jtaAbbreviation,'') 
		 + '_' + ISNULL(ccAbbr.jtaAbbreviation,'') + '_' + ISNULL(scAbbr.jtaAbbreviation,'') + '_' + UPPER(LEFT(DATENAME(MONTH, CAST('1900-'+CAST(@Bookmonth AS VARCHAR(2))+'-01' AS datetime)),3)) + '_Y' + CAST(RIGHT(@Bookyear,2) AS VARCHAR(2))  as  col10, --[TEXT]
	CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN 
		CASE WHEN ISNULL((SELECT TOP 1 customerID FROM tblPromotionCustomerSelection WHERE promotionID = prm.promotionID),0)>0 THEN CAST(cus.cusCustomerClientCode AS VARCHAR(50))
			ELSE CAST(jcc.jccCusCustomerClientCode AS VARCHAR(50)) END 
	ELSE CAST(cus.cusCustomerClientCode AS VARCHAR(50)) END 
	AS CustomerClientCode,
	CAST(prd.prdProductClientCode AS VARCHAR(50)) AS prdProductClientCode,
	prm.prmPromotionClientCode ,
	'2000' as col12,
	SUBSTRING(CAST(cus.cusGroup1ID AS VARCHAR(50)),8,LEN(cus.cusGroup1ID)) as col13 ,
	'10' as col14,
	prm.promotionID,1 as topup ,
	cast(fin.finGeneralLedgerCodeBSh as varchar) + cast(fin.finGeneralLedgerCode as varchar)  as combinationLedgerCode,fin.pnlID,fin.finSpendType
	,CASE WHEN fin.finSpendType='A&P' THEN pg11.p11PrdGroup11ClientCode + pg12.p12PrdGroup12ClientCode + pg13.p13PrdGroup13ClientCode ELSE '' END AS prodHierarchy
	,pcc.pccCostCentreDesc
	FROM (SELECT * FROM tblPromotion WHERE PromotionID IN (select * from @hldPromoIds)) AS prm
	LEFT JOIN tblPromotionCostCentre pcc ON prm.countryID = pcc.countryID AND prm.prmCostCenter = pcc.pccCostCentre
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.PromotionID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID AND cus.countryID=prm.countryID
	LEFT JOIN (SELECT promotionID,secGroup2ID FROM tblPromotionCustomerSelection WHERE secGroup2ID IS NOT NULL) AS pcus on prm.promotionID = pcus.promotionID 
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.countryID=cus.countryID AND jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	INNER JOIN tblPromotionProductSelection AS prod ON prod.promotionID=prm.promotionID
	INNER JOIN tblProduct AS prd ON prd.productID = prod.prdProductID AND prd.countryID = prm.countryID
	INNER JOIN tblPrdGroup11 AS pg11 ON prd.countryID = pg11.countryID AND prd.prdGroup11ID = pg11.prdGroup11ID
	INNER JOIN tblPrdGroup12 AS pg12 ON prd.countryID = pg12.countryID AND prd.prdGroup11ID = pg12.prdGroup12ID
	INNER JOIN tblPrdGroup13 AS pg13 ON prd.countryID = pg13.countryID AND prd.prdGroup11ID = pg13.prdGroup13ID
	LEFT JOIN tblJournalTextAbbr pg9Abbr ON pg9Abbr.countryID = prm.countryID AND pg9Abbr.jtaTableName = 'prdGroup9' AND pg9Abbr.jtaLookupID='prdGroup9ID' AND pg9Abbr.jtaLookupIDValue = prd.prdGroup9ID
	LEFT JOIN tblJournalTextAbbr glAbbr ON glAbbr.countryID = prm.countryID AND glAbbr.jtaTableName = 'tblPromoFinancial' AND glAbbr.jtaLookupID='finGeneralLedgerCode' AND glAbbr.jtaLookupIDValue = fin.finGeneralLedgerCode
	LEFT JOIN tblJournalTextAbbr cg5Abbr ON cg5Abbr.countryID = prm.countryID AND cg5Abbr.jtaTableName = 'tblCustomer' AND cg5Abbr.jtaLookupID='cusGroup5ID' AND cg5Abbr.jtaLookupIDValue = cus.cusGroup5ID
	LEFT JOIN tblJournalTextAbbr cg6Abbr ON cg6Abbr.countryID = prm.countryID AND cg6Abbr.jtaTableName = 'tblCustomer' AND cg6Abbr.jtaLookupID='cusGroup6ID' AND cg6Abbr.jtaLookupIDValue = cus.cusGroup6ID
	LEFT JOIN tblJournalTextAbbr ccAbbr ON ccAbbr.countryID = prm.countryID AND ccAbbr.jtaTableName = 'tblCustomer' AND ccAbbr.jtaLookupID='cusCustomerclientCode' AND ccAbbr.jtaLookupIDValue = CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcc.jccCusCustomerClientCode AS VARCHAR(50)) ELSE CAST(cus.cusCustomerClientCode AS VARCHAR(50)) END
	LEFT JOIN tblJournalTextAbbr scAbbr ON scAbbr.countryID = prm.countryID AND scAbbr.jtaTableName = 'tblSecGroup2ID' AND scAbbr.jtaLookupID='secGroup2ID' AND scAbbr.jtaLookupIDValue = pcus.secGroup2ID
	INNER JOIN (SELECT promotionID,customerID,prdProductID,sum(GrossSales) as GrossSales
				FROM (
				SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID, prod.prdProductID,GrossSales
				FROM tblInAcrPnL as pnl 				
				INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
				INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
				inner join tblPromotion AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID AND prm.countryID=pnl.countryID
				WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME))) 
				AND prm.PromotionID IN (select * from @hldPromoIds) ) a
				GROUP BY  promotionID,customerID,prdProductID)	
	 AS pnl ON pnl.customerID=vcus.customerID AND pnl.prdProductID=prod.prdProductID
	INNER JOIN (SELECT promotionID,SUM(GrossSales) AS totalGrossSalesPerPromo 
		FROM (
		SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID, prod.prdProductID,GrossSales
		FROM tblInAcrPnL as pnl 
		INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
		INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
		inner join tblPromotion AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID AND prm.countryID=pnl.countryID
		WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
		AND prm.PromotionID IN (select * from @hldPromoIds) ) a
		GROUP BY promotionID) as  tbl on  tbl.promotionID = prm.promotionID
	WHERE prm.[countryID]=102  
	AND fin.finCostTypeID=1 AND prd.productID=prod.prdProductID AND cast(fin.finAmount * (pnl.GrossSales/tbl.totalGrossSalesPerPromo) as DECIMAL(18,2))>0

	UNION

	SELECT
	prm.prmPromotionClientCode + '_' + UPPER(LEFT(DATENAME(MONTH, CAST('1900-'+CAST(@Bookmonth AS VARCHAR(2))+'-01' AS datetime)),2)) + CAST(RIGHT(@Bookyear,2) AS VARCHAR(2)) prmPromotionBookMonth,
	'I' as col1,
	'50' as col2,
	case when (fin.finSpendType='Trade spend') then fin.finGeneralLedgerCodeBSh else  fin.finGeneralLedgerCode end as finGeneralLedgerCode,
	case when(fin.finSpendType='Trade spend') then fin.finGeneralLedgerCodeBShDesc else fin.finGeneralLedgerCodeDesc end as finGeneralLedgerCodeDesc,
	cast(fin.finAmount as DECIMAL(18,2)) as col3,
	'' as col4,
	'' as col5,
	'' as col6,
	'' as col7,
	'' as col8,
	'' as col9,
	'ACR' + '_' + ISNULL(pg9Abbr.jtaAbbreviation,'') + '_' + ISNULL(glAbbr.jtaAbbreviation,'') + '_' + ISNULL(cg5Abbr.jtaAbbreviation,'') + '_' + ISNULL(cg6Abbr.jtaAbbreviation,'') 
		 + '_' + ISNULL(ccAbbr.jtaAbbreviation,'') + '_' + ISNULL(scAbbr.jtaAbbreviation,'') + '_' + UPPER(LEFT(DATENAME(MONTH, CAST('1900-'+CAST(@Bookmonth AS VARCHAR(2))+'-01' AS datetime)),3)) + '_Y' + CAST(RIGHT(@Bookyear,2) AS VARCHAR(2))  as  col10, --[TEXT]
	'' as cusCustomerClientCode,
	'' as prdProductClientCode,
	prm.prmPromotionClientCode ,
	'2000' as col12,
	SUBSTRING(CAST(cus.cusGroup1ID AS VARCHAR(50)),8,LEN(cus.cusGroup1ID)) as col13 ,
	'10' as col14,
	prm.promotionID,1 as topup ,
	cast(fin.finGeneralLedgerCodeBSh as varchar) + cast(fin.finGeneralLedgerCode as varchar) as combinationLedgerCode,fin.pnlID,fin.finSpendType
	,CASE WHEN fin.finSpendType='A&P' THEN pg11.p11PrdGroup11ClientCode + pg12.p12PrdGroup12ClientCode + pg13.p13PrdGroup13ClientCode ELSE '' END AS prodHierarchy
	,pcc.pccCostCentreDesc
	from (SELECT * FROM tblPromotion WHERE PromotionID IN (select * from @hldPromoIds)) AS prm
	LEFT JOIN tblPromotionCostCentre pcc ON prm.countryID = pcc.countryID AND prm.prmCostCenter = pcc.pccCostCentre
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.PromotionID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID AND prm.countryID=cus.countryID
	LEFT JOIN (SELECT promotionID,secGroup2ID FROM tblPromotionCustomerSelection WHERE secGroup2ID IS NOT NULL) AS pcus on prm.promotionID = pcus.promotionID 
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.countryID=cus.countryID AND jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	INNER JOIN tblPromotionProductSelection AS prod ON prod.promotionID=prm.promotionID
	INNER JOIN tblProduct AS prd ON prd.productID = prod.prdProductID AND prd.countryID=prm.countryID
	INNER JOIN tblPrdGroup11 AS pg11 ON prd.countryID = pg11.countryID AND prd.prdGroup11ID = pg11.prdGroup11ID
	INNER JOIN tblPrdGroup12 AS pg12 ON prd.countryID = pg12.countryID AND prd.prdGroup11ID = pg12.prdGroup12ID
	INNER JOIN tblPrdGroup13 AS pg13 ON prd.countryID = pg13.countryID AND prd.prdGroup11ID = pg13.prdGroup13ID
	LEFT JOIN tblJournalTextAbbr pg9Abbr ON pg9Abbr.countryID=prm.countryID AND pg9Abbr.jtaTableName = 'prdGroup9' AND pg9Abbr.jtaLookupID='prdGroup9ID' AND pg9Abbr.jtaLookupIDValue = prd.prdGroup9ID
	LEFT JOIN tblJournalTextAbbr glAbbr ON glAbbr.countryID=prm.countryID AND glAbbr.jtaTableName = 'tblPromoFinancial' AND pg9Abbr.jtaLookupID='finGeneralLedgerCode' AND pg9Abbr.jtaLookupIDValue = fin.finGeneralLedgerCode
	LEFT JOIN tblJournalTextAbbr cg5Abbr ON cg5Abbr.countryID=prm.countryID AND cg5Abbr.jtaTableName = 'tblCustomer' AND cg5Abbr.jtaLookupID='cusGroup5ID' AND cg5Abbr.jtaLookupIDValue = cus.cusGroup5ID
	LEFT JOIN tblJournalTextAbbr cg6Abbr ON cg6Abbr.countryID=prm.countryID AND cg6Abbr.jtaTableName = 'tblCustomer' AND cg6Abbr.jtaLookupID='cusGroup6ID' AND cg6Abbr.jtaLookupIDValue = cus.cusGroup6ID
	LEFT JOIN tblJournalTextAbbr ccAbbr ON ccAbbr.countryID=prm.countryID AND ccAbbr.jtaTableName = 'tblCustomer' AND ccAbbr.jtaLookupID='cusCustomerclientCode' AND ccAbbr.jtaLookupIDValue = CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcc.jccCusCustomerClientCode AS VARCHAR(50)) ELSE CAST(cus.cusCustomerClientCode AS VARCHAR(50)) END
	LEFT JOIN tblJournalTextAbbr scAbbr ON scAbbr.countryID=prm.countryID AND scAbbr.jtaTableName = 'tblSecGroup2ID' AND scAbbr.jtaLookupID='secGroup2ID' AND scAbbr.jtaLookupIDValue = pcus.secGroup2ID
	INNER JOIN (SELECT promotionID,customerID,prdProductID,sum(GrossSales) as GrossSales
				FROM (
				SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID, prod.prdProductID,GrossSales
				FROM tblInAcrPnL as pnl 
				INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
				INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
				inner join tblPromotion AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID AND prm.countryID=pnl.countryID
				WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME))) 
				AND prm.PromotionID IN (select * from @hldPromoIds) ) a
				GROUP BY  promotionID,customerID,prdProductID)	
	 AS pnl ON pnl.customerID=vcus.customerID AND pnl.prdProductID=prod.prdProductID
	INNER JOIN (SELECT promotionID,SUM(GrossSales) AS totalGrossSalesPerPromo 
		FROM (
		SELECT DISTINCT prm.promotionID,pnl.MonthDate, vcus.customerID, prod.prdProductID,GrossSales
		FROM tblInAcrPnL as pnl 
		INNER JOIN tblPromotionCustomer2 vcus ON vcus.customerID=pnl.customerID
		INNER JOIN tblPromotionProductSelection AS prod ON prod.prdProductID=pnl.productID 
		inner join tblPromotion AS prm on vcus.promotionID=prm.promotionID AND prod.promotionID = prm.promotionID AND prm.countryID=pnl.countryID
		WHERE pnl.MonthDate BETWEEN
				YEAR(DATEADD(MONTH,-13,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
				AND
				YEAR(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))*100 + MONTH(DATEADD(MONTH,-1,CAST(prm.PrmdateCreated AS DATETIME)))
		AND prm.PromotionID IN (select * from @hldPromoIds) ) a
		GROUP BY promotionID) as  tbl on  tbl.promotionID = prm.promotionID
	WHERE prm.[countryID]=102 AND fin.FinCostTypeID=1 AND cast(fin.finAmount as DECIMAL(18,2))>0
	AND prd.productID=prod.prdProductID ) as topup order by promotionID,pnlID,CustomerClientCode,col2
END



