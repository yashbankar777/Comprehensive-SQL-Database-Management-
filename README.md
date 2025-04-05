🍋 Little Lemon MySQL Database Project

This project involves designing and managing a relational database system for a fictional restaurant called Little Lemon. It demonstrates core database functionalities such as schema creation, data population, data retrieval, and advanced SQL operations using MySQL.

📁 Database Setup

A database named Little_Lemon is created to serve as the core of the system. Once the database is initialized, it is selected for further operations to house all tables and data relevant to the restaurant.

👥 Customers Table

The Customers table stores details about each customer, including a unique ID, full name, and phone number. Each phone number is kept unique to prevent duplication. The table is populated with 10 diverse customer records.

📅 Bookings Table

The Bookings table keeps track of reservations made by customers. It includes booking IDs, dates, table numbers, guest counts, and references to the associated customer ID. It captures a series of bookings spanning different dates and table configurations.

🍽️ Courses Table

This table lists all the food items (or “courses”) available at Little Lemon, along with their respective costs. It also serves as an example of basic product management in a database context. Later, the table is updated to include an Ingredients column using the ALTER TABLE command.

🔍 Filtering and Querying

Multiple SQL operations are performed to filter and analyze data:

Bookings are filtered based on date ranges.

A JOIN operation is used to combine customer names with their bookings on a specific date.

Grouping operations provide insights such as the number of bookings per day.

String functions are applied to generate readable booking summaries.

🔁 Data Replacement

A sample course entry is updated using the REPLACE INTO statement, demonstrating how existing records can be modified seamlessly.

📦 DeliveryAddress Table with Constraints

A new table called DeliveryAddress is introduced to manage delivery-specific data. It includes fields for address, type, and associated customer. It also enforces constraints such as NOT NULL, DEFAULT values, and foreign key linkage to maintain data integrity.

🛠 Table Alteration

To extend the database schema, the Courses table is altered by adding a new column for listing ingredients. This showcases how a schema can evolve with changing business requirements.

🔗 Subqueries

A subquery is used to identify customers who have a booking on a particular date, demonstrating nested SQL logic and relationship-based filtering.

🪞 Virtual Table (View)

A view named BookingsView is created to encapsulate complex filtering logic into a reusable virtual table. It displays bookings with more than 3 guests made before a specific date.

⚙️ Stored Procedure

A stored procedure called GetBookingsData is implemented to automate the retrieval of bookings for a given date. This allows repeated execution without rewriting the full query each time.

