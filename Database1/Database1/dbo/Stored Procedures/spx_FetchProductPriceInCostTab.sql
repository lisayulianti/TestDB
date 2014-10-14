-- =============================================
-- Author:		Anthony Steven
-- Create date: 30th September 2014
-- Description:	Fetch Products Price in Cost Tab
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchProductPriceInCostTab]
	@promotionId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    
	SELECT prod.prdProductClientCode as ClientCode, prod.prdProductName as ProductName, 
	(CASE WHEN sa.sysUomClientCode = 'CTN' THEN sa.sysAmount
	WHEN sa.sysUomClientCode = 'EA' THEN sa.sysAmount / isnull(prod.prdConversionFactor,1)
	END) as CTNAmount
	from dbo.fn_GetSysAmountByPromotionID(@promotionId,0) sa 
	inner join tblProduct prod WITH (NOLOCK) on sa.productid = prod.productid
END

