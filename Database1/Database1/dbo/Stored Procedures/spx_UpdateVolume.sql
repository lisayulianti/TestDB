-- =============================================
-- Author:		Anthony Steven
-- Create date: 18th August 2014
-- Description:	Update Volume from Summary View
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdateVolume]
	-- Add the parameters for the stored procedure here
	@promotionId NVARCHAR(20),
	@productId INT,
	@baselineP1 INT,
	@baselineP2 INT,
	@baselineP3 INT,
	@planP1 INT,
	@planP2 INT,
	@planP3 INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update tblPromoVolumeSelection
	set volVolumeP1Base = @baselineP1,
	volVolumeP2Base = @baselineP2,
	volVolumeP3Base = @baselineP3,
	volVolumeP1Plan = @planP1,
	volVolumeP2Plan = @planP2,
	volVolumeP3Plan = @planP3
	where promotionId = @promotionId and productId = @productId
END



