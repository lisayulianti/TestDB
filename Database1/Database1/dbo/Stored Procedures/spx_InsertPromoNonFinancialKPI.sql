-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 14 Aug 2014
-- Description:	Insert non financial KPI from tblPromotion to tblPromoNonFinancialKPI
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromoNonFinancialKPI] 
@promotionID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Declare @NF1 as int
	Declare @NF2 as int
	Declare @NF3 as int

	select
		@NF1 = isnull(prmNFObjPri,0),
		@NF2 = isnull(prmNFObjSec,0),
		@NF3 = isnull(prmNFObjTri,0)
	from tblPromotion where promotionID = @promotionID

	delete tblPromotionNonFinancialKPI
	where promotionID = @promotionID and proObjectiveID not in (@NF1, @NF2, @NF3)

	if @NF1 <> 0 and not exists (select top 1 promotionid from tblPromotionNonFinancialKPI where promotionID = @promotionID and proObjectiveID = @NF1)
	begin
		insert into tblPromotionNonFinancialKPI (promotionID, proObjectiveID)
		values (@promotionID, @NF1)
	end
	if @NF2 <> 0 and not exists (select top 1 promotionid from tblPromotionNonFinancialKPI where promotionID = @promotionID and proObjectiveID = @NF2)
	begin
		insert into tblPromotionNonFinancialKPI (promotionID, proObjectiveID)
		values (@promotionID, @NF2)
	end
	if @NF3 <> 0 and not exists (select top 1 promotionid from tblPromotionNonFinancialKPI where promotionID = @promotionID and proObjectiveID = @NF3)
	begin
		insert into tblPromotionNonFinancialKPI (promotionID, proObjectiveID)
		values (@promotionID, @NF3)
	end
END



