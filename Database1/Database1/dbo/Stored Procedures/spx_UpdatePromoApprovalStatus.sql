-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 8 July 2014
-- Description:	update an approval of the promotion approval
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdatePromoApprovalStatus]
@promotionID int,
@approvalStatusID int,
@userID int,
@appRole int,
@appApprovedNr nvarchar(50),
@appApprovedNrnotes nvarchar(500) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

update tblPromoApproval
	set
		ApprovalStatusID = @approvalStatusID,
		appApprovedNrnotes = @appApprovedNrnotes
	where promotionID = @promotionID
		and userID = @userID
		and appRole = @appRole
		and appApprovedNr = @appApprovedNr

if @approvalStatusID = 1	-- approved
begin
	if exists (select top 1 promoApprovalID from tblPromoApproval where promotionid = @promotionID and appApprovedNr = @appApprovedNr and appRole = @appRole and isPostApproval = 0)
	begin
		update tblPromotion
		set
			prmStatusID = cast(@appApprovedNr as int)-- + 1 
		where promotionID = @promotionID

		if not exists (select top 1 promoApprovalID from tblPromoApproval where promotionID = @promotionID and ApprovalStatusID = 0 and isPostApproval = 0)
		begin
			update tblPromotion
			set
				prmDateApproved = getdate(),
				prmStatusID = 8
			where promotionID = @promotionID

			-- store budget overview
			Declare @countryID as int
			select @countryID = countryID from tblPromotion where promotionid = @promotionID
			exec spx_GetBudgetOverview @promotionID, @countryID, 1, 0
			-- end store budget overview
		end
	end

	if exists (select top 1
		appr1.promotionID
		from tblPromoApproval appr1
		inner join tblUser user1 on user1.userid = appr1.userID
		where promotionID = @promotionID
			and (appApprovedNr = @appApprovedNr + 1 or ApprovalStatusID = 0) 
			and isPostApproval = 0
		order by appApprovedNr asc)
	begin
		select top 1
		appr1.promotionID,
		appr1.userID,
		user1.useFullName,
		user1.useEmail,
		appr1.isPostApproval,
		appApprovedNr
		from tblPromoApproval appr1
		inner join tblUser user1 on user1.userid = appr1.userID
		where promotionID = @promotionID
			and (appApprovedNr = @appApprovedNr + 1 or ApprovalStatusID = 0) 
			and isPostApproval = 0
		order by appApprovedNr asc
	end
	else
	begin
		select top 1
		appr1.promotionID,
		appr1.userID,
		user1.useFullName,
		user1.useEmail,
		appr1.isPostApproval,
		appApprovedNr
		from tblPromoApproval appr1
		inner join tblUser user1 on user1.userid = appr1.userID
		where promotionID = @promotionID
			and appApprovedNr = 1
			and isPostApproval = 0
		order by appApprovedNr asc
	end
end
else
begin
	update tblPromotion
	set
		prmStatusID = @approvalStatusID
	where promotionID = @promotionID

	update tblPromoApproval
	set
		ApprovalStatusID = @approvalStatusID
	where promotionID = @promotionID

	delete tblPromoApproval
	where promotionID = @promotionID and isPostApproval = 1

	delete tblPromotionBudgetOverview where promotionID = @promotionID

	select top 1
	appr1.promotionID,
	appr1.userID,
	user1.useFullName,
	user1.useEmail,
	appr1.isPostApproval,
	appApprovedNr
	from tblPromoApproval appr1
	inner join tblUser user1 on user1.userid = appr1.userID
	where promotionID = @promotionID
		and appApprovedNr = 1
		and isPostApproval = 0
end

END

