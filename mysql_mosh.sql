# SQL Programming with Mosh
USE sql_store;

-- Exploring sql_store database
SELECT * 
FROM `customers` -- WHERE `customer_id`=1
ORDER BY `first_name`;

-- Airthmetic Operators
SELECT `last_name`, `first_name`, `points`, (points-10)*100 AS `discount_factor`
FROM `customers`;
SELECT `name`, `unit_price` `unit price`, unit_price*1.1 `new price`
FROM `products`;

-- DISTINCT command
SELECT DISTINCT `state` FROM `customers`; 

-- WHERE clause
SELECT * FROM `customers` WHERE `points`>3000;
SELECT * FROM `customers` WHERE `state`<>'VA';
SELECT * FROM `customers` WHERE `birth_date`>'1990-01-01';
SELECT * FROM `orders` WHERE `order_date`>='2019-01-01';

-- AND, OR, NOT Operators
SELECT * FROM `customers` WHERE `birth_date`>'1990-01-01' AND `points`>1000;
SELECT * FROM `customers` WHERE `birth_date`>'1990-01-01' OR `points`>1000;
SELECT * FROM `customers` WHERE `birth_date`>'1990-01-01' OR (`points`>1000 AND `state`='VA');
SELECT * FROM `customers` WHERE NOT (`birth_date`>'1990-01-01' OR `points`>1000);
SELECT * FROM `order_items` WHERE (`order_id`=6 AND (`quantity`*`unit_price`)>30);

-- IN Operator
SELECT * FROM `customers` WHERE `state` IN ('VA','GA','FL');
SELECT * FROM `products` WHERE `quantity_in_stock` IN (38,49,72);

-- BETWEEN Operator
SELECT * FROM `customers` WHERE `points` BETWEEN 1000 and 3000;
SELECT * FROM `customers` WHERE `birth_date` BETWEEN '1990-01-01' AND '2000-01-01';

-- LIKE Operator
SELECT * FROM `customers` WHERE `last_name` LIKE 'b%';
SELECT * FROM `customers` WHERE `last_name` LIKE 'brush%';
SELECT * FROM `customers` WHERE `last_name` LIKE '%e%';
SELECT * FROM `customers` WHERE `last_name` LIKE '%y';
SELECT * FROM `customers` WHERE `last_name` LIKE '____y'; -- 6 characters, ends with y
SELECT * FROM `customers` WHERE `last_name` LIKE 'b____y'; -- 7 characters, starts with b, ends with y
SELECT * FROM `customers` WHERE (`address` LIKE '%trail%') OR (`address` LIKE '%avenue%');
SELECT * FROM `customers` WHERE `phone` LIKE '%9';

-- REGEXP Operator
SELECT * FROM `customers` WHERE `last_name` LIKE '%field%';
SELECT * FROM `customers` WHERE `last_name` REGEXP 'field';
SELECT * FROM `customers` WHERE `last_name` REGEXP '^field'; -- ^ start with
SELECT * FROM `customers` WHERE `last_name` REGEXP 'field$'; -- $ end with
SELECT * FROM `customers` WHERE `last_name` REGEXP 'field|mac|rose'; -- | logical or
SELECT * FROM `customers` WHERE `last_name` REGEXP '^field|mac|rose'; -- | ogical or
SELECT * FROM `customers` WHERE `last_name` REGEXP 'field$|mac|rose'; -- | logical or
SELECT * FROM `customers` WHERE `last_name` REGEXP '[gim]e'; -- [] combined
SELECT * FROM `customers` WHERE `last_name` REGEXP 'e[fmq]'; -- [] combined
SELECT * FROM `customers` WHERE `last_name` REGEXP '[a-h]e'; -- [-] combined with a range
SELECT * FROM `customers` WHERE `first_name` IN ('ELKA','AMBUR');
SELECT * FROM `customers` WHERE `first_name` REGEXP 'ELKA|AMBUR';
SELECT * FROM `customers` WHERE `last_name` REGEXP 'ey$|on$';
SELECT * FROM `customers` WHERE `last_name` REGEXP '^my|se';
SELECT * FROM `customers` WHERE `last_name` REGEXP 'b[ru]';

-- NULL Operator
SELECT * FROM `customers` WHERE `phone` IS NOT NULL;
SELECT * FROM `orders` WHERE `shipped_date` IS NULL;

-- ORDER BY clause
SELECT * FROM `customers` ORDER BY `first_name` DESC;
SELECT * FROM `customers` ORDER BY `state` DESC, `first_name` DESC;
SELECT `first_name`, `last_name`, 10 AS `points` FROM `customers` ORDER BY `points`, `first_name`;
SELECT * FROM `order_items` WHERE `order_id`=2 ORDER BY `quantity`*`unit_price` DESC;

-- LIMIT clause
SELECT * FROM `customers` LIMIT 3;
SELECT * FROM `customers` LIMIT 300;
SELECT * FROM `customers` LIMIT 6, 3; -- skip first 6 records, display 3 records
SELECT * FROM `customers` ORDER BY `points` DESC LIMIT 3;

-- INNER JOIN
SELECT `order_id`, `c`.`customer_id`, `first_name`, `last_name` 
	FROM `orders` `o`
	INNER JOIN `customers` `c` ON `c`.`customer_id`=`o`.`customer_id`;
SELECT `order_id`, `oi`.`product_id`,`name`,`quantity`,`oi`.`unit_price`
	FROM `order_items` `oi`
    INNER JOIN `products` `p` ON `oi`.`product_id`=`p`.`product_id`;

-- JOINING ACROSS DATABASES
SELECT *
FROM `order_items` `oi`
JOIN `sql_inventory`.`products` `p`
	ON `oi`.`product_id`=`p`.`product_id`;

-- SELF JOIN
USE `sql_hr`;
SELECT 	`e`.`employee_id` `employee_id`,
		CONCAT(`e`.`first_name`,' ',`e`.`last_name`) `employee`,
		CONCAT(`m`.`first_name`,' ',`m`.`last_name`) `manager`
FROM `employees` `e`
JOIN `employees` `m`
	ON `e`.`reports_to`=`m`.`employee_id`;

-- JOINING MULTIPLE TABLES
USE `sql_store`;
SELECT `order_id`,`order_date`,`first_name`,`last_name`,`name` `status`
FROM `orders` `o` 
	JOIN `customers` `c` ON `o`.`customer_id`=`c`.`customer_id`
    JOIN `order_statuses` `os` ON `o`.`status`=`os`.`order_status_id`;
USE `sql_invoicing`;
SELECT `p`.`date`,
		`p`.`invoice_id`,
        `p`.`amount`,
        `c`.`name`,
        `pm`.`name`
FROM `payments` `p`
	LEFT JOIN `payment_methods` `pm` ON `p`.`payment_method`=`pm`.`payment_method_id`
    LEFT JOIN `clients` `c` ON `p`.`client_id`=`c`.`client_id`;

-- COMPOUND JOIN CONDITIONS
USE `sql_store`;
SELECT *
FROM `order_items` `oi`
JOIN `order_item_notes` `oin`
	ON `oi`.`order_id`=`oin`.`order_id`
    AND `oi`.`product_id`=`oin`.`product_id`;
    
-- IMPLICIT JOIN SYNTAX
SELECT *
FROM `orders` `o`, `customers` `c`
WHERE `o`.`customer_id`=`c`.`customer_id`;

-- OUTER JOIN
SELECT `c`.`customer_id`, `c`.`first_name`,`o`.`order_id`
FROM `customers` `c`
LEFT JOIN `orders` `o` 
	ON `c`.`customer_id`=`o`.`customer_id`
ORDER BY `c`.`customer_id`;

SELECT `c`.`customer_id`, `c`.`first_name`,`o`.`order_id`
FROM `customers` `c`
RIGHT JOIN `orders` `o` 
	ON `c`.`customer_id`=`o`.`customer_id`
ORDER BY `c`.`customer_id`;

SELECT `p`.`product_id`,`name`,`oi`.`quantity`
FROM `order_items` `oi`
LEFT JOIN `products` `p`
	ON 	`p`.`product_id`=`oi`.`product_id`
ORDER BY `p`.`product_id`;

SELECT `p`.`product_id`,`name`,`oi`.`quantity`
FROM `order_items` `oi`
RIGHT JOIN `products` `p`
	ON 	`p`.`product_id`=`oi`.`product_id`
ORDER BY `p`.`product_id`;

-- OUTER JOIN BETWEEN MULTIPLE TABLES
SELECT 
    `o`.`order_id`,
	`o`.`order_date`,
    `c`.`first_name` `customer`,
    `p`.`name` `product`,
    `os`.`name` `order_status`,
    `s`.`name` `shipper`
FROM `customers` `c`
LEFT JOIN `orders` `o` ON `c`.`customer_id`=`o`.`customer_id`
LEFT JOIN `order_items` `oi` ON `o`.`order_id`=`oi`.`order_id`
LEFT JOIN `products` `p` ON `oi`.`product_id`=`p`.`product_id`
LEFT JOIN `order_statuses` `os` ON `o`.`status`=`os`.`order_status_id`
LEFT JOIN `shippers` `s` ON `o`.`shipper_id`=`s`.`shipper_id`
ORDER BY `o`.`order_id`;

-- SELF OUTER JOINS
USE `sql_hr`;
SELECT `e`.`employee_id`,
		CONCAT(`e`.`first_name`,' ',`e`.`last_name`) `employee`,
        CONCAT(`m`.`first_name`,' ',`m`.`last_name`) `manager`
FROM `employees` `e`
LEFT JOIN `employees` `m` ON `e`.`reports_to`=`m`.`employee_id`;

-- the USING clause
USE `sql_store`;
SELECT `o`.`order_id`, `c`.`first_name`,`s`.`name`
FROM `orders` `o` 
JOIN `customers` `c` 
	-- ON `o`.`customer_id`=`c`.`customer_id`
	USING (`customer_id`)
LEFT JOIN `shippers` `s` USING (`shipper_id`);

SELECT *
FROM `order_items` `oi`
JOIN `order_item_notes` `oin` USING (`order_id`,`product_id`);

USE sql_invoicing;
SELECT `p`.`date`,
		`c`.`name` `client`,
		`p`.`amount`,
        `pm`.`name` `payment_method`
FROM `payments` `p`
LEFT JOIN `clients` `c` USING(`client_id`)
LEFT JOIN `payment_methods` `pm` ON `p`.`payment_method`=`pm`.`payment_method_id`;

-- NATURAL JOINS
USE `sql_store`;
SELECT *
FROM `orders` `o`
NATURAL JOIN `customers` `c`;
 
-- CROSS JOINS
SELECT c.first_name AS customer, p.name AS product
FROM customers c, products p
# FROM customers c
# CROSS JOIN products p
ORDER BY c.first_name;

SELECT sh.name AS shipper, p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

-- UNION operator
SELECT order_id, order_date, 'Active' AS status
FROM orders WHERE order_date >= '2019.01.01'
UNION
SELECT order_id, order_date, 'Archived' AS status
FROM orders WHERE order_date < '2019.01.01';

SELECT first_name FROM customers
UNION
SELECT name FROM shippers;

SELECT customer_id, first_name, points, "Bronze" AS `type`
FROM customers WHERE points<2000
UNION
SELECT customer_id, first_name, points, "Silver" AS `type`
FROM customers WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id, first_name, points, "Gold" AS `type`
FROM customers WHERE points>2000
ORDER BY first_name;

-- COLUMN ATTRIBUTES
# datatype: 
# INT(11) - integers
# VARCHAR(50) - max 50 characters
# CHAR(2) - exactly 2 characters
# PK: Primary key
# NN: Non-null
# AI: Auto increment
# Default/Expression

-- INSERTING A SINGLE ROW
INSERT INTO customers VALUES (DEFAULT,'John','Smith','1900-01-01',NULL,'address','city','CA',DEFAULT);
INSERT INTO customers
	(first_name,
    last_name,
    birth_date,
    address,
    city,
    state)
VALUES ('John','Smith','1990-01-01','address','city','CA');
SELECT * from customers;

-- INSERTING MULTIPLE ROWS
INSERT INTO shippers(name)
VALUES ('Shipper1'),
		('Shipper2'),
        ('Shipper3');
        
INSERT INTO products(name,quantity_in_stock,unit_price)
VALUES ('product1',10,1.1),
		('product2',20,1.2),
		('product3',30,1.3);
SELECT * FROM products;

-- Inserting Hierarchical Rows
INSERT INTO orders (customer_id, order_date, status)
VALUES (1,'2019-01-12',1);

INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(),1,1,2.95),
    (LAST_INSERT_ID(),2,1,3.95);
SELECT * FROM order_items;

-- create a COPY of a Table
CREATE TABLE orders_archived AS
SELECT * FROM orders;

INSERT INTO orders_archived
SELECT * FROM orders
WHERE order_date < '2019-01-01';

CREATE TABLE orders_archived1 AS
SELECT * FROM orders
WHERE order_date >= '2018-01-01';

USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT i.invoice_id, 
		i.number, 
        c.name client,
        i.invoice_total, 
        i.payment_total,
        i.invoice_date,
        i.due_date,
        i.payment_date
FROM invoices i LEFT JOIN clients c ON i.client_id=c.client_id
WHERE i.payment_date IS NOT NULL;

-- Updating a SINGLE row
UPDATE invoices
SET payment_total=10, payment_date='2019-03-01'
WHERE invoice_id=1;

UPDATE invoices
SET 
	payment_total=DEFAULT, 
	payment_date=NULL
WHERE invoice_id=1;

UPDATE invoices
SET 
	payment_total=invoice_total * 0.5, 
	payment_date=due_date
WHERE invoice_id=1;

-- Updating MULTIPLE records
UPDATE invoices
SET 
	payment_total=invoice_total * 0.5,
    payment_date=due_date
WHERE client_id=3; 
# WHERE client_id IN (3,4); 

USE sql_stores;
UPDATE customers
SET points = points+50
WHERE birth_date < '1990-01-01';

-- Using SUBQUERIES in Updates
UPDATE invoices
SET 
	payment_total=invoice_total * 0.5,
    payment_date=due_date
WHERE client_id= 
		(SELECT client_id
				FROM clients
				WHERE name = 'Myworks');

UPDATE invoices
SET 
	payment_total=invoice_total * 0.5,
    payment_date=due_date
WHERE client_id IN 
		(SELECT client_id
				FROM clients
				WHERE state IN ('CA','NY'));
                
UPDATE invoices
SET 
	payment_total=invoice_total * 0.5,
    payment_date=due_date
WHERE payment IS NULL;

# Exercise
USE sql_store;
UPDATE orders
SET comments='gold customer'
WHERE customer_id IN
		(SELECT customer_id FROM customers WHERE points > 3000);
SELECT * FROM orders;

-- DELETING ROW
DELETE FROM invoices
WHERE invoice_id=1;

DELETE FROM invoices
WHERE invoice_id=(SELECT client_id FROM clients WHERE name='Myworks');

