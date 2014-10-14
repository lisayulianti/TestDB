-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertDetailsTypeBuildingBlock]
@promotionID int,
@buildingBlockIDs varchar(100)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

delete tblPromotionDetailsTypeBuildingBlock
where promotionID = @promotionID

if not exists (select * from dbo.fn_split(@buildingBlockIDs, ';') where data = '0')
begin
	insert into tblPromotionDetailsTypeBuildingBlock(promotionid, buildingBlockID)
	select @promotionID, data from dbo.fn_split(@buildingBlockIDs, ';')
	where data <> ''
end

END



