-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 02 Sep 2014
-- Description:	Get report settings for userid
-- =============================================
CREATE PROCEDURE [dbo].[spx_ReportSettings]
@countryID int,
@userID int,
@reportType nvarchar(50)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

select report.*
from tblReportSettings report WITH (NOLOCK) 
inner join tblUser usr WITH (NOLOCK) on usr.countryID = report.countryID and 
((usr.useRole = report.roleID or report.roleID is null) and 
(usr.useDepartment = report.departmentID or report.departmentID is null) and 
(usr.userID = @userID or usr.userID is null))
where reportType = @reportType and usr.countryID = @countryID
END

