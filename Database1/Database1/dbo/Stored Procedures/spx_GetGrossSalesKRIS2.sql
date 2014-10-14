-- =============================================
-- Author:		Robert de Castro
-- Create date: 01 October 2014
-- Description:	Gets the amount for KRIS based on product selection
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetGrossSalesKRIS2]
	@secGroup4ID CustomerList READONLY,
	@productIDs ProductList READONLY,
	@dateStart datetime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @secCustList AS TABLE 
	(
		secondaryCustomerID INT,
		customerID INT
	)

	INSERT INTO @secCustList
	SELECT secondaryCustomerID, sc.customerID 
	FROM tblSecondaryCustomer sc
	INNER JOIN @secGroup4ID sg4 ON sg4.customerID = sc.secGroup4ID
	WHERE @dateStart between sc.validFrom and sc.validTo 

	DECLARE @custList AS CustomerList
	INSERT INTO @custList
	SELECT DISTINCT customerid FROM @secCustList

	SELECT 
		CASE sysacc.sysUomClientCode WHEN 'CTN' 
			THEN (sum(sec.sctInvQtyEa) / prd.prdConversionFactor) * sysacc.sysAmount
			ELSE sum(sec.sctInvQtyEa)  * sysacc.sysAmount
		END tQTY, 
		sec.productID, 
		prd.prdGroup7ID, 
		prd.prdGroup9ID, 
		prd.prdGroup4ID, 
		prd.prdGroup21ID, 
		prd.prdGroup14ID, 
		prd.prdParentCode
	FROM tblSecTrans AS sec
	INNER JOIN @productIDs pid on pid.productID = sec.productID
	INNER JOIN @secCustList sc ON sc.secondaryCustomerID = sec.secondaryCustomerID
	INNER JOIN tblProduct AS prd ON sec.productID = prd.productID
	INNER JOIN dbo.fn_GetSysAmountByProductAndCustomer(@custList, @productIDs, @dateStart) AS sysacc ON sec.productID = sysacc.productid
	GROUP BY sec.productID, 
		prd.prdConversionFactor, 
		sysacc.sysUomClientCode,
		sysacc.sysAmount, 
		prd.prdGroup7ID, 
		prd.prdGroup9ID, 
		prd.prdGroup4ID, 
		prd.prdGroup21ID, 
		prd.prdGroup14ID, 
		prd.prdParentCode
END

