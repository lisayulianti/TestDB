-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <26th August 2014>
-- Description:	Fetch Relevant tblActual records for Cost Tab
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchRelevantTblActual]
	@prmPromotionClientCode NVARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;
	select act.pnlId as PnlId,
	map.finGeneralLedgerCodeBSh,
	map.finconditiontype,
	act.actAmount as Amount
	from tblPromotionPnlMapping map  WITH (NOLOCK) 
	inner join tblSetPnl setpnl  WITH (NOLOCK) on
	map.finGeneralLedgerCodeBSh = setpnl.pnlPnlActGL
	and map.finConditionType = setpnl.pnlpnlactcond
	inner join tblActual act  WITH (NOLOCK) on act.pnlid = setpnl.pnlid
	where act.actHeader = @prmPromotionClientCode
	UNION
	select acw.pnlId as PnlId,
	map.finGeneralLedgerCodeBSh,
	map.finconditiontype,
	acw.acwAmount as Amount
	from tblPromotionPnlMapping map  WITH (NOLOCK) 
	inner join tblSetPnl setpnl  WITH (NOLOCK) on
	map.finGeneralLedgerCodeBSh = setpnl.pnlPnlActGL
	and map.finConditionType = setpnl.pnlpnlactcond
	inner join tblActualTwo acw  WITH (NOLOCK) on acw.pnlid = setpnl.pnlid
	where acw.acwHeader = @prmPromotionClientCode
END





