-- =============================================
-- Author:		Nora Limanto
-- Create date: 26 Aug 2014
-- Description:	Get Rcprtt report related data
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportRcprtt]
	@countryId int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
	SELECT DISTINCT prm.prmPromotionClientCode+ '_' + CAST(sec.secSecCusClientCode AS VARCHAR(20)) + '_' + CAST(prm.promotionID AS VARCHAR(20)) claimClientCode,
    prm.promotionID,sec.secondaryCustomerID,prm.prmpromotionClientCode,Cast(prm.prmPromotionDescription as NVarchar(Max)) prmPromotionDescription
    ,sec.secSecCusClientCode,sec.secSecondaryCustomerName,
    CONVERT(varchar(50),prm.prmDateStart,106) AS prmDateStartConverted,CONVERT(varchar(50),prm.prmDateEnd,106) AS prmDateEndConverted,
    pst.psStatusDescription,
    CASE WHEN cn.cnStatus=1 THEN 'Yes' ELSE 'No' END AS cnStatus,
    CASE WHEN GETDATE() < prm.prmDateEnd THEN 'Yes' ELSE 'No' END AS endeddata
    ,prmDateStart,prmDateEnd,
    CONVERT(varchar(50),cn.cnCreationDate,113) AS cnCreationDate, cn.cnCreator,prm.prmStatusID,
    cn.claimNoteID, sec.secRegNr, tuse.useFullName
    FROM tblpromotion AS prm
	INNER JOIN tblUSer tuse ON prm.prmCreator = tuse.userID
    INNER JOIN vw_PromoSecCust vcus ON vcus.promotionID=prm.promotionID
    INNER JOIN tblSecondaryCustomer AS sec ON sec.countryID = vcus.countryID AND sec.customerID = vcus.customerID AND vcus.secondaryCustomerID = sec.secondaryCustomerID
    INNER JOIN tblPromotionStatus AS pst ON pst.promotionStatusID=prm.prmStatusID
    Left Join tblClaimNoteGeneration AS cn ON cn.promotionID=prm.promotionID AND cn.secondaryCustomerID = sec.secondarycustomerID
    LEFT JOIN (SELECT b.countryID,b.claimClientCode,b.promotionID,b.cnPromotionClientCode
                ,b.customerID,b.secondaryCustomerID,b.cnStatus,b.cnCreationDate,b.cnCreator 
            FROM
	        (SELECT countryID,promotionID,secondaryCustomerID,MAX(cnCreationDate) AS cnCreationDate
	        FROM tblClaimNoteGeneration
	        GROUP BY countryID,promotionID,secondaryCustomerID) a
	        INNER JOIN tblClaimNoteGeneration b ON a.countryID=b.countryID AND a.promotionID=b.promotionID AND a.secondaryCustomerID=b.secondaryCustomerID AND a.cnCreationDate=b.cnCreationDate) AS gen
        ON gen.countryID = prm.countryID AND gen.promotionID = prm.promotionID and cn.secondaryCustomerID = vcus.secondaryCustomerID
    WHERE prm.isDeleted = 0 AND ((sec.secGroup2ID IS NOT NULL AND sec.secondaryCustomerID IS NULL) OR prm.promotionTypeID IN (102020,102017,102024) )
    AND prm.prmStatusID IN (10,11) AND sec.countryID=@countryId
	AND prm.prmPromotionStructure<>'Parent' AND RIGHT(prm.prmpromotionClientCode, 2) NOT IN ('E1','E2','E3','E4','E5') -- parent and top up promotions can never appear in the Claim Notes website
END
