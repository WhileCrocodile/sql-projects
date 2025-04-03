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

DROP TABLE fecom_inc_order_reviews_no_emojis;
SHOW TABLES;
SELECT * FROM fecom_inc_geolocations;