-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 11 July 2014
-- Description:	Get average sysamount grouped by product id and sysUOMClientCode
-- =============================================
CREATE FUNCTION [dbo].[fn_GetSysAmount]
(	
)
RETURNS TABLE 
AS
RETURN 
(
	select tbl.productid, max(sysAmount) sysAmount, tbl.sysUomClientCode, combi.combinationID, acc.customerID, acc.cusGroup1ID, acc.cusGroup4ID, acc.cusGroup7ID,
		acc.validFrom, acc.validTo
		from tblSystemAccrual acc
	inner join
	(
	select productid, sysUomClientCode, min(combi.comPriority) comPriority, cust.customerID, cust.cusGroup1ID, cust.cusGroup4ID, cust.cusGroup7ID,
		acc.validFrom, acc.validTo
	from tblSystemAccrual acc
	inner join tblCustomer cust on 
		(acc.customerID is null or (acc.customerID = cust.customerID)) and 
		(acc.cusGroup1ID is null or (cust.cusGroup1ID = acc.cusGroup1ID)) and 
		(acc.cusGroup4ID is null or (cust.cusGroup4ID = acc.cusGroup4ID)) and 
		(acc.cusGroup7ID is null or (cust.cusGroup7ID = acc.cusGroup7ID))
	inner join tblSetCombination combi on combi.combinationID = acc.combinationID
	where 
	acc.sysCurrency = 'MYR' and acc.pnlID = 102012 
	--and (@date is null or @date between acc.validFrom and acc.validTo)
	group by productid, sysUomClientCode, cust.customerID, cust.cusGroup1ID, cust.cusGroup4ID, cust.cusGroup7ID,acc.validFrom, acc.validTo
	) tbl on tbl.productID = acc.productID and tbl.sysUomClientCode = acc.sysUomClientCode and
		(
		(acc.customerID is null or (acc.customerID = tbl.customerID)) and 
		(acc.cusGroup1ID is null or (tbl.cusGroup1ID = acc.cusGroup1ID)) and 
		(acc.cusGroup4ID is null or (tbl.cusGroup4ID = acc.cusGroup4ID)) and 
		(acc.cusGroup7ID is null or (tbl.cusGroup7ID = acc.cusGroup7ID))
		)
	inner join tblSetCombination combi on combi.comPriority = tbl.comPriority and combi.combinationID = acc.combinationID
	group by tbl.productID, tbl.sysUomClientCode, combi.combinationID, acc.customerID, acc.cusGroup1ID, acc.cusGroup4ID, acc.cusGroup7ID,acc.validFrom, acc.validTo
)



