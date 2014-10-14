-- =============================================
-- Author:		Anthony Steven
-- Create date: 19th August 2014
-- Description:	Fetch Raw Product Data
-- =============================================
CREATE PROCEDURE [dbo].[spx_FetchRawProductData]
	@promotionId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 
SELECT
        prs.prdProductID productID,
        prdProductClientCode, prdProductName, prdParentCode, prdProductParentID, 
        prd.prdGroup1ID, prdg1.p01PrdGroup1ClientCode AS prdPrdGroup1ClientCode, prdg1.p01PrdGroup1Desc AS prdPrdGroup1Desc,
        prd.prdGroup2ID, prdg2.p02PrdGroup2ClientCode AS prdPrdGroup2ClientCode, prdg2.p02PrdGroup2Desc AS prdPrdGroup2Desc,
        prd.prdGroup3ID, prdg3.p03PrdGroup3ClientCode AS prdPrdGroup3ClientCode, prdg3.p03PrdGroup3Desc AS prdPrdGroup3Desc,
        prd.prdGroup4ID, prdg4.p04PrdGroup4ClientCode AS prdPrdGroup4ClientCode, prdg4.p04PrdGroup4Desc AS prdPrdGroup4Desc,
		prd.prdGroup5ID, prdg5.p05PrdGroup5ClientCode AS prdPrdGroup5ClientCode, prdg5.p05PrdGroup5Desc AS prdPrdGroup5Desc,
		prd.prdGroup6ID, prdg6.p06PrdGroup6ClientCode AS prdPrdGroup6ClientCode, prdg6.p06PrdGroup6Desc AS prdPrdGroup6Desc,
        prd.prdGroup7ID, prdg7.p07PrdGroup7ClientCode AS prdPrdGroup7ClientCode, prdg7.p07PrdGroup7Desc AS prdPrdGroup7Desc,
        prd.prdGroup8ID, prdg8.p08PrdGroup8ClientCode AS prdPrdGroup8ClientCode, prdg8.p08PrdGroup8Desc AS prdPrdGroup8Desc,
        prd.prdGroup9ID, prdg9.p09PrdGroup9ClientCode AS prdPrdGroup9ClientCode, prdg9.p09PrdGroup9Desc AS prdPrdGroup9Desc,
        prd.prdGroup10ID, prdg10.p10PrdGroup10ClientCode AS prdPrdGroup10ClientCode, prdg10.p10PrdGroup10Desc AS prdPrdGroup10Desc,
        prd.prdGroup11ID, prdg11.p11PrdGroup11ClientCode AS prdPrdGroup11ClientCode, prdg11.p11PrdGroup11Desc AS prdPrdGroup11Desc,
        prd.prdGroup12ID, prdg12.p12PrdGroup12ClientCode AS prdPrdGroup12ClientCode, prdg12.p12PrdGroup12Desc AS prdPrdGroup12Desc,
        prd.prdGroup13ID, prdg13.p13PrdGroup13ClientCode AS prdPrdGroup13ClientCode, prdg13.p13PrdGroup13Desc AS prdPrdGroup13Desc,
        prd.prdGroup14ID, prdg14.p14PrdGroup14ClientCode AS prdPrdGroup14ClientCode, prdg14.p14PrdGroup14Desc AS prdPrdGroup14Desc,
        prd.prdGroup15ID, prdg15.p15PrdGroup15ClientCode AS prdPrdGroup15ClientCode, prdg15.p15PrdGroup15Desc AS prdPrdGroup15Desc,
        prd.prdGroup16ID, prdg16.p16PrdGroup16ClientCode AS prdPrdGroup16ClientCode, prdg16.p16PrdGroup16Desc AS prdPrdGroup16Desc,
        prd.prdGroup17ID, prdg17.p17PrdGroup17ClientCode AS prdPrdGroup17ClientCode, prdg17.p17PrdGroup17Desc AS prdPrdGroup17Desc,
        prd.prdGroup18ID, prdg18.p18PrdGroup18ClientCode AS prdPrdGroup18ClientCode, prdg18.p18PrdGroup18Desc AS prdPrdGroup18Desc,
        prd.prdGroup19ID, prdg19.p19PrdGroup19ClientCode AS prdPrdGroup19ClientCode, prdg19.p19PrdGroup19Desc AS prdPrdGroup19Desc,
        prd.prdGroup20ID, prdg20.p20PrdGroup20ClientCode AS prdPrdGroup20ClientCode, prdg20.p20PrdGroup20Desc AS prdPrdGroup20Desc,
        prd.prdGroup21ID, prdg21.p21PrdGroup21ClientCode AS prdPrdGroup21ClientCode, prdg21.p21PrdGroup21Desc AS prdPrdGroup21Desc,
        prd.prdGroup22ID, prdg22.p22PrdGroup22ClientCode AS prdPrdGroup22ClientCode, prdg22.p22PrdGroup22Desc AS prdPrdGroup22Desc

FROM tblPromotionProductSelection prs  WITH (NOLOCK) 
LEFT JOIN tblProduct prd WITH (NOLOCK)  ON prs.prdProductID = prd.productID
LEFT JOIN  tblPrdGroup1 prdg1 WITH (NOLOCK)  ON prdg1.prdGroup1ID = prd.prdGroup1ID
LEFT JOIN  tblPrdGroup2 prdg2 WITH (NOLOCK)  ON prdg2.prdGroup2ID = prd.prdGroup2ID
LEFT JOIN  tblPrdGroup3 prdg3 WITH (NOLOCK)  ON prdg3.prdGroup3ID = prd.prdGroup3ID
LEFT JOIN  tblPrdGroup4 prdg4 WITH (NOLOCK)  ON prdg4.prdGroup4ID = prd.prdGroup4ID
LEFT JOIN  tblPrdGroup5 prdg5 WITH (NOLOCK)  ON prdg5.prdGroup5ID = prd.prdGroup5ID
LEFT JOIN  tblPrdGroup6 prdg6 WITH (NOLOCK)  ON prdg6.prdGroup6ID = prd.prdGroup6ID
LEFT JOIN  tblPrdGroup7 prdg7 WITH (NOLOCK)  ON prdg7.prdGroup7ID = prd.prdGroup7ID
LEFT JOIN  tblPrdGroup8 prdg8 WITH (NOLOCK)  ON prdg8.prdGroup8ID = prd.prdGroup8ID
LEFT JOIN  tblPrdGroup9 prdg9 WITH (NOLOCK) ON prdg9.prdGroup9ID = prd.prdGroup9ID
LEFT JOIN  tblPrdGroup10 prdg10 WITH (NOLOCK)  ON prdg10.prdGroup10ID = prd.prdGroup10ID
LEFT JOIN  tblPrdGroup11 prdg11 WITH (NOLOCK) ON prdg11.prdGroup11ID = prd.prdGroup11ID
LEFT JOIN  tblPrdGroup12 prdg12 WITH (NOLOCK)  ON prdg12.prdGroup12ID = prd.prdGroup12ID
LEFT JOIN  tblPrdGroup13 prdg13 WITH (NOLOCK)  ON prdg13.prdGroup13ID = prd.prdGroup13ID
LEFT JOIN  tblPrdGroup14 prdg14 WITH (NOLOCK)  ON prdg14.prdGroup14ID = prd.prdGroup14ID
LEFT JOIN  tblPrdGroup15 prdg15 WITH (NOLOCK)  ON prdg15.prdGroup15ID = prd.prdGroup15ID
LEFT JOIN  tblPrdGroup16 prdg16 WITH (NOLOCK)  ON prdg16.prdGroup16ID = prd.prdGroup16ID
LEFT JOIN  tblPrdGroup17 prdg17 WITH (NOLOCK)  ON prdg17.prdGroup17ID = prd.prdGroup17ID
LEFT JOIN  tblPrdGroup18 prdg18 WITH (NOLOCK)  ON prdg18.prdGroup18ID = prd.prdGroup18ID
LEFT JOIN  tblPrdGroup19 prdg19 WITH (NOLOCK)  ON prdg19.prdGroup19ID = prd.prdGroup19ID
LEFT JOIN  tblPrdGroup20 prdg20 WITH (NOLOCK)  ON prdg20.prdGroup20ID = prd.prdGroup20ID
LEFT JOIN  tblPrdGroup21 prdg21 WITH (NOLOCK)  ON prdg21.prdGroup21ID = prd.prdGroup21ID
LEFT JOIN  tblPrdGroup22 prdg22 WITH (NOLOCK)  ON prdg22.prdGroup22ID = prd.prdGroup22ID
WHERE prs.PromotionID = @promotionId
END



