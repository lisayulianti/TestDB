-- =============================================
-- Author:		Anthony Steven
-- Create date: 9 September 20
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_IsPromotionEditable]
	-- Add the parameters for the stored procedure here
	@promotionId INT,
	@userId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @prmStatus INT
	Declare @creator INT

    select @prmStatus = promotion.prmStatusId, @creator = promotion.prmCreator
	from tblPromotion promotion
	where promotionId = @promotionId

	IF @prmStatus = 0 and @creator = @userId
	BEGIN
	select 1
	END
	ELSE
	BEGIN
	select 0
	END

END

