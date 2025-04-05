-- MySQL Database Project: Little Lemon Restaurant

-- Create the database
CREATE DATABASE IF NOT EXISTS Little_Lemon;

-- View available databases
SHOW DATABASES;

-- Select the database
USE Little_Lemon;

-- Create the Customers table
CREATE TABLE Customers (
    CustomerID INT NOT NULL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    PhoneNumber BIGINT NOT NULL UNIQUE
);

-- View created tables
SHOW TABLES;

-- Populate the Customers table
INSERT INTO Customers (CustomerID, FullName, PhoneNumber) VALUES 
(1, 'Vanessa McCarthy', 0757536378), 
(2, 'Marcos Romero', 0757536379), 
(3, 'Hiroki Yamane', 0757536376), 
(4, 'Anna Iversen', 0757536375), 
(5, 'Diana Pinto', 0757536374),     
(6, 'Altay Ayhan', 0757636378),      
(7, 'Jane Murphy', 0753536379),      
(8, 'Laurina Delgado', 0754536376),      
(9, 'Mike Edwards', 0757236375),     
(10, 'Karl Pederson', 0757936374);

-- View data in Customers table
SELECT * FROM Customers;

-- Create the Bookings table
CREATE TABLE Bookings (
    BookingID INT,
    BookingDate DATE,
    TableNumber INT,
    NumberOfGuests INT,
    CustomerID INT
);

-- Populate the Bookings table
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, NumberOfGuests, CustomerID) VALUES
(10, '2021-11-10', 7, 5, 1),  
(11, '2021-11-10', 5, 2, 2),  
(12, '2021-11-10', 3, 2, 4), 
(13, '2021-11-11', 2, 5, 5),  
(14, '2021-11-11', 5, 2, 6),  
(15, '2021-11-11', 3, 2, 7), 
(16, '2021-11-11', 3, 5, 1),  
(17, '2021-11-12', 5, 2, 2),  
(18, '2021-11-12', 3, 2, 4), 
(19, '2021-11-13', 7, 5, 6),  
(20, '2021-11-14', 5, 2, 3),  
(21, '2021-11-14', 3, 2, 4);

-- View data in Bookings table
SELECT * FROM Bookings;

-- Create the Courses table
CREATE TABLE Courses (
    CourseName VARCHAR(255) PRIMARY KEY,
    Cost DECIMAL(4,2)
);

-- Populate the Courses table
INSERT INTO Courses (CourseName, Cost) VALUES 
('Greek salad', 15.50), 
('Bean soup', 12.25), 
('Pizza', 15.00), 
('Carbonara', 12.50), 
('Kabasa', 17.00), 
('Shwarma', 11.30);

-- View data in Courses table
SELECT * FROM Courses;

-- View all created tables
SHOW TABLES;

-- Filter bookings between specific dates
SELECT * 
FROM Bookings 
WHERE BookingDate BETWEEN '2021-11-11' AND '2021-11-13';

-- Perform a RIGHT JOIN to get bookings with customer names
SELECT Customers.FullName, Bookings.BookingID 
FROM Customers 
RIGHT JOIN Bookings ON Customers.CustomerID = Bookings.CustomerID 
WHERE BookingDate = '2021-11-11';

-- Count bookings by date
SELECT BookingDate, COUNT(BookingDate) 
FROM Bookings 
GROUP BY BookingDate;

-- Update cost of a course using REPLACE
REPLACE INTO Courses (CourseName, Cost) 
VALUES ('Kabasa', 20.00);

-- View updated Courses table
SELECT * FROM Courses;

-- Create the DeliveryAddress table with constraints
CREATE TABLE DeliveryAddress (     
    ID INT PRIMARY KEY,     
    Address VARCHAR(255) NOT NULL,     
    Type VARCHAR(100) NOT NULL DEFAULT 'Private',     
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- View columns in DeliveryAddress
SHOW COLUMNS FROM DeliveryAddress;

-- Alter Courses table to add a new column
ALTER TABLE Courses ADD COLUMN Ingredients VARCHAR(255);

-- View updated columns in Courses table
SHOW COLUMNS FROM Courses;

-- Subquery to get full names of customers with bookings on a specific date
SELECT FullName 
FROM Customers 
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM Bookings 
    WHERE BookingDate = '2021-11-11'
);

-- Create a view for filtered booking data
CREATE VIEW BookingsView AS 
SELECT BookingID, BookingDate, NumberOfGuests 
FROM Bookings 
WHERE NumberOfGuests > 3 AND BookingDate < '2021-11-13';

-- View data from BookingsView
SELECT * FROM BookingsView;

-- Create a stored procedure to get bookings by date
DELIMITER //
CREATE PROCEDURE GetBookingsData (IN InputDate DATE)
BEGIN
    SELECT * FROM Bookings WHERE BookingDate = InputDate;
END //
DELIMITER ;

-- Call the stored procedure
CALL GetBookingsData('2021-11-13');

-- Use a string function to format booking details
SELECT 
    CONCAT('ID: ', BookingID, ', Date: ', BookingDate, ', Number of guests: ', NumberOfGuests) AS 'Booking Details' 
FROM Bookings;
