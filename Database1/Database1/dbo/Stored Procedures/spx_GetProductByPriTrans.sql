CREATE PROCEDURE [dbo].[spx_GetProductByPriTrans]
	@PromotionID int
AS
BEGIN
	SELECT DISTINCT prt.productID as id FROM tblPriTrans prt
	 INNER JOIN (
		 SELECT DISTINCT pc.countryID, pc.customerId FROM vw_PromoCust AS pc WHERE pc.promotionID = @PromotionID
		 UNION
		 SELECT DISTINCT tsc.countryID, tsc.customerID FROM tblPromotionSecondaryCustomer AS psc
		 INNER JOIN tblSecondaryCustomer AS tsc ON psc.secondaryCustomerId = tsc.secondaryCustomerID
		 WHERE promotionId = @PromotionID)
	 AS tbl1 ON prt.countryID = tbl1.countryID AND prt.customerID = tbl1.customerID
	 WHERE prt.dayDate BETWEEN DATEADD(MONTH,-18,CAST(CAST(MONTH(GETDATE()) AS VARCHAR(10)) +'/1/' + CAST(YEAR(GETDATE()) AS VARCHAR(10)) AS DATETIME)) AND GETDATE()
	 AND ISNULL(prt.prtGrossQuantityCtn,0)<>0;
END



