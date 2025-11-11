-- Create table 
DROP TABLE IF EXISTS property_sales;

CREATE TABLE property_sales (
    datesold DATE NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    price NUMERIC(12,2) NOT NULL,
    propertyType VARCHAR(50) NOT NULL,
    bedrooms INT CHECK (bedrooms >= 0)
);

DROP TABLE IF EXISTS property_sales_stage ;
CREATE TABLE property_sales_stage (
  datesold_text TEXT,
  postcode VARCHAR(10),
  price NUMERIC(12,2),
  propertyType VARCHAR(50),
  bedrooms INT
);

DROP TABLE IF EXISTS property_sales_stage ;
CREATE TABLE property_sales (
  datesold TEXT,
  postcode VARCHAR(10),
  price NUMERIC(12,2),
  propertyType VARCHAR(50),
  bedrooms INT
);

SELECT * FROM property_sales_stage;
-- Showes total property sold on week & month basis each year 

-- Analyze number of property sales per week of each month
SELECT 
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'YYYY-MM') AS month,              -- Month (e.g., 2007-02)
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), '"Week "W') AS week_of_month,     -- Week number in that month
    COUNT(*) AS total_sales                                                    -- Number of sales in that week
FROM 
    property_sales
WHERE 
    datesold IS NOT NULL AND datesold <> ''                                   -- Avoid blank/null dates
GROUP BY 
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'YYYY-MM'),
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), '"Week "W')
ORDER BY 
    month,
    week_of_month;
--Analyze number of property sales sold each year 
-- Analyze number of property sales per year
SELECT 
    EXTRACT(YEAR FROM TO_DATE(datesold, 'MM/DD/YYYY')) AS sales_year,  -- Extracts the year from the date
    COUNT(*) AS total_sales                                            -- Number of sales in that year
FROM 
    property_sales
WHERE 
    datesold IS NOT NULL AND datesold <> ''                            -- Skip null or blank dates
GROUP BY 
    EXTRACT(YEAR FROM TO_DATE(datesold, 'MM/DD/YYYY'))
ORDER BY 
    sales_year;
-- find out during which month from 2007 to 2019 we have seen maximum sales so that we can find a trend
-- Find the month (between 2007–2019) with maximum property sales
-- Find the month (between 2007–2019) with maximum property sales
SELECT 
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'YYYY-MM') AS year_month,  -- Format as "YYYY-MM"
    COUNT(*) AS total_sales                                              -- Number of sales that month
FROM 
    property_sales
WHERE 
    datesold IS NOT NULL 
    AND datesold <> '' 
    AND EXTRACT(YEAR FROM TO_DATE(datesold, 'MM/DD/YYYY')) BETWEEN 2007 AND 2019
GROUP BY 
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'YYYY-MM')
ORDER BY 
    total_sales DESC
LIMIT 1;   -- Only show the month with the maximum sales

-- Find which month has the maximum property sales for each year (2007–2024)
-- Find which month has the maximum property sales for each year (2007–2024)
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(datesold, 'MM/DD/YYYY')) AS sales_year,
        TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'Month') AS sales_month,
        COUNT(*) AS total_sales
    FROM 
        property_sales
    WHERE 
        datesold IS NOT NULL 
        AND datesold <> '' 
        AND EXTRACT(YEAR FROM TO_DATE(datesold, 'MM/DD/YYYY')) BETWEEN 2007 AND 2024
    GROUP BY 
        EXTRACT(YEAR FROM TO_DATE(datesold, 'MM/DD/YYYY')),
        TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'Month')
)
SELECT 
    sales_year,
    sales_month,
    total_sales AS max_sales
FROM (
    SELECT 
        sales_year,
        sales_month,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY sales_year ORDER BY total_sales DESC) AS rn
    FROM 
        monthly_sales
) ranked
WHERE rn = 1
ORDER BY sales_year;


-- Find the postcode with the highest number of sales
-- and arrange all postcodes in descending order
SELECT 
    postcode,
    COUNT(*) AS total_sales
FROM 
    property_sales
WHERE 
    postcode IS NOT NULL 
    AND postcode <> ''
GROUP BY 
    postcode
ORDER BY 
    total_sales DESC;


---- Top 10 properties with the highest prices
SELECT 
    price,
    postcode,
    propertyType,
    bedrooms,
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'Month YYYY') AS sold_month_year
FROM 
    property_sales
WHERE 
    datesold IS NOT NULL 
    AND datesold <> ''
ORDER BY 
    price DESC
LIMIT 10;

---- Top 10 properties with the lowest prices
SELECT 
    price,
    postcode,
    propertyType,
    bedrooms,
    TO_CHAR(TO_DATE(datesold, 'MM/DD/YYYY'), 'Month YYYY') AS sold_month_year
FROM 
    property_sales
WHERE 
    datesold IS NOT NULL 
    AND datesold <> ''
ORDER BY 
    price ASC
LIMIT 10;

-- Find postcode with the highest number of sales
-- and arrange all postcodes in descending order

SELECT 
    postcode,
    COUNT(*) AS total_sales
FROM 
    property_sales
WHERE 
    postcode IS NOT NULL 
    AND postcode <> ''       -- ignore empty postcodes
GROUP BY 
    postcode
ORDER BY 
    total_sales DESC;         -- show highest sales first

-- Find postcode with the highest number of sales
-- Arrange all postcodes in descending order
-- Include average price per postcode

SELECT 
    postcode,
    COUNT(*) AS total_sales,                             -- total number of sales
    ROUND(AVG(price), 2) AS average_price                -- average property price in that postcode
FROM 
    property_sales
WHERE 
    postcode IS NOT NULL 
    AND postcode <> ''                                   -- ignore blank postcodes
GROUP BY 
    postcode
ORDER BY 
    total_sales DESC;                                    -- highest sales first

-- Find the average property price for each postcode
-- and arrange all postcodes in descending order of average price

SELECT 
    postcode,
    ROUND(AVG(price), 2) AS average_price,
    COUNT(*) AS total_sales
FROM 
    property_sales
WHERE 
    postcode IS NOT NULL 
    AND postcode <> ''   -- ignore blank postcodes
GROUP BY 
    postcode
ORDER BY 
    average_price DESC;  -- sort from highest to lowest average price


-- Find the trend among the number of rooms (bedrooms) customers are buying
-- Find the trend among the number of rooms (bedrooms) customers are buying
-- Ignoring properties with 0 bedrooms and property type 'unit'

SELECT 
    bedrooms,
    COUNT(*) AS total_sales,
    ROUND(AVG(price), 2) AS average_price
FROM 
    property_sales
WHERE 
    bedrooms > 0
    AND LOWER(propertyType) <> 'unit'
GROUP BY 
    bedrooms
ORDER BY 
    bedrooms ASC;

-- Find out which property type is most popular (House or Unit)

SELECT 
    propertyType,
    COUNT(*) AS total_sales
FROM 
    property_sales
WHERE 
    propertyType IN ('house', 'unit')    -- only compare house and unit
GROUP BY 
    propertyType
ORDER BY 
    total_sales DESC;                    -- most popular first


-- Find the number of properties sold in postcode 2618
-- and show how many were Houses vs Units

SELECT 
    propertyType,
    COUNT(*) AS total_sales
FROM 
    property_sales
WHERE 
    postcode = '2618'
    AND LOWER(propertyType) IN ('house', 'unit')
GROUP BY 
    propertyType
ORDER BY 
    total_sales DESC;

-- Find the number of properties sold (House vs Unit)
-- for specific postcodes: 2618, 2603, 2600, 2605, 2911

SELECT 
    postcode,
    LOWER(propertyType) AS property_type,
    COUNT(*) AS total_sales
FROM 
    property_sales
WHERE 
    postcode IN ('2618', '2603', '2600', '2605', '2911')
    AND LOWER(propertyType) IN ('house', 'unit')
GROUP BY 
    postcode, LOWER(propertyType)
ORDER BY 
    postcode, total_sales DESC;
