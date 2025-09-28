CREATE DATABASE ShopAnalyticsDB;
USE ShopAnalyticsDB;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE OrderDetails (
    orderdetail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Customers (customer_name, email, city) VALUES
('Alice Johnson', 'alice@example.com', 'New York'),
('Bob Smith', 'bob@example.com', 'Los Angeles'),
('Charlie Brown', 'charlie@example.com', 'Chicago'),
('David Miller', 'david@example.com', 'Houston'),
('Eva Green', 'eva@example.com', 'Miami');
INSERT INTO Products (product_name, category, price) VALUES
('Laptop', 'Electronics', 800.00),
('Smartphone', 'Electronics', 500.00),
('Headphones', 'Accessories', 50.00),
('Shoes', 'Fashion', 70.00),
('Watch', 'Fashion', 120.00);
INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2025-09-20'),
(2, '2025-09-21'),
(1, '2025-09-22'),
(3, '2025-09-23'),
(4, '2025-09-24'),
(5, '2025-09-25');
INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 1),  -- Alice bought 1 Laptop
(1, 3, 2),  -- Alice bought 2 Headphones
(2, 2, 1),  -- Bob bought 1 Smartphone
(3, 4, 1),  -- Alice bought 1 Shoes
(4, 5, 1),  -- Charlie bought 1 Watch
(5, 1, 1),  -- David bought 1 Laptop
(6, 2, 2);  
SELECT c.customer_name, SUM(p.price * od.quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;
SELECT AVG(total_spent) AS avg_revenue_per_user
FROM (
    SELECT c.customer_id, SUM(p.price * od.quantity) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN OrderDetails od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY c.customer_id
) sub;
SELECT p.category, SUM(od.quantity) AS total_quantity
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_quantity DESC;
SELECT c.city, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;
SELECT c.customer_name, SUM(p.price * od.quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;
DROP VIEW IF EXISTS CustomerSummary;
CREATE VIEW CustomerSummary AS
SELECT c.customer_id, c.customer_name, c.city,
       SUM(p.price * od.quantity) AS total_spent,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city;
SELECT * FROM CustomerSummary;
SELECT customer_name, total_spent
FROM CustomerSummary
WHERE total_spent > (
    SELECT AVG(total_spent) FROM CustomerSummary
);
CREATE INDEX idx_customer_city ON Customers(city);
CREATE INDEX idx_order_date ON Orders(order_date);




