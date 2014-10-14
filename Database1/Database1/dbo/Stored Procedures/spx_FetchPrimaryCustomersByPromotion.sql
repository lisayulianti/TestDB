-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Get Primary Customer and Region Based On Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPrimaryCustomersByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	select y.customerID, y.cusGroup6ID 
	from vw_promocust x  WITH (NOLOCK)  
	INNER join tblCustomer y  WITH (NOLOCK) on x.customerID = y.customerID 
	INNER JOIN tblPromotion prm WITH (NOLOCK) on prm.promotionID = x.promotionID
	where prm.promotionId = @promotionId
		AND prm.prmDateStart between y.validFrom and y.validTo
END



