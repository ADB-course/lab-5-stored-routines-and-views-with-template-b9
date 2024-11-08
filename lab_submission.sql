-- (i) A Procedure called PROC_LAB5
DELIMITER $$

CREATE PROCEDURE PROC_LAB5 (IN target_month VARCHAR(7))
BEGIN
    SELECT 
        e.EmployeeID,
        e.EmployeeName,
        SUM(s.SaleAmount) AS TotalSales
    FROM
        Employees e
    JOIN Sales s ON e.EmployeeID = s.EmployeeID
    WHERE DATE_FORMAT(s.SaleDate, '%Y-%m') = target_month
    GROUP BY e.EmployeeID, e.EmployeeName
    ORDER BY TotalSales DESC;
END$$

DELIMITER ;

SHOW PROCEDURE STATUS

-- (ii) A Function called FUNC_LAB5
DELIMITER $$

CREATE FUNCTION `FUNC_LAB5`(customerID INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE totalRevenue DECIMAL(10,2);
    
    SELECT SUM(orderdetails.quantityOrdered * orderdetails.priceEach) 
    INTO totalRevenue
    FROM orders
    JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
    WHERE orders.customerNumber = customerID;
    
    RETURN totalRevenue;
END$$

DELIMITER ;


-- (iii) A View called VIEW_LAB5
DELIMITER $$

CREATE VIEW VIEW_LAB5 AS
SELECT 
    e.EmployeeID,
    e.EmployeeName,
    COALESCE(SUM(s.SaleAmount), 0) AS TotalSales,
    COALESCE(FUNC_LAB5(c.CustomerID), 0) AS TotalRevenue
FROM 
    Employees e
LEFT JOIN Sales s ON e.EmployeeID = s.EmployeeID
LEFT JOIN Customers c ON c.SalesRepEmployeeID = e.EmployeeID
GROUP BY 
    e.EmployeeID, e.EmployeeName
ORDER BY 
    TotalSales DESC;

SELECT * FROM VIEW_LAB5;

DELIMITER ;
