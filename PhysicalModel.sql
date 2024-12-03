USE CarDealership;

-- Indexes
CREATE INDEX IX_Purchase_CarID ON Purchase(CarID);

CREATE INDEX IX_Customer_Name ON Customer(CustomerID);

-- Trigger
USE CarDealership;
-- Create the PurchaseAudit table for auditing
DROP TABLE IF EXISTS PurchaseAudit;

CREATE TABLE PurchaseAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    modifiedBy NVARCHAR(50) NOT NULL,
    modifiedDate DATETIME NOT NULL,
    operationType NVARCHAR(10) NOT NULL,
    PurchaseID INT,
    CarID INT,
    CustomerID INT,
    SaleDate DATE,
    Price DECIMAL(10, 2),
    DiscountedPrice DECIMAL(10, 2),
	FinalPrice DECIMAL(10, 2),
);

-- Create or alter the trigger on the Purchase table
GO
CREATE OR ALTER TRIGGER PurchaseAuditTrigger
ON Purchase
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @operation_type NVARCHAR(10),
            @modifiedBy NVARCHAR(50) = SUSER_SNAME(),
            @modifiedDate DATETIME = GETDATE();

    -- Handle inserted rows
    INSERT INTO PurchaseAudit (modifiedBy, modifiedDate, operationType, PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice, FinalPrice)
    SELECT @modifiedBy, @modifiedDate, 'INSERT', i.PurchaseID, i.CarID, i.CustomerID, i.SaleDate, i.Price, i.DiscountedPrice, i.FinalPrice
    FROM inserted i;
   
    -- Handle deleted rows
    INSERT INTO PurchaseAudit (modifiedBy, modifiedDate, operationType, PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice, FinalPrice)
    SELECT @modifiedBy, @modifiedDate, 'DELETE', d.PurchaseID, d.CarID, d.CustomerID, d.SaleDate, d.Price, d.DiscountedPrice, d.FinalPrice
    FROM deleted d;
    
END;


INSERT INTO Purchase (PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice, FinalPrice)
VALUES (132,12, 98, '2024-04-10', 25000.00, 23000.00, 22000.00);


DELETE FROM Purchase WHERE PurchaseID = 131;

SELECT * FROM PurchaseAudit;


-- Views

GO
CREATE OR ALTER VIEW CarDetails AS
SELECT Make, Model, Year 
FROM Car;

GO
SELECT * FROM CarDetails;

GO
CREATE OR ALTER VIEW CustomerDetails AS
SELECT CustomerID, firstName, lastName, Address -- hides the email and phone
FROM Customer;

GO
SELECT * FROM CustomerDetails;

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

-- procedure

GO
CREATE OR ALTER PROCEDURE UpdateCustomerInfo
    @CustomerID INT,
    @Address NVARCHAR(50),
    @Phone VARCHAR(16),
    @Email VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        -- Start the transaction
        BEGIN TRANSACTION;

        -- Update customer information
        UPDATE Customer
        SET 
            Address = @Address,
            Phone = @Phone,
            Email = @Email
        WHERE CustomerID = @CustomerID;


        COMMIT TRANSACTION;

        -- Print success message
        PRINT 'Customer information updated successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'An error occurred. Transaction rolled back.';
        END;

        THROW;
    END CATCH;
END;

EXEC UpdateCustomerInfo 
    @CustomerID = 10, 
    @Address = '123 Main St', 
    @Phone = '555-1234', 
    @Email = 'ClavanDsouza@example.com';

