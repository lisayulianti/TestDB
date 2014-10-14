-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPostApprovalListForEmail]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;

select 
appr1.promotionID,
appr1.userID,
user1.useFullName,
user1.useEmail,
appr1.isPostApproval
From tblPromotion prm
inner join tblPromoApproval appr1 on prm.promotionID = appr1.promotionID and appr1.isPostApproval = 1
inner join (select * from tblPromoApproval where isPostApproval = 0 and appApprovedNr = 1) appr2 on appr2.promotionID = prm.promotionID and appr2.userID = appr1.userID
inner join tblUser user1 on user1.userid = appr1.userID
where DATEDIFF(day, prm.prmDateEnd, getdate()) >= 2 and prm.prmStatusID = 10
and appr1.ApprovalStatusID = 0

	
END



