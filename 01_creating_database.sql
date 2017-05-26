DROP DATABASE IF EXISTS WHOLESALE;

-- -----------------------------------------------------
-- DATABASE WHOLESALE
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS WHOLESALE;

USE WHOLESALE ;

-- -----------------------------------------------------
-- Table product_category
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS product_category (
  category_id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (category_id));


-- -----------------------------------------------------
-- Table product
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS product (
  product_id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(100) NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (product_id),
  UNIQUE INDEX name_UNIQUE (name ASC),
  INDEX fk_product_category_id_idx (category_id ASC),
  CONSTRAINT fk_product_category_id
    FOREIGN KEY (category_id)
    REFERENCES product_category (category_id));


-- -----------------------------------------------------
-- Table zip
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS zip (
  zip_code VARCHAR(15) NOT NULL,
  city VARCHAR(45) NOT NULL,
  province VARCHAR(45) NOT NULL,
  country VARCHAR(45) NULL,
  PRIMARY KEY (zip_code));


-- -----------------------------------------------------
-- Table buyer
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS buyer (
  buyer_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(100) NOT NULL,
  zip_code VARCHAR(15) NOT NULL,
  email VARCHAR(100) NULL,
  PRIMARY KEY (buyer_id),
  INDEX fk_buyer_zip_code_idx (zip_code ASC),
  CONSTRAINT fk_buyer_zip_code
    FOREIGN KEY (zip_code)
    REFERENCES zip (zip_code));


-- -----------------------------------------------------
-- Table purchase
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS purchase (
  purchase_id INT(11) NOT NULL AUTO_INCREMENT,
  buyer_id INT(11) NOT NULL,
  order_date DATE NOT NULL,
  required_date DATE NOT NULL,
  shipped_date DATE NULL,
  status ENUM('Pending', 'Cancel', 'Delivered') NOT NULL,
  payment TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (purchase_id),
  INDEX fk_purchase_buyer_id_idx (buyer_id ASC),
  CONSTRAINT fk_purchase_buyer_id
    FOREIGN KEY (buyer_id)
    REFERENCES buyer (buyer_id));


-- -----------------------------------------------------
-- Table customer
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS customer (
  customer_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  address VARCHAR(100) NOT NULL,
  zip_code VARCHAR(15) NOT NULL,
  email VARCHAR(100) NULL,
  PRIMARY KEY (customer_id),
  INDEX fk_customer_zip_code_idx (zip_code ASC),
  CONSTRAINT fk_customer_zip_code
    FOREIGN KEY (zip_code)
    REFERENCES zip (zip_code));


-- -----------------------------------------------------
-- Table sale
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS sale (
  sale_id INT(11) NOT NULL AUTO_INCREMENT,
  customer_id INT(11) NOT NULL,
  order_date DATE NOT NULL,
  required_date DATE NOT NULL,
  shipped_date DATE NULL,
  status ENUM('Pending', 'Cancel', 'Delivered') NOT NULL,
  payment TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (sale_id),
  INDEX fk_sale_customer_id_idx (customer_id ASC),
  CONSTRAINT fk_sale_customer_id
    FOREIGN KEY (customer_id)
    REFERENCES customer (customer_id));


-- -----------------------------------------------------
-- Table stock
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS stock (
  stock_id INT(11) NOT NULL AUTO_INCREMENT,
  product_id INT(11) NOT NULL,
  quantity INT(5) NOT NULL,
  price_each FLOAT NOT NULL,
  PRIMARY KEY (stock_id),
  INDEX fk_stock_product_id_idx (product_id ASC),
  CONSTRAINT fk_stock_product_id
    FOREIGN KEY (product_id)
    REFERENCES product (product_id))
PASSWORD = '';


-- -----------------------------------------------------
-- Table sale_detail
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS sale_detail (
  sale_id INT(11) NOT NULL,
  stock_id INT(11) NOT NULL,
  quantity INT(11) NOT NULL,
  discount INT(2) NOT NULL,
  price_each DOUBLE(10,2) NOT NULL,
  INDEX fk_sale_detail_sale_detail_id_idx (sale_id ASC),
  INDEX fk_sale_detail_stock_id_idx (stock_id ASC),
  CONSTRAINT fk_sale_detail_sale_detail_id
    FOREIGN KEY (sale_id)
    REFERENCES sale (sale_id),
  CONSTRAINT fk_sale_detail_stock_id
    FOREIGN KEY (stock_id)
    REFERENCES stock (stock_id));


-- -----------------------------------------------------
-- Table purchase_detail
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS purchase_detail (
  purchase_id INT(11) NOT NULL,
  stock_id INT(11) NOT NULL,
  quantity INT(11) NOT NULL,
  discount INT(2) NOT NULL,
  price_each DOUBLE(10,2) NOT NULL,
  INDEX fk_purchase_detail_purchase_id_idx (purchase_id ASC),
  INDEX fk_purchase_detail_stock_id_idx (stock_id ASC),
  CONSTRAINT fk_purchase_detail_purchase_id
    FOREIGN KEY (purchase_id)
    REFERENCES purchase (purchase_id),
  CONSTRAINT fk_purchase_detail_stock_id
    FOREIGN KEY (stock_id)
    REFERENCES stock (stock_id));

