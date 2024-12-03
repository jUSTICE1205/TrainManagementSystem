--inner join

use CarDealership;

SELECT 
    c.CustomerID,
    c.firstName,
    c.lastName,
    ca.CarID,
    ca.Model,
    ca.Year,
    p.PurchaseID,
    p.SaleDate,
    p.Price
FROM 
    Customer c
INNER JOIN 
    Purchase p ON c.CustomerID = p.CustomerID
INNER JOIN 
    Car ca ON p.CarID = ca.CarID;

-- outer join

SELECT 
    c.Model, c.make, c. Year, c. Price
FROM 
    Car c
LEFT JOIN 
    Purchase p ON c.CarID = p.CarID
WHERE 
    p.CarID IS NULL;



-- agg
SELECT 
    c.CustomerID,
    c.firstName,
    c.lastName,
    COUNT(p.PurchaseID) AS TotalPurchases
FROM 
    Customer c
LEFT JOIN 
    Purchase p ON c.CustomerID = p.CustomerID
GROUP BY 
    c.CustomerID,
    c.firstName,
    c.lastName;
