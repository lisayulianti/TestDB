-- =============================================
-- Author: Sweta Sadhya		
-- Create date: 14-Jul-2014
-- Description:	generates customer data with grouping
-- =============================================
CREATE PROCEDURE [dbo].[spx_GetAllCustomers] 
@countryID int
AS
BEGIN

SELECT c.countryID,
               c.customerID, c.cusCustomerClientCode, c.cusCustomerName,
			   s.secFPercentage,
                c.cusGroup1ID, cg1.c01CusGroup1ClientCode CusGroup1ClientCode, cg1.c01CusGroup1Desc CusGroup1Desc,
                c.cusGroup2ID, cg2.c02CusGroup2ClientCode CusGroup2ClientCode, cg2.c02CusGroup2Desc CusGroup2Desc,
				c.cusGroup3ID, cg3.c03CusGroup3ClientCode CusGroup3ClientCode, cg3.c03CusGroup3Desc CusGroup3Desc,
                c.cusGroup4ID, cg4.c04CusGroup4ClientCode CusGroup4ClientCode, cg4.c04CusGroup4Desc CusGroup4Desc,
                c.cusGroup5ID, cg5.c05CusGroup5ClientCode CusGroup5ClientCode, cg5.c05CusGroup5Desc CusGroup5Desc,
                c.cusGroup6ID, cg6.c06CusGroup6ClientCode CusGroup6ClientCode, cg6.c06CusGroup6Desc CusGroup6Desc,
                c.cusGroup7ID, cg7.c07CusGroup7ClientCode CusGroup7ClientCode, cg7.c07CusGroup7Desc CusGroup7Desc,

                s.secGroup1ID, sg1.s01SecGroup1ClientCode  SecGroup1ClientCode, sg1.s01SecGroup1Desc SecGroup1Desc,
                s.secGroup2ID, sg2.s02SecGroup2ClientCode  SecGroup2ClientCode, sg2.s02SecGroup2Desc SecGroup2Desc,
                s.secGroup3ID, sg3.s03SecGroup3ClientCode  SecGroup3ClientCode, sg3.s03SecGroup3Desc SecGroup3Desc,
                s.secGroup4ID, sg4.s04SecGroup4ClientCode  SecGroup4ClientCode, sg4.s04SecGroup4Desc SecGroup4Desc,
				s.secGroup5ID, sg5.s05SecGroup5ClientCode  SecGroup5ClientCode, sg5.s05SecGroup5Desc SecGroup5Desc,

				o.outletID, o.outOutletDesc, o.outOutletClientCode

                FROM tblCustomer c  
                INNER JOIN (SELECT countryID, customerID, MAX(validFrom) validFromMax FROM tblCustomer GROUP BY countryID, customerID) c2 
	                ON c.countryID = c2.countryID AND c.customerID = c2.customerID AND c.validFrom = c2.validFromMax
                LEFT JOIN (tblSecondaryCustomer s 
                    INNER JOIN (SELECT countryID, secondaryCustomerID, MAX(validFrom) validFromMax FROM tblSecondaryCustomer GROUP BY countryID, secondaryCustomerID) s2 
	                    ON s.countryID = s2.countryID AND s.secondaryCustomerID = s2.secondaryCustomerID AND s.validFrom = s2.validFromMax)
                    ON s.customerID = c.customerID
				LEFT JOIN tblCusGroup1 cg1 on c.cusGroup1ID = cg1.cusGroup1ID
				LEFT JOIN tblCusGroup2 cg2 on c.cusGroup2ID = cg2.cusGroup2ID
				LEFT JOIN tblCusGroup3 cg3 on c.cusGroup3ID = cg3.cusGroup3ID
				LEFT JOIN tblCusGroup4 cg4 on c.cusGroup4ID = cg4.cusGroup4ID
				LEFT JOIN tblCusGroup5 cg5 on c.cusGroup5ID = cg5.cusGroup5ID
				LEFT JOIN tblCusGroup6 cg6 on c.cusGroup6ID = cg6.cusGroup6ID
				LEFT JOIN tblCusGroup7 cg7 on c.cusGroup7ID = cg7.cusGroup7ID
				LEFT JOIN tblSecGroup1 sg1 on s.secGroup1ID = sg1.secGroup1ID
				LEFT JOIN tblSecGroup2 sg2 on s.secGroup2ID = sg2.secGroup2ID
				LEFT JOIN tblSecGroup3 sg3 on s.secGroup3ID = sg3.secGroup3ID
				LEFT JOIN tblSecGroup4 sg4 on s.secGroup4ID = sg4.secGroup4ID
				LEFT JOIN tblSecGroup5 sg5 on s.secGroup5ID = sg5.secGroup5ID
				LEFT JOIN tblOutlet o on o.customerID = c.customerID

                WHERE c.countryId = @countryID

                GROUP BY c.countryID,
                c.customerID, c.cusCustomerClientCode, c.cusCustomerName, s.secFPercentage,
                c.cusGroup1ID, cg1.c01CusGroup1ClientCode, cg1.c01CusGroup1Desc,
                c.cusGroup2ID, cg2.c02CusGroup2ClientCode, cg2.c02CusGroup2Desc,
                c.cusGroup3ID, cg3.c03CusGroup3ClientCode, cg3.c03CusGroup3Desc,
                c.cusGroup4ID, cg4.c04CusGroup4ClientCode, cg4.c04CusGroup4Desc,
                c.cusGroup5ID, cg5.c05CusGroup5ClientCode, cg5.c05CusGroup5Desc,
                c.cusGroup6ID, cg6.c06CusGroup6ClientCode, cg6.c06CusGroup6Desc,
                c.cusGroup7ID, cg7.c07CusGroup7ClientCode, cg7.c07CusGroup7Desc,
			   
                s.secGroup1ID, sg1.s01SecGroup1ClientCode, sg1.s01SecGroup1Desc,
                s.secGroup2ID, sg2.s02SecGroup2ClientCode, sg2.s02SecGroup2Desc,
                s.secGroup3ID, sg3.s03SecGroup3ClientCode, sg3.s03SecGroup3Desc,
                s.secGroup4ID, sg4.s04SecGroup4ClientCode, sg4.s04SecGroup4Desc,
				s.secGroup5ID, sg5.s05SecGroup5ClientCode, sg5.s05SecGroup5Desc,

				o.outletID, o.outOutletDesc, o.outOutletClientCode
END
