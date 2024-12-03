-- Insert statements for Make table
INSERT INTO Make (make) VALUES ('Dodge');
INSERT INTO Make (make) VALUES ('TVS');

-- Insert statements for Car table
INSERT INTO Car (CarID, Model, Make, Year, Condition, Price) 
VALUES (59, 'Camry', 'Toyota', '2022', 'New', '25000.00');

INSERT INTO Car (CarID, Model, Make, Year, Condition, Price) 
VALUES (79, 'Civic', 'Honda', '2021', 'Old', '15000.00');

-- Insert statements for Customer table
INSERT INTO Customer (CustomerID, firstName, lastName, Address, Phone, Email) 
VALUES (149, 'Clavan', 'Dsouza', '123 Main St', '555-1234', 'clavandsouza@example.com');

INSERT INTO Customer (CustomerID, firstName, lastName, Address, Phone, Email) 
VALUES (148, 'Dsouza', 'Clavan', '456 Elm St', '555-5678', 'dsouzaclavan@example.com');

-- Insert statements for CarExchange table
INSERT INTO CarExchange (ExchangeID, OldCarID, NewCarID, CustomerID, ExchangeDate) 
VALUES (159, 16, 25, 1, '2024-04-10');

INSERT INTO CarExchange (ExchangeID, OldCarID, NewCarID, CustomerID, ExchangeDate) 
VALUES (247, 2, 1, 2, '2024-04-11');

-- Insert statements for Purchase table
INSERT INTO Purchase (PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice, FinalPrice) 
VALUES (169, 1, 1, '2024-04-10', 25000.00, 23000.00, dbo.CalculateTotalPrice(25000.00, 23000.00));

INSERT INTO Purchase (PurchaseID, CarID, CustomerID, SaleDate, Price, DiscountedPrice, FinalPrice) 
VALUES (268, 2, 2, '2024-04-11', 15000.00, 14000.00, dbo.CalculateTotalPrice(15000.00, 14000.00));
