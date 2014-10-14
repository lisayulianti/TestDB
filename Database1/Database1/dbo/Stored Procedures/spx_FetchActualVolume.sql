-- =============================================
-- Author:		Anthony Steven
-- Create date: 18 July 2014
-- Description:	Fetch Actual Volume
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchActualVolume]	
	
	@startDate DATE, --Promotion Start Date
	@endDate DATE, --Promotion End Date
	@transType INT, --Transaction Type (0:Primary, 1:Secondary, 2/4 :External)
	@uomType INT, --Unit of Measurement Type (102000001/102000002:CTN, 102000003:EA, 102000006:Value)
	@sellType INT, -- Sell in / Sell out (0:Sell In, 1: Sell Out)
    @promotionId INT, -- Promotion Id
	@products ProductList READONLY, --Filtered Products
	@customers CustomerList READONLY -- Filtered Customers
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @promotionDays INT 	
	DECLARE	@p1StartDate as DATE
	DECLARE @p3EndDate as DATE
	DECLARE @p1 as float
	DECLARE @p2 as float
	DECLARE @p3 as float


	
	Declare @sysAmount as table
	(
		productID int,
		sysAmount float,
		sysUOMClientCode varchar(10),
		combinationID int
	)
	insert into @sysAmount
	select * from dbo.fn_GetSysAmountValueByPromotionID(@promotionID)

	SET @promotionDays = DATEDIFF(day,@startDate,@endDate)
	SET @p1StartDate = DATEADD(dd,-@promotionDays,@startDate);
	SET @p3EndDate = DATEADD(dd, @promotionDays, @endDate);

	IF @transType = 0   or @transType = 4 -- Primary Transaction		
		IF @sellType = 0 -- Sell In
			BEGIN
				SELECT x.period, x.product, SUM(x.volume) as volume 
				FROM(
					SELECT 
					(
					CASE 
						WHEN pt.dayDate >= @p1StartDate and pt.dayDate < @startDate THEN 'P1'
						WHEN pt.dayDate >= @startDate and pt.dayDate <= @endDate THEN 'P2'
						WHEN pt.dayDate > @endDate and pt.dayDate <= @p3EndDate THEN 'P3'
					END
					) as Period,
					pt.productID as Product,								
					(
					CASE 
						WHEN @uomType = 102000001 or @uomType=102000002 THEN isnull(pt.prtGrossQuantityCtn,0)+(isnull(pt.prtGrossQuantityEa,0)/isnull(prod.prdConversionFactor,1))/1*1
						WHEN @uomType = 102000003 THEN isnull(pt.prtGrossQuantityEa,0)+(isnull(pt.prtGrossQuantityCtn,0)*isnull(prod.prdConversionFactor,1))/1*1
						WHEN @uomType = 102000006 THEN 
							CASE 
								WHEN ts.sysUomClientCode = 'CTN' THEN (((isnull(pt.prtGrossQuantityCtn,0)+(isnull(pt.prtGrossQuantityEa,0)
										/isnull(prod.prdConversionFactor,1))/1)*1))*ts.sysAmount
								WHEN ts.sysUomClientCode = 'EA'  THEN (((isnull(pt.prtGrossQuantityEa,0)+(isnull(pt.prtGrossQuantityCtn,0)
										*isnull(prod.prdConversionFactor,1))/1)*1))*ts.sysAmount		
							END
						
						END) as Volume
						FROM tblPriTrans pt  WITH (NOLOCK) join tblProduct prod  WITH (NOLOCK) on pt.productID = prod.productID 
						left join @sysAmount ts on ts.productid = pt.productID inner join @products x on pt.productID = x.productID		
						inner join @customers c on pt.customerID = c.customerID 
						WHERE pt.dayDate >= @p1StartDate and pt.dayDate <= @p3EndDate
						)x
					GROUP BY x.period, x.product 			
			END
		ELSE IF @transType = 0 and  @sellType = 1 -- Sell Out (Pri Trans)
				BEGIN
					
				SELECT x.period, x.product, SUM(x.volume)  as volume
				FROM 
				(
					SELECT
					(
						CASE 
							WHEN pt.dayDate >= @p1StartDate and pt.dayDate < @startDate THEN 'P1'
							WHEN pt.dayDate >= @startDate and pt.dayDate <= @endDate THEN 'P2'
							WHEN pt.dayDate > @endDate and pt.dayDate <= @p3EndDate THEN 'P3'
						END
					) as Period, pt.productID as Product,
					(
					CASE 
							WHEN @uomType = 102000001 or @uomType=102000002 THEN ((isnull(pt.sctInvQtyEa,0)/isnull(prod.prdConversionFactor,1))/1)*1
							WHEN @uomType = 102000003 THEN ((isnull(pt.sctInvQtyEa,0))/1)*1
							WHEN @uomType = 102000006 THEN 						
									(CASE WHEN ts.sysUomClientCode = 'CTN' THEN (pt.sctInvQtyEa/1/prod.prdConversionFactor * 1)*ts.sysAmount
										WHEN ts.sysUomClientCode = 'EA' THEN (pt.sctInvQtyEa/1 * 1)*ts.sysAmount
										END
										)*1					
					END) as Volume
					FROM tblSecTrans pt  WITH (NOLOCK) join tblProduct prod  WITH (NOLOCK) on pt.productID = prod.productID 
					left join @sysAmount ts on ts.productid = pt.productID  inner join @products x on pt.productID = x.productID
					inner join @customers c on pt.customerID = c.customerID 			
					WHERE pt.dayDate >= @p1StartDate and pt.dayDate <= @p3EndDate 				
				)x
				GROUP BY x.period,x.product
				END
		ELSE IF @transType = 4 and  @sellType = 1 -- Sell Out (Ext Trans)
				BEGIN
					
				SELECT x.period, x.product, SUM(x.volume)  as volume
				FROM 
				(
					SELECT
					(
						CASE 
							WHEN pt.dayDate >= @p1StartDate and pt.dayDate < @startDate THEN 'P1'
							WHEN pt.dayDate >= @startDate and pt.dayDate <= @endDate THEN 'P2'
							WHEN pt.dayDate > @endDate and pt.dayDate <= @p3EndDate THEN 'P3'
						END
					) as Period, pt.productID as Product,
					(
					CASE 
							WHEN @uomType = 102000001 or @uomType=102000002 THEN ((isnull(pt.extSalesQuantityEa,0)/isnull(prod.prdConversionFactor,1))/1)*1
							WHEN @uomType = 102000003 THEN ((isnull(pt.extSalesQuantityEa,0))/1)*1
							WHEN @uomType = 102000006 THEN 						
									(CASE WHEN ts.sysUomClientCode = 'CTN' THEN (pt.extSalesQuantityEa/1/prod.prdConversionFactor * 1)*ts.sysAmount
										WHEN ts.sysUomClientCode = 'EA' THEN (pt.extSalesQuantityEa/1 * 1)*ts.sysAmount
										END
										)*1					
					END) as Volume
					FROM tblExtTrans pt  WITH (NOLOCK) join tblProduct prod  WITH (NOLOCK) on pt.productID = prod.productID 
					left join @sysAmount ts on ts.productid = pt.productID  inner join @products x on pt.productID = x.productID	
					inner join @customers c on pt.customerID = c.customerID 		
					WHERE pt.dayDate >= @p1StartDate and pt.dayDate <= @p3EndDate
				)x
				GROUP BY x.period,x.product
				END
		
		
		
	ELSE IF @transType = 1 -- Secondary Transaction
		BEGIN
					
				SELECT x.period, x.product, SUM(x.volume)  as volume
				FROM 
				(
					SELECT
					(
						CASE 
							WHEN pt.dayDate >= @p1StartDate and pt.dayDate < @startDate THEN 'P1'
							WHEN pt.dayDate >= @startDate and pt.dayDate <= @endDate THEN 'P2'
							WHEN pt.dayDate > @endDate and pt.dayDate <= @p3EndDate THEN 'P3'
						END
					) as Period, pt.productID as Product,
					(
					CASE 
							WHEN @uomType = 102000001 or @uomType=102000002 THEN ((isnull(pt.sctInvQtyEa,0)/isnull(prod.prdConversionFactor,1))/1)*1
							WHEN @uomType = 102000003 THEN ((isnull(pt.sctInvQtyEa,0))/1)*1
							WHEN @uomType = 102000006 THEN 						
									(CASE WHEN ts.sysUomClientCode = 'CTN' THEN (pt.sctInvQtyEa/1/prod.prdConversionFactor * 1)*ts.sysAmount
										WHEN ts.sysUomClientCode = 'EA' THEN (pt.sctInvQtyEa/1 * 1)*ts.sysAmount
										END
										)*1					
					END) as Volume
					FROM tblSecTrans pt  WITH (NOLOCK) join tblProduct prod  WITH (NOLOCK) on pt.productID = prod.productID 
					left join @sysAmount ts on ts.productid = pt.productID  inner join @products x on pt.productID = x.productID
					inner join @customers c on pt.secondaryCustomerID = c.customerID 			
					WHERE pt.dayDate >= @p1StartDate and pt.dayDate <= @p3EndDate
				)x
				GROUP BY x.period,x.product
		END	
	ELSE IF @transType = 2-- External Transaction
	BEGIN
		IF @uomType = 102000001 or @uomType = 102000002-- CTN			
			IF @sellType = 0 -- Sell In
				BEGIN
				SELECT x.period, x.product, SUM(x.volume)  as volume
				FROM(
					SELECT 
					(
					CASE 
						WHEN pt.dayDate >= @p1StartDate and pt.dayDate < @startDate THEN 'P1'
						WHEN pt.dayDate >= @startDate and pt.dayDate <= @endDate THEN 'P2'
						WHEN pt.dayDate > @endDate and pt.dayDate <= @p3EndDate THEN 'P3'
					END
					) as Period,
					pt.productID as Product,								
					(
					CASE 
						WHEN @uomType = 102000001 or @uomType=102000002 THEN isnull(pt.prtGrossQuantityCtn,0)+(isnull(pt.prtGrossQuantityEa,0)/isnull(prod.prdConversionFactor,1))/1*1
						WHEN @uomType = 102000003 THEN isnull(pt.prtGrossQuantityEa,0)+(isnull(pt.prtGrossQuantityCtn,0)*isnull(prod.prdConversionFactor,1))/1*1
						WHEN @uomType = 102000006 THEN 
							CASE 
								WHEN ts.sysUomClientCode = 'CTN' THEN (((isnull(pt.prtGrossQuantityEa,0)+(isnull(pt.prtGrossQuantityCtn,0)
										*isnull(prod.prdConversionFactor,1))/1)*1))*ts.sysAmount
								WHEN ts.sysUomClientCode = 'EA'  THEN (((isnull(pt.prtGrossQuantityEa,0)+(isnull(pt.prtGrossQuantityCtn,0)
										*isnull(prod.prdConversionFactor,1))/1)*1))*ts.sysAmount		
							END
						
						END) as Volume
						FROM tblPriTrans pt  WITH (NOLOCK) join tblProduct prod  WITH (NOLOCK) on pt.productID = prod.productID 
						left join @sysAmount ts on ts.productid = pt.productID  inner join @products x on pt.productID = x.productID
						inner join @customers c on pt.customerID = c.customerID 			
						WHERE pt.dayDate >= @p1StartDate and pt.dayDate <= @p3EndDate
						)x
					GROUP BY x.period, x.product 			
				END
			ELSE IF @sellType = 1 -- Sell Out
				BEGIN
				SELECT x.period, x.product, SUM(x.volume)  as volume
				FROM(
					SELECT 
					(
					CASE 
						WHEN pt.dayDate >= @p1StartDate and pt.dayDate < @startDate THEN 'P1'
						WHEN pt.dayDate >= @startDate and pt.dayDate <= @endDate THEN 'P2'
						WHEN pt.dayDate > @endDate and pt.dayDate <= @p3EndDate THEN 'P3'
					END
					) as Period,
					pt.productID as Product,								
					(
					CASE 
						WHEN @uomType = 102000001 or @uomType=102000002 THEN (isnull(pt.extSalesQuantityEa,0)/isnull(prod.prdConversionFactor,1)/1)*1						
						WHEN @uomType = 102000003 THEN (isnull(pt.extSalesQuantityEa,0)/1)*1
						WHEN @uomType = 102000006 THEN 
							(CASE
								 WHEN ts.sysUomClientCode = 'CTN' THEN (pt.extSalesQuantityEa/1/prod.prdConversionFactor*1)*ts.sysAmount
								 WHEN ts.sysUomClientCode = 'EA' THEN (pt.extSalesQuantityEa/1)*1*ts.sysAmount		
							END)
					END) as Volume
						FROM tblExtTrans pt  WITH (NOLOCK) join tblProduct prod  WITH (NOLOCK) on pt.productID = prod.productID		
						LEFT JOIN @sysAmount ts on ts.productid = pt.productID  inner join @products x on pt.productID = x.productID	
						inner join @customers c on pt.outletID = c.customerID 			
						where pt.dayDate >= @p1StartDate and pt.dayDate <= @p3EndDate						
						)x
					GROUP BY x.period, x.product 			
				END
	END
END



