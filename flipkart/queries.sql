USE flipkart;

CREATE TABLE flipkart_products (
	Product_Name VARCHAR(100),
    Price DECIMAL(65, 3),
    Rating FLOAT,
    Number_of_Buyers INT,
    Total_Sold INT,
    Available_Stock INT,
    Main_Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Discount_Percent SMALLINT,
    Seller VARCHAR(100),
    Return_Policy VARCHAR(10),
    Product_URL VARCHAR(1000));

SELECT * FROM flipkart_products;

/* Checking some mean statistics based on Rating bins*/
SELECT AVG(Price), AVG(Number_of_Buyers), AVG(Total_Sold), AVG(Discount_Percent), Rating_Group
FROM (SELECT *, CASE WHEN Rating <= 1 THEN 1
					WHEN Rating  <= 2 THEN 2
					WHEN Rating <= 3 THEN 3
					WHEN Rating <= 4 THEN 4
					WHEN Rating <= 5 THEN 5
				END AS Rating_Group
		FROM flipkart_products) AS rating_grouped
GROUP BY Rating_Group
ORDER BY Rating_Group DESC;

/* Checking mean statistics for Main_Category */
SELECT Main_Category, Sub_Category, AVG(Price) avg_price, AVG(Rating) avg_rating, AVG(Number_of_Buyers) avg_buyers, AVG(Total_Sold) avg_sold, AVG(Discount_Percent) avg_discount
FROM flipkart_products
GROUP BY Main_Category, Sub_Category
ORDER BY avg_price DESC;

/* What are the most-bought items in each category? */
WITH rank_by_sales AS (
	SELECT *, RANK() OVER(PARTITION BY Sub_Category ORDER BY Total_Sold DESC) AS sales_rank
	FROM flipkart_products
)
SELECT Product_Name, Price, Rating, Number_of_Buyers, Total_Sold, Available_Stock, Main_Category, Sub_Category, Discount_Percent, Seller, Return_Policy
FROM rank_by_sales
WHERE sales_rank <= 3
ORDER BY Number_of_Buyers DESC;

/* What are the biggest deals in each category? */
WITH rank_by_discount AS (
	SELECT *, RANK() OVER(PARTITION BY Sub_Category ORDER BY Discount_Percent DESC) AS discount_rank
	FROM flipkart_products
)
SELECT Product_Name, Price, Rating, Number_of_Buyers, Total_Sold, Available_Stock, Main_Category, Sub_Category, Discount_Percent, Seller, Return_Policy
FROM rank_by_discount
WHERE discount_rank <= 3
ORDER BY Number_of_Buyers DESC;

/* How do return policies affect ratings? */
SELECT AVG(Rating), Main_Category, Sub_Category, Return_Policy 
FROM flipkart_products
GROUP BY Main_Category, Sub_Category,Return_Policy
ORDER BY Main_Category, Sub_Category;

/* Which categories have the most low-sale items?*/
-- Check max and mins for each category to determine an appropriate threshold
SELECT Main_Category, Sub_Category, COUNT(*), MAX(Total_Sold), MIN(Total_Sold)
FROM flipkart_products
GROUP BY Main_Category, Sub_Category;

SELECT Main_Category, Sub_Category, COUNT(*) sale_count
FROM flipkart_products
WHERE Total_Sold < 1000
GROUP BY Main_Category, Sub_Category
ORDER BY sale_count DESC;