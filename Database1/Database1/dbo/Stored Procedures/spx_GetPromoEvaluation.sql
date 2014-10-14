-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 16 July 2014
-- Description:	To get promo evaluation
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetPromoEvaluation]-- 10460, 102
@promotionID int,
@countryID int
AS
BEGIN

SET NOCOUNT ON;

if exists (select top 1 promotionID from tblPromoProfitAndLoss where promotionID = @promotionID and finAmount <> 0)
begin

	select *,
	dateadd(day, -datediff(day, PActualStart, PActualEnd)-1, PActualStart) P1Start,
	dateadd(day, -1, PActualStart) P1End,
	dateadd(day, 1, PActualEnd) P3Start,
	dateadd(day, datediff(day, PActualStart, PActualEnd)+1, PActualEnd) P3End
	from 
	(
	select promotionID,
	prm.prmDateStart P2Start,
	prm.prmDateEnd P2End,
	isnull(prm.prmDateActualStart,prm.prmDateStart) PActualStart,
	isnull(prm.prmDateActualEnd, prm.prmDateEnd) PActualEnd,
	prmStatusID,
	((prm.prmGP + prmListingFees) / prm.prmGrossSales) GPTarget
	from tblPromotion prm WITH (NOLOCK)
	where prm.promotionID = @promotionID and countryID = @countryID
	) AA

	Select
	promotionID, finCostTypeID, 
		evaGSV, evaNSV, evaGP,
		evaROI,
		evaKPItwo,
		evaKPIthree,
		case when isnull(evaNSV,0) <> 0 then (evaGP / isnull(evaNSV,1)) * 100 else 0 end evaNSPerc
	from tblPromoEvaluation prmeval WITH (NOLOCK)
	where prmeval.promotionID = @promotionID
	union
	select promotionID, finCostTypeID, GrossSales, TotalNetSales, GrossProfit, null, null, null, (GrossProfit/TotalNetSales) * 100 from 
	(
	select
	promotionid, finCostTypeID, replace(pnlitem, ' ', '') pnlitem, finAmount
	from tblPromoProfitAndLoss pnl WITH (NOLOCK)
	where pnl.promotionID = @promotionID
	and finCostTypeID = 0
	and pnlitem in ('Gross Sales', 'Total Net Sales', 'Gross Profit')
	) p
	pivot 
	(
		avg(finAmount)
		for pnlItem in 
		(
			GrossProfit,
			GrossSales,
			TotalNetSales
		)
	)
	pvt
	order by finCostTypeID

	Declare @NS0 as float
	Declare @NS1 as float
	Declare @NS2 as float

	select @NS0 = finAmount
	from tblPromoProfitAndLoss
	where promotionID = @promotionID
	and pnlitem = 'Total Net Sales'
	and finCostTypeID = 0

	select @NS1 = finAmount
	from tblPromoProfitAndLoss WITH (NOLOCK)
	where promotionID = @promotionID
	and pnlitem = 'Total Net Sales'
	and finCostTypeID = 1

	select @NS2 = finAmount
	from tblPromoProfitAndLoss WITH (NOLOCK)
	where promotionID = @promotionID
	and pnlitem = 'Total Net Sales'
	and finCostTypeID = 2

	--select *
	--from tblPromoProfitAndLoss
	--where promotionID = @promotionID
	--and pnlitem = 'Total Net Sales'


	select
	FBase as P1Base, F1 as P1Plan, F3a as P1Actual, F3b as P1ActualSellOut,
	FBase as P2Base, @NS1 - F1 - F2 as P2Plan, @NS2 - F3a - F4a as P2Actual, @NS2 - F3b - F4b as P2ActualSellOut,
	FBase as P3Base, F2 as P3Plan, F4a as P3Actual, F4b as P3ActualSellOut
	from
	(
	select 
	promotionID,
	@NS0 / 3 FBase, 
	((@NS0 / 3) / volumeP1Base) * volumeP1Plan F1, 
	((@NS0 / 3) / volumeP3Base) * volumeP3Plan F2, 
	((@NS0 / 3) / volumeP1Base) * volumeP1Actual F3a,
	((@NS0 / 3) / volumeP3Base) * volumeP3Actual F4a,
	((@NS0 / 3) / volumeP1Base) * volumeP1ActualSellOut F3b,
	((@NS0 / 3) / volumeP3Base) * volumeP3ActualSellOut F4b
	from
	(
	select promotionID, 
	sum(prmvol.volVolumeP1Base) volumeP1Base, 
	sum(prmvol.volVolumeP1Plan) volumeP1Plan,
	sum(isnull(prmvol.volVolumeP1Actual,0)) volumeP1Actual,
	sum(isnull(prmvol.volVolumeP1ActualSellOut,0)) volumeP1ActualSellOut,
	sum(prmvol.volVolumeP2Base) volumeP2Base, 
	sum(prmvol.volVolumeP2Plan) volumeP2Plan,
	sum(isnull(prmvol.volVolumeP2Actual,0)) volumeP2Actual,
	sum(isnull(prmvol.volVolumeP2ActualSellOut,0)) volumeP2ActualSellOut,
	sum(prmvol.volVolumeP3Base) volumeP3Base, 
	sum(prmvol.volVolumeP3Plan) volumeP3Plan,
	sum(isnull(prmvol.volVolumeP3Actual,0)) volumeP3Actual,
	sum(isnull(prmvol.volVolumeP3ActualSellOut,0)) volumeP3ActualSellOut
	from tblPromoVolumeSelection prmvol WITH (NOLOCK)
	where promotionID = @promotionID
	group by promotionID
	) vol
	) vol2

	Select
	promotionID,
	evaPreEvaluationNotes,
	evaPostEvaluationLearnings1,
	evaPostEvaluationLearnings2,
	evaPostEvaluationLearnings3,
	evaConclusion
	from tblPromoEvaluationResult WITH (NOLOCK)
	where promotionID = @promotionID
end
--spx_GetPromoEvaluation 4, 102
END
