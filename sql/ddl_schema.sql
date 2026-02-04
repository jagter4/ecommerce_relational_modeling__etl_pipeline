
-- Select the database to use
USE ecommerce_db;

-- Create the Products table to store product information
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each product
    ProductName VARCHAR(255) NOT NULL, -- Name of the product
    Description TEXT, -- Description of the product
    Price DECIMAL(10, 2) NOT NULL, -- Price of the product
    StockQuantity INT NOT NULL, -- Quantity of product available in stock
    Category VARCHAR(100), -- Category of the product (e.g., Electronics)
    DateAdded DATE NOT NULL DEFAULT (CURDATE()) -- Date when the product was added, defaults to today's date
);




-- Create the Users table to store customer information
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each user
    UserName VARCHAR(255) NOT NULL, -- Name of the user
    Email VARCHAR(255) NOT NULL UNIQUE, -- Email of the user, must be unique
    Password VARCHAR(255) NOT NULL, -- Hashed password for security
    Address VARCHAR(255), -- User's shipping address
    DateRegistered DATE NOT NULL DEFAULT (CURDATE()) -- Date when the user registered, defaults to today's date
);





-- Create the Orders table to store transaction details
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each order
    UserID INT, -- ID of the user who placed the order
    OrderDate DATE NOT NULL, -- Date when the order was placed
    TotalAmount DECIMAL(10, 2) NOT NULL, -- Total amount of the order
    FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Link to the Users table
);


-- Create the Reviews table to store customer feedback
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each review
    ProductID INT, -- ID of the product being reviewed
    UserID INT, -- ID of the user who wrote the review
    Rating INT, -- Rating given by the user (1 to 5 stars)
    ReviewText TEXT, -- Text of the review
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID), -- Link to the Products table
    FOREIGN KEY (UserID) REFERENCES Users(UserID), -- Link to the Users table
    CHECK (Rating >= 1 AND Rating <= 5) -- Ensure the rating is between 1 and 5
);



-- Create the Payments table to store payment transaction details
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each payment
    OrderID INT, -- ID of the order being paid for
    PaymentMethod VARCHAR(50), -- Method of payment (e.g., Credit Card)
    PaymentDate DATE NOT NULL, -- Date when the payment was made
    Amount DECIMAL(10, 2) NOT NULL, -- Amount paid
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) -- Link to the Orders table
);

