
CREATE PROCEDURE [dbo].[spx_InsertAccrualGeneration]	
	@countryId int,
	@PromotionID int,
	@Bookmonth int,
	@Bookyear int,
	@IsJournalGeneration int,
	@Creator nvarchar(50)
AS
BEGIN
	INSERT INTO tblAccrualGeneration
	SELECT DISTINCT prm.prmPromotionClientCode + LEFT(DATENAME(MONTH, CAST('1900-'+CAST(@Bookmonth AS VARCHAR(2))+'-01' AS datetime)),3) + CAST(RIGHT(@Bookyear,2) AS VARCHAR(2)) 
	,prm.countryID, prm.promotionID
	,CASE WHEN jcc.jccCusCustomerClientCode<>'' THEN (@countryId*1000000)+jcc.jccCusCustomerClientCode ELSE cus.customerID END
	,fin.finGeneralLedgerCode,@IsJournalGeneration,GETDATE(),@Bookyear*100+@Bookmonth,@Creator
	FROM tblPromotion AS prm
	INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.PromotionID
	INNER JOIN tblPromotionCustomer2 vcus ON vcus.promotionID=prm.promotionID
	INNER JOIN tblCustomer AS cus on cus.customerID=vcus.customerID
	LEFT JOIN tblJournalCustomerCode AS jcc ON jcc.cusGroup5ID=cus.cusGroup5ID AND jcc.cusGroup6ID=cus.cusGroup6ID
	WHERE prm.countryID = @countryId AND prm.promotionID = @PromotionID
END



