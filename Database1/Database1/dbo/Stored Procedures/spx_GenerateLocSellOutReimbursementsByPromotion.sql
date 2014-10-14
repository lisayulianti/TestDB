
CREATE PROCEDURE [dbo].[spx_GenerateLocSellOutReimbursementsByPromotion]
	@promotionId INT, @resultFee FLOAT OUTPUT	
AS
BEGIN
	DECLARE @count INT
	DECLARE @lumpSum FLOAT
	DECLARE @fee FLOAT
	
	Declare @sysAmount as table
	(
		productID int,
		sysAmount float,
		sysUOMClientCode varchar(10),
		combinationID int
	)
	insert into @sysAmount
	select * from dbo.fn_GetSysAmountValueByPromotionID(@promotionID)
	
	SET NOCOUNT ON;    
	BEGIN
	


	SET @lumpSum = (SELECT TOP 1 isnull(x.detLocalisedRebateLumpsum,0)
	from tblPromotionDetails x  WITH (NOLOCK)  where x.promotionId = @promotionId)



	END

	IF @lumpSum = 0
	BEGIN	
	SELECT @fee = isnull((
			SUM
			(
				CASE
				    WHEN (prm.prmUnitID = 102000002 AND sa.sysUomClientCode = 'CTN') OR (prm.prmUnitID = 102000001 AND sa.sysUomClientCode = 'EA')
						THEN (
								((isnull(tpd.detLocalisedRebatePercentage,0)/100) * isnull(sa.sysAmount,0)
								/ 
								(case when tpd.detVolumeReq is null or tpd.detVolumeReq > 0 
								then tpd.detVolumeReq 
								else 1 end))
							) *pvs.volVolumeP2Plan*pvs.volParticipationpercentagePlan/100
				    WHEN prm.prmUnitID  = 102000002 AND sa.sysUomClientCode = 'EA'
						THEN (
								((isnull(tpd.detLocalisedRebatePercentage,0)/100) * isnull(sa.sysAmount,0) * isnull(prod.prdConversionFactor,1)
								/
								(case when tpd.detVolumeReq is null or tpd.detVolumeReq > 0 
								then tpd.detVolumeReq 
								else 1 end))
							)*pvs.volVolumeP2Plan*pvs.volParticipationpercentagePlan/100						
					WHEN prm.prmUnitID  = 102000001 AND sa.sysUomClientCode = 'CTN'
						THEN (
								((isnull(tpd.detLocalisedRebatePercentage,0)/100) * isnull(sa.sysAmount,0) 
								/ 
								isnull(prod.prdConversionFactor,1)
								/
								(case when tpd.detVolumeReq is null or tpd.detVolumeReq > 0 
								then tpd.detVolumeReq
								 else 1 end))
							 )*pvs.volVolumeP2Plan*pvs.volParticipationpercentagePlan/100
				END
			)
		),0)
		FROM tblPromotion prm  WITH (NOLOCK) inner join tblPromotionDetails tpd  WITH (NOLOCK) on prm.promotionID = tpd.promotionID and prm.promotionID=@promotionId 
		inner join tblProduct prod  WITH (NOLOCK) on tpd.productID = prod.productID
		inner join tblPromoVolumeSelection pvs  WITH (NOLOCK) on tpd.productID = pvs.productID and pvs.promotionID = @promotionId left join @sysAmount sa on tpd.productID = sa.productid
	END
	ELSE
	BEGIN
	SET @fee = @lumpSum
	END

	IF @fee = 0
	BEGIN
		select @fee = isnull(sum(case when y.detVolumeReq > 0 then (isnull(y.detLocalisedRebate,0)*(isnull(z.volVolumeP2Plan,0)/(case when y.detVolumeReq is null or y.detVolumeReq > 0 then y.detVolumeReq else 1 end))
		*(isnull(z.volParticipationpercentagePlan,0))/100) 	else 0 end),0)
		from tblPromotion x  WITH (NOLOCK) join tblPromotionDetails y  WITH (NOLOCK) on x.promotionId = y.PromotionID
		inner join tblPromoVolumeSelection z WITH (NOLOCK)  on y.productId = z.productID AND y.promotionId = z.promotionId and x.promotionID = @promotionId
	END

	--select isnull(@fee,0)

	set @resultFee = isnull(@fee,0)
END




