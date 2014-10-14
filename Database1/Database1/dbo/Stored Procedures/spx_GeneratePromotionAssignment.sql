
CREATE PROCEDURE [dbo].[spx_GeneratePromotionAssignment]	
	@PromotionID varchar(250),
	@CustomerPromotionList CustomerPromotionList READONLY
AS
BEGIN	

SELECT tbl.DistributorCode,tbl.promotionID,tbl.promotionTypeID,
CASE WHEN pty.promotionTypeID IN (102007,102025,102026) AND ISNULL(pdi.detValue,0)<>0 THEN
	tbl.PromotionCode + '_' + CAST(pdi.detValue AS VARCHAR(50))
ELSE tbl.PromotionCode END AS PromotionCode
,tbl.CustomerHierarchyLevel,tbl.AssignmentCode,tbl.ParentCode
FROM (
	SELECT DISTINCT 'HQ' AS DistributorCode,prm.promotionID,prm.promotionTypeID,
	ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) AS PromotionCode,
	'D' AS AssignmentType,'' AS CustomerHierarchyLevel,
	CAST(cus.cusCustomerClientCode AS varchar(50)) AS AssignmentCode,
	'' AS ParentCode
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionDetails AS prd ON prm.promotionID = prd.promotionID
	INNER JOIN tblPromotionProductSelection AS pps ON prm.promotionID = pps.promotionId
	INNER JOIN tblProduct AS prod ON prod.countryID = prm.countryID AND prod.productID = pps.prdProductID
	LEFT JOIN tblPrdGroup21 AS prg ON prg.countryID = prod.countryID AND prg.prdGroup21ID = prod.prdGroup21ID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.countryID = prm.countryID AND cus.customerID = vcus.customerID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN tbldistributorNames AS dms ON dms.countryID=cus.countryID AND dms.dinCustomerClientCode = cus.cusCustomerClientCode
	WHERE prod.productID=pps.prdProductID 
	UNION
	SELECT DISTINCT 'HQ' AS DistributorCode,prm.promotionID,prm.promotionTypeID,
	ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) AS PromotionCode,
	'C' AS AssignmentType,'2' AS CustomerHierarchyLevel,
	sg1.s01SecGroup1ClientCode AS AssignmentCode,
	'' AS ParentCode
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionDetails AS prd ON prm.promotionID = prd.promotionID
	INNER JOIN tblPromotionCustomer vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.countryID = prm.countryID AND cus.customerID = vcus.customerID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN tblPromotionCustomerSelection pcus ON pcus.promotionID=prm.promotionID
	INNER JOIN tblSecGroup1 AS sg1 ON pcus.countryID = sg1.countryID AND pcus.secGroup1ID = sg1.secGroup1ID
	INNER JOIN tblPromotionProductSelection AS pps ON prm.promotionID = pps.promotionId
	INNER JOIN tblProduct AS prod ON prod.countryID = prm.countryID AND prod.productID = pps.prdProductID
	INNER JOIN tbldistributorNames AS dms ON dms.countryID=cus.countryID AND dms.dinCustomerClientCode = cus.cusCustomerClientCode
	WHERE prod.productID=pps.prdProductID 
	UNION	
	SELECT DISTINCT 'HQ' AS DistributorCode,prm.promotionID,prm.promotionTypeID,
	ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) AS PromotionCode,
	'K' AS AssignmentType,'' AS CustomerHierarchyLevel,
	sg2.s02SecGroup2ClientCode AS AssignmentCode,
	'' AS ParentCode
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionDetails AS prd ON prm.promotionID = prd.promotionID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.countryID = prm.countryID AND cus.customerID = vcus.customerID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN tblPromotionCustomerSelection pcus ON pcus.promotionID=prm.promotionID
	INNER JOIN tblSecGroup2 AS sg2 ON pcus.countryID = sg2.countryID AND pcus.secGroup2ID = sg2.secGroup2ID
	INNER JOIN tblPromotionProductSelection AS pps ON prm.promotionID = pps.promotionId
	INNER JOIN tblProduct AS prod ON prod.countryID = prm.countryID AND prod.productID = pps.prdProductID
	INNER JOIN tblPrdGroup21 AS prg ON prg.countryID = prod.countryID AND prg.prdGroup21ID = prod.prdGroup21ID
	INNER JOIN tbldistributorNames AS dms ON dms.countryID=cus.countryID AND dms.dinCustomerClientCode = cus.cusCustomerClientCode
	WHERE prod.productID=pps.prdProductID 
	UNION
	SELECT DISTINCT 'HQ' AS DistributorCode,prm.promotionID,prm.promotionTypeID,
	ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) AS PromotionCode,
	'C' AS AssignmentType,'4' AS CustomerHierarchyLevel,sec.secSecondaryCustomerClientCode AS AssignmentCode,
	ISNULL(CAST(cus.cusCustomerClientCode AS VARCHAR(50)),'') AS ParentCode --sec.secCustomerClientCode AS ParentCode
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	INNER JOIN tblPromotionDetails AS prd ON prm.promotionID = prd.promotionID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.countryID = prm.countryID AND cus.customerID = vcus.customerID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	INNER JOIN tblPromotionCustomerSelection pcus ON pcus.promotionID=prm.promotionID
	INNER JOIN tblSecondaryCustomer AS sec ON pcus.countryID = sec.countryID AND pcus.secondarycustomerID = sec.secondaryCustomerID
	INNER JOIN tblCustomer as tcus on sec.countryID = tcus.countryID AND sec.customerID = tcus.customerID
	INNER JOIN tblPromotionProductSelection AS pps ON prm.promotionID = pps.promotionId
	INNER JOIN tblProduct AS prod ON prod.countryID = prm.countryID AND prod.productID = pps.prdProductID
	INNER JOIN tbldistributorNames AS dms ON dms.countryID=cus.countryID AND dms.dinCustomerClientCode = cus.cusCustomerClientCode
	WHERE prod.productID=pps.prdProductID
	) tbl
	INNER JOIN tblPromotionType AS pty ON pty.promotionTypeId = tbl.promotionTypeId
	LEFT JOIN tblPromotionDetailsIncentive pdi ON tbl.promotionID = pdi.promotionID
	ORDER BY tbl.AssignmentType DESC,tbl.CustomerHierarchyLevel, tbl.PromotionCode
END
