/*
 * Name: Clavan Dsouza
 * Course: DataBase 2
 * Date: 03/03/2024
 */

USE CarDealership;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Purchase;
DROP TABLE IF EXISTS CarExchange;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Make;

-- Create Tables
CREATE TABLE Make (
    make NVARCHAR(30) NOT NULL PRIMARY KEY
);

CREATE TABLE Car (
    CarID INT NOT NULL PRIMARY KEY,
    Model NVARCHAR(30) NOT NULL,
    make NVARCHAR(30) NOT NULL,
    Condition NVARCHAR(3) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Year DATE NOT NULL,
	CONSTRAINT manufacturesFk
		FOREIGN KEY (make)
		REFERENCES Make(make),
	CONSTRAINT CHECK_Car_Condition
		CHECK (Condition IN ('New', 'Old'))
);

CREATE TABLE Customer (
    CustomerID INT NOT NULL PRIMARY KEY,
    firstName NVARCHAR(40) NOT NULL,
	lastName NVARCHAR(40) NOT NULL,
    Address NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(30) NOT NULL
);

CREATE TABLE CarExchange (
    ExchangeID INT NOT NULL PRIMARY KEY,
    OldCarID INT NOT NULL,
    NewCarID INT NOT NULL,
    CustomerID INT NOT NULL,
    ExchangeDate DATE NOT NULL,
	CONSTRAINT tradeFk
		FOREIGN KEY (OldCarID)
		REFERENCES Car(CarID),
	CONSTRAINT forFk
		FOREIGN KEY (NewCarID)
		REFERENCES Car(CarID),
	CONSTRAINT makesFk
		FOREIGN KEY (CustomerID)
		REFERENCES Customer(CustomerID)
);

CREATE TABLE Purchase (
    PurchaseID INT NOT NULL PRIMARY KEY,
    CarID INT NOT NULL,
    CustomerID INT NOT NULL,
    SaleDate DATE NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    DiscountedPrice DECIMAL(10, 2) NOT NULL,
	FinalPrice DECIMAL(10, 2) NOT NULL,
	CONSTRAINT boughtFk
		FOREIGN KEY (CarID)
		REFERENCES Car(CarID),
	CONSTRAINT participatesFk
		FOREIGN KEY (CustomerID)
		REFERENCES Customer(CustomerID)
);

-- Indexes 
CREATE INDEX IX_Purchase_CarID ON Purchase(CarID);

CREATE INDEX IX_Customer_Name ON Customer(CustomerID);

-- Trigger
USE CarDealership;
-- Create the PurchaseAudit table for auditing
DROP TABLE IF EXISTS PurchaseAudit;

CREATE TABLE PurchaseAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    Operation NVARCHAR(10) NOT NULL, -- Insert, Update, Delete
    PurchaseID INT,
    CarID INT,
    CustomerID INT,
    SaleDate DATE,
    Price DECIMAL(10, 2),
    DiscountedPrice DECIMAL(10, 2),
    AuditDateTime DATETIME DEFAULT GETDATE() -- Date and time of the audit
);

-- Create or alter the trigger on the Purchase table
GO
CREATE OR ALTER TRIGGER PurchaseAuditTrigger
ON Purchase
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert audit records for insert operations
    INSERT INTO PurchaseAudit (Operation, PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice)
    SELECT 'Insert', PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice
    FROM inserted;

    -- Insert audit records for update operations
    INSERT INTO PurchaseAudit (Operation, PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice)
    SELECT 'Update', PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice
    FROM deleted;

    -- Insert audit records for delete operations
    INSERT INTO PurchaseAudit (Operation, PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice)
    SELECT 'Delete', PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice
    FROM deleted;
END;


-- Views

GO
CREATE VIEW UsedCars AS
SELECT *
FROM Car
WHERE Condition = 'Old';

GO
CREATE VIEW CustomerDetails AS
SELECT CustomerID, firstName, lastName, Address
FROM Customer;

--functions

-- CalculateTotalPrice function
GO
CREATE OR ALTER FUNCTION CalculateTotalPrice (@Price DECIMAL(10, 2), @DiscountedPrice DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalPrice DECIMAL(10, 2);

    -- Calculate total price
    SET @TotalPrice = @Price - @DiscountedPrice;

    RETURN @TotalPrice;
END;


-- pr0cedure
GO
CREATE PROCEDURE UpdateCustomerInfo
    @CustomerID INT,
    @Address NVARCHAR(50),
    @Phone VARCHAR(16),
    @Email VARCHAR(255)
AS
BEGIN
    -- Start the transaction
    BEGIN TRANSACTION;

    -- Update customer information
    UPDATE Customer
    SET 
        Address = @Address,
        Phone = @Phone,
        Email = @Email
    WHERE CustomerID = @CustomerID;

    -- Commit the transaction if update is successful
    COMMIT TRANSACTION;

    -- Print success message
    PRINT 'Customer information updated successfully.';

    -- Rollback the transaction if any error occurs
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred. Transaction rolled back.';
    END;
END;

