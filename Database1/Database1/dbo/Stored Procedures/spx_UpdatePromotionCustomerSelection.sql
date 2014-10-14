-- =============================================
-- Author: Sweta Sadhya		
-- Create date: 14-Jul-2014
-- Description:	update all field in customer selection table
-- =============================================
CREATE PROCEDURE [dbo].[spx_UpdatePromotionCustomerSelection] 
@PromotionID int
AS
BEGIN

update tblPromotionCustomerSelection 
set pslSelAllCusGroup1 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and cusGroup1ID is not null)  then 0
    else 1
    END
),
 pslSelAllCusGroup2 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and cusGroup2ID is not null)  then 0
    else 1
    END
),
 pslSelAllCusGroup3 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and cusGroup3ID is not null)  then 0
    else 1
    END
),
 pslSelAllCusGroup4 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and cusGroup4ID is not null)  then 0
    else 1
    END
),
 pslSelAllCusGroup5 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and cusGroup5ID is not null)  then 0
    else 1
    END
),
 pslSelAllCusGroup6 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and cusGroup6ID is not null)  then 0
    else 1
    END
),
 pslSelAllCusGroup7 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and cusGroup7ID is not null)  then 0
    else 1
    END
),
 pslSelAllSecGroup1 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and secGroup1ID is not null)  then 0
    else 1
    END
),
 pslSelAllSecGroup2 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and secGroup2ID is not null)  then 0
    else 1
    END
),
 pslSelAllSecGroup3 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and secGroup3ID is not null)  then 0
    else 1
    END
),
 pslSelAllSecGroup4 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and secGroup4ID is not null)  then 0
    else 1
    END
),
 pslSelAllSecGroup5 =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and secGroup5ID is not null)  then 0
    else 1
    END
),
 pslSelAllOutlet =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and outletID is not null)  then 0
    else 1
    END
),
 pslSelAllSecondaryCustomer =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and secondarycustomerID is not null)  then 0
    else 1
    END
),
 pslSelAllCustomer =
( case 
	when EXISTS (select 1 from tblPromotionCustomerSelection where promotionID = @PromotionID and customerID is not null)  then 0
    else 1
    END
)
where promotionID = @PromotionID
END
