-- =============================================
-- Author:		Anthony Steven
-- Create date: 30 July 2014
-- Description:	Calculate Additional Budget Financial 
-- =============================================
CREATE  PROCEDURE [dbo].[spx_CalculateAdditionalBudgetPromoFin]
	@promotionId INT
	
AS


BEGIN
	SET NOCOUNT ON;    	
	
	INSERT into tblPromoFinancial(promotionId, countryId, finPromotionTypeID,finBuildingBlockId,
                                            finConditionType,pnlID,finGeneralLedgerCode,
                                            finGeneralLedgerCodeDesc,finGeneralLedgerCodeBsh,
                                            finGeneralLedgerCodeBShDesc,finSpendType,finAmount,finCostTypeID)
	select @promotionId,x.countryId,x.finPromotionTypeID,x.finBuildingBlockId,x.finConditionType,x.pnlID,x.finGeneralLedgerCode,x.finGeneralLedgerCodeDesc,x.finGeneralLedgerCodeBsh,
                                            x.finGeneralLedgerCodeBShDesc,x.finSpendType,(y.finAmount-x.finAmount),1 
	from 
	tblPromoFinancial x inner join tblPromoFinancial y
	on isnull(x.finBuildingBLockID,0) = isnull(y.finBuildingBLockID,0)
	and x.promotionID = y.promotionID
	where x.promotionID = @promotionId
	and x.finCostTypeID=4  and y.finCostTypeID=3
	

	
END



