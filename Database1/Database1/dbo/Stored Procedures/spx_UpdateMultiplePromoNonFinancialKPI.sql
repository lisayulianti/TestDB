-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 17 July 2014
-- Description:	Insert into/update tblPromotionNonFinancialKPI
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdateMultiplePromoNonFinancialKPI] 
	@promotionID int,
	@NFObjectiveKPItable PromoNonFinancialKPI_TableType readonly
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

delete tblPromotionNonFinancialKPI
where promotionid = @promotionID and 
proObjectiveID not in (select proObjectiveID from @NFObjectiveKPItable)

insert into tblPromotionNonFinancialKPI
select promotionid, proObjectiveID, valueBase, valuePlan, valueActual
from @NFObjectiveKPItable
where proObjectiveID not in 
(
select proObjectiveID from tblPromotionNonFinancialKPI kpi where promotionID = @promotionID
)

update tblPromotionNonFinancialKPI
set
	valueBase = newkpi.valueBase,
	valuePlan = newkpi.valuePlan,
	valueActual = newkpi.valueActual
from tblPromotionNonFinancialKPI prmkpi
inner join @NFObjectiveKPItable newkpi on prmkpi.promotionID = newkpi.promotionID and prmkpi.proObjectiveID = newkpi.proObjectiveID

END



