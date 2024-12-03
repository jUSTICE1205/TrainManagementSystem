/*
 * Name: Clavan Dsouza
 * Course: DataBase 2
 * Date: 10/04/2024
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
    make NVARCHAR(50) NOT NULL PRIMARY KEY
);

CREATE TABLE Car (
    CarID INT NOT NULL PRIMARY KEY,
    Model NVARCHAR(50) NOT NULL,
    Make NVARCHAR(50) NOT NULL,
	Year NVARCHAR(10) NOT NULL,
    Condition NVARCHAR(10) NOT NULL,
    Price  NVARCHAR(50) NOT NULL,
    CONSTRAINT manufacturesFk
        FOREIGN KEY (Make)
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
    Email NVARCHAR(50) NOT NULL
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