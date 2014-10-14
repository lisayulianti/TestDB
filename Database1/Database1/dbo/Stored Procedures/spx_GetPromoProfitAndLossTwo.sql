-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 14 July 2014
-- Description:	Get all PnL of a Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromoProfitAndLossTwo] --7432,102,0
@PromotionID int,
@CountryID int = 102,
@IncludeActual bit = 1
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

if not exists (select top 1 promoProfitAndLossTwoID from tblPromoProfitAndLossTwo where promotionid = @promotionID)
begin
	exec spx_InsertPromoProfitAndLostTwo @PromotionID, @countryID
end

--select 
--prmpnl.promotionID, helper.PnLSubGroup, prmpnl.pnlitem, prmpnl.finCostTypeID, prmpnl.finAmount 
--from tblPromoProfitAndLossTwo prmpnl
--inner join (select distinct pnlSubGroup, pnlItem from tblProfitAndLossHelper) helper on helper.pnlitem = prmpnl.pnlitem
--where promotionID = @PromotionID

Declare @NS0 as float, @NS1 as float, @NS2 as float, @NS5 as float
select @NS0 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 0 and pnlitem = 'Gross Sales'
select @NS1 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 1 and pnlitem = 'Gross Sales'
select @NS2 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 2 and pnlitem = 'Gross Sales'
select @NS5 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 5 and pnlitem = 'Gross Sales'

select promotionID, PnLDesc pnlItem, 
	cast((case when finCostTypeID = 5 then 3 else finCostTypeID end) as float) finCostTypeID, 
	finAmount, helper.PnlGroup, helper.PnLOrder
from
(
select promotionID, pnlItem, finCostTypeID, finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID in (0,1)
or (finCostTypeID in (2,5) and @IncludeActual = 1))
union
select tbl1.promotionID, tbl1.pnlItem, 1.5 finCostTypeID, tbl2.finAmount - tbl1.finAmount finAmount from
(
select * 
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID and finCostTypeID = 0
) tbl1 inner join 
(
select * 
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID and finCostTypeID = 1
) tbl2 on tbl1.pnlitem = tbl2.pnlitem
union
select tbl1.promotionID, tbl1.pnlItem, 2.5 finCostTypeID, tbl2.finAmount - tbl1.finAmount finAmount from
(
select * 
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID and finCostTypeID = 0
) tbl1 inner join 
(
select * 
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID and finCostTypeID = 2
) tbl2 on tbl1.pnlitem = tbl2.pnlitem
where @IncludeActual = 1
union
select tbl1.promotionID, tbl1.pnlItem, 3.5 finCostTypeID, tbl2.finAmount - tbl1.finAmount finAmount from
(
select * 
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID and finCostTypeID = 0
) tbl1 inner join 
(
select * 
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID and finCostTypeID = 5
) tbl2 on tbl1.pnlitem = tbl2.pnlitem
where @IncludeActual = 1
union
select promotionID, pnlItem, 
case finCostTypeID 
	when 0 then 6
	when 1 then 7
	when 2 then 8
	when 5 then 9
end finCostTypeID, 
case finCostTypeID 
	when 0 then case when @NS0 > 0 then finAmount / @NS0 else 0 end
	when 1 then case when @NS1 > 0 then finAmount / @NS1 else 0 end
	when 2 then case when @NS2 > 0 then finAmount / @NS2 else 0 end
	when 3 then case when @NS5 > 0 then finAmount / @NS5 else 0 end
end finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID in (0,1)
or (finCostTypeID in (2,5) and @IncludeActual = 1))
union
select tbl1.promotionID, tbl1.pnlitem, 7.5 finCostTypeId, tbl2.finAmount - tbl1.finAmount finAmount
from
(
select promotionID, pnlItem, 
finCostTypeID, 
case when @NS0 > 0 then finAmount / @NS0 else 0 end finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID = 0)
) tbl1 
inner join 
(
select promotionID, pnlItem, 
finCostTypeID, 
case when @NS1 > 0 then finAmount / @NS1 else 0 end finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID = 1)
) tbl2 on tbl1.pnlitem = tbl2.pnlitem
union
select tbl1.promotionID, tbl1.pnlitem, 8.5 finCostTypeId, tbl2.finAmount - tbl1.finAmount finAmount
from
(
select promotionID, pnlItem, 
finCostTypeID, 
case when @NS0 > 0 then finAmount / @NS0 else 0 end finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID = 0)
) tbl1 
inner join 
(
select promotionID, pnlItem, 
finCostTypeID, 
case when @NS2 > 0 then finAmount / @NS2 else 0 end finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID = 2)
) tbl2 on tbl1.pnlitem = tbl2.pnlitem and @IncludeActual = 1
union
select tbl1.promotionID, tbl1.pnlitem, 9.5 finCostTypeId, tbl2.finAmount - tbl1.finAmount finAmount
from
(
select promotionID, pnlItem, 
finCostTypeID, 
case when @NS0 > 0 then finAmount / @NS0 else 0 end finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID = 0)
) tbl1 
inner join 
(
select promotionID, pnlItem, 
finCostTypeID, 
case when @NS5 > 0 then finAmount / @NS5 else 0 end finAmount
from tblPromoProfitAndLossTwo 
where promotionid = @PromotionID
and (finCostTypeID = 5)
) tbl2 on tbl1.pnlitem = tbl2.pnlitem and @IncludeActual = 1
) tbl inner join (select distinct PnLItem, PnLDesc, PnlGroup, PnLOrder from tblProfitAndLossHelper where PnlGroup is not null) helper on helper.PnLItem = tbl.pnlitem
order by helper.PnLOrder, finCostTypeID

--exec spx_GetPromoProfitAndLossDetail @promotionID = @promotionID

exec spx_GetBudgetOwners @promotionID, @CountryID

END

