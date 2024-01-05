# Group - YanYZhuZ
# Yichen Yan, Zichuan Zhu, 
# CS5200
# 4/15/2023

CREATE SCHEMA IF NOT EXISTS online_phone_sales_db;
USE online_phone_sales_db;


DROP TABLE IF EXISTS user;
CREATE TABLE user (
  user_id 		INT 			AUTO_INCREMENT,
  user_name		VARCHAR(50) 	NOT NULL,
  first_name 	VARCHAR(50) 	NOT NULL,
  last_name 	VARCHAR(50) 	NOT NULL,
  email 		VARCHAR(50) 	NOT NULL,
  password 		VARCHAR(50) 	NOT NULL,
  phone_no 		VARCHAR(20) 	NOT NULL,
  address 		VARCHAR(100) 	NOT NULL,
  zip_code 		VARCHAR(10) 	NOT NULL,
  CONSTRAINT pk_User_user_id PRIMARY KEY (user_id),
  CONSTRAINT uq_User_user_name UNIQUE(user_name),
  CONSTRAINT uq_User_email UNIQUE(email)
);


DROP TABLE IF EXISTS payment;
CREATE TABLE payment (
  card_no          BIGINT          PRIMARY KEY,
  card_type        VARCHAR(50)     NOT NULL,
  expiration_date  DATE            NOT NULL,
  CONSTRAINT chk_card_type CHECK (card_type IN ('Credit Card', 'Debit Card', 'Gift Card'))
);


DROP TABLE IF EXISTS company;
CREATE TABLE company (
  company_id 	INT 			AUTO_INCREMENT,
  company_name 	VARCHAR(50)		NOT NULL,
  website 		VARCHAR(100)	NOT NULL,
  address 		VARCHAR(100) 	NOT NULL,
  phone 		VARCHAR(20) 	NOT NULL,
  CONSTRAINT pk_Company_company_id PRIMARY KEY (company_id),
  CONSTRAINT uk_Company_phone UNIQUE (phone)
  -- CONSTRAINT chk_Company_website CHECK (website LIKE '%.com%')
);

DROP TABLE IF EXISTS feature;
CREATE TABLE feature (
  keyword 		VARCHAR(50) 	PRIMARY KEY,
  description 	TEXT 			NOT NULL,  	
  CONSTRAINT min_keyword_length CHECK (LENGTH(keyword) > 0),
  CONSTRAINT max_description_length CHECK (LENGTH(description) <= 1000)
);


DROP TABLE IF EXISTS phone_model;
CREATE TABLE phone_model (
  model_id 		INT 			AUTO_INCREMENT,
  model_name 	VARCHAR(50) 	NOT NULL,
  processor 	VARCHAR(50) 	NOT NULL,
  price 		DECIMAL(10,2) 	NOT NULL,
  screen_size 	FLOAT 			NOT NULL,
  memory_size 	INT 			NOT NULL,
  release_date 	DATE 			NOT NULL,
  battery_size 	FLOAT 			NOT NULL,
  storage 		INT 			NOT NULL,
  color 		VARCHAR(20) 	NOT NULL,
  company_id    INT 			NOT NULL,
  CONSTRAINT pk_phone_model_model_id PRIMARY KEY (model_id),
  CONSTRAINT chk_phone_model_price CHECK (price >= 0),
  CONSTRAINT chk_phone_model_screen_size CHECK (screen_size > 0),
  CONSTRAINT chk_phone_model_memory_size CHECK (memory_size > 0),
  CONSTRAINT chk_phone_model_battery_size CHECK (battery_size > 0),
  FOREIGN KEY fk_phone_model_company(company_id) REFERENCES company(company_id)
	ON UPDATE CASCADE
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS discount;
CREATE TABLE discount (
  discount_code 	VARCHAR(20) 	PRIMARY KEY,
  discount_rate 	DECIMAL(5,2) 	NOT NULL,
  start_date 		DATE 			NOT NULL,
  expiration_date 	DATE 			NOT NULL,
  CONSTRAINT chk_discount_rate CHECK (discount_rate >= 0 AND discount_rate <= 1),
  CONSTRAINT chk_expiration_date CHECK (expiration_date > start_date)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id 		INT 		AUTO_INCREMENT,
  order_date 	DATE 		NOT NULL,
  order_time 	TIME 		NOT NULL,
  user_name 	VARCHAR(50) NOT NULL,
  card_no 		BIGINT  	NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (user_name) REFERENCES user(user_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
  FOREIGN KEY (card_no) REFERENCES payment(card_no)
	ON UPDATE CASCADE
    ON DELETE CASCADE
);



DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
  user_name VARCHAR(50),
  model_id 	INT,
  quantity 	INT NOT NULL,
  PRIMARY KEY (user_name, model_id),
  FOREIGN KEY (user_name) REFERENCES user(user_name)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (model_id) REFERENCES phone_model(model_id)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
	CHECK (quantity >= 1)
);

DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (
  model_id INT PRIMARY KEY,
  quantity INT NOT NULL,
  FOREIGN KEY (model_id) REFERENCES phone_model(model_id)
	ON UPDATE CASCADE
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS order_model;
CREATE TABLE order_model (
  order_id INT,
  model_id INT,
  quantity INT NOT NULL,
  PRIMARY KEY (order_id, model_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (model_id) REFERENCES phone_model(model_id)
	ON UPDATE CASCADE
    ON DELETE RESTRICT
);


DROP TABLE IF EXISTS model_discount;
CREATE TABLE model_discount (
  model_id 		INT,
  discount_code VARCHAR(20),
  PRIMARY KEY (model_id, discount_code),
  FOREIGN KEY (model_id) REFERENCES phone_model(model_id)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (discount_code) REFERENCES discount(discount_code)
	ON UPDATE CASCADE
    ON DELETE CASCADE
  );

  
DROP TABLE IF EXISTS model_feature;
CREATE TABLE model_feature (
  model_id 	INT,
  keyword 	VARCHAR(50),
  PRIMARY KEY (model_id,keyword),
  FOREIGN KEY (model_id) REFERENCES phone_model(model_id)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (keyword) REFERENCES feature(keyword)
	ON UPDATE CASCADE
    ON DELETE CASCADE
);
  
DROP TABLE IF EXISTS user_discount;
CREATE TABLE user_discount (
  user_name 	VARCHAR(50)  NOT NULL,
  discount_code VARCHAR(20)  NOT NULL,
  PRIMARY KEY (user_name, discount_code),
  FOREIGN KEY (user_name) REFERENCES user(user_name)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (discount_code) REFERENCES discount(discount_code)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
  UNIQUE (discount_code)
);

DROP TABLE IF EXISTS user_payment;
CREATE TABLE user_payment (
  user_name        VARCHAR(50)     NOT NULL,
  card_no          BIGINT          NOT NULL,
  PRIMARY KEY (user_name, card_no),
  FOREIGN KEY fk_user_payment_user(user_name)
    REFERENCES User(user_name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY fk_user_payment_payment(card_no)
    REFERENCES payment(card_no)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);