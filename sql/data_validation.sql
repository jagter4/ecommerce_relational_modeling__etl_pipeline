
USE ecommerce_db;

--/DATA VALIDATION

-- 1. CHECK FOR MISSING DATA
SELECT 
    * 
FROM 
    Products 
WHERE 
    ProductName IS NULL 
    OR Price IS NULL 
    OR StockQuantity IS NULL;

SELECT 
    * 
FROM 
    Users 
WHERE 
    Email IS NULL 
    OR UserName IS NULL;




-- 2. VALIDATE DATA FORMATS
-- Check that all email addresses in the Users table are correctly formatted
SELECT 
    * 
FROM 
    Users 
WHERE 
    Email NOT LIKE '%_@__%.__%';


-- 3. STANDADIZE DATA FORMATS
-- Check all dates in the Orders table are within a reasonable range
SELECT 
    * 
FROM 
    Orders 
WHERE 
    OrderDate < '2000-01-01' 
    OR OrderDate > CURDATE();


-- 4. CHECK FOR DUPLICATE ENTRIES
-- Check for duplicate UserIDs in the Users table
SELECT 
    UserID, 
    COUNT(*) 
FROM 
    Users 
GROUP BY 
    UserID 
HAVING 
    COUNT(*) > 1;


-- 5. ENFORCING CONSTRAINTS
-- Ensure Non-Negative Prices
ALTER TABLE 
    Products
ADD CONSTRAINT 
    chk_price CHECK (Price >= 0);

-- Ensure email addresses follow a basic format
ALTER TABLE 
    Users
ADD CONSTRAINT 
    chk_email CHECK (Email LIKE '%_@__%.__%');



-- 6. CASCADING DELETES
-- If a user is deleted, ensure that their associated orders are also deleted to avoid orphaned records
-- This foreign key constraint ensures that if a user is removed from the Users table, 
-- their associated orders are automatically deleted.
ALTER TABLE 
    Orders
ADD CONSTRAINT 
    fk_user
FOREIGN KEY 
    (UserID) REFERENCES Users(UserID)
ON DELETE 
    CASCADE;


