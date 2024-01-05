USE online_phone_sales_db;

DROP PROCEDURE IF EXISTS add_new_account;
DELIMITER $$
CREATE PROCEDURE add_new_account (
    IN in_first_name VARCHAR(50),
    IN in_last_name VARCHAR(50),
    IN in_email VARCHAR(50),
    IN in_password VARCHAR(50),
    IN in_phone_no VARCHAR(20),
    IN in_address VARCHAR(100),
    IN in_zip_code VARCHAR(10),
    IN in_user_name VARCHAR(50)
)
BEGIN
    INSERT INTO User (first_name, last_name, email, password, phone_no, address, zip_code, user_name) 
    VALUES (in_first_name, in_last_name, in_email, in_password, in_phone_no, in_address, in_zip_code, in_user_name);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS edit_account_info;
DELIMITER $$
CREATE PROCEDURE edit_account_info (
    IN in_user_name VARCHAR(50),
    IN in_first_name VARCHAR(50),
    IN in_last_name VARCHAR(50),
    IN in_email VARCHAR(50),
    IN in_password VARCHAR(50),
    IN in_phone_no VARCHAR(20),
    IN in_address VARCHAR(100),
    IN in_zip_code VARCHAR(10)
)
BEGIN
    UPDATE User SET 
    first_name = in_first_name, 
    last_name = in_last_name, 
    email = in_email, 
    password = in_password, 
    phone_no = in_phone_no, 
    address = in_address, 
    zip_code = in_zip_code 
    WHERE user_name = in_user_name;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS display_user_payment;
DELIMITER $$
CREATE PROCEDURE display_user_payment (
    IN in_user_name VARCHAR(50)
)
BEGIN
    SELECT p.card_no, p.card_type, p.expiration_date 
    FROM user_payment up 
    JOIN payment p USING(card_no)
    WHERE up.user_name = in_user_name;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS add_new_payment;
DELIMITER $$
CREATE PROCEDURE add_new_payment(
    IN in_user_name VARCHAR(50),
    IN in_card_no BIGINT,
    IN in_card_type VARCHAR(50),
    IN in_expiration_date DATETIME
)
BEGIN
	INSERT INTO payment (user_name, card_no, card_type, expiration_date) 
    VALUES ( in_card_no, in_card_type, in_expiration_date);
    INSERT INTO user_payment (user_name, card_no) 
    VALUES (in_user_name, in_card_no);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS display_all_models;
DELIMITER $$
CREATE PROCEDURE display_all_models ()
BEGIN
    SELECT pm.*, c.company_name
    FROM phone_model pm
    JOIN company c ON pm.company_id = c.company_id;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS display_by_brand;
DELIMITER $$
CREATE PROCEDURE display_by_brand (
    IN in_company_name VARCHAR(50)
)
BEGIN
    SELECT * 
    FROM phone_model pm 
    JOIN company c 
    ON pm.company_id = c.company_id 
    WHERE c.company_name Like concat("%", in_company_name, "%");
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS display_by_color;
DELIMITER $$
CREATE PROCEDURE display_by_color (
    IN in_color VARCHAR(20)
)
BEGIN
    SELECT * 
    FROM phone_model pm
    WHERE pm.color Like concat("%", in_coolor, "%");
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS display_by_price;
DELIMITER $$
CREATE PROCEDURE display_by_price (
    IN min_price DECIMAL(10,2),
    IN max_price DECIMAL(10,2)
)
BEGIN
    SELECT * 
    FROM phone_model 
    WHERE price BETWEEN min_price AND max_price;
END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS user_add_cart_item;
DELIMITER $$
CREATE PROCEDURE user_add_cart_item(
    IN in_user_name VARCHAR(50), 
    IN in_model_id INT, 
    IN in_quantity INT)
BEGIN
  DECLARE current_stock INT;

  SELECT quantity INTO current_stock
  FROM inventory
  WHERE model_id = in_model_id;

  IF current_stock >= in_quantity THEN
    UPDATE inventory
    SET quantity = quantity - in_quantity
    WHERE model_id = in_model_id;

    INSERT INTO cart (user_name, model_id, quantity) 
    VALUES (in_user_name, in_model_id, in_quantity) 
    ON DUPLICATE KEY UPDATE quantity = quantity + in_quantity;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Insufficient stock for the requested quantity.';
  END IF;
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS get_model_inventory;
DELIMITER $$
CREATE PROCEDURE get_model_inventory(
	IN in_model_id INT)
BEGIN
  SELECT quantity 
  FROM inventory 
  WHERE model_id = in_model_id;
END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS display_user_cart;
DELIMITER $$
CREATE PROCEDURE display_user_cart(IN in_user_name VARCHAR(50))
BEGIN
  SELECT pm.model_id, 
		pm.model_name, 
		pm.price, 
        c.quantity 
  FROM phone_model pm 
  JOIN cart c 
	ON pm.model_id = c.model_id 
  WHERE c.user_name = in_user_name;
END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS user_edit_cart_item;
DELIMITER $$
CREATE PROCEDURE user_edit_cart_item(
    IN in_user_name VARCHAR(50), 
    IN in_model_id INT, 
    IN in_new_quantity INT)
BEGIN
  DECLARE current_cart_quantity INT;
  DECLARE current_stock INT;
  DECLARE diff_quantity INT;

  SELECT quantity INTO current_cart_quantity
  FROM cart
  WHERE user_name = in_user_name AND model_id = in_model_id;

  SELECT quantity INTO current_stock
  FROM inventory
  WHERE model_id = in_model_id;

  SET diff_quantity = in_new_quantity - current_cart_quantity;

  IF diff_quantity <= current_stock THEN
    UPDATE inventory
    SET quantity = quantity - diff_quantity
    WHERE model_id = in_model_id;

    UPDATE cart SET quantity = in_new_quantity 
    WHERE user_name = in_user_name AND model_id = in_model_id;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Insufficient stock for the requested quantity.';
  END IF;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS user_delete_cart_item;
DELIMITER $$
CREATE PROCEDURE user_delete_cart_item (
    IN in_user_name VARCHAR(50), 
    IN in_model_id INT)
BEGIN
  DECLARE current_cart_quantity INT;

  SELECT quantity INTO current_cart_quantity
  FROM cart
  WHERE user_name = in_user_name AND model_id = in_model_id;

  UPDATE inventory
  SET quantity = quantity + current_cart_quantity
  WHERE model_id = in_model_id;

  DELETE FROM cart 
  WHERE user_name = in_user_name AND model_id = in_model_id;
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS create_order;
DELIMITER $$
CREATE PROCEDURE create_order (
	IN in_user_name VARCHAR(50), 
	IN in_card_no BIGINT
)
BEGIN
    DECLARE v_order_id INT;
    SET v_order_id = 0;
    
    START TRANSACTION;
    
    INSERT INTO orders (order_date, order_time, user_name, card_no)
    VALUES (CURDATE(), CURTIME(), in_user_name, in_card_no);
    
    SET v_order_id = LAST_INSERT_ID();
    
    INSERT INTO order_model (order_id, model_id, quantity)
    SELECT v_order_id, model_id, quantity 
    FROM cart 
    WHERE user_name = in_user_name;
    
    DELETE FROM cart WHERE user_name = in_user_name;
    
    COMMIT;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS show_order_detail;
DELIMITER $$
CREATE PROCEDURE show_order_detail(IN in_order_id INT)
BEGIN
  SELECT 
    m.model_id,
	m.model_name, 
    m.processor, 
    m.price, 
    m.screen_size, 
    m.memory_size, 
    m.release_date, 
    m.battery_size, 
    m.storage, 
    m.color, 
    om.quantity
  FROM phone_model m
  JOIN order_model om 
	ON m.model_id = om.model_id
  WHERE om.order_id = in_order_id;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS authentication;
DELIMITER $$
CREATE PROCEDURE authentication(
    IN in_user_name VARCHAR(50),
    IN in_password VARCHAR(50)
)
BEGIN
    SELECT first_name
    FROM User 
    WHERE user_name = in_user_name AND password = in_password;
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS show_item_detail;
DELIMITER $$
CREATE PROCEDURE show_item_detail(IN p_model_id INT)
BEGIN
  SELECT 
    pm.model_id,
    pm.model_name,
    pm.processor,
    pm.price,
    pm.screen_size,
    pm.memory_size,
    pm.release_date,
    pm.battery_size,
    pm.storage,
    pm.color,
    c.company_name,
    c.website,
    c.address,
    c.phone,
    d.discount_code,
    d.discount_rate,
    d.start_date,
	d.expiration_date,
    f.keyword,
    f.description
  FROM 
    phone_model pm
	JOIN company c ON pm.company_id = c.company_id
	LEFT JOIN Model_feature mf 
		ON pm.model_id = mf.model_id
	LEFT JOIN feature f 
		ON mf.keyword = f.keyword
	LEFT JOIN model_discount md 
		ON pm.model_id = md.model_id
	LEFT JOIN discount d 
		ON md.discount_code = d.discount_code
	WHERE pm.model_id = p_model_id;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS show_user_order_history;
DELIMITER $$
CREATE PROCEDURE show_user_order_history(IN in_user_name VARCHAR(50))
BEGIN
	SELECT *
	FROM orders o
	WHERE o.user_name = in_user_name
	ORDER BY o.order_date DESC, o.order_time DESC;
END $$

DELIMITER ;



