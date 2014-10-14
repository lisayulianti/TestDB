-- =============================================
-- Author:		Anthony Steven
-- Modified by Lin
-- Modified date 19 09 2014
-- Create date: 13th August 2014
-- Description:	Promotion Product Selection Options
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchPromoProductSelectionOptions] 
	@countryId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT p.productID,p.countryID,prdProductClientCode,prdProductName,prdProductClientCode,prdParentCode,
	                    pg1.prdGroup1ID,pg1.p01PrdGroup1ClientCode as prdPrdGroup1ClientCode,pg1.p01PrdGroup1Desc as prdPrdGroup1Desc,
	                    pg2.prdGroup2ID,pg2.p02PrdGroup2ClientCode as prdPrdGroup2ClientCode,pg2.p02PrdGroup2Desc as prdPrdGroup2Desc,
	                    pg3.prdGroup3ID,pg3.p03PrdGroup3ClientCode as prdPrdGroup3ClientCode,pg3.p03PrdGroup3Desc as prdPrdGroup3Desc,
	                    pg4.prdGroup4ID,pg4.p04PrdGroup4ClientCode as prdPrdGroup4ClientCode,pg4.p04PrdGroup4Desc as prdPrdGroup4Desc,
	                    pg5.prdGroup5ID,pg5.p05PrdGroup5ClientCode as prdPrdGroup5ClientCode,pg5.p05PrdGroup5Desc as prdPrdGroup5Desc,
	                    pg6.prdGroup6ID,pg6.p06PrdGroup6ClientCode as prdPrdGroup6ClientCode,pg6.p06PrdGroup6Desc as prdPrdGroup6Desc,
	                    pg7.prdGroup7ID,pg7.p07PrdGroup7ClientCode as prdPrdGroup7ClientCode,pg7.p07PrdGroup7Desc as prdPrdGroup7Desc,
	                    pg8.prdGroup8ID,pg8.p08PrdGroup8ClientCode as prdPrdGroup8ClientCode,pg8.p08PrdGroup8Desc as prdPrdGroup8Desc,
	                    pg9.prdGroup9ID,pg9.p09PrdGroup9ClientCode as prdPrdGroup9ClientCode,pg9.p09PrdGroup9Desc as prdPrdGroup9Desc,
	                    pg10.prdGroup10ID,pg10.p10PrdGroup10ClientCode as prdPrdGroup10ClientCode,pg10.p10PrdGroup10Desc as prdPrdGroup10Desc,
	                    pg11.prdGroup11ID,pg11.p11PrdGroup11ClientCode as prdPrdGroup11ClientCode,pg11.p11PrdGroup11Desc as prdPrdGroup11Desc,
	                    pg12.prdGroup12ID,pg12.p12PrdGroup12ClientCode as prdPrdGroup12ClientCode,pg12.p12PrdGroup12Desc as prdPrdGroup12Desc,
	                    pg13.prdGroup13ID,pg13.p13PrdGroup13ClientCode as prdPrdGroup13ClientCode,pg13.p13PrdGroup13Desc as prdPrdGroup13Desc,
                        pg14.prdGroup14ID,pg14.p14PrdGroup14ClientCode as prdPrdGroup14ClientCode,pg14.p14PrdGroup14Desc as prdPrdGroup14Desc,
	                    pg15.prdGroup15ID,pg15.p15PrdGroup15ClientCode as prdPrdGroup15ClientCode,pg15.p15PrdGroup15Desc as prdPrdGroup15Desc,
	                    pg16.prdGroup16ID,pg16.p16PrdGroup16ClientCode as prdPrdGroup16ClientCode,pg16.p16PrdGroup16Desc as prdPrdGroup16Desc,
	                    pg17.prdGroup17ID,pg17.p17PrdGroup17ClientCode as prdPrdGroup17ClientCode,pg17.p17PrdGroup17Desc as prdPrdGroup17Desc,
	                    pg18.prdGroup18ID,pg18.p18PrdGroup18ClientCode as prdPrdGroup18ClientCode,pg18.p18PrdGroup18Desc as prdPrdGroup18Desc,
	                    pg19.prdGroup19ID,pg19.p19PrdGroup19ClientCode as prdPrdGroup19ClientCode,pg19.p19PrdGroup19Desc as prdPrdGroup19Desc,
	                    pg20.prdGroup20ID,pg20.p20PrdGroup20ClientCode as prdPrdGroup20ClientCode,pg20.p20PrdGroup20Desc as prdPrdGroup20Desc,
	                    pg21.prdGroup21ID,pg21.p21PrdGroup21ClientCode as prdPrdGroup21ClientCode,pg21.p21PrdGroup21Desc as prdPrdGroup21Desc,
	                    pg22.prdGroup22ID,pg22.p22PrdGroup22ClientCode as prdPrdGroup22ClientCode,pg22.p22PrdGroup22Desc as prdPrdGroup22Desc
 
                    FROM tblProduct p
					INNER JOIN (select distinct productid from tblCoGS WITH (NOLOCK) ) AS cogs ON cogs.productID = p.productID			
                    INNER JOIN (SELECT countryID, productID, MAX(validFrom) validFromMax FROM tblProduct WITH (NOLOCK)  GROUP BY countryID, productID) p2 
	                        ON p.countryID = p2.countryID AND p.productID = p2.productID AND p.validFrom = p2.validFromMax
					LEFT JOIN tblPrdGroup1 pg1 WITH (NOLOCK) on p.prdGroup1ID = pg1.prdGroup1ID
					LEFT JOIN tblPrdGroup2 pg2 WITH (NOLOCK)  on p.prdGroup2ID = pg2.prdGroup2ID
					LEFT JOIN tblPrdGroup3 pg3 WITH (NOLOCK)  on p.prdGroup3ID = pg3.prdGroup3ID
					LEFT JOIN tblPrdGroup4 pg4 WITH (NOLOCK)  on p.prdGroup4ID = pg4.prdGroup4ID
					LEFT JOIN tblPrdGroup5 pg5 WITH (NOLOCK)  on p.prdGroup5ID = pg5.prdGroup5ID
					LEFT JOIN tblPrdGroup6 pg6 WITH (NOLOCK)  on p.prdGroup6ID = pg6.prdGroup6ID
					LEFT JOIN tblPrdGroup7 pg7 WITH (NOLOCK)  on p.prdGroup7ID = pg7.prdGroup7ID
					LEFT JOIN tblPrdGroup8 pg8 WITH (NOLOCK)  on p.prdGroup8ID = pg8.prdGroup8ID
					LEFT JOIN tblPrdGroup9 pg9 WITH (NOLOCK)  on p.prdGroup9ID = pg9.prdGroup9ID
					LEFT JOIN tblPrdGroup10 pg10 WITH (NOLOCK)  on p.prdGroup10ID = pg10.prdGroup10ID
					LEFT JOIN tblPrdGroup11 pg11 WITH (NOLOCK)  on p.prdGroup11ID = pg11.prdGroup11ID
					LEFT JOIN tblPrdGroup12 pg12 WITH (NOLOCK)  on p.prdGroup12ID = pg12.prdGroup12ID
					LEFT JOIN tblPrdGroup13 pg13 WITH (NOLOCK)  on p.prdGroup13ID = pg13.prdGroup13ID
					LEFT JOIN tblPrdGroup14 pg14 WITH (NOLOCK)  on p.prdGroup14ID = pg14.prdGroup14ID
					LEFT JOIN tblPrdGroup15 pg15 WITH (NOLOCK)  on p.prdGroup15ID = pg15.prdGroup15ID
					LEFT JOIN tblPrdGroup16 pg16 WITH (NOLOCK)  on p.prdGroup16ID = pg16.prdGroup16ID
					LEFT JOIN tblPrdGroup17 pg17 WITH (NOLOCK)  on p.prdGroup17ID = pg17.prdGroup17ID
					LEFT JOIN tblPrdGroup18 pg18 WITH (NOLOCK)  on p.prdGroup18ID = pg18.prdGroup18ID
					LEFT JOIN tblPrdGroup19 pg19 WITH (NOLOCK)  on p.prdGroup19ID = pg19.prdGroup19ID
					LEFT JOIN tblPrdGroup20 pg20 WITH (NOLOCK)  on p.prdGroup20ID = pg20.prdGroup20ID
					LEFT JOIN tblPrdGroup21 pg21 WITH (NOLOCK)  on p.prdGroup21ID = pg21.prdGroup21ID
					LEFT JOIN tblPrdGroup22 pg22 WITH (NOLOCK)  on p.prdGroup22ID = pg22.prdGroup22ID
                    WHERE p.countryId = @countryId 
END
