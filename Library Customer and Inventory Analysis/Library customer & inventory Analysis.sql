\c library_database;

-- Create table customer
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    city VARCHAR(50),
    country VARCHAR(80)
);

-- View table Cistomers
SELECT * FROM customers;

DROP TABLE IF EXISTS customers;

-- Import table Customer & view table
SELECT * FROM customers;
-- As the file has been exported Now we will start with table 2 - Books 


CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    published_year INT CHECK (published_year > 0),
    price NUMERIC(10,2) CHECK (price >= 0),
    stock INT CHECK (stock >= 0)
);

-- View table Books
SELECT * FROM books
-- Import table Customer & view table
SELECT * FROM books

-- As the file has been exported Now we will start with table 3 - Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    book_id INT NOT NULL,
    order_date DATE NOT NULL,
    quantity INT CHECK (quantity > 0),
    total_amount NUMERIC(10,2) CHECK (total_amount >= 0)

	);

--  View table Orders & the file has been imported 
SELECT * FROM orders


-- merging data of all three table 
CREATE OR REPLACE VIEW master_library_data AS
SELECT
    o.order_id,
    c.customer_id,
    c.name AS customer_name,
    c.email,
    c.city,
    c.country,
    b.book_id,
    b.title AS book_title,
    b.author,
    b.genre,
    b.published_year,
    o.order_date,
    o.quantity,
    o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN books b ON o.book_id = b.book_id;


--- Basic quarries to study --
-- 1. Calculate the total revenue generated from all orders 

SELECT 
    SUM(total_amount) AS total_revenue
FROM master_library_data;

-- 2. find the books with lowest stocks 
SELECT 
    book_id,
    title,
    author,
    genre,
    stock
FROM books
WHERE stock = (SELECT MIN(stock) FROM books);

-- 3. List all genres available in the Books table
SELECT DISTINCT genre
FROM books
ORDER BY genre;

--4.Retrieve all orders where the total amount exceeds $20
SELECT 
    order_id,
    customer_id,
    book_id,
    order_date,
    quantity,
    total_amount
FROM orders
WHERE total_amount > 20
ORDER BY total_amount DESC;

-- 5. show all customers who ordered more than 1 quantity of a book 
SELECT 
    c.customer_id,
    c.name AS customer_name,
    c.email,
    c.city,
    c.country,
    o.order_id,
    o.book_id,
    o.quantity,
    o.order_date
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE o.quantity > 1
ORDER BY o.quantity DESC;

-- 6. find  total number of loyal customers who have order more then or equal to 7 Orders 
SELECT 
    c.customer_id,
    c.name AS customer_name,
    SUM(o.quantity) AS total_quantity_ordered,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(o.quantity) >= 7
ORDER BY total_quantity_ordered DESC;
 -- 7. Customers who made 3+ orders and have a total quantity ordered ≥ 15.

SELECT 
    c.customer_id,
    c.name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity) AS total_quantity_ordered
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 3 AND SUM(o.quantity) >= 15
ORDER BY total_quantity_ordered DESC;

-- 8. find number of first time buyers and how many orders they have placed 
WITH first_orders AS (
    SELECT 
        customer_id,
        order_id,
        order_date,
        quantity,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS order_rank
    FROM orders
)
SELECT 
    quantity AS number_of_books_ordered,
    COUNT(DISTINCT customer_id) AS number_of_customers
FROM first_orders
WHERE order_rank = 1   -- only first order per customer
GROUP BY quantity
ORDER BY quantity;

--9. find number of customer who order 10 boooks on it's first order 

WITH first_orders AS (
    SELECT 
        customer_id,
        order_id,
        order_date,
        quantity,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS order_rank
    FROM orders
)
SELECT 
    COUNT(DISTINCT customer_id) AS customers_with_10_books_first_order
FROM first_orders
WHERE order_rank = 1   -- first order only
  AND quantity = 10;   -- ordered exactly 10 books


--10. find details of most expensive books 
SELECT 
    book_id,
    title,
    author,
    genre,
    published_year,
    price,
    stock
FROM books
ORDER BY price DESC
LIMIT 1;

--11. find books published after the year 1950
SELECT 
    book_id,
    title,
    author,
    genre,
    published_year,
    price,
    stock
FROM books
WHERE published_year > 1950
ORDER BY published_year ASC;

-- 12 . list all customers from the canada 
SELECT 
    customer_id,
    name,
    email,
    phone,
    city,
    country
FROM customers
WHERE country = 'Canada';

--13 Retreve the total stock of book available 

SELECT 
    SUM(stock) AS total_stock_available
FROM books;


-- Advance queries 
--14 Calculate the stock remaining after fulfilling all orders
SELECT 
    b.book_id,
    b.title,
    b.stock AS initial_stock,
    COALESCE(SUM(o.quantity), 0) AS total_ordered,
    (b.stock - COALESCE(SUM(o.quantity), 0)) AS remaining_stock
FROM books b
LEFT JOIN orders o 
    ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock
ORDER BY remaining_stock ASC;

--15 Find the customer the customer who spend the most on order 
SELECT 
    c.customer_id,
    c.name,
    c.email,
    c.city,
    c.country,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email, c.city, c.country
ORDER BY total_spent DESC
LIMIT 1;

--16 List the cities where customer over $30 are located 
SELECT 
    DISTINCT c.city
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.city, c.customer_id
HAVING SUM(o.total_amount) > 30;

--17 Retrieve the total quantity of books sold by each author
SELECT 
    b.author,
    SUM(o.quantity) AS total_books_sold
FROM books b
JOIN orders o 
    ON b.book_id = o.book_id
GROUP BY b.author
ORDER BY total_books_sold DESC;
-- 18 show the top 10 books that are most sold and there quantnity and there joner
SELECT 
    b.book_id,
    b.title,
    b.genre,
    SUM(o.quantity) AS total_quantity_sold
FROM books b
JOIN orders o 
    ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.genre
ORDER BY total_quantity_sold DESC
LIMIT 10;

--19 find Average price of books on each Genre 
SELECT 
    genre,
    ROUND(AVG(price), 2) AS average_price
FROM books
GROUP BY genre
ORDER BY average_price DESC;

--20 Find the number of books need to be re- stocked
SELECT 
    COUNT(*) AS books_to_restock
FROM books
WHERE stock < 5;

--21 Find the Details  of books need to be re- stocked
SELECT 
    book_id,
    title,
    author,
    genre,
    published_year,
    price,
    stock
FROM books
WHERE stock < 5
ORDER BY stock ASC;
