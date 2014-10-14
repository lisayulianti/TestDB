-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetAllPromoProfitAndLossDetail]
@PromotionID int,
@IncludeActual bit = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    exec spx_GetPromoProfitAndLossDetail 
		@promotionID, @includeActual

    exec spx_GetPromoProfitAndLossDetailTwo
		@promotionID, @includeActual
END



