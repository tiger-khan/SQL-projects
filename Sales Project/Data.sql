-- Sales and product analysis using three data tables 
-- combining with join and using subqueries to represent various insights
-- using when to combine columns into groups


-- CREATING TABLES
DROP TABLE IF EXISTS CUSTOMER;
CREATE TABLE CUSTOMER(
	CUSTOMER_ID VARCHAR,
	CUSTOMER_NAME VARCHAR,
	SEGMENT VARCHAR,
	AGE INT,
	COUNTRY VARCHAR,
	CITY VARCHAR,
	STATE VARCHAR,
	POSTAL_CODE INT,
	REGION VARCHAR,
	PRIMARY KEY(CUSTOMER_ID)
);

DROP TABLE IF EXISTS PRODUCT;
CREATE TABLE PRODUCT(
	PRODUCT_ID VARCHAR,
	CATEGORY VARCHAR,
	"Sub-Category" VARCHAR,
	PRODUCT_NAME VARCHAR,
	PRIMARY KEY(PRODUCT_ID)
);

DROP TABLE IF EXISTS SALES;
CREATE TABLE SALES(
	ORDER_LINE VARCHAR,
	ORDER_ID VARCHAR,
	ORDER_DATE VARCHAR,
	SHIP_DATE VARCHAR,
	SHIP_MODE VARCHAR,
	CUSTOMER_ID VARCHAR,
	PRODUCT_ID VARCHAR,
	SALES NUMERIC,
	QUANTITY INT,
	DISCOUNT NUMERIC,
	PROFIT NUMERIC,
	FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
	FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID)
);

SELECT *FROM CUSTOMER;
SELECT *FROM PRODUCT;
SELECT *FROM SALES;
--list of all the cities where the region is north or east without any duplicates
SELECT DISTINCT(CITY) FROM CUSTOMER WHERE REGION IN ('North') OR REGION IN ('East');

-- list of all orders where the ‘sales’ value is between 100 and 500
SELECT SALES FROM SALES WHERE SALES BETWEEN 100 AND 500;

-- list of customers whose last name contains only 4 characters
SELECT CUSTOMER_NAME FROM CUSTOMER WHERE CUSTOMER_NAME LIKE '% ____';

-- all orders where the ‘discount’ value is greater than zero ordered in descending order basis ‘discount’ value
SELECT * FROM SALES WHERE DISCOUNT > 0 ORDER BY DISCOUNT DESC;

-- Limit the number of results in the above query to the top 10
SELECT * FROM SALES WHERE DISCOUNT > 0 ORDER BY DISCOUNT DESC LIMIT 10;

-- sum of all ‘sales’ values
SELECT SUM(SALES) FROM SALES;

-- count of the number of customers in the north region with ages between 20 and 30
SELECT COUNT(CUSTOMER_ID) FROM CUSTOMER WHERE REGION IN ('North') and AGE BETWEEN 20 AND 30;

-- Find the average age of east region customers
SELECT AVG(AGE) FROM CUSTOMER WHERE REGION IN ('East');

-- minimum and maximum aged customers from Philadelphia
SELECT MIN(AGE), MAX(AGE) FROM CUSTOMER WHERE CITY = 'Philadelphia';

-- dashboard showing the following figures for each product ID
SELECT PRODUCT_ID,SUM(SALES) as SALES, SUM(QUANTITY), COUNT(ORDER_ID), MAX(SALES), MIN(SALES), AVG(SALES)
FROM SALES GROUP BY PRODUCT_ID ORDER BY SALES DESC;

-- list of product ID’s where the quantity of product sold is greater than 10
SELECT PRODUCT_ID FROM SALES WHERE QUANTITY > 10;

-- all orders where ‘discount’ value is greater than Zero ordered in descending order basis ‘discount’
SELECT *FROM SALES WHERE DISCOUNT > 0 ORDER BY DISCOUNT DESC;

-- LIMIT THE ABOVE LIST BY 10
SELECT *FROM SALES WHERE DISCOUNT > 0 ORDER BY DISCOUNT DESC LIMIT 10;

-- data with all columns of the sales table, and customer name, customer age, product name, and category are in the same result set
SELECT sales.*, c.customer_name AS customer_name, c.age AS customer_age, p.product_name AS product_name, p.category AS category
FROM sales
JOIN customer c ON sales.customer_id = c.customer_id
JOIN product p ON sales.product_id = p.product_id;

-- sales table, product name, and category in the result set.
SELECT s.*, p.product_name, p.category FROM sales s
JOIN product p on s.product_id = p.product_id;

-- create a sub-query by using the customer, product, sales data
SELECT *FROM SALES WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM PRODUCT
WHERE CUSTOMER_ID IN (SELECT CUSTOMER_ID FROM CUSTOMER));

-- maximum length of characters in the Product name string from Product table
SELECT MAX(LENGTH(PRODUCT_NAME)) FROM PRODUCT;

SELECT *FROM PRODUCT;

-- additional column named “product_details” which contains a concatenated string of product name, sub-category and category
SELECT PRODUCT_NAME, Sub_Category , CATEGORY, CONCAT(PRODUCT_NAME,'|', sub_category,'|',CATEGORY) as PRODUCT_DETAILS
FROM PRODUCT; 

-- product_id column and take out the three parts composing the product_id in three different columns
SELECT 
	split_part(product_id,'-',1) as split1,
	split_part(product_id,'-',2) as split1,
	split_part(product_id,'-',3) as split1
FROM
PRODUCT;

-- List down comma separated product name where sub-category is either Chairs or tables
SELECT string_agg(product_name,', ') as product_names
FROM PRODUCT
WHERE SUB_CATEGORY IN ('Chairs','Tables');

-- a list of 5 lucky customers from customer table using random function
SELECT * FROM CUSTOMER ORDER BY RANDOM() LIMIT 5;

-- Total sales revenue if you are charging the lower integer value of sales always.
SELECT SUM(FLOOR(sales)) as total_sales_lower_integer
FROM SALES;

-- Total sales revenue if you are charging the higher integer value is sales always.
SELECT SUM(CEIL(sales)) as total_sales_higher_integer
FROM SALES;

-- Total sales revenue if you are rounding-off the sales always.
SELECT SUM(ROUND(sales)) as total_sales_rounded
FROM SALES;

-- current age of “batman” who was born on “April 6,1939” in Years, months and days
SELECT
  date_part('year', age(now(), '1999-12-20')) as years,
  date_part('month', age(now(), '1939-12-20')) as months,
  date_part('day', age(now(), '1939-12-20')) as days;

-- monthly sales of sub-category chair
SELECT ORDER_DATE,SUM(SALES) AS TOTAL_SALES FROM SALES WHERE PRODUCT_ID IN
(SELECT PRODUCT_ID FROM PRODUCT WHERE SUB_CATEGORY = 'Chairs')
GROUP BY ORDER_DATE;

/*Creating sales table of the year 2015*/
drop table if exists sales_2015;
Create table sales_2015 as select * from sales where ship_date between '01-01-2015' and '31-12-2015';
select count(*) from sales_2015; 
select count(distinct customer_id) from sales_2015;

/* Customers with ages between 20 and 60 */
create table customer_20_60 as select * from customer where age between 20 and 60;
select count (*) from customer_20_60;

-- total sales done in every state for customer_20_60 and sales_2015 table
select c.state,sum(sales) from sales_2015 s join customer_20_60 c on s.customer_id = c.customer_id
GROUP BY state;

-- data containing Product_id, Product name, category, total sales value of that product, and total quantity sold
SELECT P.PRODUCT_ID, PRODUCT_NAME, CATEGORY, S.SALES, S.QUANTITY  FROM PRODUCT P 
JOIN SALES S ON P.PRODUCT_ID = S.PRODUCT_ID;

-- Finding which age group got most sales and profits
-- also find the bar visualization for this query
SELECT  
	CASE 
		WHEN Age < 20 THEN '<20' WHEN Age BETWEEN 20 AND 29 THEN '20-29' 
		WHEN Age BETWEEN 30 AND 39 THEN '30-39' WHEN Age BETWEEN 40 AND 49 THEN '40-49' 
		WHEN Age BETWEEN 50 AND 59 THEN '50-59' WHEN Age BETWEEN 60 AND 69 THEN '60-69' 
		WHEN Age BETWEEN 70 AND 79 THEN '70-79' WHEN Age BETWEEN 80 AND 89 THEN '80-89' 
		WHEN Age BETWEEN 90 AND 99 THEN '90-99' WHEN Age >= 100 THEN '100+' 
		END AS Age_Group, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit 
		FROM Customer 
		JOIN Sales ON Customer.Customer_ID = Sales.Customer_ID GROUP BY Age_Group;






