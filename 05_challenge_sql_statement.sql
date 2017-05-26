-- CHALLENGE SQL STATEMENT
 
-- For how long is a product maintained into a stock (in hand)? 
-- This represents costs for the company, so the fast it sells, 
-- the more economic the wholesale system is.


DROP VIEW IF EXISTS `GetDatePurchase`;
CREATE VIEW `GetDatePurchase` AS
	SELECT 
		p.purchase_id, 
		pd.stock_id AS stockid,
		p.shipped_date AS shippeddate
	FROM purchase AS p
	INNER JOIN purchase_detail AS pd ON p.purchase_id = pd.purchase_id
	ORDER BY p.shipped_date DESC;
    


DROP VIEW IF EXISTS `GetDateSale`;
CREATE VIEW `GetDateSale` AS
	SELECT 
		s.sale_id, 
		sd.stock_id AS stockid,
		s.shipped_date AS shippeddate
	FROM sale AS s
	INNER JOIN sale_detail AS sd ON sd.sale_id = s.sale_id
	ORDER BY s.shipped_date DESC;


DROP VIEW IF EXISTS `TimeInStock`;
CREATE VIEW `TimeInStock` AS
	SELECT 
		s.stock_id AS 'Product ID',
		pro.name AS 'Product Name',
        p.shippeddate AS 'Purchase Date',
        sl.shippeddate AS 'Sale Date',
        DATEDIFF(sl.shippeddate, p.shippeddate) AS 'Days in Stock'
	FROM stock AS s
	INNER JOIN product AS pro ON pro.product_id = s.product_id
	INNER JOIN GetDatePurchase AS p ON p.stockid = s.stock_id
	INNER JOIN GetDateSale AS sl ON sl.stockid = s.stock_id
    WHERE p.shippeddate IS NOT NULL AND sl.shippeddate IS NOT NULL
	GROUP BY s.stock_id, p.shippeddate, sl.shippeddate;
