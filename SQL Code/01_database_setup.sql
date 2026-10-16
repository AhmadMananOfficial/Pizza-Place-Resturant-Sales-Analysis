CREATE DATABASE pizza_sales;
USE pizza_sales;

SHOW GLOBAL VARIABLES LIKE 'LOCAL_INFILE';
SET GLOBAL  LOCAL_INFILE = 1;


-- --------------------------------
-- 1. 'pizza_types' Table
-- --------------------------------

DROP TABLE IF EXISTS pizza_types;

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name TEXT,
    category VARCHAR(50),
    ingredients TEXT
);

LOAD DATA LOCAL INFILE 'D:/Mission/Pizza+Place+Sales/Dataset/pizza_types.csv'
INTO TABLE pizza_types
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- -----------------------------------
-- 2. 'pizzas' Table
-- -----------------------------------

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size VARCHAR(10) ,
    price DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'D:/Mission/Pizza+Place+Sales/Dataset/pizzas.csv' 
INTO TABLE pizzas
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- -------------------------------------------
-- 3. 'Orders' Table
-- -------------------------------------------

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    date DATE,
    time TIME
);

LOAD DATA LOCAL INFILE 'D:/Mission/Pizza+Place+Sales/Dataset/orders.csv' 
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- ----------------------------------
-- 4. 'order_details' Table
-- ----------------------------------

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT
);

LOAD DATA LOCAL INFILE 'D:/Mission/Pizza+Place+Sales/Dataset/order_details.csv' 
INTO TABLE order_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT * FROM pizza_types;
SELECT * FROM orders;
SELECT * FROM order_details;
SELECT * FROM pizzas;
