
CREATE PROCEDURE [dbo].[spx_InsertReleasesGeneration]	
	@countryId int,
	@PromotionID int,
	@CustomerID int,
	@IsJournalGeneration int,
	@Creator nvarchar(50)
AS
BEGIN
	INSERT INTO tblReleaseJournalGeneration VALUES(@PromotionID,@CustomerID,@countryId,@IsJournalGeneration,GETDATE(),@Creator)

	UPDATE prm SET prmStatusID = 12
	FROM (SELECT * FROM tblPromotion WHERE isDeleted=0 AND prmStatusID=11) prm
	INNER JOIN (SELECT rjg0.promotionID,COUNT(rjg0.customerID) genCount
		FROM tblReleaseJournalGeneration rjg0
		INNER JOIN (SELECT promotionID,customerID,MAX(rgJournalcreationDate) rgJournalcreationDate FROM tblReleaseJournalGeneration GROUP BY promotionID,customerID) AS rjg
		ON rjg0.promotionID = rjg.promotionID AND rjg0.customerID = rjg.customerID AND rjg0.rgJournalcreationDate = rjg.rgJournalcreationDate
		WHERE rjg0.rgJournalgeneration=1
		GROUP BY rjg0.promotionID) rjg2 ON prm.promotionID = rjg2.promotionID
	INNER JOIN (SELECT promotionID,CASE WHEN (SELECT COUNT(*) FROM tblPromotionCustomerSelection WHERE promotionID = @PromotionID AND cusGroup1ID=102000001)>0 THEN 1 ELSE COUNT(customerID) END cusCount 
				FROM vw_PromoCust GROUP BY promotionID) vcus2
		ON prm.promotionID = vcus2.promotionID AND rjg2.genCount = vcus2.cusCount
END
