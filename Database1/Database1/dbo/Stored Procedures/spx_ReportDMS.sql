

-- =============================================
-- Author:		Nora Limanto
-- Create date: 27 Aug 2014
-- Description:	Get DMS report related data
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportDMS]
@countryID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT DISTINCT prm.promotionId,prm.promotionTypeID, pty.ptyPromotionTypeName, vcus.customerID, cgr.c06CusGroup6Desc,
CAST(cusCustomerClientCode AS VARCHAR(250)) + '-' + cus.cusCustomerName AS distributor
,prm.prmPromotionClientCode, Cast(prm.prmPromotionDescription as NVarchar(Max)) prmPromotionDescription
, prs.psStatusDescription,
CONVERT(VARCHAR(50),prm.prmDateStart,106) AS prmDateStartConverted, prmDateStart
, CONVERT(VARCHAR(50),prm.prmDateEnd,106) AS prmDateEndConverted, prmDateEnd, cus.cusGroup5ID,
gen.dgDMSgeneration, CONVERT(VARCHAR(50), gen.dgDMScreationDate,113) AS dgDMScreationDateConverted, gen.dgDMScreationDate,
CASE WHEN gen.dgDMSgeneration = 1 THEN 'Yes' ELSE 'No' END AS dmsGenerated,
prm.prmStatusId, pty.ptyDMSCode, cus.cusGroup1ID
FROM tblPromotion AS prm 
INNER JOIN tblDetSelTab dst ON dst.countryID = prm.countryID AND dst.PromotionTypeID = prm.PromotionTypeID
INNER JOIN tblPromotionStatus AS prs ON prm.prmStatusId = prs.promotionStatusId
INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
INNER JOIN tblCustomer AS cus ON vcus.customerID = cus.customerID and prm.countryID = cus.countryID
INNER JOIN tblCusGroup1 AS cg1 ON cg1.countryID = cus.countryID AND cg1.cusGroup1ID = cus.cusGroup1ID
INNER JOIN 
	(select count(cusGroup1ID) ctrCusGroup1, promotionID
	from 
	(
	select distinct cusGroup1ID, vcust.promotionID
	from tblPromotionCustomer2 vcust
	inner join tblCustomer cust on cust.customerID = vcust.customerID
	) cusgroup1
group by promotionID) cusgroup1 ON cusgroup1.promotionID = prm.promotionID and ctrCusGroup1 = 1
LEFT JOIN (SELECT b.* FROM
	(SELECT promotionID,MAX(dgDMScreationDate) AS dgDMScreationDate, customerID
	FROM tblDMSGeneration
	GROUP BY promotionID, customerID) a
	INNER JOIN tblDMSGeneration b ON a.promotionID=b.promotionID AND a.dgDMScreationDate=b.dgDMScreationDate 
		and a.customerID = b.customerID) AS gen 
        ON gen.promotionID = prm.promotionID and gen.customerID = vcus.customerID
INNER JOIN tblCusGroup6 AS cgr ON cgr.countryID = cus.countryID AND cgr.cusGroup6ID = cus.cusGroup6ID
INNER JOIN tblPromotionType AS pty ON pty.countryID = prm.countryID AND pty.promotiontypeID = prm.promotionTypeID
WHERE prm.isDeleted = 0
AND (CG1.c01CusGroup1ClientCode IN (SELECT DMSCusGroup1IDsettings FROM tblDMSSettings WHERE countryId = @countryID) OR cg1.cusGroup1ID=102000006)
AND prm.prmStatusId BETWEEN 1 AND 9 
AND prm.promotionTypeID NOT IN (102005,102006,102017,102018,102020,102024)
AND dst.buildingblockID NOT IN (102022,102023,102025,102026)
AND prm.prmPromotionStructure<>'Parent' AND RIGHT(prm.prmpromotionClientCode, 2) NOT IN ('E1','E2','E3','E4','E5') -- parent and top up promotions can never appear in the DMS website
AND prm.countryId = @countryID

END
