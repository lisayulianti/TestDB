-- =============================================
-- Author:		Anthony Steven
-- Create date: 14 August 2014
-- Description:	Get Outlet Based On Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchOutletsByPromotion]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	select tpcs.outletID
	 from tblPromotionCustomerSelection tpcs  WITH (NOLOCK) 
	 inner join tblOutlet outlet  WITH (NOLOCK)  on tpcs.outletID = outlet.outletID
	 inner join tblPromotion prm on tpcs.promotionId = prm.promotionId
	 where tpcs.promotionID = @promotionId
	 and tpcs.outletID is not null	 
	 and prm.prmDateStart between outlet.validFrom and outlet.validTo
END



