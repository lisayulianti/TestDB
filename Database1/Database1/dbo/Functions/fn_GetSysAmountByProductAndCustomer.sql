-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 30 Sep 2014
-- Description:	To get prices for products-customers
-- =============================================
CREATE FUNCTION [dbo].[fn_GetSysAmountByProductAndCustomer]
(	
	@CustomerIDs CustomerList READONLY,
	@ProductIDs ProductList READONLY,
	@DateStart datetime
)
RETURNS TABLE 
AS
RETURN 
(

with tbl as
(
	select max(cusGST) cusGST
	from @CustomerIDs pcust 
	inner join tblCustomer cust on cust.customerID = pcust.customerId
)
--tbl1-- (rownumber, productid, sysUomClientCode, sysAmount, sysAmountWOTax, comPriority, customerID, cusGroup1ID, cusGroup4ID, cusGroup7ID)
--as
--(
	select
	productid, sysAmount, sysAmountWOTax, sysUomClientCode, combi.combinationID
	from 
	(
		select 
		ROW_NUMBER() over (partition by productID,sysUomClientCode order by sysAmount desc) rownumber2,
		*
		from
		(
		select 
		ROW_NUMBER() over (partition by prd.productID, cust.customerID order by prd.productID, cust.customerID, combi.comPriority) rowNumber
		,prd.productid productID, sysUomClientCode, acc.sysAmount + (acc.sysAmount * tbl.cusGST * prdm.prdGST) sysAmount, 
		acc.sysAmount sysAmountWOTax,
		combi.comPriority, cust.customerID, cust.cusGroup1ID, cust.cusGroup4ID, cust.cusGroup7ID
		from 
		@ProductIDs prd  
		inner join tblProduct prdM  WITH (NOLOCK) on prd.productID = prdM.productID 
		left outer join tblProduct prdParent  WITH (NOLOCK) on prdParent.prdParentCode = replace(replace(prdM.prdParentCode, '_BASE', ''), '_PROMO', '') 
		inner join tblSystemAccrual acc  WITH (NOLOCK) on acc.productID in (prdm.productID, prdparent.productID)
		inner join tblSetCombination combi  WITH (NOLOCK) on combi.combinationID = acc.combinationID
		inner join (select c1.customerID, cusGroup1ID, cusGroup4ID, cusGroup7ID, cusGST from @CustomerIDs c1 inner join tblCustomer c2 on c1.customerID = c2.customerID) cust on 
			(acc.customerID is null or (acc.customerID = cust.customerID)) and 
			(acc.cusGroup1ID is null or (cust.cusGroup1ID = acc.cusGroup1ID)) and 
			(acc.cusGroup4ID is null or (cust.cusGroup4ID = acc.cusGroup4ID)) and 
			(acc.cusGroup7ID is null or (cust.cusGroup7ID = acc.cusGroup7ID))
		, tbl
		where (sysDelete = '' or sysDelete is null) and acc.sysCurrency = 'MYR' and acc.pnlID = 102012 
		and @DateStart between acc.validFrom and acc.validTo	
		) tbl1
		where rownumber = 1
	) tbl2
	inner join tblSetCombination combi on combi.comPriority = tbl2.comPriority
	where rownumber2 = 1
--) select * from tbl1
--tbl2 as
--(
	--select 
	--ROW_NUMBER() over (partition by productID,sysUomClientCode order by sysAmount desc) rownumber2
	--* 
	--from tbl1  WITH (NOLOCK) 
	--where rownumber = 1
--)
--select productid, sysAmount, sysAmountWOTax, sysUomClientCode, combi.combinationID
--from tbl2  WITH (NOLOCK) 
--inner join tblSetCombination combi on combi.comPriority = tbl2.comPriority
--where rownumber2 = 1
)

