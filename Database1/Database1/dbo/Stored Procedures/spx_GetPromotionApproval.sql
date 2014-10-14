-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 8 July 2014
-- Description:	To get approval list for a certain promotion 
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromotionApproval] 
	@PromotionID int,
	@LoginUserEmail nvarchar(100) = ''
AS
BEGIN

SET NOCOUNT ON;

if not exists (select top 1 promoApprovalID from tblPromoApproval where promotionID = @PromotionID)
begin
	EXEC	[dbo].spx_InsertPromotionApproval
			@PromotionID
end

Declare @userID as int
Select @userID = userId
from tblUser user1
where user1.useEmail = @LoginUserEmail

Declare @hasPromoEnded as bit

select @hasPromoEnded = case when getdate() > prmDateEnd and prmStatusID = 10 then 1 else 0 end
from tblPromotion
where promotionID = @PromotionID
--select @hasPromoEnded
SELECT [promoApprovalID]
      , appr.[countryID]
      , [promotionID]
      , [ApprovalStatusID]
      , [appRole]
      , case when exists (select top 1 userID from tblUser user1 where user1.userID = appr.[userID])-- and user1.useRole = appr.appRole)
			then appr.userID
			else null
		end userID
      , [appApprovedNr]
      , [appApprovedNrNotes]
      , [timeStamp]
	  , rolRoleName roleName
	  , case when @hasPromoEnded = 0 and isPostApproval = 0 and @userID = isnull(userID, 0) and ApprovalStatusID = 0 and 
		((select top 1 ApprovalStatusID from tblPromoApproval where promotionID = @PromotionID and appApprovedNr = appr.appApprovedNr - 1) = 1 
		or appApprovedNr = 1) then 1 
		when @hasPromoEnded = 1 and isPostApproval = 1 and ApprovalStatusID = 0 then 1
		when @hasPromoEnded = 1 and isPostApproval = 1 and ApprovalStatusID = 1 then 0
		else 0 
		end allowEdit
	  , isPostApproval
from tblPromoApproval appr
inner join tblRole role1 on appr.appRole = role1.roleID
where promotionID = @PromotionID



END



