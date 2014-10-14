-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Relevant tblPromoFinancial records for Cost Tab
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchRelevantPromoFinForCost]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT finPromotionTypeID,finBuildingBlockID,
                    finConditionType,finGeneralLedgerCode,finGeneralLedgerCodeDesc,
                    finGeneralLedgerCodeBSh,finGeneralLedgerCodeBShDesc,finSpendType,
                    finAmount,pnlID,finCostTypeId from tblPromoFinancial  WITH (NOLOCK) where promotionId = @promotionId
END



