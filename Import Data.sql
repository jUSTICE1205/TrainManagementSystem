use CarDealership;
INSERT INTO Make
SELECT * FROM makeCSV;

use CarDealership;
INSERT INTO Car
SELECT * FROM carCSV;



use CarDealership;
INSERT INTO Customer
SELECT * FROM CustomersCSV;


use CarDealership;
INSERT INTO CarExchange
SELECT * FROM CarExchangeCSV;


use CarDealership;
INSERT INTO Purchase
SELECT * FROM PurchaseCSV;

