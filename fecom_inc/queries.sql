USE portfolio_projects;

CREATE TABLE fecom_inc_customer_list(
	CUSTOMER_Trx_ID CHAR(32),
	Subscriber_ID SMALLINT,
	Subscribe_Date DATE,
	First_Order_date DATE,
	Customer_Postal_Code VARCHAR(100),
	Customer_City VARCHAR(100),
    Customer_Country VARCHAR(100),
    Customer_Country_Code VARCHAR(10),
    AGE SMALLINT,
    Gender VARCHAR(100));
    
CREATE TABLE fecom_inc_geolocations(
	Geo_Postal_Code VARCHAR(100),
	Geo_Lat VARCHAR(100),
	Geo_Lon VARCHAR(100),
	Geolocation_City VARCHAR(100),
	Geo_Country VARCHAR(100));

CREATE TABLE fecom_inc_order_items(
	Order_ID CHAR(32),
	Order_Item_ID SMALLINT,
	Product_ID CHAR(32),
	Seller_ID CHAR(32),
	Shipping_Limit_Date DATETIME,
	Price FLOAT,
	Freight_Value FLOAT);

CREATE TABLE fecom_inc_order_payments(
	Order_ID CHAR(32),
    Payment_Sequential SMALLINT,
    Payment_Type VARCHAR(100),
    Payment_Installments SMALLINT,
    Payment_Value FLOAT);
    
CREATE TABLE fecom_inc_order_reviews_no_emojis(
	Review_ID CHAR(32),
	Order_ID CHAR(32),
	Review_Score SMALLINT,
	Review_Comment_Title_En VARCHAR(1000),
	Review_Comment_Message_En VARCHAR(10000),
	Review_Creation_Date VARCHAR(50),
	Review_Answer_Timestamp VARCHAR(50));
    
CREATE TABLE fecom_inc_orders(
	Order_ID CHAR(32),
    Customer_Trx_ID CHAR(32),
    Order_Status VARCHAR(100),
    Order_Purchase_Timestamp VARCHAR(100),
    Order_Approved_At VARCHAR(100),
    Order_Delivered_Carrier_Date VARCHAR(100),
    Order_Delivered_Customer_Date VARCHAR(100),
    Order_Estimated_Delivery_Date VARCHAR(100));
    
CREATE TABLE fecom_inc_products(
	Product_ID CHAR(32),
	Product_Category_Name VARCHAR(100),
    Product_Weight_Gr MEDIUMINT,
    Product_Length_Cm SMALLINT,
    Product_Height_Cm SMALLINT,
    Product_Width_Cm SMALLINT);
    
CREATE TABLE fecom_inc_sellers_list(
	Seller_ID CHAR(32),
    Seller_Name VARCHAR(100),
    Seller_Postal_Code VARCHAR(100),
    Seller_City VARCHAR(100),
    Country_Code VARCHAR(100),
    Seller_Country VARCHAR(100));

/* There is an error in some of our data; 
Germany is usually marked as Germany\r, but in exactly one entry it's just Germany */

/* First, we'd like to figure out some basic statistics about where our sales, sellers, and customers are from. */
/* Which countries which countries have the highest number of sellers? */
WITH sellersbycountry AS
(
SELECT Seller_Country, COUNT(*) as num_sellers FROM fecom_inc_sellers_list
GROUP BY Seller_Country
ORDER BY num_sellers DESC
),

/* How does this correspond with sale numbers? */
ordersbycountry AS
(
SELECT sellers_list.Seller_Country, 
	COUNT(*) AS num_orders, 
	SUM(order_items.Price) AS gross_profit,
    AVG(Freight_Value) as avg_transport_costs,
    SUM(order_items.Price)-(SUM(Freight_Value)) AS gross_profit_minus_transport
FROM fecom_inc_order_items AS order_items
INNER JOIN fecom_inc_sellers_list AS sellers_list ON order_items.Seller_ID = sellers_list.Seller_ID
GROUP BY Seller_Country
ORDER BY num_orders DESC
)

/* Join them together into one table */
SELECT s.Seller_Country, s.num_sellers, o.num_orders, o.gross_profit, o.avg_transport_costs, o.gross_profit_minus_transport
FROM sellersbycountry AS s
INNER JOIN ordersbycountry AS o ON s.Seller_Country = o.Seller_Country;
/* Germany has by far the highest number of sellers, orders placed, and gross profit.alter
It's followed far behind by Austria, the Netherlands, and Switzerland.*/

/* Where are our orders coming from?*/
SELECT Customer_Country, COUNT(*) as num_customers
FROM fecom_inc_customer_list AS customer_list
GROUP BY Customer_country
ORDER BY num_customers DESC;
/* Our orders are mostly coming from Germany, but we also have a significant number from France and the Netherlands.*/

/* Who's our biggest customer? */
SELECT Customer_Trx_ID, COUNT(*) as num_orders 
FROM fecom_inc_orders
GROUP BY Customer_Trx_ID
ORDER BY num_orders DESC;
/* Apparently every customer has only ordered once... */

/* How long does it take orders to be approved, then delivered? */
SHOW COLUMNS FROM `fecom_inc_orders`;
/* The dates in fecom_inc_orders are actually stored as strings, and not dates. */
/* For our purposes, we create a temp table to fix them and cast them as dates */
CREATE TEMPORARY TABLE fecom_inc_orders_asdates
SELECT Order_ID, 
	Customer_Trx_ID, 
    Order_Status, 
    CASE
		WHEN Order_Purchase_Timestamp LIKE "%:%" THEN CONCAT(Order_Purchase_Timestamp, ":00")
	END AS Order_Purchase_Timestamp,
    CASE
		WHEN Order_Approved_At LIKE "%:%" THEN CONCAT(Order_Approved_At, ":00")
	END AS Order_Approved_At,
    CASE
		WHEN Order_Delivered_Carrier_Date LIKE "%:%" THEN CONCAT(Order_Delivered_Carrier_Date, ":00")
	END AS Order_Delivered_Carrier_Date,
    CASE
		WHEN Order_Delivered_Customer_Date LIKE "%:%" THEN CONCAT(Order_Delivered_Customer_Date, ":00")
	END AS Order_Delivered_Customer_Date,
    CASE
		WHEN Order_Estimated_Delivery_Date LIKE "%:%" THEN CONCAT(LEFT(Order_Estimated_Delivery_Date, CHAR_LENGTH(Order_Estimated_Delivery_Date)-1), ":00")
        -- This column specifically has the /r character at the end of Order_Estimated_Delivery_Date, 
        -- which messes with the formatting so we remove it
	END AS Order_Estimated_Delivery_Date
FROM fecom_inc_orders;

-- MODIFYing columns into DATETIME
ALTER TABLE fecom_inc_orders_asdates
MODIFY Order_Purchase_Timestamp DATETIME,
MODIFY Order_Approved_At DATETIME,
MODIFY Order_Delivered_Carrier_Date DATETIME, 
MODIFY Order_Delivered_Customer_Date DATETIME, 
MODIFY Order_Estimated_Delivery_Date DATETIME;

/* Checking which areas have the longest delivery times.*/
/* Many customers seem to lack locations; this seems to be an error with the data.*/
SELECT orders.Customer_Trx_ID, 
	customers.Customer_City,
    customers.Customer_Country,
    customers.Customer_Postal_Code,
	TIMESTAMPDIFF(DAY, Order_Purchase_Timestamp, Order_Approved_At) AS Approval_Delay,
    TIMESTAMPDIFF(DAY, Order_Purchase_Timestamp, Order_Delivered_Carrier_Date) AS To_Carrier_Delay,
    TIMESTAMPDIFF(DAY, Order_Purchase_Timestamp, Order_Delivered_Customer_Date) AS Delivery_Delay,
    TIMESTAMPDIFF(DAY, Order_Estimated_Delivery_Date, Order_Delivered_Customer_Date) AS Diff_From_Estimate
FROM fecom_inc_orders_asdates AS orders
LEFT JOIN fecom_inc_customer_list AS customers ON orders.Customer_Trx_ID = customers.Customer_Trx_ID
ORDER BY Delivery_Delay DESC;




