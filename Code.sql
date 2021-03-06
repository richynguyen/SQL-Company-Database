COLUMN ProductID FORMAT a10
COLUMN ProductName FORMAT a20
COLUMN ProductFinish FORMAT a20
COLUMN ProductLineID FORMAT a20
COLUMN Photo FORMAT a20
COLUMN CustomerState FORMAT a20
COLUMN CustomerCity FORMAT a20
COLUMN CustomerName FORMAT a30
COLUMN CustomerAddress FORMAT a30


/* VIEW 1 - A list of each of the products in the product line showing each product's
total sales to date*/
CREATE OR REPLACE VIEW View1_Comparison (ProductLineID, ProductName, Total) AS
SELECT PL.ProductLineID, P.ProductName, SUM(P.ProductStandardPrice*O.OrderedQuantity) AS Total
FROM Product P, Orderline O, ProductLine PL
WHERE P.ProductID = O.ProductID AND PL.ProductLineID = P.ProductLineID
GROUP BY PL.ProductLineID, P.ProductName
ORDER BY ProductLineID;

SELECT * FROM View1_Comparison;


/* VIEW 2 - Total value of orders placed for each furniture product */
CREATE OR REPLACE VIEW View2_Sales (ProductName, Total) AS
SELECT P.ProductName, SUM(P.ProductStandardPrice*O.OrderedQuantity) AS Total
FROM Product P, Orderline O
GROUP BY P.ProductName;

SELECT * FROM View2_Sales;


/* VIEW 3 - For each customer in his territory, produce the list of products and their prices */
CREATE OR REPLACE VIEW View3_CustomerData (TerritoryID, ProductID, ProductName, ProductStandardPrice) AS
SELECT T.TerritoryID, P.ProductID, P.ProductName, P.ProductStandardPrice
FROM Territory T, DoesBusinessIn D, Orders O, OrderLine OL, Product P
WHERE T.TerritoryID = D.TerritoryID AND D.CustomerID = O.CustomerID AND O.OrderID = OL.OrderID 
AND OL.ProductID = P.ProductID
GROUP BY T.TerritoryID, P.ProductID, P.ProductName, P.ProductStandardPrice
ORDER BY T.TerritoryID;

SELECT * FROM View3_CustomerData;


/* VIEW 4 - Count the number of customers with addresses in each state to which we ship */
CREATE OR REPLACE VIEW View4_Shipment (CustomerCity, CustomerState, Count) AS
SELECT CustomerCity, CustomerState, COUNT(*) AS "Count"
FROM Customer
GROUP BY CustomerState, CustomerCity
ORDER BY CustomerState;

SELECT * FROM View4_Shipment;


/* VIEW 5 - List the customer's purchase history displaying the order date, the quantity,
the price, and the name of the product */
CREATE OR REPLACE VIEW View5_purchasehistory (CustomerID, OrderID, OrderDate, Quantity, 
Price, ProductName) AS
SELECT O.CustomerID, O.OrderID, O.OrderDate, OL.OrderedQuantity, 
P.ProductStandardPrice, P.ProductName
FROM Orders O, OrderLine OL, Product P
WHERE O.OrderID = OL.OrderID AND OL.ProductID = P.ProductID
ORDER BY O.OrderID;

SELECT * FROM View5_purchasehistory;


/* VIEW 6 - List OrderID, Date, CustomerID, ProductID, and Quantity of all orders */
CREATE OR REPLACE VIEW View6_Ordered (OrderID, "Date", CustomerID, ProductID, Quantity) AS
SELECT O.OrderID, O.OrderDate, O.CustomerID, OL.ProductID, OL.OrderedQuantity
FROM Orders O, OrderLine OL
WHERE O.OrderID = OL.OrderID;

SELECT * FROM View6_Ordered;


/* Create Customer Table */
/*----------------------------------------------------------------*/
CREATE TABLE Customer
(
    CustomerID INT,
    CustomerName NVARCHAR2(50),
    CustomerAddress NVARCHAR2(50),
    CustomerCity NVARCHAR2(50),
    CustomerState NVARCHAR2(50),
    CustomerPostalCode NVARCHAR2(50),
    CustomerEmail NVARCHAR2(50),
    CustomerUserName NVARCHAR2(50),
    CustomerPassword NVARCHAR2(50),
    PRIMARY KEY (CustomerID)
);


/* Create Salesperson Table */
/*----------------------------------------------------------------*/
CREATE TABLE Salesperson
(
    SalespersonID INT,
    SalespersonnName NVARCHAR2(50),
    SalespersonPhone NVARCHAR2(50),
    SalespersoneEmail NVARCHAR2(50),
    SalespersonUserName NVARCHAR2(50),
    SalespersonPassword NVARCHAR2(50),
    TerritoryID INT,
    PRIMARY KEY (SalespersonID)
);


/* Create Territory Table */
/*----------------------------------------------------------------*/
CREATE TABLE Territory
(
    TerritoryID INT,
    TerritoryName NVARCHAR2(50),
    PRIMARY KEY (TerritoryID)
);


/* Create DoesBusinessIn Table */
/*----------------------------------------------------------------*/
CREATE TABLE DoesBusinessIn
(
    CustomerID INT,
    TerritoryID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TerritoryID) REFERENCES Territory(TerritoryID)
);


/* Create Product Table */
/*----------------------------------------------------------------*/
CREATE TABLE Product
(
    ProductID INT,
    ProductName NVARCHAR2(50),
    ProductFinish NVARCHAR2(50),
    ProductStandardPrice INT,
    ProductLineID INT,
    Photo NVARCHAR2(50),
    PRIMARY KEY (ProductID)
);


/* Create ProductLine Table */
/*----------------------------------------------------------------*/
CREATE TABLE ProductLine
(
    ProductLineID INT,
    ProductLineName NVARCHAR2(50),
    PRIMARY KEY (ProductLineID)
);


/* Create Order Table */
/*----------------------------------------------------------------*/
CREATE TABLE Orders
(
    OrderID INT,
    OrderDate DATE,
    CustomerID INT,
    PRIMARY KEY (OrderID)
);


/* Create OrderLine Table */
/*----------------------------------------------------------------*/
CREATE TABLE OrderLine
(
    OrderID INT,
    ProductID INT,
    OrderedQuantity INT,
    SalePrice INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


/* Create PriceUpdate Table */
/*----------------------------------------------------------------*/
CREATE TABLE PriceUpdate
(
    PriceUpdateID INT,
    DateChanged DATE,
    OldPrice INT,
    NewPrice INT
);


/* Inserting data into Customer Table */
/*----------------------------------------------------------------*/
INSERT INTO Customer
VALUES (1, 'Contemporary Casuals', '1355 S Hines Blvd', 'Gainesville', 'FL', '32601-2871', 
        NULL, NULL, NULL);
     
INSERT INTO Customer
VALUES (2, 'Value Furnitures', '15145 S.W. 17th St.', 'Plano', 'TX', '75094-7734',
        NULL, NULL, NULL);

INSERT INTO Customer
VALUES (3, 'Home Furnishings', '1900 Allard Ave', 'Albany', 'NY', '12209-1125',  
        'homefurnishings?@gmail.com', 'CUSTOMER1', 'CUSTOMER1#');
     
INSERT INTO Customer
VALUES (4, 'Eastern Furniture', '1925 Beltline Rd.', 'Carteret', 'NJ', '07008-3188',
        NULL, NULL, NULL);
     
INSERT INTO Customer
VALUES (5, 'Impressions', '5585 Westcott Ct.', 'Sacramento', 'CA', '94206-4056',
        NULL, NULL, NULL);
     
INSERT INTO Customer
VALUES (6, 'Furniture Gallery', '325 Flatiron Dr.', 'Boulder', 'CO', '80514-4432',
        NULL, NULL, NULL);

INSERT INTO Customer
VALUES (7, 'New Furniture', 'Palace Ave', 'Farmington', 'NM', NULL, NULL, NULL, NULL);
    
INSERT INTO Customer
VALUES (8, 'Dunkins Furniture', '7700 Main St', 'Syracuse', 'NY', '31590',
        NULL, NULL, NULL);
     
INSERT INTO Customer
VALUES (9, 'A Carpet', '434 Abe Dr', 'Rome', 'NY', '13440', NULL, NULL, NULL);
    
INSERT INTO Customer
VALUES (12, 'Flanigan Furniture', 'Snow Flake Rd', 'Ft Walton Beach', 'FL', '32548',
        NULL, NULL, NULL);
     
INSERT INTO Customer
VALUES (13, 'Ikards', '1011 S. Main St', 'Las Cruces', 'NM', '88001', NULL, NULL, NULL);
    
INSERT INTO Customer
VALUES (14, 'Wild Bills', 'Four Horse Rd', 'Oak Brook', 'Il', '60522', NULL, NULL, NULL);
    
INSERT INTO Customer
VALUES (15, 'Janet''s Collection', 'Janet Lane', 'Virginia Beach', 'VA', '10012', NULL, NULL, NULL);

INSERT INTO Customer
VALUES (16, 'ABC Furniture Co.', '152 Geramino Drive', 'Rome', 'NY', '13440', NULL, NULL, NULL);
    

/* Inserting into Salesperson Table */
/*----------------------------------------------------------------*/
INSERT INTO Salesperson
VALUES (1, 'Doug Henny', '8134445555', 'salesperson?@gmail.com', 'SALESPERSON', 'SALESPERSON#', 1);
    
INSERT INTO Salesperson
VALUES (2, 'Robert Lewis', '8139264006', NULL, NULL, NULL, 2);
    
INSERT INTO Salesperson
VALUES (3, 'William Strong', '5053821212', NULL, NULL, NULL, 3);
    
INSERT INTO Salesperson
VALUES (4, 'Julie Dawson', '4355346677', NULL, NULL, NULL, 4);
    
INSERT INTO Salesperson
VALUES (5, 'Jacob Winslow', '2238973498', NULL, NULL, NULL, 5);


/* Insert into Territory Table */
/*----------------------------------------------------------------*/
INSERT INTO Territory
VALUES (1, 'SouthEast');
    
INSERT INTO Territory
VALUES (2, 'SouthWest');
    
INSERT INTO Territory
VALUES (3, 'NorthEast');
    
INSERT INTO Territory
VALUES (4, 'NorthWest');
    
INSERT INTO Territory
VALUES (5, 'Central');


/* Insert into DoesBusinessIn Table */
/*----------------------------------------------------------------*/
INSERT INTO DoesBusinessIn
VALUES (1,1);

INSERT INTO DoesBusinessIn
VALUES (2,2);

INSERT INTO DoesBusinessIn
VALUES (3,3);

INSERT INTO DoesBusinessIn
VALUES (4,4);

INSERT INTO DoesBusinessIn
VALUES (5,5);

INSERT INTO DoesBusinessIn
VALUES (6,1);

INSERT INTO DoesBusinessIn
VALUES (7,2);


/* Insert into Product Table */
/*----------------------------------------------------------------*/
INSERT INTO Product
VALUES (1, 'End Table', 'Cherry', 175, 1, 'table.jpg');

INSERT INTO Product
VALUES (2, 'Coffee Table', 'Natural Ash', 200, 2, NULL);

INSERT INTO Product
VALUES (3, 'Computer Desk', 'Natural Ash', 375, 2, NULL);

INSERT INTO Product
VALUES (4, 'Entertainment Center', 'Natural Maple', 650, 3, NULL);

INSERT INTO Product
VALUES (5, 'Writers Desk', 'Cherry', 325, 1, NULL);

INSERT INTO Product
VALUES (6, '8-Drawer Desk', 'White Ash', 750, 2, NULL);

INSERT INTO Product
VALUES (7, 'Dining Table', 'Natural Ash', 800, 2, NULL);

INSERT INTO Product
VALUES (8, 'Computer Desk', 'Walnut', 250, 3, NULL);


/* Insert into ProductLine */
/*----------------------------------------------------------------*/
INSERT INTO ProductLine
VALUES (1, 'Cherry Tree');

INSERT INTO ProductLine
VALUES (2, 'Scandinavia');

INSERT INTO ProductLine
VALUES (3, 'Country Look');


/* Insert into Orders Table */
/*----------------------------------------------------------------*/
INSERT INTO Orders
VALUES (1001, '21/Aug/16', 1);

INSERT INTO Orders
VALUES (1002, '21/Jul/16', 8);

INSERT INTO Orders
VALUES (1003, '22/Aug/16', 15);

INSERT INTO Orders
VALUES (1004, '22/Oct/16', 5);

INSERT INTO Orders
VALUES (1005, '24/Jul/16', 3);

INSERT INTO Orders
VALUES (1006, '24/Oct/16', 2);

INSERT INTO Orders
VALUES (1007, '27/Aug/16', 5);

INSERT INTO Orders
VALUES (1008, '30/Oct/16', 12);

INSERT INTO Orders
VALUES (1009, '05/Nov/16', 4);

INSERT INTO Orders
VALUES (1010, '05/Nov/16', 1);


/* Insert into OrderLine */
/*----------------------------------------------------------------*/
INSERT INTO OrderLine
VALUES (1001, 1, 2, NULL);

INSERT INTO OrderLine
VALUES (1001, 2, 2, NULL);

INSERT INTO OrderLine
VALUES (1001, 4, 1, NULL);

INSERT INTO OrderLine
VALUES (1002, 3, 5, NULL);

INSERT INTO OrderLine
VALUES (1003, 3, 3, NULL);

INSERT INTO OrderLine
VALUES (1004, 6, 2, NULL);

INSERT INTO OrderLine
VALUES (1004, 8, 2, NULL);

INSERT INTO OrderLine
VALUES (1005, 4, 4, NULL);

INSERT INTO OrderLine
VALUES (1006, 4, 1, NULL);

INSERT INTO OrderLine
VALUES (1006, 5, 2, NULL);

INSERT INTO OrderLine
VALUES (1006, 7, 2, NULL);

INSERT INTO OrderLine
VALUES (1007, 1, 3, NULL);

INSERT INTO OrderLine
VALUES (1007, 2, 2, NULL);

INSERT INTO OrderLine
VALUES (1008, 3, 3, NULL);

INSERT INTO OrderLine
VALUES (1008, 8, 3, NULL);

INSERT INTO OrderLine
VALUES (1009, 4, 2, NULL);

INSERT INTO OrderLine
VALUES (1009, 7, 3, NULL);

INSERT INTO OrderLine
VALUES (1010, 8, 10, NULL);


/*----------------------------------------------------------------*/
/* Q1 - Which products have a standard price of less than $ 275? */
-- ProductName          ProductStandardPrice
-- End Table            175
-- Coffee Table         200
-- Computer Desk        250

CREATE VIEW No_1_standardprice (ProductName, ProductStandardPrice) AS
SELECT ProductName, ProductStandardPrice
FROM Product
WHERE ProductStandardPrice < 275;

SELECT * FROM No_1_standardprice;


/* Q2 - List the unit price, product name, and product ID for all products
in the Product table. */
-- ProductID    ProductName             ProductStandardPrice
-- 1            End Table               175
-- 2            Coffee Table            200
-- 3            Computer Desk           375
-- 4            Entertainment Center    650
-- 5            Writers Desk            325
-- 6            8-Drawer Desk           750
-- 7            Dining Table            800
-- 8            Computer Desk           250

CREATE VIEW No_2_products (ProductID, ProductName, ProductStandardPrice) AS
SELECT ProductID, ProductName, ProductStandardPrice
FROM Product;

SELECT * FROM No_2_products;


/* Q3 - What is the average standard price for all products in inventory? */
-- ProductStandardPriceAVG
-- 440.625

CREATE VIEW No_3_avgprice (ProductStandardPriceAVG) AS
SELECT AVG(ProductStandardPrice) AS "AVG Standard price"
FROM Product;

SELECT * FROM No_3_avgprice;


/* Q4 - How many different items were ordered on
order number 1004? */
-- SumofOrderedQuantity
-- 4

CREATE VIEW No_4_sum (SumofOrderedQuantity) AS
SELECT SUM(OrderedQuantity)
FROM Orderline
WHERE OrderID = '1004';

SELECT * FROM No_4_sum;


/* Q5 - Which orders have been placed since 10/ 24/ 2010? */
-- OrderID      OrderDate
-- 1001         21-Aug-16
-- 1002         21-Jul-16
-- 1003         22-Aug-16
-- 1004         22-Oct-16
-- 1005         24-Jul-16
-- 1006         24-Oct-16
-- 1007         27-Aug-16
-- 1008         30-Oct-16
-- 1009         05-Nov-16
-- 1010         05-Nov-16

CREATE VIEW No_5_orders (OrderID, OrderDate) AS
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderDate > '24/Oct/2010';

SELECT * FROM No_5_orders;


/* Q6 - What furniture does COSC3380 carry that isnt made of cherry? */
-- ProductID    ProductName             ProductFinish
-- 2            Coffee Table            Natural Ash
-- 3            Computer Desk           Natural Ash
-- 4            Entertainment Center    Natural Maple
-- 6            8-Drawer Desk           White Ash
-- 7            Dining Table            Natural Ash
-- 8            Computer Desk           Walnut

CREATE VIEW No_6_cherry (ProductID, ProductName, ProductFinish) AS
SELECT ProductID, ProductName, ProductFinish
FROM Product
WHERE ProductFinish NOT LIKE 'Cherry';

SELECT * FROM No_6_cherry;


/* Q7 - List product name, finish, and standard price for all desks and all tables
that cost more than $ 300 in the Product table.  */
-- ProductName              ProductFinish       ProductStandardPrice
-- Computer Desk            Natural Ash         375
-- Entertainment Center     Natural Maple       650
-- Writers Desk             Cherry              325
-- 8-Drawer Desk            White Ash           750
-- Dining Table             Natural Ash         800

CREATE VIEW No_7_morethan300 (ProductName, ProductFinish, ProductStandardPrice) AS
SELECT ProductName, ProductFinish, ProductStandardPrice
FROM Product
WHERE ProductStandardPrice > 300;

SELECT * FROM No_7_morethan300;


/* Q8 - Which products in the Product table have a standard price 
between $ 200 and $ 300? */
-- ProductID    ProductName     ProductStandardPrice
-- 2            Coffee Table    200
-- 8            Computer Desk   250

CREATE VIEW No_8_between (ProductID, ProductName, ProductStandardPrice) AS
SELECT ProductID, ProductName, ProductStandardPrice
FROM Product
WHERE ProductStandardPrice BETWEEN 200 AND 300;

SELECT * FROM No_8_between;


/* Q9 - List customer, city, and state for all customers in the 
Customer table whose address is Florida, Texas, California, or Hawaii.
List the customers alphabetically by state and alphabetically by 
customer within each state. */
-- CustomerName             CustomerCity        CustomerState
-- Impressions              Sacramento          CA
-- Contemporary Casuals     Gainesville         FL
-- Flanigan Furniture       Ft Walton Beach     FL
-- Value Furnitures         Plano               TX

CREATE VIEW No_9_alpha (CustomerName, CustomerCity, CustomerState) AS
SELECT CustomerName, CustomerCity, CustomerState
FROM Customer
WHERE CustomerState IN ('FL','TX','CA','HI')
ORDER BY CustomerState,CustomerName;

SELECT * FROM No_9_alpha;


/* Q10 - Count the number of customers with addresses in each 
state to which we ship */
-- CustomerState    TotalCount
-- CA               1
-- CO               1
-- FL               2
-- IL               1
-- NJ               1
-- NM               2
-- NY               4
-- TX               1
-- VA               1

CREATE VIEW No_10_countcustomers (CustomerState, TotalCount) AS
SELECT CustomerState, COUNT(*) AS "Count"
FROM Customer
GROUP BY CustomerState
ORDER BY CustomerState;

SELECT * FROM No_10_countcustomers;


/* Q11 - Count the number of customers with addresses in each city to which
we ship. List the cities by state*/
-- CustomerCity         CustomerState       TotalCount
-- Sacramento           CA                  1
-- Boulder              CO                  1
-- Ft Walton Beach      FL                  1
-- Gainesville          FL                  1
-- Oak Brook            IL                  1
-- Carteret             NJ                  1
-- Farmington           NM                  1
-- Las Cruces           NM                  1
-- Albany               NY                  1
-- Rome                 NY                  2
-- Syracuse             NY                  1
-- Plano                TX                  1
-- Viginia Beach        VA                  1

CREATE VIEW No_11_citycount (CustomerCity, CustomerState, TotalCount) AS
SELECT CustomerCity, CustomerState, COUNT(*) AS "Count"
FROM Customer
GROUP BY CustomerState, CustomerCity
ORDER BY CustomerState;

SELECT * FROM No_11_citycount;


/* Q12 - Find only states with more than one customer.  */
-- CustomerState        No. of Customers
-- FL                   2
-- NY                   4
-- NM                   2

CREATE VIEW No_12_states (CustomerState, "No. of Customers") AS
SELECT CustomerState, COUNT(CustomerState) AS "No. of Customers"
FROM Customer
GROUP BY CustomerState
HAVING COUNT(CustomerState) > 1;

SELECT * FROM No_12_states;


/* Q13 - List, in alphabetical order, the product finish and the average standard 
price for each finish for selected finishes having an average standard price less
than 750 */
-- Product Finish           AVG Standard Price
-- Cherry                   250
-- Natural Ash              458.333333
-- Natural Maple            650
-- Walnut                   250

CREATE VIEW No_13_avgstandardprice ("Product Finish", "Avg Standard Price") AS 
SELECT ProductFinish, AVG(ProductStandardPrice)
FROM Product
GROUP BY ProductFinish
HAVING AVG(ProductStandardPrice) < 750
ORDER BY ProductFinish ASC;

SELECT * FROM No_13_avgstandardprice;


/* Q14 - What is the total value of orders placed for each furniture product?  */
-- ProductName              Total
-- End Table                9100
-- Computer Desk            32500
-- 8-Drawer Desk            39000
-- Coffee Table             10400
-- Entertainment Center     33800
-- Dining Table             41600
-- Writers Desk             16900

CREATE VIEW No_14_total_value (ProductName, Total)
AS SELECT P.ProductName, SUM(P.ProductStandardPrice*O.OrderedQuantity) AS Total
FROM Product P, Orderline O
GROUP BY P.ProductName;

SELECT * FROM No_14_total_value;
