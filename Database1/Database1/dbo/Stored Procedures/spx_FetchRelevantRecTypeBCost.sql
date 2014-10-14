-- =============================================
-- Author:		<Anthony Steven>
-- Create date: <7th August 2014>
-- Description:	Fetch Relevant tblRecTypeB records for Cost Tab
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchRelevantRecTypeBCost]
	@prmPromotionClientCode NVARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;
	select rtb.pnlID as PnlID,    
           rtbAmount as Amount
    from tblRecTypeB rtb  WITH (NOLOCK) 
	where rtb.rtbHeader = @prmPromotionClientCode
END



