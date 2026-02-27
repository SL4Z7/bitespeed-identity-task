
CREATE DATABASE IF NOT EXISTS CompanyOperations;
USE CompanyOperations;


CREATE TABLE Subcontractor (
    Subcontractor_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Postal_Code VARCHAR(20),
    Email VARCHAR(100)
);


CREATE TABLE Material (
    Material_ID INT PRIMARY KEY,
    Material_Type VARCHAR(100),
    Availability VARCHAR(50),
    Stock INT,
    Subcontractor_ID INT,
    FOREIGN KEY (Subcontractor_ID) REFERENCES Subcontractor(Subcontractor_ID)
);


CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Material_ID INT,
    Type VARCHAR(100),
    Availability VARCHAR(50),
    Stock INT,
    Subcontractor_ID INT,
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID),
    FOREIGN KEY (Subcontractor_ID) REFERENCES Subcontractor(Subcontractor_ID)
);


CREATE TABLE Event (
    Event_ID INT PRIMARY KEY,
    Location VARCHAR(255),
    Date DATE,
    Address_ID INT
);


CREATE TABLE Invoice (
    Invoice_ID INT PRIMARY KEY,
    Price DECIMAL(10, 2),
    Tax DECIMAL(10, 2),
    Date DATE,
    Due_Date DATE,
    Total DECIMAL(10, 2)
);


CREATE TABLE `Order` (
    Order_ID INT PRIMARY KEY,
    Order_Type VARCHAR(50),
    Product_Type VARCHAR(100),
    Product_Location VARCHAR(100),
    Product_ID INT,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);


CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Surname VARCHAR(100),
    Address VARCHAR(255),
    Age INT,
    Postal_Code VARCHAR(20),
    Email VARCHAR(100),
    Gender CHAR(1),
    Event_ID INT,
    Invoice_ID INT,
    Order_ID INT,
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID),
    FOREIGN KEY (Invoice_ID) REFERENCES Invoice(Invoice_ID),
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_ID)
);


INSERT INTO Subcontractor (Subcontractor_ID, Name, Address, Postal_Code, Email) VALUES
(1, 'Acme Corp', '123 Factory Blvd', '10001', 'contact@acmecorp.com'),
(2, 'Global Supplies', '456 Warehouse Way', '20002', 'sales@globalsupplies.com'),
(3, 'Prime Materials', '789 Industry Ave', '30003', 'info@primematerials.com'),
(4, 'BuildIt Right', '321 Construction Rd', '40004', 'hello@builditright.com'),
(5, 'Apex Logistics', '654 Transport St', '50005', 'support@apexlogistics.com');


INSERT INTO Material (Material_ID, Material_Type, Availability, Stock, Subcontractor_ID) VALUES
(1, 'Steel', 'In Stock', 500, 1),
(2, 'Wood', 'In Stock', 1200, 2),
(3, 'Plastic', 'Out of Stock', 0, 3),
(4, 'Glass', 'In Stock', 300, 4),
(5, 'Aluminum', 'Low Stock', 50, 1);


INSERT INTO Product (Product_ID, Material_ID, Type, Availability, Stock, Subcontractor_ID) VALUES
(1, 1, 'Metal Frame', 'In Stock', 150, 1),
(2, 2, 'Wooden Table', 'In Stock', 75, 2),
(3, 3, 'Plastic Chair', 'Out of Stock', 0, 3),
(4, 4, 'Glass Window', 'In Stock', 40, 4),
(5, 5, 'Aluminum Door', 'In Stock', 25, 1);


INSERT INTO Event (Event_ID, Location, Date, Address_ID) VALUES
(1, 'Convention Center', '2024-05-10', 101),
(2, 'Downtown Plaza', '2024-06-15', 102),
(3, 'City Park', '2024-07-20', 103),
(4, 'Grand Hotel', '2024-08-05', 104),
(5, 'Exhibition Hall', '2024-09-12', 105);


INSERT INTO Invoice (Invoice_ID, Price, Tax, Date, Due_Date, Total) VALUES
(1, 1000.00, 100.00, '2024-01-10', '2024-02-10', 1100.00),
(2, 250.00, 25.00, '2024-01-12', '2024-02-12', 275.00),
(3, 3400.00, 340.00, '2024-01-15', '2024-02-15', 3740.00),
(4, 150.00, 15.00, '2024-01-18', '2024-02-18', 165.00),
(5, 800.00, 80.00, '2024-01-20', '2024-02-20', 880.00);

INSERT INTO `Order` (Order_ID, Order_Type, Product_Type, Product_Location, Product_ID) VALUES
(1, 'Online', 'Furniture', 'Warehouse A', 2),
(2, 'In-Store', 'Hardware', 'Store Front 1', 1),
(3, 'Online', 'Decor', 'Warehouse B', 4),
(4, 'Phone', 'Furniture', 'Warehouse A', 3),
(5, 'In-Store', 'Hardware', 'Store Front 2', 5);


INSERT INTO Customer (Customer_ID, Name, Surname, Address, Age, Postal_Code, Email, Gender, Event_ID, Invoice_ID, Order_ID) VALUES
(1, 'John', 'Doe', '111 Maple St', 34, '90210', 'john.doe@email.com', 'M', 1, 1, 1),
(2, 'Jane', 'Smith', '222 Oak Ave', 28, '90211', 'jane.smith@email.com', 'F', 2, 2, 2),
(3, 'Michael', 'Johnson', '333 Pine Rd', 45, '90212', 'mjohnson@email.com', 'M', 3, 3, 3),
(4, 'Emily', 'Davis', '444 Cedar Ln', 22, '90213', 'emily.davis@email.com', 'F', 4, 4, 4),
(5, 'Chris', 'Wilson', '555 Birch Blvd', 39, '90214', 'cwilson@email.com', 'M', 5, 5, 5);