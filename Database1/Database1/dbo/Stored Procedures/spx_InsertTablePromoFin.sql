-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Insert Table Promo Financial 
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertTablePromoFin]
	@promotionId INT,
	@countryId INT,
	@finPromotionTypeID INT,
	@finBuildingBlockId INT = null,
	@finConditionType NVARCHAR(200),
	@pnlID INT,
	@finGeneralLedgerCode INT,
    @finGeneralLedgerCodeDesc NVARCHAR(200),
	@finGeneralLedgerCodeBsh INT = null,
	@finGeneralLedgerCodeBShDesc NVARCHAR(200) = null,
	@finSpendType NVARCHAR(200),
	@finAmount FLOAT,
	@finCostType INT	
AS


BEGIN
	SET NOCOUNT ON;    
	

	--add new records
	IF @finAmount <> 0
	BEGIN
	INSERT into tblPromoFinancial(promotionId, countryId, finPromotionTypeID,finBuildingBlockId,
                                  finConditionType,pnlID,finGeneralLedgerCode,
                                  finGeneralLedgerCodeDesc,finGeneralLedgerCodeBsh,
                                  finGeneralLedgerCodeBShDesc,finSpendType,finAmount,finCostTypeID)
                                  VALUES(@promotionId,@countryId,@finPromotionTypeID,@finBuildingBlockId,@finConditionType,@pnlID,@finGeneralLedgerCode
                                 ,@finGeneralLedgerCodeDesc,@finGeneralLedgerCodeBsh,@finGeneralLedgerCodeBShDesc,@finSpendType,@finAmount,@finCostType)

	END
END



