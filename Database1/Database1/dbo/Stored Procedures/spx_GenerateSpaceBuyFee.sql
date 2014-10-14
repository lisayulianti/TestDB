-- =============================================
-- Author:		Anthony Steven
-- Create date: 6-8-2014
-- Description:	Space Buy Fee
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateSpaceBuyFee] 
	@promotionId INT	
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

	SET @fee = (SELECT TOP 1 x.detSpaceBuyFee 
	FROM tblPromotionDetails x where x.promotionID = @promotionId)


	IF isnull(@fee,0) = 0
	BEGIN
		SELECT @fee = sum(isnull(tpdi.detValue,0))		
		FROM tblPromotionDetailsIncentive tpdi where tpdi.promotionId = @promotionId
	END
	
	IF isnull(@fee,0) = 0
	BEGIN
	DECLARE @highestPrices Table
	(
		productID int,
		price float
	)
	insert into @highestPrices
		select products.productID, (case when sa.sysUomClientCode='CTN' then sa.sysAmount
		when sa.sysUomClientCode='EA' then sa.sysAmount*prod.prdConversionFactor end) as price		
		from
		(
			select productID from tblPromotionDetails where promotionId = @promotionId
		)products  inner join @sysAmount sa on products.productID = sa.productID
		inner join tblProduct prod on products.productId = prod.productID
	

	SET @fee = (select sum(dataSource.amount)
				from(
				select tpd.detprdproductfield, tpd.detprdproductvalue, sum(tpd.detNumberofFreeUOMs * (case when tpd.detFreeUOM in (102000002,102000001) then hp.price
					else hp.price/prod.prdConversionFactor end)) as amount	
					from tblPromotionDetails tpd  WITH (NOLOCK) 
					inner join tblProduct prod WITH (NOLOCK)  on tpd.productID = prod.productID
					inner join @highestPrices hp on tpd.productID = hp.productID
					where tpd.promotionId = @promotionId and tpd.detNumberofFreeUOMs is not null
					group by tpd.detPrdProductField, tpd.detPrdProductValue) dataSource)	

	END

	SELECT isnull(@fee,0)

		
END



