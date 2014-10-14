-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Get Promotion Budget Parameters
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionBudgetParameters] 
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;
    
	SELECT y.depUsePromotionPnLMapping bdoUsePromotionPnLMapping, x.promotionTypeId as usePnlMapping FROM tblPromotion x  WITH (NOLOCK) 
           join tblDepartment y  WITH (NOLOCK) on x.prmBudgetOwnerID = y.departmentID
           WHERE promotionID = @promotionId
END



