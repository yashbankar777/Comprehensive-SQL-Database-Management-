
-- Create the database with proper character set
CREATE DATABASE IF NOT EXISTS Little_Lemon 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Select the database
USE Little_Lemon;

-- =====================================================
-- ENHANCED TABLE STRUCTURE
-- =====================================================

-- Create Customers table with enhanced fields
CREATE TABLE Customers (
    CustomerID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL UNIQUE,
    DateOfBirth DATE,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LoyaltyPoints INT DEFAULT 0,
    IsActive BOOLEAN DEFAULT TRUE,
    INDEX idx_email (Email),
    INDEX idx_phone (PhoneNumber)
);

-- Create Staff table for restaurant employees
CREATE TABLE Staff (
    StaffID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2),
    IsActive BOOLEAN DEFAULT TRUE
);

-- Create Tables table for restaurant seating
CREATE TABLE RestaurantTables (
    TableNumber INT NOT NULL PRIMARY KEY,
    Capacity INT NOT NULL,
    Location VARCHAR(50) DEFAULT 'Main Floor',
    IsAvailable BOOLEAN DEFAULT TRUE
);

-- Enhanced Bookings table with foreign key constraints
CREATE TABLE Bookings (
    BookingID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    TableNumber INT NOT NULL,
    BookingDate DATE NOT NULL,
    BookingTime TIME NOT NULL,
    NumberOfGuests INT NOT NULL CHECK (NumberOfGuests > 0),
    SpecialRequests TEXT,
    Status ENUM('Confirmed', 'Cancelled', 'Completed', 'No-Show') DEFAULT 'Confirmed',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (TableNumber) REFERENCES RestaurantTables(TableNumber),
    INDEX idx_booking_date (BookingDate),
    INDEX idx_customer_booking (CustomerID, BookingDate)
);

-- Enhanced Courses table with categories and nutritional info
CREATE TABLE Categories (
    CategoryID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT
);

CREATE TABLE Courses (
    CourseID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT NOT NULL,
    Cost DECIMAL(6,2) NOT NULL CHECK (Cost > 0),
    Description TEXT,
    Ingredients TEXT,
    Calories INT,
    PreparationTime INT, -- in minutes
    IsAvailable BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    INDEX idx_category (CategoryID),
    INDEX idx_available (IsAvailable)
);

-- Orders table for tracking customer orders
CREATE TABLE Orders (
    OrderID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    BookingID INT,
    OrderDate DATE NOT NULL,
    OrderTime TIME NOT NULL,
    TotalAmount DECIMAL(8,2) NOT NULL DEFAULT 0,
    Status ENUM('Pending', 'Preparing', 'Ready', 'Served', 'Cancelled') DEFAULT 'Pending',
    PaymentMethod ENUM('Cash', 'Card', 'Digital') DEFAULT 'Card',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE SET NULL,
    INDEX idx_order_date (OrderDate),
    INDEX idx_customer_order (CustomerID)
);

-- Order Items table for detailed order tracking
CREATE TABLE OrderItems (
    OrderItemID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    CourseID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(6,2) NOT NULL,
    Subtotal DECIMAL(8,2) NOT NULL,
    SpecialInstructions TEXT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    INDEX idx_order_items (OrderID)
);

-- Enhanced DeliveryAddress table
CREATE TABLE DeliveryAddresses (
    AddressID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    AddressLine1 VARCHAR(255) NOT NULL,
    AddressLine2 VARCHAR(255),
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100),
    ZipCode VARCHAR(20),
    Country VARCHAR(100) DEFAULT 'USA',
    AddressType ENUM('Home', 'Work', 'Other') DEFAULT 'Home',
    IsDefault BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    INDEX idx_customer_address (CustomerID)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert Categories
INSERT INTO Categories (CategoryName, Description) VALUES 
('Appetizers', 'Light dishes to start your meal'),
('Salads', 'Fresh and healthy salad options'),
('Main Courses', 'Hearty main dishes'),
('Desserts', 'Sweet treats to end your meal'),
('Beverages', 'Refreshing drinks'),
('Soups', 'Warm and comforting soups');

-- Insert Restaurant Tables
INSERT INTO RestaurantTables (TableNumber, Capacity, Location) VALUES 
(1, 2, 'Window Side'),
(2, 4, 'Main Floor'),
(3, 2, 'Main Floor'),
(4, 6, 'Main Floor'),
(5, 4, 'Patio'),
(6, 8, 'Private Room'),
(7, 2, 'Bar Area'),
(8, 4, 'Window Side');

-- Insert Staff
INSERT INTO Staff (FirstName, LastName, Position, Email, PhoneNumber, HireDate, Salary) VALUES 
('John', 'Smith', 'Manager', 'john.smith@littlelemon.com', '555-0101', '2020-01-15', 55000.00),
('Maria', 'Garcia', 'Head Chef', 'maria.garcia@littlelemon.com', '555-0102', '2020-03-20', 48000.00),
('David', 'Johnson', 'Waiter', 'david.johnson@littlelemon.com', '555-0103', '2021-06-10', 32000.00),
('Sarah', 'Wilson', 'Hostess', 'sarah.wilson@littlelemon.com', '555-0104', '2021-09-05', 28000.00);

-- Insert Enhanced Customer Data
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, DateOfBirth, LoyaltyPoints) VALUES 
('Vanessa', 'McCarthy', 'vanessa.mccarthy@email.com', '0757536378', '1990-05-15', 250),
('Marcos', 'Romero', 'marcos.romero@email.com', '0757536379', '1985-12-03', 180),
('Hiroki', 'Yamane', 'hiroki.yamane@email.com', '0757536376', '1992-08-22', 320),
('Anna', 'Iversen', 'anna.iversen@email.com', '0757536375', '1988-03-10', 150),
('Diana', 'Pinto', 'diana.pinto@email.com', '0757536374', '1995-11-28', 400),
('Altay', 'Ayhan', 'altay.ayhan@email.com', '0757636378', '1987-07-14', 200),
('Jane', 'Murphy', 'jane.murphy@email.com', '0753536379', '1993-01-25', 175),
('Laurina', 'Delgado', 'laurina.delgado@email.com', '0754536376', '1991-09-08', 225),
('Mike', 'Edwards', 'mike.edwards@email.com', '0757236375', '1989-04-17', 300),
('Karl', 'Pederson', 'karl.pederson@email.com', '0757936374', '1986-10-12', 125);

-- Insert Enhanced Courses with Categories
INSERT INTO Courses (CourseName, CategoryID, Cost, Description, Ingredients, Calories, PreparationTime) VALUES 
('Greek Salad', 2, 15.50, 'Fresh Mediterranean salad with feta cheese', 'Tomatoes, cucumber, olives, feta cheese, olive oil', 280, 10),
('Bean Soup', 6, 12.25, 'Hearty white bean soup with herbs', 'White beans, onions, carrots, herbs, vegetable broth', 320, 25),
('Margherita Pizza', 3, 18.00, 'Classic pizza with tomato, mozzarella, and basil', 'Pizza dough, tomato sauce, mozzarella, basil', 450, 15),
('Carbonara', 3, 16.50, 'Creamy pasta with bacon and parmesan', 'Pasta, eggs, bacon, parmesan, black pepper', 580, 20),
('Kabasa', 3, 20.00, 'Grilled chicken with Mediterranean spices', 'Chicken breast, herbs, olive oil, lemon', 380, 30),
('Shawarma', 3, 14.30, 'Middle Eastern spiced meat wrap', 'Lamb, pita bread, tahini, vegetables', 420, 18),
('Tiramisu', 4, 8.50, 'Classic Italian dessert', 'Mascarpone, coffee, ladyfingers, cocoa', 350, 15),
('Caesar Salad', 2, 13.75, 'Crisp romaine with parmesan and croutons', 'Romaine lettuce, parmesan, croutons, caesar dressing', 320, 12);

-- Insert Enhanced Bookings
INSERT INTO Bookings (CustomerID, TableNumber, BookingDate, BookingTime, NumberOfGuests, SpecialRequests, Status) VALUES
(1, 7, '2024-06-15', '19:00:00', 2, 'Window table preferred', 'Confirmed'),
(2, 5, '2024-06-15', '18:30:00', 4, 'Birthday celebration', 'Confirmed'),
(4, 3, '2024-06-15', '20:00:00', 2, NULL, 'Confirmed'),
(5, 2, '2024-06-16', '19:30:00', 4, 'Vegetarian options needed', 'Confirmed'),
(6, 5, '2024-06-16', '18:00:00', 3, NULL, 'Confirmed'),
(7, 3, '2024-06-16', '20:30:00', 2, 'Quiet table please', 'Confirmed'),
(1, 4, '2024-06-17', '19:00:00', 6, 'Anniversary dinner', 'Confirmed'),
(2, 5, '2024-06-17', '18:30:00', 4, NULL, 'Confirmed'),
(4, 3, '2024-06-17', '20:00:00', 2, NULL, 'Confirmed'),
(6, 7, '2024-06-18', '19:30:00', 2, 'Late arrival possible', 'Confirmed');

-- Insert Sample Orders
INSERT INTO Orders (CustomerID, BookingID, OrderDate, OrderTime, TotalAmount, Status, PaymentMethod) VALUES
(1, 1, '2024-06-15', '19:15:00', 42.50, 'Served', 'Card'),
(2, 2, '2024-06-15', '18:45:00', 73.25, 'Served', 'Cash'),
(4, 3, '2024-06-15', '20:15:00', 31.25, 'Served', 'Digital');

-- Insert Order Items
INSERT INTO OrderItems (OrderID, CourseID, Quantity, UnitPrice, Subtotal) VALUES
(1, 1, 1, 15.50, 15.50),
(1, 5, 1, 20.00, 20.00),
(1, 7, 1, 8.50, 8.50),
(2, 3, 2, 18.00, 36.00),
(2, 8, 2, 13.75, 27.50),
(2, 7, 1, 8.50, 8.50),
(3, 2, 1, 12.25, 12.25),
(3, 4, 1, 16.50, 16.50);

-- Insert Delivery Addresses
INSERT INTO DeliveryAddresses (CustomerID, AddressLine1, City, State, ZipCode, AddressType, IsDefault) VALUES
(1, '123 Main St', 'Chicago', 'IL', '60601', 'Home', TRUE),
(2, '456 Oak Ave', 'New York', 'NY', '10001', 'Home', TRUE),
(3, '789 Pine Rd', 'Los Angeles', 'CA', '90210', 'Work', TRUE),
(4, '321 Elm St', 'Miami', 'FL', '33101', 'Home', TRUE),
(5, '654 Maple Dr', 'Seattle', 'WA', '98101', 'Home', TRUE);

-- =====================================================
-- ENHANCED VIEWS
-- =====================================================

-- Customer booking summary view
CREATE VIEW CustomerBookingSummary AS
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    c.Email,
    COUNT(b.BookingID) AS TotalBookings,
    c.LoyaltyPoints,
    MAX(b.BookingDate) AS LastBookingDate
FROM Customers c
LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email, c.LoyaltyPoints;

-- Daily revenue view
CREATE VIEW DailyRevenue AS
SELECT 
    o.OrderDate,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalRevenue,
    AVG(o.TotalAmount) AS AverageOrderValue
FROM Orders o
WHERE o.Status = 'Served'
GROUP BY o.OrderDate
ORDER BY o.OrderDate DESC;

-- Popular courses view
CREATE VIEW PopularCourses AS
SELECT 
    c.CourseName,
    cat.CategoryName,
    c.Cost,
    COUNT(oi.OrderItemID) AS TimesOrdered,
    SUM(oi.Quantity) AS TotalQuantitySold,
    SUM(oi.Subtotal) AS TotalRevenue
FROM Courses c
JOIN Categories cat ON c.CategoryID = cat.CategoryID
LEFT JOIN OrderItems oi ON c.CourseID = oi.CourseID
GROUP BY c.CourseID, c.CourseName, cat.CategoryName, c.Cost
ORDER BY TimesOrdered DESC;

-- =====================================================
-- ENHANCED STORED PROCEDURES
-- =====================================================

-- Procedure to get customer booking history
DELIMITER //
CREATE PROCEDURE GetCustomerBookingHistory(IN customer_id INT)
BEGIN
    SELECT 
        b.BookingID,
        b.BookingDate,
        b.BookingTime,
        b.NumberOfGuests,
        rt.TableNumber,
        rt.Location,
        b.Status,
        b.SpecialRequests
    FROM Bookings b
    JOIN RestaurantTables rt ON b.TableNumber = rt.TableNumber
    WHERE b.CustomerID = customer_id
    ORDER BY b.BookingDate DESC, b.BookingTime DESC;
END //
DELIMITER ;

-- Procedure to calculate customer loyalty points
DELIMITER //
CREATE PROCEDURE UpdateLoyaltyPoints(IN customer_id INT, IN points_to_add INT)
BEGIN
    UPDATE Customers 
    SET LoyaltyPoints = LoyaltyPoints + points_to_add 
    WHERE CustomerID = customer_id;
    
    SELECT 
        CONCAT(FirstName, ' ', LastName) AS CustomerName,
        LoyaltyPoints AS CurrentPoints
    FROM Customers 
    WHERE CustomerID = customer_id;
END //
DELIMITER ;

-- Procedure to get table availability
DELIMITER //
CREATE PROCEDURE CheckTableAvailability(IN check_date DATE, IN check_time TIME)
BEGIN
    SELECT 
        rt.TableNumber,
        rt.Capacity,
        rt.Location,
        CASE 
            WHEN b.BookingID IS NULL THEN 'Available'
            ELSE 'Booked'
        END AS Status
    FROM RestaurantTables rt
    LEFT JOIN Bookings b ON rt.TableNumber = b.TableNumber 
        AND b.BookingDate = check_date 
        AND ABS(TIME_TO_SEC(b.BookingTime) - TIME_TO_SEC(check_time)) <= 7200 -- 2 hours buffer
        AND b.Status = 'Confirmed'
    WHERE rt.IsAvailable = TRUE
    ORDER BY rt.TableNumber;
END //
DELIMITER ;

-- =====================================================
-- ENHANCED QUERIES AND ANALYTICS
-- =====================================================

-- Monthly booking trends
SELECT 
    YEAR(BookingDate) AS Year,
    MONTH(BookingDate) AS Month,
    MONTHNAME(BookingDate) AS MonthName,
    COUNT(*) AS TotalBookings,
    SUM(NumberOfGuests) AS TotalGuests,
    AVG(NumberOfGuests) AS AvgGuestsPerBooking
FROM Bookings
WHERE Status = 'Confirmed'
GROUP BY YEAR(BookingDate), MONTH(BookingDate), MONTHNAME(BookingDate)
ORDER BY Year DESC, Month DESC;

-- Customer lifetime value analysis
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS LifetimeValue,
    AVG(o.TotalAmount) AS AvgOrderValue,
    c.LoyaltyPoints,
    TIMESTAMPDIFF(MONTH, c.RegistrationDate, CURDATE()) AS MonthsAsCustomer
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Status = 'Served'
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.LoyaltyPoints, c.RegistrationDate
HAVING LifetimeValue > 0
ORDER BY LifetimeValue DESC;

-- Peak hours analysis
SELECT 
    HOUR(BookingTime) AS Hour,
    COUNT(*) AS BookingCount,
    CASE 
        WHEN HOUR(BookingTime) BETWEEN 11 AND 14 THEN 'Lunch'
        WHEN HOUR(BookingTime) BETWEEN 17 AND 22 THEN 'Dinner'
        ELSE 'Off-Peak'
    END AS TimeSlot
FROM Bookings
WHERE Status = 'Confirmed'
GROUP BY HOUR(BookingTime)
ORDER BY BookingCount DESC;

-- =====================================================
-- ADVANCED FEATURES
-- =====================================================

-- Trigger to update order total when order items change
DELIMITER //
CREATE TRIGGER UpdateOrderTotal
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET TotalAmount = (
        SELECT SUM(Subtotal) 
        FROM OrderItems 
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END //
DELIMITER ;

-- Function to calculate age from date of birth
DELIMITER //
CREATE FUNCTION CalculateAge(birth_date DATE) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, birth_date, CURDATE());
END //
DELIMITER ;

-- =====================================================
-- SAMPLE QUERIES TO TEST THE SYSTEM
-- =====================================================

-- Test the customer booking history procedure
CALL GetCustomerBookingHistory(1);

-- Test the table availability procedure
CALL CheckTableAvailability('2024-06-20', '19:00:00');

-- Test the loyalty points update procedure
CALL UpdateLoyaltyPoints(1, 50);

-- View customer summary
SELECT * FROM CustomerBookingSummary;

-- View daily revenue
SELECT * FROM DailyRevenue;

-- View popular courses
SELECT * FROM PopularCourses;

-- Show tables and their current status
SHOW TABLES;

-- Display table information
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'Little_Lemon'
ORDER BY TABLE_NAME;
