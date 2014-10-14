-- =============================================
-- Author:		Anthony Steven
-- Create date: 24th September 2014
-- Description:	Generate DMS Key Account Group Report
-- =============================================
CREATE PROCEDURE [dbo].[spx_GenerateDMSKeyAccountGroupReport] 
	@month int, 
	@year int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
 select allgroup.DMS, allgroup.Region, trx.Year, trx.Month, trx.Day, trx.Amount
 from 
 (
 select tsg2.secGroup2ID as sg2id, tsg2.s02SecGroup2ClientCode as DMS, allcg6.c06CusGroup6Desc as Region, allcg6.cusGroup6ID
 from tblSecGroup2 tsg2 cross join 
	(
		select cusGroup6Id, c06CusGroup6Desc
		from tblcusgroup6 cg6
		where cg6.cusGroup6ID BETWEEN 102000001 AND 102000006
	) allcg6
 where tsg2.secGroup2ID = 102000005 OR tsg2.secGroup2ID = 102000007 OR tsg2.secGroup2ID = 102000008 
 OR tsg2.secGroup2ID = 102000009 OR tsg2.secGroup2ID = 102000010
 ) allGroup
 left join  
 (select tsg2.secGroup2ID as DMS, cg6.cusGroup6ID as Region, DatePart(year,st.dayDate) as [Year], 
 DatePart(month,st.dayDate) as [Month], DatePart(day,st.dayDate) as [Day],
                    sum(isnull(st.sctInvQtyEa,0)*isnull(sys.maxAmount,0)) as Amount
                    from tblSecTrans st WITH (NOLOCK) 
					 inner join tblCustomer tc WITH (NOLOCK)on st.customerID = tc.customerID
                     inner join tblSecondaryCustomer tscust WITH (NOLOCK)on st.secondaryCustomerID = tscust.secondaryCustomerID
                     inner join tblCusGroup6 cg6 WITH (NOLOCK)on tc.cusgroup6id = cg6.cusGroup6ID
                     inner join tblSecGroup2 tsg2 WITH (NOLOCK)on tscust.secGroup2ID = tsg2.secGroup2ID
					inner join
                    (
	                    SELECT accrualSource.customerId, accrualSource.productID, 
						accrualSource.cusGroup1ID, accrualSource.cusGroup4ID, accrualSource.cusGroup7ID,
						max(accrualSource.eaAmount) as maxAmount
	                    FROM 
	                    (
		                    SELECT tsa.customerID, tsa.productID, 
		                    (CASE WHEN tsa.sysUOMClientCode = 'CRT' or tsa.sysUOMCLientCode = 'CTN' then tsa.sysAmount/isnull(prod.prdConversionFactor,1)
							WHEN tsa.sysUomClientCode = 'EA' then tsa.sysAmount END) eaAmount,min(tsc.comPriority) as comPriority
							,tsa.cusGroup1ID, tsa.cusGroup4ID, tsa.cusGroup7ID
		                    FROM [dbo].[tblSystemAccrual] tsa WITH (NOLOCK)
		                    inner join tblSetCombination tsc WITH (NOLOCK)on tsa.combinationID = tsc.combinationID
		                    inner join tblProduct prod WITH (NOLOCK)on tsa.productID = prod.productID
		                    WHERE sysCurrency = 'MYR' 
		                    AND pnlID = 102129 
		                    --AND (sysDocType = '' OR sysDocType = 'S57' OR sysDocType is null)
		                    group by tsa.customerID, tsa.productID,  (CASE WHEN tsa.sysUOMClientCode = 'CRT' or tsa.sysUOMCLientCode = 'CTN' then tsa.sysAmount/isnull(prod.prdConversionFactor,1)
		                    WHEN tsa.sysUomClientCode = 'EA' then tsa.sysAmount END), tsa.cusGroup1ID, tsa.cusGroup4ID, tsa.cusGroup7ID
	                    ) accrualSource
	                    GROUP BY  accrualSource.customerId, accrualSource.productID,	accrualSource.cusGroup1ID, accrualSource.cusGroup4ID, accrualSource.cusGroup7ID
                    )
                     sys on st.productID = sys.productID 
					 and (sys.customerID IS NULL OR st.customerID = sys.customerID) 
					 AND (sys.cusGroup1ID IS NULL OR tc.cusGroup1ID = sys.cusGroup1ID)
					 AND (sys.cusGroup4ID IS NULL OR tc.cusGroup4ID = sys.cusGroup4ID)
					 AND (sys.cusGroup7ID IS NULL OR tc.cusGroup7ID = sys.cusGroup7ID)
                 
                     WHERE (cg6.cusGroup6ID BETWEEN 102000001 AND 102000006) AND (tsg2.secGroup2ID = 102000005 OR tsg2.secGroup2ID = 102000007 OR tsg2.secGroup2ID = 102000008 OR tsg2.secGroup2ID = 102000009 OR tsg2.secGroup2ID = 102000010)
                     AND DatePart(month,st.dayDate)=@month
					 AND DatePart(year,st.dayDate)=@year
					 AND st.dayDate between tc.validFrom and tc.validTo
					 AND st.dayDate between tscust.validFrom and tscust.validTo					 
                     GROUP BY cg6.cusGroup6ID, tsg2.secGroup2ID, DatePart(month,st.dayDate),
					  DatePart(year,st.dayDate), DatePart(day,st.dayDate)
)trx on allGroup.sg2id = trx.DMS and allGroup.cusGroup6ID = trx.Region

order by DMS,[Month]

  
END

