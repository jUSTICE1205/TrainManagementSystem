use CarDealership;

SELECT 
    p.PurchaseID,
    c.firstName AS CustomerFirstName,
    c.lastName AS CustomerLastName,
    c.Address AS CustomerAddress,
    c.Phone AS CustomerPhone,
    car.Model AS CarModel,
    car.Make AS CarMake,
    car.Year AS CarYear,
    p.SaleDate,
    p.Price,
    p.DiscountedPrice,
    p.FinalPrice
FROM 
    Purchase p
INNER JOIN 
    Customer c ON p.CustomerID = c.CustomerID
INNER JOIN 
    Car car ON p.CarID = car.CarID;