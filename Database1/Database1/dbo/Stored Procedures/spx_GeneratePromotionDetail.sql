
CREATE PROCEDURE [dbo].[spx_GeneratePromotionDetail]	
	@PromotionID varchar(250),
	@CustomerPromotionList CustomerPromotionList READONLY
AS
BEGIN
	SELECT DISTINCT 'HQ' AS DistributorCode,
	CASE WHEN pty.promotionTypeID IN (102007,102025,102026) AND ISNULL(pdi.detValue,0)<>0 THEN
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) + '_' + CAST(pdi.detValue AS VARCHAR(50))
	ELSE
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) 
	END AS PromotionCode,
	CASE WHEN (ISNULL(prd.detStepNr,'') = '' OR prd.detStepNr = 1) THEN '1' ELSE prd.detStepNr END AS PromotionIndex,
	CASE WHEN dst.buildingblockID=102003 OR dst.buildingblockID=102024 THEN '2' ELSE 
		CASE WHEN pty.ptyDMSCode = 'S' AND prd.detNumberOfFreeUOMs <> '' THEN '1' ELSE
			Case WHEN pty.ptyDMSCode = 'S'AND (prd.detSpaceBuyFee <> '' OR pdi.detValue <> '') THEN '2' ELSE
				CASE WHEN pty.ptyDMSCode = 'S' THEN '' ELSE
					CASE WHEN (ISNULL(prd.detRebate,'') <> '' OR ISNULL(prd.detTradeDiscount ,'') <> '') THEN '2'		 
						 ELSE CASE WHEN (ISNULL(prd.detRebatepercentage,'') <> '' OR ISNULL(prd.detTradeDiscount ,'') <> '') THEN '3' ELSE '1' END			  
					END
				END 
			END
		END
	END AS MechanicType,
	CASE WHEN pty.ptyDMSCode = 'S' THEN '' ELSE
		CASE WHEN ISNULL(prd.detVolumeReq,0)=0 THEN '' ELSE ISNULL(prd.detVolumeReq,0) END		
	END AS TotalBuyQuantity,	
	CASE WHEN prm.PromotionTypeID IN (102007,102021,102025,102026) THEN	
		CASE WHEN ISNULL(pdi.detValue,0)=0 THEN '' ELSE ISNULL(pdi.detValue,0) END
	ELSE
		CASE WHEN (ISNULL(prd.detRebate,'') <> '') THEN 
			CASE WHEN prm.prmUnitID=102000003 THEN 
				CASE WHEN ISNULL(prd.detRebate,0)=0 THEN '' ELSE ISNULL(prd.detRebate,0)* prod.prdConversionFactor END 
			ELSE
				CASE WHEN ISNULL(prd.detRebate,0)=0 THEN '' ELSE ISNULL(prd.detRebate,0) END
			END					 
		ELSE CASE WHEN (ISNULL(prd.detTradeDiscount,'') <> '') THEN 			 
			CASE WHEN prm.prmUnitID=102000003 THEN 
				CASE WHEN ISNULL(prd.detTradeDiscount,0)=0 THEN '' ELSE ISNULL(prd.detTradeDiscount,0)* prod.prdConversionFactor END 
			ELSE
				CASE WHEN ISNULL(prd.detTradeDiscount,0)=0 THEN '' ELSE ISNULL(prd.detTradeDiscount,0) END
			END					 
			ELSE CASE WHEN (ISNULL(prd.detRebatepercentage,'') <> '') THEN CASE WHEN ISNULL(prd.detRebatepercentage,0)=0 THEN '' ELSE ISNULL(prd.detRebatepercentage,0) END
				ELSE CASE WHEN (ISNULL(prd.detTradediscountPercentage,'') <> '') THEN CASE WHEN ISNULL(prd.detTradediscountPercentage,0)=0 THEN '' ELSE ISNULL(prd.detTradediscountPercentage,0) END
					ELSE '' END
				END 
			END			  
		END
	END AS FactorValue,
	CASE WHEN pty.ptyDMSCode = 'S' THEN '' ELSE 
		CASE WHEN (ISNULL(prd.detRebate,'') <> '' OR ISNULL(prd.detTradeDiscount ,'') <> '') THEN '1'		 
			 ELSE CASE WHEN (ISNULL(prd.detRebatepercentage,'') <> '' OR ISNULL(prd.detTradeDiscount ,'') <> '') THEN '2' ELSE '1' END			  
		END
	END AS ApplyOn
	FROM (SELECT * FROM tblPromotion WHERE promotionId IN (SELECT data FROm dbo.fn_split(@PromotionID,','))) AS prm
	LEFT JOIN tblPromotionDetailsIncentive pdi ON prm.promotionId = pdi.promotionId
	LEFT JOIN (SELECT promotionID,COUNT(secondaryCustomerId) totalSec FROM tblPromotionSecondaryCustomer GROUP BY promotionID) secCount ON prm.promotionId = secCount.promotionId
	INNER JOIN tblPromotionDetails AS prd ON prm.promotionID = prd.promotionID
	INNER JOIN tblPromotionType AS pty ON prd.PromotionTypeID = pty.promotionTypeID
	INNER JOIN tblDetSelTab dst ON dst.promotiontypeID = pty.promotionTypeID
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionId = prm.promotionId
	INNER JOIN (SELECT promotionID, MAX(prdProductID) productID FROM tblPromotionProductSelection GROUP BY  promotionID) pps ON pps.promotionID = prm.promotionID
	INNER JOIN tblProduct prod ON pps.productID = prod.productID AND prod.countryID = prm.countryID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus ON cus.customerID = vcus.customerID AND cus.countryID = prm.countryID
	INNER JOIN @CustomerPromotionList cusprm ON cusprm.customerID = cus.customerID and cusprm.promotionID = prm.promotionID
	LEFT JOIN tblSecondaryCustomer AS sec ON cus.customerID = sec.customerID AND cus.countryID = sec.countryID
	INNER JOIN tbldistributorNames AS dms ON dms.dinCustomerClientCode = cus.cusCustomerClientCode AND dms.countryID = cus.countryID
	ORDER BY CASE WHEN pty.promotionTypeID IN (102007,102025,102026) AND ISNULL(pdi.detValue,0)<>0 THEN
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) + '_' + CAST(pdi.detValue AS VARCHAR(50))
	ELSE
		ISNULL(prm.prmPromotionClientCode,'')+UPPER(dms.cusPrefix) 
	END
END

