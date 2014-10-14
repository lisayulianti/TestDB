-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 17 July 2014
-- Description:	Insert into/update tblPromotionNonFinancialKPI
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdatePromoNonFinancialKPI] 
	@promotionID int,
	@proObjectiveID int,
	@valueBase float = 0,
	@valuePlan float = 0,
	@valueActual float = 0
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

if exists (select top 1 promotionNonFinancialKPIID from tblPromotionNonFinancialKPI where promotionID = @PromotionID and proObjectiveID = @proObjectiveID)
begin
	update tblPromotionNonFinancialKPI
	set 
		valueBase = @valueBase,
		valuePlan = @valuePlan,
		valueActual = @valueActual
	where promotionID = @PromotionID and proObjectiveID = @proObjectiveID
end
else
begin
	insert into tblPromotionNonFinancialKPI
	select @PromotionID, @proObjectiveID, @valueBase, @valuePlan, @valueActual
end

END



