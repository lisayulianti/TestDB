CREATE VIEW [dbo].[vw_cusGroup4_5]
AS
SELECT DISTINCT cus.countryID
	, cus.cusGroup4ID, cg4.c04CusGroup4ClientCode, cg4.c04CusGroup4Desc
	, cus.cusGroup5ID, cg5.c05CusGroup5ClientCode, cg5.c05CusGroup5Desc
FROM tblCustomer cus
INNER JOIN tblCusGroup4 cg4 ON cus.countryID = cg4.countryID AND cus.cusGroup4ID = cg4.cusGroup4ID
INNER JOIN tblCusGroup5 cg5 ON cus.countryID = cg5.countryID AND cus.cusGroup5ID = cg5.cusGroup5ID



