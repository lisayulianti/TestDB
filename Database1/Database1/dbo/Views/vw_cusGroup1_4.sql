CREATE VIEW [dbo].[vw_cusGroup1_4]
AS
SELECT DISTINCT cus.countryID, cus.cusGroup1ID
	, cg1.c01CusGroup1ClientCode, cg1.c01CusGroup1Desc
	, cus.cusGroup4ID, cg4.c04CusGroup4ClientCode, cg4.c04CusGroup4Desc
FROM tblCustomer cus
INNER JOIN tblCusGroup1 cg1 ON cus.countryID = cg1.countryID AND cus.cusGroup1ID = cg1.cusGroup1ID
INNER JOIN tblCusGroup4 cg4 ON cus.countryID = cg4.countryID AND cus.cusGroup4ID = cg4.cusGroup4ID



