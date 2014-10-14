-- =============================================
-- Author:		Anthony Steven
-- Create date: 15 August 2014
-- Description:	Get Max Sys Amount 
-- Usage:       For Free Goods Cap Counting
-- =============================================
CREATE FUNCTION [dbo].[fn_GetMaxSysAmount]
(	
	@productId INT
)
RETURNS TABLE 
AS
RETURN 
(
	select 
	MAX(CASE WHEN sa.sysUomClientCode = 'CTN'
	THEN sa.sysAmount 
	ELSE sa.sysAmount*isnull(p.prdConversionFactor,1)
	END) as EachAmount
	from tblSystemAccrual sa inner join tblProduct p
	on sa.productId = p.productId
	and p.productId = @productId  and (sa.sysDelete='' or sa.sysDelete is null)
)



