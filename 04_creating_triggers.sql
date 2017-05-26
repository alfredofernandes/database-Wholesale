-- product_insert_on_stock
DROP TRIGGER IF EXISTS `product_insert_on_stock`;
CREATE TRIGGER `product_insert_on_stock` 
    AFTER INSERT ON `product` 
    FOR EACH ROW 
        INSERT INTO `stock` (product_id, quantity, price_each) VALUES (NEW.product_id, 0, 0.00);


-- insert_purchase_detail_update_on_stock
DROP TRIGGER IF EXISTS `insert_purchase_detail_update_on_stock`;
CREATE TRIGGER `insert_purchase_detail_update_on_stock` 
    AFTER INSERT ON `purchase_detail`
    FOR EACH ROW 
        UPDATE `stock` SET quantity = (NEW.quantity + quantity) WHERE product_id = product_id;

-- insert_sale_detail_update_on_stock
DROP TRIGGER IF EXISTS `insert_sale_detail_update_on_stock`;
CREATE TRIGGER `insert_sale_detail_update_on_stock` 
    AFTER INSERT ON `sale_detail`
    FOR EACH ROW 
        UPDATE `stock` SET quantity = (NEW.quantity - quantity) WHERE product_id = product_id;
