-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 8 July 2014
-- Description:	update the user ids of all roles in the approval route
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdatePromoApprovalUsers]
@promotionID int,
@strRoleUserIDs nvarchar(max),
@isSubmitted bit = 0,
@notes varchar(500) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @tbl as table
(
	roleID int,
	userID int
)

insert into @tbl
select left(data, CHARINDEX(';',data) - 1),
	right(data, len(data) - CHARINDEX(';',data))  
from dbo.fn_split(@strRoleUserIDs, '|')


update tblPromoApproval
set
	userID = tbl.userID
from tblPromoApproval appr
inner join @tbl tbl on appr.appRole = tbl.roleID and promotionID = @promotionID
where tbl.userID is not null

if @isSubmitted = 1
begin
	-- update first approval to approved
	update tblPromoApproval
	set
		ApprovalStatusID = 1,
		appApprovedNrnotes = @notes
	where promotionID = @promotionID and appApprovedNr = 1

	-- update promotion status to waiting level 1 approval
	update tblPromotion 
	set 
		prmStatusID = 1,
		prmDateSubmitted = getdate()
	where promotionID = @promotionID

	-- add post approval users
	insert into tblPromoApproval
	select countryid, promotionid, 0, appRole, userID, 
	(select max(cast(appapprovednr as int)) from tblPromoApproval where promotionID = @promotionID) + cast(appapprovednr as int),
	null, getdate(), 1
	from tblPromoApproval
	where promotionID = @promotionID and appApprovedNr in (1,2)


	select top 1
	appr1.promotionID,
	appr1.userID,
	user1.useFullName,
	user1.useEmail,
	appr1.isPostApproval
	from tblPromoApproval appr1
	inner join tblUser user1 on user1.userid = appr1.userID
	where promotionID = @promotionID
		and appApprovedNr = 2
end
else
begin
	select top 1
	appr1.promotionID,
	appr1.userID,
	user1.useFullName,
	user1.useEmail,
	appr1.isPostApproval
	from tblPromoApproval appr1
	inner join tblUser user1 on user1.userid = appr1.userID
	where promotionID = @promotionID
		and appApprovedNr = 1
end

END

