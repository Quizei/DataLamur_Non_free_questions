/*Problem Statement

You are given a table `products` that contains `product_id`, `category`, and `name` columns. Some rows are missing the `category` value (i.e., it is `NULL`). Your task is to **fill forward** the `category` column such that any missing value gets replaced with the most recent non-null value **above it in the row order**.
Use SQL window functions to perform this transformation **without using subqueries in the SELECT** clause or writing procedural logic
*/ 


--Table Setup

--Create Statement 
    CREATE TABLE products (
        product_id INT PRIMARY KEY,
        category VARCHAR(255),
        name VARCHAR(255)
    );

--Insert Statement
    INSERT INTO products (product_id, category, name)
    VALUES
    (1, 'Electronics', 'Laptop'),
    (2, NULL, 'Tablet'),
    (3, NULL, 'Smartphone'),
    (4, 'Clothing', 'T-Shirt'),
    (5, NULL, 'Jeans'),
    (6, NULL, 'Sneakers');


--Solution 
    WITH cte AS (
        SELECT *, 
            ROW_NUMBER() OVER () AS no,
            CASE WHEN category IS NOT NULL THEN 1 ELSE 0 END AS grp 
        FROM products
    ),
    cte_2 AS (
        SELECT *, 
            SUM(grp) OVER (ORDER BY no) AS grp_2
        FROM cte
    )
    SELECT 
        product_id,
        FIRST_VALUE(category) OVER (PARTITION BY grp_2 ORDER BY no) AS category,
        name
    FROM cte_2;