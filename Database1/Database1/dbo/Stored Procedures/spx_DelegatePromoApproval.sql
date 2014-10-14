-- =============================================
-- Author:		Robert De Castro
-- Create date: 15 July 2014
-- Description:	Update the tblPromoApproval with the delegated userID
-- =============================================
CREATE PROCEDURE [dbo].[spx_DelegatePromoApproval]
	-- Add the parameters for the stored procedure here
	@useDelegateID int, 
	@userID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (SELECT useDelegateID FROM tblUser WHERE userID=@userID) IS NULL
	BEGIN
		UPDATE tblPromoApproval SET userID=@useDelegateID WHERE userID=@userID
		UPDATE tblUser SET useDelegateID=@useDelegateID WHERE userID=@userID
	END
	ELSE
	BEGIN
		UPDATE tblPromoApproval SET userID=@userID WHERE userID=@useDelegateID
		UPDATE tblUser SET useDelegateID=NULL WHERE userID=@userID
	END
END



