
-- =============================================
-- Author:		Anthony Steven
-- Create date: 17-7-2014
-- Description:	Fetch Fee Accrual
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchFeeAccrual]
	@promotionId INT,
	@feeType INT -- (0:Display Fee, 1:Gondola Fee, 2:Shelf Space Fee, 3: Space Buy Fee)
AS
BEGIN
	SET NOCOUNT ON;	
	DECLARE @fee FLOAT
	SET @fee = -1

	Declare @sysAmount as table
	(
		productID int,
		sysAmount float,
		sysUOMClientCode varchar(10),
		combinationID int
	)
	insert into @sysAmount
	select * from dbo.fn_GetSysAmountValueByPromotionID(@promotionID)


	IF @feeType = 0
	BEGIN
	SET @fee = (SELECT TOP 1 x.detDisplayFee 
	FROM tblPromotionDetails x  WITH (NOLOCK) where x.promotionID = @promotionId)
	
	END
	ELSE IF @feeType = 1
	BEGIN 
	SET @fee = (SELECT TOP 1 x.detGondolaFee 
	FROM tblPromotionDetails x  WITH (NOLOCK) where x.promotionID = @promotionId)
	END
	
	IF @fee is null
	BEGIN
		SELECT 
			isnull(SUM
			(
				CASE
				    WHEN (tpd.detFreeUOM = 102000002 AND sa.sysUomClientCode = 'CTN') OR (tpd.detNumberOfFreeUoms = 102000001 AND sa.sysUomClientCode = 'EA')
						THEN isnull(tpd.detNumberOfFreeUoms,0) * isnull(sa.sysAmount,0)
				    WHEN tpd.detFreeUOM = 102000002 AND sa.sysUomClientCode = 'EA'
						THEN isnull(tpd.detNumberOfFreeUoms,0) * isnull(prod.prdConversionFactor,0) * isnull(sa.sysAmount,0)
					WHEN tpd.detFreeUOM = 102000001 AND sa.sysUomClientCode = 'CTN'
						THEN isnull(tpd.detNumberOfFreeUoms,0) / isnull(prod.prdConversionFactor,0) * isnull(sa.sysAmount,0)
				END
			),0)
		
		FROM tblPromotionDetails tpd  WITH (NOLOCK) inner join tblProduct prod  WITH (NOLOCK) on tpd.productID = prod.productID
		and promotionID = @promotionId
		left join @sysAmount sa on tpd.productID = sa.productid		
	END
    ELSE
		SELECT isnull(@fee,0)

		
END




