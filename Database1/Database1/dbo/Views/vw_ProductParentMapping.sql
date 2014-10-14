CREATE VIEW [dbo].[vw_ProductParentMapping]
AS

select prd.productID, parentPrd.productID as parentProductId
from tblProduct prd inner join tblProduct parentPrd on replace(replace(prd.prdParentCode, '_BASE', ''), '_PROMO', '') = parentPrd.prdParentCode
and prd.productID <> parentPrd.productID



