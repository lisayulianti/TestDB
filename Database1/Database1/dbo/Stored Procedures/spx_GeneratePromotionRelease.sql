
CREATE procedure [dbo].[spx_GeneratePromotionRelease]
	@PromoIds varchar(max)='0',
	@CustomerPromotionList CustomerPromotionList READONLY
As 
BEGIN	
	declare @hldPromoIds as table(promoid int)
	insert into @hldPromoIds  select * from dbo.fn_split(@PromoIds,',')

	select DISTINCT col1, col2, finGeneralLedgerCode, finGeneralLedgerCodeDesc,
	SUM(col3) as col3,
	col4, col5, col6, col7, col8, col9,col10, CustomerClientCode, prdProductClientCode, prmPromotionClientCode ,
	col12, col13, col14, promotionID, combinationLedgerCode , pnlID,finSpendType,prodHierarchy
	from 
	  (
	  SELECT
	'I' as col1,
	'50' as col2,
	fin.finGeneralLedgerCode,
	fin.finGeneralLedgerCodeDesc,
	CASE WHEN actw.acwAmount IS NULL 
			THEN rtb.rtbAmount - isnull(act.actAmount ,0)
			ELSE rtb.rtbAmount - isnull(actw.acwAmount,0)*(rtb.rtbAmount/tbl.totalAccrual) 
	END AS col3,
	'' as col4,
	'' as col5,
	'' as col6,
	'' as col7,
	'' as col8,
	'' as col9,
	'REL' + '_' + ISNULL(pg9Abbr.jtaAbbreviation,'') + '_' + ISNULL(glAbbr.jtaAbbreviation,'') + '_' + ISNULL(cg5Abbr.jtaAbbreviation,'') + '_' + ISNULL(cg6Abbr.jtaAbbreviation,'') 
		 + '_' + ISNULL(ccAbbr.jtaAbbreviation,'') + '_' + ISNULL(scAbbr.jtaAbbreviation,'') + '_' + LEFT(UPPER(DATENAME(month, GETDATE())),2)+RIGHT(YEAR(GETDATE()),2) as col10, -- [TEXT]
	CAST(CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END AS VARCHAR(50)) AS CustomerClientCode,
	CAST(prd.prdProductClientCode AS VARCHAR(50)) AS prdProductClientCode,
	prm.prmPromotionClientCode ,
	'2000' as col12,
	SUBSTRING(CAST(cus.cusGroup1ID AS VARCHAR(50)),8,LEN(cus.cusGroup1ID))  as col13,
	'10' as col14,
	prm.promotionID,
	cast(fin.finGeneralLedgerCodeBSh as varchar) + cast(fin.finGeneralLedgerCode as varchar)  as combinationLedgerCode
	,fin.pnlID,fin.finSpendType
	,CASE WHEN fin.finSpendType='A&P' THEN pg11.p11PrdGroup11ClientCode + pg12.p12PrdGroup12ClientCode + pg13.p13PrdGroup13ClientCode ELSE '' END AS prodHierarchy
	FROM (SELECT * FROM tblPromotion WHERE PromotionID IN (select * from @hldPromoIds)) AS prm
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.PromotionID
	INNER JOIN tblAccrualGeneration jg ON jg.promotionID=prm.PromotionID AND fin.finGeneralLedgerCode = jg.jgGeneralLedgerCode
	INNER JOIN tblClaimNoteGeneration AS cn ON cn.promotionID = prm.promotionID AND cn.promotionID=jg.promotionID AND fin.finGeneralLedgerCodeBSh = cn.cnGeneralLedgerCodeBSh
	INNER JOIN (SELECT countryID ,pnlID,rtbHeader,customerID ,productID,SUM(rtbAmount) rtbAmount
				FROM ( SELECT DISTINCT countryID ,pnlID
					  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(rtbHeader,'E1',''),'E2',''),'E3',''),'E4',''),'E5','') rtbHeader
					  ,customerID ,productID ,rtbAmount
					  FROM tblRecTypeB
					  WHERE rtbHeader<>''
				) a GROUP BY countryID ,pnlID,rtbHeader,customerID ,productID) AS rtb ON rtb.rtbHeader=prm.prmPromotionClientCode AND rtb.customerID = jg.customerID
	INNER JOIN tblPromotionPnLMapping ppm ON rtb.pnlID = ppm.pnlID AND ppm.finGeneralLedgerCode = jg.jgGeneralLedgerCode
	LEFT JOIN (SELECT a.*,c.finGeneralLedgerCodeBSh FROM tblActual a
		INNER JOIN tblSetPnL b ON a.pnlID = b.pnlID
		INNER JOIN tblPromotionPnLMapping c ON c.finConditionType = b.pnlPnlActCond
		WHERE isnull(actHeader,'') <> '' AND isnull(finGeneralLedgerCodeBSh, '') <> '' AND productID is not NULL)
		AS act ON 
			act.actHeader is NULL OR
			(act.actHeader=prm.prmPromotionClientCode AND act.customerID=jg.customerID AND act.finGeneralLedgerCodeBSh = cn.cnGeneralLedgerCodeBSh AND rtb.productID = act.productID)
	LEFT JOIN (SELECT a.*,c.finGeneralLedgerCodeBSh FROM tblActualtwo a 
		INNER JOIN tblSetPnL b ON a.pnlID = b.pnlID
		INNER JOIN tblPromotionPnLMapping c ON c.finConditionType = b.pnlPnlAcrCond
		WHERE isnull(acwHeader, '') <> '')
		AS actw ON 
			actw.acwHeader is null OR
			(actw.acwHeader=cn.cnPromotionClientCode AND actw.finGeneralLedgerCodeBSh = cn.cnGeneralLedgerCodeBSh)
	INNER JOIN tblPromotionCustomer vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	LEFT JOIN (SELECT promotionID,secGroup2ID FROM tblPromotionCustomerSelection WHERE secGroup2ID IS NOT NULL) AS pcus on prm.promotionID = pcus.promotionID 
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	INNER JOIN tblPromotionProductSelection AS prod ON prod.promotionID=prm.promotionID
	INNER JOIN tblProduct AS prd ON prd.productID = prod.prdProductID AND prd.productID = rtb.productID
	INNER JOIN tblPrdGroup11 AS pg11 ON prd.countryID = pg11.countryID AND prd.prdGroup11ID = pg11.prdGroup11ID
	INNER JOIN tblPrdGroup12 AS pg12 ON prd.countryID = pg12.countryID AND prd.prdGroup11ID = pg12.prdGroup12ID
	INNER JOIN tblPrdGroup13 AS pg13 ON prd.countryID = pg13.countryID AND prd.prdGroup11ID = pg13.prdGroup13ID
	INNER JOIN (SELECT rtbHeader,SUM(rtbAmount) totalAccrual FROM tblRecTypeB GROUP BY rtbHeader) tbl ON tbl.rtbHeader = prm.prmPromotionClientCode AND rtb.customerID = cus.customerID
	LEFT JOIN tblJournalTextAbbr pg9Abbr ON pg9Abbr.countryID = prm.countryID AND pg9Abbr.jtaTableName = 'prdGroup9' AND pg9Abbr.jtaLookupID='prdGroup9ID' AND pg9Abbr.jtaLookupIDValue = prd.prdGroup9ID
	LEFT JOIN tblJournalTextAbbr glAbbr ON glAbbr.countryID = prm.countryID AND glAbbr.jtaTableName = 'tblPromoFinancial' AND glAbbr.jtaLookupID='finGeneralLedgerCode' AND glAbbr.jtaLookupIDValue = fin.finGeneralLedgerCode
	LEFT JOIN tblJournalTextAbbr cg5Abbr ON cg5Abbr.countryID = prm.countryID AND cg5Abbr.jtaTableName = 'tblCustomer' AND cg5Abbr.jtaLookupID='cusGroup5ID' AND cg5Abbr.jtaLookupIDValue = cus.cusGroup5ID
	LEFT JOIN tblJournalTextAbbr cg6Abbr ON cg6Abbr.countryID = prm.countryID AND cg6Abbr.jtaTableName = 'tblCustomer' AND cg6Abbr.jtaLookupID='cusGroup6ID' AND cg6Abbr.jtaLookupIDValue = cus.cusGroup6ID
	LEFT JOIN tblJournalTextAbbr ccAbbr ON ccAbbr.countryID = prm.countryID AND ccAbbr.jtaTableName = 'tblCustomer' AND ccAbbr.jtaLookupID='cusCustomerclientCode' AND ccAbbr.jtaLookupIDValue = CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcc.jccCusCustomerClientCode AS VARCHAR(50)) ELSE CAST(cus.cusCustomerClientCode AS VARCHAR(50)) END
	LEFT JOIN tblJournalTextAbbr scAbbr ON scAbbr.countryID = prm.countryID AND scAbbr.jtaTableName = 'tblSecGroup2ID' AND scAbbr.jtaLookupID='secGroup2ID' AND scAbbr.jtaLookupIDValue = pcus.secGroup2ID
	WHERE prm.[countryID]=102

	UNION

	SELECT
	'I' as col1,
	'40' as col2,
	case when (fin.finSpendType='Trade spend') then fin.finGeneralLedgerCodeBSh else  fin.finGeneralLedgerCode end as finGeneralLedgerCode,
	case when(fin.finSpendType='Trade spend') then fin.finGeneralLedgerCodeBShDesc else fin.finGeneralLedgerCodeDesc end as finGeneralLedgerCodeDesc,
	rtb.rtbAmount - ISNULL(actw.acwAmount,isnull(act.actAmount,0)) AS col3,
	'' as col4,
	'' as col5,
	'' as col6,
	'' as col7,
	'' as col8,
	'' as col9,
	'REL' + '_' + ISNULL(pg9Abbr.jtaAbbreviation,'') + '_' + ISNULL(glAbbr.jtaAbbreviation,'') + '_' + ISNULL(cg5Abbr.jtaAbbreviation,'') + '_' + ISNULL(cg6Abbr.jtaAbbreviation,'') 
		 + '_' + ISNULL(ccAbbr.jtaAbbreviation,'') + '_' + ISNULL(scAbbr.jtaAbbreviation,'') + '_' + LEFT(UPPER(DATENAME(month, GETDATE())),2)+RIGHT(YEAR(GETDATE()),2) as col10, -- [TEXT]
	--CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END AS CustomerClientCode,
	'' AS CustomerClientCode,
	'' as prdProductClientCode,
	prm.prmPromotionClientCode ,
	'2000' as col12,
	SUBSTRING(CAST(cus.cusGroup1ID AS VARCHAR(50)),8,LEN(cus.cusGroup1ID))  as col13,
	'10' as col14,
	prm.promotionID , 
	cast(fin.finGeneralLedgerCodeBSh as varchar) + cast(fin.finGeneralLedgerCode as varchar) as combinationLedgerCode
	,fin.pnlID,fin.finSpendType
	,CASE WHEN fin.finSpendType='A&P' THEN pg11.p11PrdGroup11ClientCode + pg12.p12PrdGroup12ClientCode + pg13.p13PrdGroup13ClientCode ELSE '' END AS prodHierarchy
	from (SELECT * FROM tblPromotion WHERE PromotionID IN (select * from @hldPromoIds)) AS prm
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.PromotionID
	INNER JOIN tblAccrualGeneration jg ON jg.promotionID=prm.PromotionID AND fin.finGeneralLedgerCode = jg.jgGeneralLedgerCode
	INNER JOIN tblClaimNoteGeneration AS cn ON cn.promotionID = prm.promotionID AND cn.promotionID=jg.promotionID AND fin.finGeneralLedgerCodeBSh = cn.cnGeneralLedgerCodeBSh
	INNER JOIN (SELECT countryID ,pnlID,rtbHeader,customerID ,productID,SUM(rtbAmount) rtbAmount
				FROM ( SELECT DISTINCT countryID ,pnlID
					  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(rtbHeader,'E1',''),'E2',''),'E3',''),'E4',''),'E5','') rtbHeader
					  ,customerID ,productID ,rtbAmount
					  FROM tblRecTypeB
					  WHERE rtbHeader<>''
				) a GROUP BY countryID ,pnlID,rtbHeader,customerID ,productID) AS rtb ON rtb.rtbHeader=prm.prmPromotionClientCode AND rtb.customerID = jg.customerID
	INNER JOIN tblPromotionPnLMapping ppm ON rtb.pnlID = ppm.pnlID AND ppm.finGeneralLedgerCode = jg.jgGeneralLedgerCode
	LEFT JOIN (SELECT a.*,c.finGeneralLedgerCodeBSh FROM tblActual a
		INNER JOIN tblSetPnL b ON a.pnlID = b.pnlID
		INNER JOIN tblPromotionPnLMapping c ON c.finConditionType = b.pnlPnlActCond
		WHERE isnull(actHeader,'') <> '' AND isnull(finGeneralLedgerCodeBSh, '') <> '' AND productID is not NULL)
		AS act ON 
		act.actHeader is NULL OR
		(act.actHeader=prm.prmPromotionClientCode AND act.customerID=jg.customerID AND act.finGeneralLedgerCodeBSh = cn.cnGeneralLedgerCodeBSh AND rtb.productID = act.productID)
	LEFT JOIN (SELECT a.*,c.finGeneralLedgerCodeBSh FROM tblActualtwo a 
		INNER JOIN tblSetPnL b ON a.pnlID = b.pnlID
		INNER JOIN tblPromotionPnLMapping c ON c.finConditionType = b.pnlPnlAcrCond
		WHERE isnull(acwHeader, '') <> '')
		AS actw ON 
		actw.acwHeader is null OR
		(actw.acwHeader=cn.cnPromotionClientCode AND actw.finGeneralLedgerCodeBSh = cn.cnGeneralLedgerCodeBSh)
	INNER JOIN tblPromotionCustomer vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	LEFT JOIN (SELECT promotionID,secGroup2ID FROM tblPromotionCustomerSelection WHERE secGroup2ID IS NOT NULL) AS pcus on prm.promotionID = pcus.promotionID 
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	INNER JOIN tblPromotionProductSelection AS prod ON prod.promotionID=prm.promotionID
	INNER JOIN tblProduct AS prd ON prd.productID = prod.prdProductID AND prd.productID = rtb.productID
	INNER JOIN tblPrdGroup11 AS pg11 ON prd.countryID = pg11.countryID AND prd.prdGroup11ID = pg11.prdGroup11ID
	INNER JOIN tblPrdGroup12 AS pg12 ON prd.countryID = pg12.countryID AND prd.prdGroup11ID = pg12.prdGroup12ID
	INNER JOIN tblPrdGroup13 AS pg13 ON prd.countryID = pg13.countryID AND prd.prdGroup11ID = pg13.prdGroup13ID
	INNER JOIN (SELECT rtbHeader,SUM(rtbAmount) totalAccrual FROM tblRecTypeB GROUP BY rtbHeader) tbl ON tbl.rtbHeader = prm.prmPromotionClientCode AND rtb.customerID = cus.customerID
	LEFT JOIN tblJournalTextAbbr pg9Abbr ON pg9Abbr.countryID = prm.countryID AND pg9Abbr.jtaTableName = 'prdGroup9' AND pg9Abbr.jtaLookupID='prdGroup9ID' AND pg9Abbr.jtaLookupIDValue = prd.prdGroup9ID
	LEFT JOIN tblJournalTextAbbr glAbbr ON glAbbr.countryID = prm.countryID AND glAbbr.jtaTableName = 'tblPromoFinancial' AND glAbbr.jtaLookupID='finGeneralLedgerCode' AND glAbbr.jtaLookupIDValue = fin.finGeneralLedgerCode
	LEFT JOIN tblJournalTextAbbr cg5Abbr ON cg5Abbr.countryID = prm.countryID AND cg5Abbr.jtaTableName = 'tblCustomer' AND cg5Abbr.jtaLookupID='cusGroup5ID' AND cg5Abbr.jtaLookupIDValue = cus.cusGroup5ID
	LEFT JOIN tblJournalTextAbbr cg6Abbr ON cg6Abbr.countryID = prm.countryID AND cg6Abbr.jtaTableName = 'tblCustomer' AND cg6Abbr.jtaLookupID='cusGroup6ID' AND cg6Abbr.jtaLookupIDValue = cus.cusGroup6ID
	LEFT JOIN tblJournalTextAbbr ccAbbr ON ccAbbr.countryID = prm.countryID AND ccAbbr.jtaTableName = 'tblCustomer' AND ccAbbr.jtaLookupID='cusCustomerclientCode' AND ccAbbr.jtaLookupIDValue = CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN CAST(jcc.jccCusCustomerClientCode AS VARCHAR(50)) ELSE CAST(cus.cusCustomerClientCode AS VARCHAR(50)) END
	LEFT JOIN tblJournalTextAbbr scAbbr ON scAbbr.countryID = prm.countryID AND scAbbr.jtaTableName = 'tblSecGroup2ID' AND scAbbr.jtaLookupID='secGroup2ID' AND scAbbr.jtaLookupIDValue = pcus.secGroup2ID
	WHERE prm.[countryID]=102) as rel 
	GROUP BY col1, col2,  finGeneralLedgerCode, finGeneralLedgerCodeDesc,
	col4, col5, col6, col7, col8, col9,col10, CustomerClientCode, prdProductClientCode, prmPromotionClientCode ,
	col12, col13, col14, promotionID , combinationLedgerCode , pnlID,finSpendType,prodHierarchy
	ORDER BY promotionID,pnlID,CustomerClientCode,col2	
END



