-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Generate Free Good Cap Cost based on Promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateFreeGoodsCapCostByPromotion] 
	@promotionId INT	, @resultFee FLOAT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;   	

	Declare @fee FLOAT
    Declare @uomId INT
	Declare @freeGoodsPerProduct FLOAT
	Declare @freeGoodsCap FLOAT
	Declare @maxPrice FLOAT
	Declare @maxPriceEA FLOAT

	SET @maxPrice = 
		(select max( 
		(
			CASE WHEN sysUomClientCode = 'CTN' then sysAmount
			WHEN sysUomClientCode = 'EA' then sysAmount*prod.prdConversionFactor
			END
		)) CTNAmount
		from dbo.fn_GetMaxSysAmountByPromotion(@promotionId,0) msa 
		inner join tblProduct prod  WITH (NOLOCK) on msa.productid = prod.productID)

		
	SET @maxPriceEA = 
		(select max( 
		(
			CASE WHEN sysUomClientCode = 'CTN' then sysAmount/prod.prdConversionFactor
			WHEN sysUomClientCode = 'EA' then sysAmount
			END
		)) CTNAmount
		from dbo.fn_GetMaxSysAmountByPromotion(@promotionId,0) msa
		inner join tblProduct prod  WITH (NOLOCK) on msa.productid = prod.productID)



	SET @uomId  = (SELECT TOP 1 detFreegoodscapunit
	FROM tblPromotionDetails  WITH (NOLOCK) where promotionId = @promotionId)

	SET @freeGoodsCap = (SELECT TOP 1 detFreegoodscap
	FROM tblPromotionDetails  WITH (NOLOCK) where promotionId = @promotionId)
	-- ==== STEP 1 ====
	-- Check Free Goods Cap Amount, if the unit type is MYR (102000004)
	-- Use the amount.

	IF @uomId = 102000004 -- FREE GOODS CAP UNIT MYR
	BEGIN	
	SELECT @fee = sum(isnull(freeGoodsCap.amount,0))
	FROM
	(
		SELECT tpd.detPrdProductField, tpd.detPrdProductValue,
			   max(isnull(tpd.detFreegoodscap,0)) as amount
		FROM tblPromotionDetails tpd  WITH (NOLOCK) 
		where tpd.promotionId = @promotionId
		group by tpd.detPrdProductField, tpd.detPrdProductValue
	) freeGoodsCap

	select @fee

	END	

	ELSE IF @uomId = 102000002 -- FREE GOODS CAP UNIT CTN
	BEGIN
	SELECT @fee = sum(isnull(freeGoodsCap.amount,0)) * @maxPrice
	FROM
	(
		SELECT tpd.detPrdProductField, tpd.detPrdProductValue,
			   max(isnull(tpd.detFreegoodscap,0)) as amount
		FROM tblPromotionDetails tpd  WITH (NOLOCK) 
		where tpd.promotionId = @promotionId
		group by tpd.detPrdProductField, tpd.detPrdProductValue
	) freeGoodsCap
	select @fee
	END

	ELSE IF @uomId = 102000003 -- FREE GOODS CAP UNIT EACH
	BEGIN
	SELECT @fee = sum(isnull(freeGoodsCap.amount,0)) * @maxPriceEA
	FROM
	(
		SELECT tpd.detPrdProductField, tpd.detPrdProductValue,
			   max(isnull(tpd.detFreegoodscap,0)) as amount
		FROM tblPromotionDetails tpd  WITH (NOLOCK) 
		where tpd.promotionId = @promotionId
		group by tpd.detPrdProductField, tpd.detPrdProductValue
	) freeGoodsCap
	select @fee
	END


	ELSE
	BEGIN	
	SELECT
			@fee = SUM
			(
				CASE when tpd.detFreegoodsunit = 102000002 -- CTN
					 then (tpd.detFreegoodsamount * ((pvs.volVolumeP2Plan * pvs.volParticipationpercentagePlan) / 100)
					  / 
					  (
					  	(case when isnull(tpd.detVolumeReq,1)=0 then 1
						  else isnull(tpd.detVolumeReq,1) end)						 
					  )
					  *@maxPrice) 			 
					 
					 when tpd.detFreegoodsunit = 102000003 -- EACH
					 then (tpd.detFreegoodsamount * ((pvs.volVolumeP2Plan * pvs.volParticipationpercentagePlan) / 100)
					  / 
					  (
					  	(case when isnull(tpd.detVolumeReq,1)=0 then 1
						  else isnull(tpd.detVolumeReq,1) end)						 
					  )
					  *					  
					   @maxPriceEA) 				 
										
				END
			)		
		FROM tblPromotionDetails tpd  WITH (NOLOCK) inner join tblProduct prod  WITH (NOLOCK) on tpd.productID = prod.productID
		and tpd.promotionID = @promotionId inner join tblPromoVolumeSelection pvs on tpd.productId = pvs.productID and pvs.promotionID = @promotionId		
		inner join tblPromotion promotion on tpd.promotionId = promotion.promotionID
	END
	 
	--SELECT isnull(@fee,0)
	SET @resultFee = isnull(@fee,0)
END



