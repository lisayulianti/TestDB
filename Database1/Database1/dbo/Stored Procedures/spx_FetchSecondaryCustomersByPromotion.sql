-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Get Secondary Customer and It's Primary and Region Based On Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchSecondaryCustomersByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	select x.secondaryCustomerID, y.customerID, y.cusGroup6ID
	 from vw_promoseccust x  WITH (NOLOCK) left join tblCustomer y WITH (NOLOCK)  on x.customerID = y.customerID 
	 inner join tblPromotion prm on x.promotionID = prm.promotionID
	 where x.promotionId = @promotionId
	 and prm.prmDateStart between y.validFrom and y.validTo

END



