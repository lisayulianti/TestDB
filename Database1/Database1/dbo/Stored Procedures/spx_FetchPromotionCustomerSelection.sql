-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Get Promotion Customer Selection
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromotionCustomerSelection]
	@promotionId INT	
AS
BEGIN
	DECLARE @count INT
	SET NOCOUNT ON;
    
	select a.promotionCustomerSelectionID, a.promotionID, a.pslSelAllCusGroup1,
                a.pslSelAllCusGroup2, a.pslSelAllCusGroup3, a.pslSelAllCusGroup4, a.pslSelAllCusGroup5, a.pslSelAllCusGroup6,
                a.pslSelAllCusGroup7, a.pslSelAllSecGroup1, a.pslSelAllSecGroup2, a.pslSelAllSecGroup3, a.cusGroup1ID,
                a.cusGroup2ID, a.cusGroup3ID, a.cusGroup4ID, a.cusGroup5ID, a.cusGroup6ID, a.cusGroup7ID, a.customerID,
                a.secGroup1ID, a.secGroup2ID, a.secGroup3ID, a.secondarycustomerID, a.countryID, b.c06CusGroup6Desc
                from tblPromotionCustomerSelection a  WITH (NOLOCK) 
                left join tblCusGroup6 b  WITH (NOLOCK) on a.cusGroup6ID = b.cusGroup6ID
                where a.promotionID=@promotionId
END



