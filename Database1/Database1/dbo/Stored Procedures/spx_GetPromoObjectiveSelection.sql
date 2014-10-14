-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 17 July 2014
-- Description:	get PromoObjectiveSelection
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromoObjectiveSelection]
@countryID int,
@proObjectiveType nvarchar(15) = 'F'
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

select
proObjectiveID,
proObjectiveDesc,
proObjectiveType
from tblPromotionObjectiveSelection
where 
countryID = @countryID 
and 
proObjectiveType = @proObjectiveType


END



