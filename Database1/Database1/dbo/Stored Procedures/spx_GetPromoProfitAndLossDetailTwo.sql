-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 25-July-2014
-- Description:	To get the detail of a PnL item
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromoProfitAndLossDetailTwo]  --7432, 0
@PromotionID int,
@IncludeActual bit = 1
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

Declare @NS0 as float, @NS1 as float, @NS2 as float, @NS5 as float
select @NS0 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 0 and pnlitem = 'Gross Sales'
select @NS1 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 1 and pnlitem = 'Gross Sales'
select @NS2 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 2 and pnlitem = 'Gross Sales'
select @NS5 = finAmount from tblPromoProfitAndLossTwo where promotionID = @PromotionID and finCostTypeID = 5 and pnlitem = 'Gross Sales'

Declare @tblTemp as table
(
	promotionID int,
	PnLSubItem varchar(50),
	pnlItem varchar(50),
	finCostTypeID float,
	finAmount float,
	pnlOrder int,
	pnlSubOrder int
)

insert into @tblTemp
select 
@PromotionID promotionID, helper.PnLSubDesc pnlSubItem, helper.pnlItem, 0 as 'finCostTypeId', isnull(finAmount,0) finAmount, pnlOrder, PnLSubOrder
from tblProfitAndLossHelper helper 
left join (select * from tblPromoProfitAndLossDetailTwo where promotionID = @promotionID and finCostTypeID = 0) pnlDetail 
	on helper.PnLSubGroupItem = pnldetail.pnlSubItem
where helper.PnLSubGroupItem is not null
union
select 
@PromotionID promotionID, helper.PnLSubDesc, helper.PnLItem, 1, isnull(finAmount,0) finAmount, pnlOrder, PnLSubOrder
from tblProfitAndLossHelper helper 
left join (select * from tblPromoProfitAndLossDetailTwo where promotionID = @promotionID and finCostTypeID = 1) pnlDetail 
	on helper.PnLSubGroupItem = pnldetail.pnlSubItem
where helper.PnLSubGroupItem is not null
union
select 
@PromotionID promotionID, helper.PnLSubDesc, helper.PnLItem, 2, isnull(finAmount,0) finAmount, pnlOrder, PnLSubOrder
from tblProfitAndLossHelper helper 
left join (select * from tblPromoProfitAndLossDetailTwo where promotionID = @promotionID and finCostTypeID = 2) pnlDetail 
	on helper.PnLSubGroupItem = pnldetail.pnlSubItem
where helper.PnLSubGroupItem is not null and @IncludeActual = 1
union
select 
@PromotionID promotionID, helper.PnLSubDesc, helper.PnLItem, 3, isnull(finAmount,0) finAmount, pnlOrder, PnLSubOrder
from tblProfitAndLossHelper helper 
left join (select * from tblPromoProfitAndLossDetailTwo where promotionID = @promotionID and finCostTypeID = 5) pnlDetail 
	on helper.PnLSubGroupItem = pnldetail.pnlSubItem
where helper.PnLSubGroupItem is not null and @IncludeActual = 1
union
select 
@PromotionID promotionID, helper.PnLSubDesc, helper.PnLItem, 1.5 finCostTypeID, isnull(finAmount,0) finAmount, pnlOrder, PnLSubOrder
from tblProfitAndLossHelper helper 
left join (
select detail1.pnlSubItem, 1.5 finCostTypeID, detail2.finAmount - detail1.finAmount finAmount from
(
select * from tblPromoProfitAndLossDetailTwo where promotionID = @PromotionID and finCostTypeID = 0
) detail1
inner join 
(
select * from tblPromoProfitAndLossDetailTwo where promotionID = @PromotionID and finCostTypeID = 1
) detail2 on detail1.pnlSubItem = detail2.pnlSubItem) pnlDetail 
	on helper.PnLSubGroupItem = pnldetail.pnlSubItem
where helper.PnLSubGroupItem is not null
union
select 
@PromotionID promotionID, helper.PnLSubDesc, helper.PnLItem, 2.5, isnull(finAmount,0) finAmount, pnlOrder, PnLSubOrder
from tblProfitAndLossHelper helper 
left join (
select detail1.pnlSubItem, 2.5 finCostTypeID, detail2.finAmount - detail1.finAmount finAmount from
(
select * from tblPromoProfitAndLossDetailTwo where promotionID = @PromotionID and finCostTypeID = 0
) detail1
inner join 
(
select * from tblPromoProfitAndLossDetailTwo where promotionID = @PromotionID and finCostTypeID = 2
) detail2 on detail1.pnlSubItem = detail2.pnlSubItem) pnlDetail 
	on helper.PnLSubGroupItem = pnldetail.pnlSubItem
where helper.PnLSubGroupItem is not null and @IncludeActual = 1
union
select 
@PromotionID promotionID, helper.PnLSubDesc, helper.PnLItem, 3.5, isnull(finAmount,0) finAmount, pnlOrder, PnLSubOrder
from tblProfitAndLossHelper helper 
left join (
select detail1.pnlSubItem, 3.5 finCostTypeID, detail2.finAmount - detail1.finAmount finAmount from
(
select * from tblPromoProfitAndLossDetailTwo where promotionID = @PromotionID and finCostTypeID = 0
) detail1
inner join 
(
select * from tblPromoProfitAndLossDetailTwo where promotionID = @PromotionID and finCostTypeID = 5
) detail2 on detail1.pnlSubItem = detail2.pnlSubItem) pnlDetail 
	on helper.PnLSubGroupItem = pnldetail.pnlSubItem
where helper.PnLSubGroupItem is not null and @IncludeActual = 1
order by helper.PnLOrder, helper.PnLSubOrder, helper.PnLSubDesc, finCostTypeID

select 
*
from @tblTemp
where (finCostTypeID < 2
or (finCostTypeID >= 2 and @IncludeActual = 1))
union
select 
 promotionID, pnlSubItem, pnlItem, 
case finCostTypeID 
	when 0 then 6
	when 1 then 7
	when 2 then 8
	when 3 then 9
end finCostTypeID, 
case finCostTypeID 
	when 0 then case when @NS0 > 0 then finAmount / @NS0 else 0 end
	when 1 then case when @NS1 > 0 then finAmount / @NS1 else 0 end
	when 2 then case when @NS2 > 0 then finAmount / @NS2 else 0 end
	when 3 then case when @NS5 > 0 then finAmount / @NS5 else 0 end
end finAmount, pnlOrder, PnLSubOrder
from @tblTemp 
where (finCostTypeID in (0,1)
or (finCostTypeID in (2,3) and @IncludeActual = 1))
union
select 
tbl1.promotionID, tbl1.PnLSubItem, tbl1.pnlItem,
7.5 finCostTypeID, tbl2.finAmount - tbl1.finAmount finAmount, tbl1.pnlorder, tbl1.pnlSubOrder
from
(
select 
 promotionID, pnlSubItem, pnlItem, 
 finCostTypeID, 
 case when @NS0 > 0 then finAmount / @NS0 else 0 end
 finAmount, pnlOrder, PnLSubOrder
from @tblTemp 
where (finCostTypeID = 0)
)tbl1
inner join
(
select 
 promotionID, pnlSubItem, pnlItem, 
 finCostTypeID, 
 case when @NS1 > 0 then finAmount / @NS1 else 0 end
 finAmount, pnlOrder, PnLSubOrder
from @tblTemp 
where (finCostTypeID = 1)
)tbl2 on tbl1.pnlItem = tbl2.pnlItem and tbl1.PnLSubItem = tbl2.PnLSubItem
union
select 
tbl1.promotionID, tbl1.PnLSubItem, tbl1.pnlItem,
8.5 finCostTypeID, tbl2.finAmount - tbl1.finAmount finAmount, tbl1.pnlorder, tbl1.pnlSubOrder
from
(
select 
 promotionID, pnlSubItem, pnlItem, 
 finCostTypeID, 
 case when @NS0 > 0 then finAmount / @NS0 else 0 end
 finAmount, pnlOrder, PnLSubOrder
from @tblTemp 
where (finCostTypeID = 0)
)tbl1
inner join
(
select 
 promotionID, pnlSubItem, pnlItem, 
 finCostTypeID, 
 case when @NS2 > 0 then finAmount / @NS2 else 0 end
 finAmount, pnlOrder, PnLSubOrder
from @tblTemp 
where (finCostTypeID = 2 and @IncludeActual = 1)
)tbl2 on tbl1.pnlItem = tbl2.pnlItem and tbl1.PnLSubItem = tbl2.PnLSubItem
union
select 
tbl1.promotionID, tbl1.PnLSubItem, tbl1.pnlItem,
9.5 finCostTypeID, tbl2.finAmount - tbl1.finAmount finAmount, tbl1.pnlorder, tbl1.pnlSubOrder
from
(
select 
 promotionID, pnlSubItem, pnlItem, 
 finCostTypeID, 
 case when @NS0 > 0 then finAmount / @NS0 else 0 end
 finAmount, pnlOrder, PnLSubOrder
from @tblTemp 
where (finCostTypeID = 0)
)tbl1
inner join
(
select 
 promotionID, pnlSubItem, pnlItem, 
 finCostTypeID, 
 case when @NS5 > 0 then finAmount / @NS5 else 0 end
 finAmount, pnlOrder, PnLSubOrder
from @tblTemp 
where (finCostTypeID = 3 and @IncludeActual = 1)
)tbl2 on tbl1.pnlItem = tbl2.pnlItem and tbl1.PnLSubItem = tbl2.PnLSubItem
order by PnLOrder, PnLSubOrder, PnLSubItem, finCostTypeID

END



