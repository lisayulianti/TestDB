
-- =============================================
-- Author:		Anthony Steven
-- Create date: 18th-July-2014
-- Description:	Fetching Baseline Volume Value 
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchBaseLineVolume]	
	@startDate DATE, --Promotion Start Date
	@endDate DATE, --Promotion End Date
	@transType INT, --Transaction Type (0:Primary, 1:Secondary, 2:External)
	@uomType INT, --Unit of Measurement Type (0:CTN, 1:EA, 2:Value)
	@baselineStartDate DATE, -- Promotion Baseline Start Date
	@baselineEndDate DATE, -- Promotion Baseline End Date
	@promotionId INT, -- Promotion Id
	@products ProductList READONLY, -- Filtered Products
	@customers CustomerList READONLY -- Filtered Customers
	
AS
BEGIN	
	SET NOCOUNT ON;	 
	DECLARE @promotionDays INT 
	DECLARE @salesDays INT
	SET @promotionDays = DATEDIFF(day,@startDate,@endDate)+1
	--SET @salesDays = 365

	Declare @sysAmount as table
	(
		productID int,
		sysAmount float,
		sysUOMClientCode varchar(10),
		combinationID int
	)

	insert into @sysAmount
	select * from dbo.fn_GetSysAmountValueByPromotionID(@promotionID)
	----
	Declare @salesTable as table
	(
		productID int,
		salesDate int
	)
	
	---

	IF @transType = 0 or @transType = 4	-- Primary Transaction / External Transacti0on
	BEGIN
	
	INSERT INTO @salesTable
	SELECT pt.productID, (365-ISNULL(DATEPART(dy,MIN(pt.dayDate)),1))+1 as salesDate
	FROM tblPriTrans pt inner join tblProduct prod on pt.productID = prod.productID			
			inner join @products x on pt.productID = x.productID
			inner join @customers c on pt.customerID = c.customerID 
			where pt.dayDate between @baselineStartDate and @baselineEndDate	
	GROUP BY pt.productID
	
	--SELECT  @salesDays = (365 - DATEPART(dy,MIN(pt.dayDate)))
	--FROM tblPriTrans pt inner join tblProduct prod on pt.productID = prod.productID
	--		--left join @sysAmount acc on acc.productID = pt.productID 
	--		inner join @products x on pt.productID = x.productID
	--		inner join @customers c on pt.customerID = c.customerID 
	--		where pt.dayDate between @baselineStartDate and @baselineEndDate	

	SELECT  pt.productID, (CASE WHEN @uomType = 102000001 or @uomType = 102000002 THEN sum((isnull(pt.prtGrossQuantityCtn,0)+(isnull(pt.prtGrossQuantityEa,0)/isnull(prod.prdConversionFactor,1)))/st.salesDate)*@promotionDays
			WHEN @uomType = 102000003 THEN sum((isnull(pt.prtGrossQuantityEa,0)+(isnull(pt.prtGrossQuantityCtn,0)*isnull(prod.prdConversionFactor,1)))/st.salesDate)*@promotionDays
			WHEN @uomType = 102000006 THEN SUM(
				CASE WHEN acc.sysUomClientCode = 'CTN' 
					 THEN (((isnull(pt.prtGrossQuantityCtn,0)+((isnull(pt.prtGrossQuantityEa,0)/isnull(prod.prdConversionFactor,1))))/st.salesDate)*@promotionDays)*acc.sysAmount
					 WHEN acc.sysUomClientCode = 'EA' 
					 THEN (((isnull(pt.prtGrossQuantityEa,0)+((isnull(pt.prtGrossQuantityCtn,0)*isnull(prod.prdConversionFactor,1))))/st.salesDate)*@promotionDays)*acc.sysAmount		
				END)
			END
			) as Volume
			
			FROM tblPriTrans pt  WITH (NOLOCK) 
			inner join tblProduct prod  WITH (NOLOCK) on pt.productID = prod.productID
			left join @sysAmount acc on acc.productID = pt.productID 
			inner join @products x on pt.productID = x.productID
			inner join @customers c on pt.customerID = c.customerID 
			inner join @salesTable st on pt.productID = st.productID
			where pt.dayDate between @baselineStartDate and @baselineEndDate	
			group by pt.productID	
	END
	ELSE IF @transType = 1 -- Secondary Transaction
	BEGIN
		
		INSERT INTO @salesTable
		SELECT pt.productID, (365-ISNULL(DATEPART(dy,MIN(pt.dayDate)),1))+1 as salesDate
		FROM tblSecTrans pt inner join tblProduct prod on pt.productID = prod.productID			
				inner join @products x on pt.productID = x.productID
				inner join @customers c on pt.secondaryCustomerID = c.customerID 
				where pt.dayDate between @baselineStartDate and @baselineEndDate	
		GROUP BY pt.productID
		
		--SELECT  @salesDays = (365 - DATEPART(dy,MIN(pt.dayDate)))
		--	FROM tblSecTrans pt inner join tblProduct prod on pt.productID = prod.productID
		--	--left join @sysAmount acc on acc.productID = pt.productID 
		--	inner join @products x on pt.productID = x.productID
		--	inner join @customers c on pt.secondaryCustomerID = c.customerID 
		--	where pt.dayDate between @baselineStartDate and @baselineEndDate

		SELECT pt.productID, (CASE 
			WHEN @uomType = 102000001 or @uomType = 102000002 THEN sum(isnull(pt.sctInvQtyEa,0)/isnull(prod.prdConversionFactor,1)/st.salesDate)*@promotionDays
			WHEN @uomType = 102000003 THEN sum(isnull(pt.sctInvQtyEa,0)/st.salesDate)*@promotionDays
			WHEN @uomType = 102000006 THEN ((sum
				(CASE WHEN acc.sysUomClientCode = 'CTN' THEN((pt.sctInvQtyEa/st.salesDate)/isnull(prod.prdConversionFactor,1) )*acc.sysAmount
				WHEN acc.sysUomClientCode = 'EA' THEN (pt.sctInvQtyEa/st.salesDate)*acc.sysAmount 
				END
				))*@promotionDays)
			END)
			as Volume 
			FROM tblSecTrans pt  WITH (NOLOCK) 
			inner join tblProduct prod WITH (NOLOCK)  on pt.productID = prod.productID
			left join @sysAmount acc on acc.productID = pt.productID 
			inner join @products x on pt.productID = x.productID
			inner join @customers c on pt.secondaryCustomerID = c.customerID 
			inner join @salesTable st on pt.productID = st.productID
			where pt.dayDate between @baselineStartDate and @baselineEndDate
			group by pt.productID
	END
	ELSE IF @transType = 2 -- External Transaction (With Outlets)
	BEGIN
	
		INSERT INTO @salesTable
		SELECT pt.productID, (365-ISNULL(DATEPART(dy,MIN(pt.dayDate)),1))+1 as salesDate
		FROM tblExtTrans pt inner join tblProduct prod on pt.productID = prod.productID			
				inner join @products x on pt.productID = x.productID
				inner join @customers c on pt.outletID = c.customerID 
				where pt.dayDate between @baselineStartDate and @baselineEndDate	
		GROUP BY pt.productID
	
		--SELECT  @salesDays = (365 - DATEPART(dy,MIN(et.dayDate)))
		--	FROM tblExtTrans et inner join tblProduct prod on et.productID = prod.productID
		--	--left join @sysAmount acc on acc.productID = et.productID 
		--	inner join @products x on et.productID = x.productID
		--	inner join @customers c on et.outletID = c.customerID 
		--	where et.dayDate between @baselineStartDate and @baselineEndDate
		SELECT et.productID, (CASE 
			WHEN @uomType = 102000001 or @uomType = 102000002 THEN sum(isnull(et.extSalesQuantityEa,0)/isnull(prod.prdConversionFactor,1)/st.salesDate)*@promotionDays
			WHEN @uomType = 102000003 THEN sum(isnull(et.extSalesQuantityEa,0)/st.salesDate)*@promotionDays
			WHEN @uomType = 102000006 THEN ((sum
				(CASE WHEN acc.sysUomClientCode = 'CTN' THEN((et.extSalesQuantityEa/st.salesDate)/isnull(prod.prdConversionFactor,1) )*acc.sysAmount
				WHEN acc.sysUomClientCode = 'EA' THEN (et.extSalesQuantityEa/st.salesDate)*acc.sysAmount 
				END
				))*@promotionDays)
			END) as Volume
			FROM tblExtTrans et  WITH (NOLOCK) 
			inner join tblProduct prod  WITH (NOLOCK) on et.productID = prod.productID
			left join @sysAmount acc on acc.productID = et.productID 
			inner join @products x on et.productID = x.productID
			inner join @customers c on et.outletID = c.customerID 
			inner join @salesTable st on et.productID = st.productID
			where et.dayDate between @baselineStartDate and @baselineEndDate
			group by et.productID
	END
		
END




