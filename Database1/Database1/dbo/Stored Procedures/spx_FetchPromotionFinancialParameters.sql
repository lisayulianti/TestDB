-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Get Promotion Financial Parameters
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionFinancialParameters]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;
    
	SELECT y.promotionTypeID,y.BuildingBlockID as finBuildingBlockID,y.finConditionType,	       
		   y.finGeneralLedgerCode as FinGeneralLedgerCode,		   
		   y.finGeneralLedgerCodeBSh,y.finGeneralLedgerCodeBShDesc,
		   y.finGeneralLedgerCodeDesc,y.pnlID,y.finSpendType from tblPromotion x
           join tblPromotionPnLMapping y on x.promotionTypeId = y.promotionTypeID where x.promotionID = @promotionId
END



