-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 11 July 2014
-- Description:	Get average sysamount grouped by product id and sysUOMClientCode
-- =============================================
CREATE FUNCTION [dbo].[fn_GetSysAmountByPromotionIDAndCustomerID]
(	
@PromotionID int,
@ProductID int = 0,
@CustomerID int = 0
)
RETURNS TABLE 
AS
RETURN 
(
with tbl1 (rownumber, productid, sysUomClientCode, sysAmount, sysAmountWOTax, comPriority, customerID, cusGroup1ID, cusGroup4ID, cusGroup7ID)
as
(
	select 
	ROW_NUMBER() over (partition by prd.prdproductID, cust.customerID order by prd.prdproductID, cust.customerID, combi.comPriority)
	,prd.prdproductid productID, sysUomClientCode, acc.sysAmount + (acc.sysAmount * cusGST * prdm.prdGST) sysAmount, 
	acc.sysAmount sysAmountWOTax,
	combi.comPriority, cust.customerID, cust.cusGroup1ID, cust.cusGroup4ID, cust.cusGroup7ID
	from 
	tblPromotionProductSelection prd  WITH (NOLOCK) 
	inner join tblProduct prdM  WITH (NOLOCK) on prd.prdProductID = prdM.productID and promotionID = @PromotionID
	left outer join tblProduct prdParent  WITH (NOLOCK) on prdParent.prdParentCode = replace(replace(prdM.prdParentCode, '_BASE', ''), '_PROMO', '') 
	inner join tblSystemAccrual acc  WITH (NOLOCK) on acc.productID in (prdm.productID, prdparent.productID)
	inner join tblSetCombination combi  WITH (NOLOCK) on combi.combinationID = acc.combinationID
	inner join (select distinct customerid, cusgroup1ID, cusgroup4id, cusgroup7id, cusGST from dbo.fn_GetCustomerIDsByPromotionID (@PromotionID)) cust on 
		(cust.customerID = @CustomerID or @CustomerID = 0) AND (
		(acc.customerID is null or (acc.customerID = cust.customerID)) and 
		(acc.cusGroup1ID is null or (cust.cusGroup1ID = acc.cusGroup1ID)) and 
		(acc.cusGroup4ID is null or (cust.cusGroup4ID = acc.cusGroup4ID)) and 
		(acc.cusGroup7ID is null or (cust.cusGroup7ID = acc.cusGroup7ID)))
	where (sysDelete = '' or sysDelete is null) and acc.sysCurrency = 'MYR' and acc.pnlID = 102012 
	and (select prmDateStart from tblPromotion WITH (NOLOCK) where promotionID = @PromotionID) between acc.validFrom and acc.validTo	
),
tbl2 as
(
	select 
	ROW_NUMBER() over (partition by productID,sysUomClientCode order by sysAmount desc) rownumber2
	,* 
	from tbl1  WITH (NOLOCK) 
	where rownumber = 1
)
select productid, sysAmount, sysAmountWOTax, sysUomClientCode, combi.combinationID
from tbl2  WITH (NOLOCK) 
inner join tblSetCombination combi on combi.comPriority = tbl2.comPriority
where rownumber2 = 1
--union
--select prdProductID, tbl2.price sysAmount, tbl2.sysUomClientCode, null
--from tblPromotionProductSelection,
--(
--select sysUomClientCode, 
--max(case sysUomClientCode 
--	when 'CTN' then sysAmount
--	when 'EA' then sysAmount / prd.prdConversionFactor
--end) price
--from tbl2
--inner join tblSetCombination combi on combi.comPriority = tbl2.comPriority
--inner join tblProduct prd on prd.productID = tbl2.productid
--where rownumber2 = 1
--group by sysUomClientCode) tbl2
--where promotionID = @promotionID
--and prdProductID not in 
--(
--select productid
--from tbl2
--inner join tblSetCombination combi on combi.comPriority = tbl2.comPriority
--where rownumber2 = 1
--)
)

