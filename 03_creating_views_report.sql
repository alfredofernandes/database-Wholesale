-- BUSINESS REPORTS


-- FIRST REPORT 
-- Defaulters list of Customers who has not paid their pending amount.

DROP VIEW IF EXISTS `R1_SaleListOfCustomersPendingAmount`;
CREATE VIEW `R1_SaleListOfCustomersPendingAmount` AS
    SELECT 
        CONCAT(c.first_name, ' ', c.last_name) AS 'Customer Name', 
        CONCAT('$ ', FORMAT(SUM((sd.quantity * sd.price_each) * ((100 - sd.discount)/100)), 2)) AS 'Total Pending'
    FROM sale AS s
    INNER JOIN sale_detail AS sd ON sd.sale_id = s.sale_id
    INNER JOIN customer AS c ON c.customer_id = s.customer_id
    WHERE s.payment = 0 AND s.status <> 'Cancel'
    GROUP BY c.customer_id
    ORDER BY c.first_name ASC;
    
    
-- SECOND REPORT 
-- List of Payment Paid or Pending.

DROP VIEW IF EXISTS `R2_SaleListOfPaymentsPaidOrPendingAmount`;
CREATE VIEW `R2_SaleListOfPaymentsPaidOrPendingAmount` AS
    SELECT 
        s.sale_id AS 'Order ID', 
        s.order_date AS 'Order Date', 
        CONCAT(c.first_name, ' ', c.last_name) AS 'Customer Name', 
        CONCAT('$ ', FORMAT(SUM((sd.quantity * sd.price_each)), 2)) AS 'Total Amount',
        CONCAT('$ ', FORMAT(SUM((sd.quantity * sd.price_each) * ((100 - sd.discount)/100)), 2)) AS 'Total Discount Amount',
        IF(s.payment = 1, 'Paid', 'Pending') as 'Payment'
    FROM sale_detail AS sd
    INNER JOIN sale AS s ON s.sale_id = sd.sale_id
    INNER JOIN customer AS c ON c.customer_id = s.customer_id
    WHERE status <> 'Cancel'
    GROUP BY sd.sale_id
    ORDER BY Payment ASC, s.order_date DESC;
    
    
-- THIRD REPORT 
-- Customer name, order total quantities, group by the customer and total amount paid.

DROP VIEW IF EXISTS `R3_SaleListOfCustomersOrderQuantityTotalAmountPaid`;
CREATE VIEW `R3_SaleListOfCustomersOrderQuantityTotalAmountPaid` AS
    SELECT 
        c.customer_id AS 'Customer ID', 
        CONCAT(c.first_name, ' ', c.last_name) AS 'Customer Name', 
        COUNT(s.sale_id) AS 'Order Quantity', 
        CONCAT('$ ', FORMAT(SUM((sd.quantity * sd.price_each) * ((100 - sd.discount)/100)), 2)) AS 'Total Sale Amount'
    FROM sale AS s 
    LEFT OUTER JOIN customer AS c ON c.customer_id = s.customer_id
    LEFT OUTER JOIN sale_detail AS sd ON sd.sale_id = s.sale_id
    WHERE s.payment = 1
    GROUP BY c.customer_id
    ORDER BY c.customer_id ASC;
    
    
-- FOUR REPORT 
-- Product details which are shipped after the year 2017.

DROP VIEW IF EXISTS `R4_SaleListOfProductDetailsShippedAfter2017`;
CREATE VIEW `R4_SaleListOfProductDetailsShippedAfter2017` AS
	SELECT 
		s.shipped_date AS 'Shipped Date',
		sd.sale_id AS 'Order ID',
		p.product_id AS 'Product ID', 
		p.name AS 'Product Name',
		s.status AS 'Order Status'
	FROM sale AS s 
	LEFT OUTER JOIN sale_detail AS sd on sd.sale_id = s.sale_id
	LEFT OUTER JOIN stock AS st ON st.stock_id = sd.stock_id 
	LEFT OUTER JOIN product AS p ON p.product_id = st.stock_id 
	WHERE s.shipped_date >= '2017-01-01' AND s.status = 'Delivered'
	ORDER BY s.shipped_date ASC, s.sale_id ASC;
    
    
-- FIFTH REPORT
-- Stock maintenance details with product it associated with and quantity available.

DROP VIEW IF EXISTS `R5_StockProductQuantityAvalible`;
CREATE VIEW `R5_StockProductQuantityAvalible` AS
	SELECT 
		st.product_id AS 'Stock Product ID',
		p.name AS 'Product Name',
        st.quantity AS 'Quantity'
	FROM stock AS st
    INNER JOIN product AS p ON p.product_id = st.product_id
	ORDER BY p.name  ASC;


-- SIXTH REPORT
-- What are sales from different cities.

DROP VIEW IF EXISTS `R6_SaleFromDifferentCities`;
CREATE VIEW `R6_SaleFromDifferentCities` AS
	SELECT 
		z.city AS 'City', 
		z.province AS 'Province',
		z.country AS 'Country',
	    COUNT(s.sale_id) AS 'Total Sale Amount'
	FROM sale AS s
    INNER JOIN customer AS c ON c.customer_id = s.customer_id
    INNER JOIN zip AS z ON z.zip_code = c.zip_code
	GROUP BY z.city, z.province, z.country
	ORDER BY  COUNT(s.sale_id) DESC;


-- SEVENTH 

-- Sale per month
DROP VIEW IF EXISTS `R7_MonthlySale`;
CREATE VIEW `R7_MonthlySale` AS
    SELECT 
         YEAR(s.order_date) AS 'Year', 
         MONTH(s.order_date) AS 'Month', 
         ROUND(SUM((sd.quantity * sd.price_each) * ((100 - sd.discount)/100)), 2) AS 'Total'
    FROM sale AS s
    INNER JOIN sale_detail AS sd ON sd.sale_id = s.sale_id
    WHERE s.payment = 1 AND s.status <> 'Cancel'
    GROUP BY YEAR(s.order_date), MONTH(s.order_date);

-- Purchase per month
DROP VIEW IF EXISTS `R7_MonthlyPurchase`;
CREATE VIEW `R7_MonthlyPurchase` AS
    SELECT 
        YEAR(p.order_date) AS 'Year', 
        MONTH(p.order_date) AS 'Month', 
        ROUND(SUM((pd.quantity * pd.price_each) * ((100 - pd.discount)/100)), 2) AS 'Total'
    FROM purchase AS p
    INNER JOIN purchase_detail AS pd ON pd.purchase_id = p.purchase_id
    WHERE p.payment = 1 AND p.status <> 'Cancel'
    GROUP BY YEAR(p.order_date), MONTH(p.order_date);
 
-- Profit per month
DROP VIEW IF EXISTS `R7_MonthlyProfit`;
CREATE VIEW `R7_MonthlyProfit` AS
    SELECT 
        m.Month AS 'Month',
        CASE WHEN ms.Total IS NULL THEN 0 ELSE ms.Total END AS 'Monthly Sale', 
        CASE WHEN mp.Total IS NULL THEN 0 ELSE mp.Total END AS 'Monthly Purchase',
        CONCAT('$ ', FORMAT(CASE WHEN ms.Total IS NULL THEN 0 ELSE ms.Total END - CASE WHEN mp.Total IS NULL THEN 0 ELSE mp.Total  END, 2)) AS 'Monthly Profit'
    FROM ( 
        SELECT 1 AS MONTH UNION 
        SELECT 2 AS MONTH UNION 
        SELECT 3 AS MONTH UNION 
        SELECT 4 AS MONTH UNION 
        SELECT 5 AS MONTH UNION 
        SELECT 6 AS MONTH UNION 
        SELECT 7 AS MONTH UNION 
        SELECT 8 AS MONTH UNION 
        SELECT 9 AS MONTH UNION 
        SELECT 10 AS MONTH UNION 
        SELECT 11 AS MONTH UNION 
        SELECT 12 AS MONTH
    ) AS m
    LEFT JOIN R7_MonthlySale AS ms ON m.Month = ms.Month AND ms.Year = 2017
    LEFT JOIN R7_MonthlyPurchase AS mp ON m.Month = mp.Month AND mp.Year = 2017
    ORDER BY m.Month;
