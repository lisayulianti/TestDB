
-- =============================================
-- Author:		Nora Limanto
-- Create date: 26 Aug 2014
-- Description:	Get ERdcn report related data
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportERdcn]
	@countryId int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
	SELECT DISTINCT prm.prmpromotionClientCode,Cast(prm.prmPromotionDescription as NVarchar(Max)) prmPromotionDescription, cus.customerID, cus.cusCustomerClientCode, 
    cus.cusCustomerName,(CONVERT(varchar(50), prm.prmDateStart, 106)) AS prmDateStartConverted, (CONVERT(varchar(50), prm.prmDateEnd, 106)) AS prmDateEndConverted, pst.psStatusDescription,cus.customerID,
    CASE WHEN GETDATE() < prmDateEnd THEN 'Yes' ELSE 'No' END AS endeddata, cn.cnStatus,
    CASE WHEN cn.cnStatus=1 THEN 'Yes' ELSE 'No' END AS Status,prmDateStart,prmDateEnd,
    (CONVERT(varchar(50),cn.cnCreationDate, 113)) AS cnCreationDate,cn.cnCreator,prm.promotionID,prm.prmStatusID,
	tuse.useFullName
    FROM tblPromotion AS prm
	INNER JOIN tblUSer tuse ON prm.prmCreator = tuse.userID
    INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
    INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID
    LEFT JOIN tblSecondaryCustomer AS sec ON sec.countryID = prm.countryID AND sec.customerID = vcus.customerID
    INNER JOIN tblPromotionStatus AS pst ON pst.promotionStatusID=prm.prmStatusID                             
    LEFT JOIN (SELECT b.countryID,b.claimClientCode,b.promotionID,b.cnPromotionClientCode
                ,b.customerID,b.secondaryCustomerID,b.cnStatus,b.cnCreationDate,b.cnCreator 
        FROM
	    (SELECT distinct countryID,promotionID,customerID,MAX(cnCreationDate) AS cnCreationDate
	    FROM tblClaimNoteGeneration
	    GROUP BY countryID,promotionID,customerID) a
	    INNER JOIN tblClaimNoteGeneration b ON a.countryID=b.countryID AND a.promotionID=b.promotionID 
	    AND a.customerID=b.customerID AND a.cnCreationDate=b.cnCreationDate) AS cn 
            ON cn.countryID = prm.countryID AND cn.promotionID = prm.promotionID and cn.customerID = vcus.customerID
    WHERE prm.isDeleted = 0 AND (CASE WHEN vcus.customerID IS NOT NULL THEN cus.cusGroup1ID ELSE cus.cusGroup1ID END IN (102000002,102000006)
    OR (CASE WHEN sec.secGroup2ID IS NOT NULL AND sec.secondarycustomerID IS NOT NULL THEN sec.secGroup2ID ELSE 0 END IN (102000007,102000008,102000009,102000010)))
	AND prm.prmStatusID IN (10,11) AND prm.CountryID=@countryId
	AND prm.prmPromotionStructure<>'Parent' AND RIGHT(prm.prmpromotionClientCode, 2) NOT IN ('E1','E2','E3','E4','E5') -- parent and top up promotions can never appear in the Claim Notes website

END

