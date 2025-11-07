CREATE DATABASE IF NOT EXISTS RestaurantDB;
USE RestaurantDB;
CREATE TABLE Manager (
    manager_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);
CREATE TABLE Employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Manager(manager_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
CREATE TABLE Item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0)
);
CREATE TABLE `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    cashier_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) DEFAULT 0.00
);
CREATE TABLE `Transaction` (
    order_id INT,
    item_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
INSERT INTO Manager (first_name, last_name, password, salary)
VALUES ('Alice', 'Baker', 'password123', 75000.00);

INSERT INTO Employee (first_name, last_name, position, salary, manager_id)
VALUES 
('John', 'Smith', 'Cashier', 35000.00, 1),
('Maria', 'Lopez', 'Server', 32000.00, 1);

INSERT INTO Item (item_name, price, stock)
VALUES 
('Burger', 9.99, 100),
('Fries', 3.49, 200),
('Soda', 1.99, 150),
('Salad', 7.49, 80);

INSERT INTO `Order` (cashier_name, price)
VALUES 
('John Smith', 0.00),
('Maria Lopez', 0.00);

INSERT INTO `Transaction` (order_id, item_id, quantity)
VALUES 
(1, 1, 2),
(1, 2, 1),
(2, 3, 3);
SELECT * FROM Manager;
SELECT * FROM Employee;
SELECT * FROM Item;
SELECT * FROM `Order`;
SELECT * FROM `Transaction`;
UPDATE `Order` o
JOIN (
    SELECT t.order_id, SUM(i.price * t.quantity) AS total
    FROM `Transaction` t
    JOIN Item i ON t.item_id = i.item_id
    GROUP BY t.order_id
) AS totals ON o.order_id = totals.order_id
SET o.price = totals.total;