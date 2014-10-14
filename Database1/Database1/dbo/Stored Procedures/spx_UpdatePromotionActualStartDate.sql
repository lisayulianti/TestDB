-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 21 July 2014
-- Description:	Update promotion's actual start/end date
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdatePromotionActualStartDate]
@promotionID int,
@prmDateActualStart datetime
AS
BEGIN

SET NOCOUNT ON;

if @prmDateActualStart is not null
begin
	update tblPromotion
	set 
		prmDateActualStart = @prmDateActualStart,
		prmDateActualEnd = dateadd(day, datediff(day, prm.prmDateStart, prm.prmDateEnd), @prmDateActualStart)
	from tblPromotion prm 
	where promotionID = @promotionID

-- TO DO: call sp to update tblPromoVolumeSelection

end
END



