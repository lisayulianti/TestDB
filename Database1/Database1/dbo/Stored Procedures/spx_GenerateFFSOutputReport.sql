-- =============================================
-- Author:		Robert de Castro
-- Create date: 25 August 2014
-- Description:	Generate the Output report for FFS
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateFFSOutputReport]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	declare @FFSPromotionID nvarchar(50)
	select top 1 @FFSPromotionID = promotionID from tblPromotion where promotionTypeID=102017 and GETDATE() BETWEEN prmDateStart and prmDateEnd and isDeleted=0 order by promotionID desc
	declare @ColumnNameNetVol nvarchar(max)
	select @ColumnNameNetVol=isnull(@ColumnNameNetVol+',','') + QUOTENAME(p.prdProductName + ' Net Vol') from tblPromotionDetails pd join tblProduct p on p.productID=pd.productID where pd.PromotionID=@FFSPromotionID
	declare @ColumnNameNetKg nvarchar(max)
	select @ColumnNameNetKg=isnull(@ColumnNameNetKg+',','') + QUOTENAME(p.prdProductName + ' Net Kg') from tblPromotionDetails pd join tblProduct p on p.productID=pd.productID where pd.PromotionID=@FFSPromotionID
	declare @ColumnNameNetSales nvarchar(max)
	select @ColumnNameNetSales=isnull(@ColumnNameNetSales+',','') + QUOTENAME(p.prdProductName + ' Net Sales') from tblPromotionDetails pd join tblProduct p on p.productID=pd.productID where pd.PromotionID=@FFSPromotionID
	declare @ColumnNameTotalNetVol nvarchar(max)
	select @ColumnNameTotalNetVol=isnull(@ColumnNameTotalNetVol+'+','') + 'isnull(' +QUOTENAME(p.prdProductName + ' Net Vol') + ',0)' from tblPromotionDetails pd join tblProduct p on p.productID=pd.productID where pd.PromotionID=@FFSPromotionID
	declare @ColumnNameTotalNetSales nvarchar(max)
	select @ColumnNameTotalNetSales=isnull(@ColumnNameTotalNetSales+'+','') + 'isnull(' +QUOTENAME(p.prdProductName + ' Net Sales') + ',0)' from tblPromotionDetails pd join tblProduct p on p.productID=pd.productID where pd.PromotionID=@FFSPromotionID 
	--Prepare the PIVOT query using the dynamic 
	declare @DynamicPivotQuery nvarchar(max)
	SET @DynamicPivotQuery = 
	  N'select a.secSecCusClientCode as [Concatenate], a.secSecondaryCustomerName as [Outlet], [Target Kg],' + @ColumnNameNetVol + ',' + @ColumnNameNetKg + ',[Total Net Kg], cast((([Target Kg] / [Total Net Kg])-1)*100 as NVARCHAR(10)) + ''%'' as [Net Kg Ach],' + @ColumnNameNetSales + ',' + @ColumnNameTotalNetVol + ' as [Total Net Vol],' + @ColumnNameTotalNetSales + ' as [Total Net Sales] from
		(SELECT secSecCusClientCode, secSecondaryCustomerName, ' + @ColumnNameNetVol + '
		FROM (select sc.secSecCusClientCode, sc.secSecondaryCustomerName, p.prdProductName + '' Net Vol'' as prdProductName, sctInvQtyEa as value
			from tblSecTrans st 
			join tblProduct p on p.productID=st.productID 
			join tblSecondaryCustomer sc on sc.secondaryCustomerID=st.secondaryCustomerID 
			where st.secondaryCustomerID in (select SecondaryCustomerID from tblPromotionDetailsIncentive where promotionID='+@FFSPromotionID+') 
			and st.productID in (select productID from tblPromotionDetails where PromotionID='+@FFSPromotionID+') 
			and year(dayDate)=year(getdate())) as source
		PIVOT(SUM(value) 
			  FOR prdProductName IN (' + @ColumnNameNetVol + ')) AS PVTTable) a
		left join
		(SELECT secSecCusClientCode, secSecondaryCustomerName, ' + @ColumnNameNetKg + '
		FROM (select sc.secSecCusClientCode, sc.secSecondaryCustomerName, p.prdProductName + '' Net Kg'' as prdProductName, sctInvQtyEa*p.prdNetWeight as value
			from tblSecTrans st 
			join tblProduct p on p.productID=st.productID 
			join tblSecondaryCustomer sc on sc.secondaryCustomerID=st.secondaryCustomerID 
			where st.secondaryCustomerID in (select SecondaryCustomerID from tblPromotionDetailsIncentive where promotionID='+@FFSPromotionID+') 
			and st.productID in (select productID from tblPromotionDetails where PromotionID='+@FFSPromotionID+') 
			and year(dayDate)=year(getdate())) as source
		PIVOT(SUM(value) 
			  FOR prdProductName IN (' + @ColumnNameNetKg + ')) AS PVTTable) b
		on b.secSecCusClientCode=a.secSecCusClientCode
		left join 
		(select sc.secSecCusClientCode, sc.secSecondaryCustomerName, sum(sctInvQtyEa*p.prdNetWeight) as [Total Net Kg]
		from tblSecTrans st 
		join tblProduct p on p.productID=st.productID 
		join tblSecondaryCustomer sc on sc.secondaryCustomerID=st.secondaryCustomerID 
		where st.secondaryCustomerID in (select SecondaryCustomerID from tblPromotionDetailsIncentive where promotionID='+@FFSPromotionID+') 
		and st.productID in (select productID from tblPromotionDetails where PromotionID='+@FFSPromotionID+') 
		and year(dayDate)=year(getdate())
		group by sc.secSecCusClientCode, sc.secSecondaryCustomerName) c
		on c.secSecCusClientCode=a.secSecCusClientCode
		left join
		(select distinct sc.secSecCusClientCode, pdi.detVolumeReqRetailer as [Target Kg] from tblPromotionDetailsIncentive pdi join tblSecondaryCustomer sc on sc.secondaryCustomerID=pdi.SecondaryCustomerID where PromotionTypeID=102017 and pdi.promotionID=' + @FFSPromotionID +') d
		on d.secSecCusClientCode=a.secSecCusClientCode
		left join
		(SELECT secSecCusClientCode, secSecondaryCustomerName, ' + @ColumnNameNetSales + '
		FROM (select sc.secSecCusClientCode, sc.secSecondaryCustomerName, p.prdProductName + '' Net Sales'' as prdProductName, case when sa.sysUomClientCode=''EA'' then st.sctInvQtyEa*sa.sysAmount else st.sctInvQtyEa*(sa.sysAmount/p.prdConversionFactor) END as value
			from tblSecTrans st 
			join tblProduct p on p.productID=st.productID 
			join tblSecondaryCustomer sc on sc.secondaryCustomerID=st.secondaryCustomerID 
			join dbo.fn_GetSysAmountByPromotionID('+@FFSPromotionID+',0) sa on sa.productid=st.productID
			where st.secondaryCustomerID in (select SecondaryCustomerID from tblPromotionDetailsIncentive where promotionID='+@FFSPromotionID+') 
			and st.productID in (select productID from tblPromotionDetails where PromotionID='+@FFSPromotionID+') 
			and year(dayDate)=year(getdate())) as source
		PIVOT(SUM(value) 
				FOR prdProductName IN (' + @ColumnNameNetSales +')) AS PVTTable) e
		on e.secSecCusClientCode=a.secSecCusClientCode'
	EXEC sp_executesql @DynamicPivotQuery

	select top 1 promotionID, prmDateStart, prmDateEnd from tblPromotion where promotionTypeID=102017 and GETDATE() BETWEEN prmDateStart and prmDateEnd and isDeleted=0 order by promotionID desc
END

