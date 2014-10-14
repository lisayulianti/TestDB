-- =============================================
-- Author:		Anthony Steven
-- Create date: 22 July 2014
-- Description:	Modified from fn_GetSysAmountByPromotionID to handle volume calculation
-- =============================================
CREATE FUNCTION [dbo].[fn_GetSysAmountValueByPromotionID]
(	
@PromotionID int
)
RETURNS TABLE 
AS
RETURN 
(
	
with tblTemp (productId,sysAmount,sysUomClientCode,combinationId, rn)
as
(	select productId,
		sysAmount,
		sysUomClientCode,
		combinationid,
		ROW_NUMBER() over (partition by productiD, combinationId order by productiD, combinationId asc) as rn
	from dbo.fn_GetSysAmountByPromotionID(@promotionID,0)
)
select productId,sysAmount,sysUomClientCode,combinationId from tblTemp where rn=1
	

)

