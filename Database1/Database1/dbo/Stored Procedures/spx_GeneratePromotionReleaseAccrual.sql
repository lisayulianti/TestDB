-- =============================================
-- Author:           Nora Limanto
-- Create date: 26 Aug 2014
-- Description:      Get Releases report related data
-- =============================================select * from tblCusGroup1
CREATE PROCEDURE [dbo].[spx_GeneratePromotionReleaseAccrual] 
       @startDate DATETIME,
       @endDate DATETIME,
       @tblCusGroup1ID int,
       @countryId int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
        SELECT
            DISTINCT
				prm.promotionID,
				prm.prmPromotionClientCode,
				prm.prmPromotionName,
				CASE WHEN jcc.jccCusCustomerClientCode <> '' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END AS CustomerCode,
				MONTH(prm.prmDateStart) AS [month],
				YEAR(prm.prmDateStart) AS [year],
				fin.finGeneralLedgerCode, 
				fin.finGeneralLedgerCodeDesc,
				cast(rtb.rtbAmount as money) as Accrualamount,
				cast(ISNULL(actw.acwAmount, act.actAmount ) as money) AS Claimedamount,
				cast(rtb.rtbAmount - ISNULL(actw.acwAmount,act.actAmount) as money) AS Releaseamount
    FROM tblPromotion AS prm
    INNER JOIN tblPromoFinancial AS fin ON fin.promotionID = prm.PromotionID
    INNER JOIN tblPromotionCustomer vcus ON prm.countryID = prm.countryID AND prm.promotionID = vcus.promotionID
    LEFT JOIN tblCustomer AS cus ON cus.countryID = prm.countryID AND cus.customerID = vcus.customerID
    LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.cusGroup5ID = cus.cusGroup5ID AND jcc.cusGroup6ID = cus.cusGroup6ID
    INNER JOIN ( SELECT a.*, b.CusCustomerClientCode FROM tblAccrualGeneration a
           INNER JOIN tblCustomer b ON a.countryID = b.countryID AND a.customerID = b.customerID) AS jgen
           ON jgen.promotionID = prm.promotionID AND jgen.CusCustomerClientCode = CASE WHEN jcc.jccCusCustomerClientCode <> '' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END
    INNER JOIN tblPromotionStatus AS prs ON prm.prmStatusID = prs.promotionStatusID
    INNER JOIN tblClaimNoteGeneration AS cn ON cn.promotionID = prm.promotionID AND cn.promotionID = jgen.promotionID
    LEFT JOIN ( SELECT b.*
            FROM
            (SELECT countryID, promotionID, MAX(rgJournalcreationDate) AS rgJournalcreationDate
            FROM tblReleaseJournalGeneration
            GROUP BY countryID,promotionID ) a
            INNER JOIN tblReleaseJournalGeneration b ON a.countryID = b.countryID AND a.promotionID = b.promotionID AND a.rgJournalcreationDate = b.rgJournalcreationDate
    )AS rgen ON rgen.promotionID = jgen.promotionID
    INNER JOIN ( SELECT countryID, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(rtbHeader,'E1',''),'E2',''),'E3',''),'E4',''),'E5','') rtbHeader, 
			customerID , SUM (ISNULL( rtbAmount,0 )) AS rtbAmount, pnlID FROM tblRecTypeB GROUP BY countryID, 
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(rtbHeader,'E1',''),'E2',''),'E3',''),'E4',''),'E5',''), customerID, pnlID ) 
           AS rtb ON rtb.rtbHeader = prm.prmPromotionClientCode AND rtb.customerID = jgen.customerID and rtb.pnlID = fin.pnlID
	INNER JOIN tblPromotionPnLMapping pnlmap on pnlmap.pnlID = fin.pnlID
	LEFT JOIN tblSetPnL setpnl on setpnl.pnlPnlActCond = fin.finConditionType and setpnl.pnlPnlActGL = fin.finGeneralLedgerCodeBSh
    LEFT JOIN ( SELECT countryID, actHeader, customerID , SUM (ISNULL( actAmount,0 )) AS actAmount, pnlID FROM tblActual GROUP BY countryID, actHeader, customerID, pnlID )
           AS act ON isnull(act.actHeader,'') = '' OR 
		   (act.actHeader = prm.prmPromotionClientCode AND act.customerID = jgen.customerID and act.pnlID = setpnl.pnlID)
    LEFT JOIN tblActualtwo AS actw ON isnull(actw.acwHeader,'') = '' OR actw.acwHeader = cn.claimClientCode
    WHERE prm.isDeleted = 0 AND prm.prmStatusID IN (11 ,10, 12) AND Prm.countryID = @countryId
    AND (ISNULL( prm.promotionTypeID ,0) = 102017 OR (ISNULL( prm.promotionTypeID ,0)<> 102017 AND prm .promotionID NOT IN (SELECT ISNULL(prmParentSelectionID ,0) FROM tblPromotion WHERE CountryID= @countryId)))
    AND (prm.prmPromotionStructure = 'Child' OR prm.prmPromotionStructure = 'Standalone')
    and cus .cusGroup1ID= @tblCusGroup1ID AND
       prm .prmDateStart BETWEEN @startDate AND @endDate
    GROUP BY 	prm.promotionID,
				prm.prmPromotionClientCode,
				prm.prmPromotionName,
				CASE WHEN jcc.jccCusCustomerClientCode <> '' THEN jcc.jccCusCustomerClientCode ELSE cus.cusCustomerClientCode END,
				prm.prmDateStart,
				fin.finGeneralLedgerCode, 
				fin.finGeneralLedgerCodeDesc,
				rtb.rtbAmount,
				actw.acwAmount, 
				act.actAmount,
				rtb.rtbAmount
    ORDER BY prm.prmPromotionClientCode
END
