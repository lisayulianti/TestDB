-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 8 July 2014
-- Description:	To get a list of users for each role in the approval list
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromotionApprovalUsers] 
	@PromotionID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if exists (select top 1 promotionID from tblPromotion where prmStatusID = 0 and promotionID = @promotionID)
	begin
		-- promotion drafted

		select appr.promotionID, 
			role1.roleID, role1.rolRoleName roleName, 
			CASE WHEN user1.useDelegateID IS NOT NULL THEN user1.useDelegateID ELSE user1.userID END AS userID, 
			CASE WHEN user1.useDelegateID IS NOT NULL THEN (SELECT useFullName FROM tblUser WHERE userID = user1.useDelegateID) ELSE user1.useFullName END AS useFullName,
			appr.appApprovedNr
		from tblPromoApproval appr
		inner join tblUser user1 on user1.useRole = appr.appRole
		inner join tblRole role1 on role1.roleID = appr.appRole
		where
			appr.promotionID = @PromotionID and (user1.usePromotionApprover = 1 or 
			(appr.appApprovedNr = 1 or appr.userID = (select prmCreator from tblPromotion where promotionID = @promotionID))
			)
		order by appr.appApprovedNr, useFullName

	end
	else
	begin
		-- promotion submitted

		select appr.promotionID, 
			appr.appRole roleID, role1.rolRoleName roleName, 
			CASE WHEN user1.useDelegateID IS NOT NULL THEN user1.useDelegateID ELSE user1.userID END AS userID, 
			CASE WHEN user1.useDelegateID IS NOT NULL THEN (SELECT useFullName FROM tblUser WHERE userID = user1.useDelegateID) ELSE user1.useFullName END AS useFullName,
			appr.appApprovedNr
		from tblPromoApproval appr
		inner join tblUser user1 on user1.userID = appr.userID
		inner join tblRole role1 on role1.roleID = appr.appRole
		where
			appr.promotionID = @PromotionID and (user1.usePromotionApprover = 1 or 
			(appr.appApprovedNr = 1 or appr.userID = (select prmCreator from tblPromotion where promotionID = @promotionID))
			)
		order by appr.appApprovedNr, useFullName
	end
END

