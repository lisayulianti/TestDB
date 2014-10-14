-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 16 July 2014
-- Description:	update editable fields in tblPromoEvaluation
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdatePromoEvaluationResult]
	@promotionID int,
	@evaPreEvaluationNotes nvarchar(max) = '',
	@evaPostEvaluationLearnings1 nvarchar(max) = '',
	@evaPostEvaluationLearnings2 nvarchar(max) = '',
	@evaPostEvaluationLearnings3 nvarchar(max) = '',
	@evaConclusion nvarchar(max) = '',
	@prmDateActualStart datetime = null
AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

if exists (select top 1 promotionid	from tblPromoEvaluationResult where promotionID = @PromotionID)
begin
	-- update
	update tblPromoEvaluationResult
	set 
		evaPreEvaluationNotes = @evaPreEvaluationNotes,
		evaPostEvaluationLearnings1 = @evaPostEvaluationLearnings1,
		evaPostEvaluationLearnings2 = @evaPostEvaluationLearnings2,
		evaPostEvaluationLearnings3 = @evaPostEvaluationLearnings3,
		evaConclusion = @evaConclusion
	where promotionID = @PromotionID
end
else
begin
	-- insert
	insert into tblPromoEvaluationResult
	values (@PromotionID, @evaPreEvaluationNotes, @evaPostEvaluationLearnings1,
	@evaPostEvaluationLearnings2, @evaPostEvaluationLearnings3, 
	@evaConclusion)
end

exec spx_UpdatePromotionActualStartDate @promotionID, @prmDateActualStart

END



