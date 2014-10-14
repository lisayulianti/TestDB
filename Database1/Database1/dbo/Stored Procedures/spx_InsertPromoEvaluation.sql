-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 16 July 2014
-- Description:	To insert promo evaluation
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromoEvaluation] --7397, 102
@PromotionID int,
@CountryID int
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

if exists (select top 1 promoProfitAndLossID from tblPromoProfitAndLoss where promotionID = @PromotionID)
begin

	if exists (select top 1 promoEvaluationID from tblPromoEvaluation where promotionid = @promotionID)
	begin
		delete tblPromoEvaluation where promotionID = @promotionID
	end

	Declare @GP0 as float
	Declare @NS0 as float

	Select @GP0 = finAmount
	from tblPromoProfitAndLoss
	where promotionID = @promotionID and pnlitem = 'Gross Profit' and finCostTypeID = 0

	Select @NS0 = finAmount
	from tblPromoProfitAndLoss
	where promotionID = @promotionID and pnlitem = 'Total Net Sales' and finCostTypeID = 0

	--select @GP0 GP0, @NS0 NS0

	insert into tblPromoEvaluation 
	(promotionID, finCostTypeID, 
	evaGSV, evaNSV, evaGP,
	evaROI,
	evaKPItwo,
	evaKPIthree
	)
	select 
	pvt.promotionID, pvt.finCostTypeID,
	pvt.GrossSales as evaGSV, pvt.TotalNetSales as evaNSP, pvt.GrossProfit as evaGP,
	case when prmfin.finAmount > 0 then ((pvt.GrossProfit - @GP0) + pvt.[A&P]) / prmfin.finAmount else 0 end as evaROI, 
	case when prmfin.finAmount > 0 then (pvt.TotalNetSales - @NS0) / prmfin.finAmount else 0 end as evaKPItwo, 
	pvt.[GP%]/((prm.prmGP+isnull(prm.prmListingFees,0))/isnull(prm.prmGrossSales,1)) as evaKPIthree
	from
	(
	select
	promotionid, finCostTypeID, replace(pnlitem, ' ', '') pnlitem, finAmount
	from tblPromoProfitAndLoss pnl
	where pnl.promotionID = @PromotionID
	and finCostTypeID in (1,2,5)
	and pnlitem in ('Gross Sales', 'Total Net Sales', 'Gross Profit', 'A & P', 'GP %')
	) p
	pivot 
	(
		avg(finAmount)
		for pnlItem in 
		(
			[A&P],
			[GP%],
			GrossProfit,
			GrossSales,
			TotalNetSales
		)
	)
	pvt
	inner join tblPromotion prm on prm.promotionID = pvt.promotionID and prm.countryID = @countryID
	left outer join 
	(
		select promotionID, finCostTypeID, sum(finAmount) finAmount 
		from tblPromoFinancial fin 
		where fin.promotionID = @promotionID and fin.finCostTypeID in (1,2)
		group by fin.promotionID, fin.finCostTypeID
		union
		select promotionID, 5 finCostTypeID, sum(finAmount) finAmount 
		from tblPromoFinancial fin 
		where fin.promotionID = @promotionID and fin.finCostTypeID = 2
		group by fin.promotionID, fin.finCostTypeID
	) prmfin on prmfin.promotionID = prm.promotionID and prmfin.finCostTypeID = pvt.finCostTypeID

end

END



