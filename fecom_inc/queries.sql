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

SELECT * FROM fecom_inc_sellers_list;
