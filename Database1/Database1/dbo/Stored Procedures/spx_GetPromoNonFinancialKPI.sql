-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 17 July 2014
-- Description:	get tblPromotionNonFinancialKPI
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromoNonFinancialKPI]
@promotionID int
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

select
prm.promotionID,
kpi.proObjectiveID,
pos.proObjectiveDesc,
valueBase,
valuePlan,
valueActual,
prm.prmStatusID
from tblPromotionNonFinancialKPI kpi
inner join tblPromotion prm on prm.promotionID = kpi.promotionID
inner join tblPromotionObjectiveSelection pos on pos.proObjectiveID = kpi.proObjectiveID
where prm.promotionID = @promotionID

END
