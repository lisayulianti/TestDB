-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetAllPromoProfitAndLoss] --7432,102,0
@PromotionID int,
@CountryID int = 102,
@IncludeActual bit = 1,
@GetProductPrice bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    exec spx_GetPromoProfitAndLoss 
		@promotionID, @countryID, @includeActual, 0, @GetProductPrice

    exec spx_GetPromoProfitAndLossTwo
		@promotionID, @countryID, @includeActual
END

