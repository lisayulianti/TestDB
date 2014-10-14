
CREATE PROCEDURE [dbo].[spx_InsertClaimNoteGeneration]	
	@countryId int,
	@PromotionID int,
	@CustomerID int=NULL,
	@secCustomerID int=NULL,
	@IsJournalGeneration int,
	@Creator nvarchar(50)
AS
BEGIN
	IF @CustomerID>0
	BEGIN
		INSERT INTO tblClaimNoteGeneration
		SELECT @countryId,prm.prmPromotionClientCode+ '_' + CAST(cus.cusCustomerClientCode AS VARCHAR(20)) + '_' + CAST(prm.promotionID AS VARCHAR(20))
		,prm.promotionID,prm.prmPromotionClientCode,@CustomerID,@secCustomerID,fin.finGeneralLedgerCodeBSh,@IsJournalGeneration,GETDATE(),@Creator
		FROM (SELECT * FROM tblPromotion WHERE promotionID = @PromotionID) AS prm
		INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
		INNER JOIN tblPromotionCustomer2 pcus ON prm.promotionID = pcus.promotionId
		INNER JOIN tblCustomer AS cus ON cus.customerID = pcus.customerID 
		WHERE prm.countryID = @countryId AND (pcus.customerID = @CustomerID or CAST(pcus.customerID AS VARCHAR(50)) = (cast(prm.countryID as varchar(10)) + cast(@CustomerID as varchar(20))))
	END
	ELSE
	BEGIN
		INSERT INTO tblClaimNoteGeneration
		SELECT DISTINCT @countryId,prm.prmPromotionClientCode+ '_' + CAST(cus.cusCustomerClientCode AS VARCHAR(20)) + '_' + CAST(prm.promotionID AS VARCHAR(20))
		,prm.promotionID,prm.prmPromotionClientCode,@CustomerID,@secCustomerID,fin.finGeneralLedgerCodeBSh,@IsJournalGeneration,GETDATE(),@Creator
		FROM (SELECT * FROM tblPromotion WHERE promotionID = @PromotionID) AS prm
		INNER JOIN tblPromoFinancial AS fin ON fin.promotionID=prm.promotionID 
		INNER JOIN tblPromotionSecondaryCustomer psec ON prm.promotionID = psec.promotionId
		INNER JOIN tblSecondaryCustomer AS sec ON sec.secondaryCustomerID = psec.secondaryCustomerID 
		INNER JOIN tblCustomer AS cus ON cus.customerID = sec.customerID 
		WHERE prm.countryID = @countryId AND (psec.secondaryCustomerID = @secCustomerID or CAST(psec.secondaryCustomerID AS VARCHAR(50)) = (cast(prm.countryID as varchar(10)) + cast(@secCustomerID as varchar(20))))
	END

	UPDATE prm SET prmStatusID = 11
	FROM (SELECT * FROM tblPromotion WHERE isDeleted=0 AND prmStatusID=10) prm
	INNER JOIN (SELECT cng2.promotionID,COUNT(cng2.customerID) genCount
		FROM (SELECT DISTINCT cng0.promotionID,cng0.customerID
			FROM tblClaimNoteGeneration cng0
			INNER JOIN (SELECT promotionID,customerID,MAX(CnCreationDate) CnCreationDate FROM tblClaimNoteGeneration GROUP BY promotionID,customerID) AS cng
			ON cng0.promotionID = cng.promotionID AND cng0.customerID = cng.customerID AND cng0.CnCreationDate = cng.CnCreationDate
			WHERE cng0.cnStatus=1) cng2
		GROUP BY cng2.promotionID) cng3 ON prm.promotionID = cng3.promotionID
	INNER JOIN (SELECT promotionID,CASE WHEN (SELECT COUNT(*) FROM tblPromotionCustomerSelection WHERE promotionID = @PromotionID AND cusGroup1ID=102000001)>0 THEN 1 ELSE COUNT(customerID) END cusCount 
				FROM tblPromotionCustomer2 GROUP BY promotionID) vcus2
		ON prm.promotionID = vcus2.promotionID AND cng3.genCount = vcus2.cusCount
END

