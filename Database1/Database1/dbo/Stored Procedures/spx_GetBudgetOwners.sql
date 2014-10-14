-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 16 Sep 2014
-- Description:	Get list of budget owners of a promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetBudgetOwners] 
@promotionID int,
@countryID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;


select 
A.cusGroup5ID, A.cusGroup6ID, A.secGroup2ID, balBudgetOwnerName BudgetOwnerName 
from
(
select
cusGroup5ID, cusGroup6ID, secGroup2ID
from dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
group by cusGroup5ID, cusGroup6ID, secGroup2ID) A inner join 
(
select 
cusGroup5ID, cusGroup6ID, secGroup2ID, balBudgetOwnerName 
from tblBudgetAllocation
where balYear = datepart(year, getdate())
group by cusGroup5ID, cusGroup6ID, secGroup2ID, balBudgetOwnerName
) B on A.cusGroup5ID = B.cusGroup5ID and A.cusGroup6ID = B.cusGroup6ID
AND ((A.secGroup2ID is null and B.secGroup2ID is null) OR A.secGroup2ID = B.secGroup2ID)
--select
--bal.cusGroup5ID, bal.cusGroup6ID, bal.secGroup2ID, balBudgetOwnerName BudgetOwnerName
--from
--(
--select 
--cusGroup5ID, cusGroup6ID, secGroup2ID, balBudgetOwnerName 
--from tblBudgetAllocation
--where balYear = datepart(year, getdate())
--group by cusGroup5ID, cusGroup6ID, secGroup2ID, balBudgetOwnerName
--) bal inner join
--(
--select
--cusGroup5ID, cusGroup6ID, secGroup2ID
--from dbo.fn_GetCustomerIDsByPromotionID(@promotionID)
--group by cusGroup5ID, cusGroup6ID, secGroup2ID
--) pcust on pcust.cusGroup5ID = bal.cusGroup5ID
--	and pcust.cusGroup6ID = bal.cusGroup6ID
--	and ((pcust.secGroup2ID is null and bal.secGroup2ID is null) OR pcust.secGroup2ID = bal.secGroup2ID)

END

