USE online_phone_sales_db;


INSERT INTO user (user_id, user_name, first_name, last_name, email, password, phone_no, address, zip_code)
VALUES
(1, 'Yutian','John', 'Doe', 'johndoe@example.com', 'password123', '555-555-1234', '123 Main St', '12345'),
(2, 'jack01','Jane', 'Smith', 'janesmith@example.com', 'password456', '555-555-5678', '456 Elm St', '67890'),
(3, 'bobbb','Bob', 'Johnson', 'bobjohnson@example.com', 'password789', '555-555-2468', '789 Oak St', '13579'),
(4, 'either00','Alice', 'Williams', 'alicewilliams@example.com', 'passwordabc', '555-555-3691', '246 Pine St', '46802'),
(5, 'cj345', 'Chris', 'Jones', 'chrisjones@example.com', 'passworddef', '555-555-1357', '369 Cedar St', '80246');


Insert INTO payment (card_no, card_type, expiration_date)
VALUES
(12345678901, 'Credit Card', '2025-01-01'),
(23456789012,  'Gift Card', '2024-06-01'),
(34567890123,  'Debit Card', '2026-09-01'),
(45678901234,  'Debit Card', '2023-11-01'),
(56789012345,  'Credit Card', '2027-03-01'),
(67890123456,  'Debit Card', '2023-12-01'),
(78901234567,  'Gift Card', '2024-12-01');


INSERT INTO company (company_id, company_name, website, address, phone)
VALUES
(1, 'Apple', 'www.apple.com', '1 Apple Park Way, Cupertino, CA', '1-800-MY-APPLE'),
(2, 'Samsung', 'www.samsung.com', '129 Samsung-ro, Yeongtong-gu, Suwon-si, Gyeonggi-do', '+82-31-200-2111'),
(3, 'Google', 'www.google.com', '1600 Amphitheatre Parkway, Mountain View, CA', '1-650-253-0000'),
(4, 'LG', 'www.lg.com', '222 LG-ro, Jinwi-myeon, Pyeongtaek-si, Gyeonggi-do', '+82-2-3777-1114'),
(5, 'Sony', 'www.sony.com', '1-7-1 Konan, Minato-ku, Tokyo', '+81-3-6748-2111');

INSERT INTO feature (keyword, description)
VALUES
('5G', 'Supports 5G network connectivity'),
('Dual_Camera', 'Has two rear-facing cameras'),
('Wireless_Charging', 'Supports wireless charging'),
('Water_Resistant', 'Resistant to water damage'),
('Fingerprint_Sensor', 'Has a built-in fingerprint sensor');

INSERT INTO phone_model (model_id, model_name, processor, price, screen_size, memory_size, release_date, battery_size, storage, color, company_id)
VALUES
(1, 'iPhone 13 Pro', 'A15 Bionic chip', 999.00, 6.1, 128, '2021-09-24', 3085, 128, 'Sierra Blue', 1),
(2, 'Galaxy S21', 'Exynos 2100', 799.99, 6.2, 128, '2021-01-29', 4000, 128, 'Phantom Gray', 2),
(3, 'Pixel 6', 'Google Tensor', 699.00, 6.4, 128, '2021-10-28', 4614, 128, 'Stormy Black', 3),
(4, 'V60 ThinQ', 'Snapdragon 865', 899.99, 6.8, 128, '2020-03-20', 5000, 256, 'Classy Blue', 4),
(5, 'Xperia 5 III', 'Snapdragon 888', 949.99, 6.1, 128, '2021-08-30', 4500, 256, 'Black', 5);

INSERT INTO discount (discount_code, discount_rate, start_date, expiration_date)
VALUES
('DISCOUNT10', 0.10, '2023-01-01', '2023-12-31'),
('DISCOUNT20', 0.20, '2024-01-01', '2024-12-31'),
('DISCOUNT30', 0.30, '2025-01-01', '2025-12-31'),
('DISCOUNT40', 0.40, '2026-01-01', '2026-12-31'),
('DISCOUNT50', 0.50, '2027-01-01', '2027-12-31');

INSERT INTO orders (order_id, order_date, order_time, user_name, card_no)
VALUES 
(1, '2023-04-17', '10:00:00', 'Yutian', 12345678901),
(2, '2023-04-16', '15:30:00', 'jack01', 23456789012),
(3, '2023-04-15', '11:45:00', 'bobbb', 34567890123),
(4, '2023-04-14', '12:15:00', 'either00', 45678901234),
(5, '2023-04-13', '09:00:00', 'cj345', 56789012345);


INSERT INTO cart (user_name, model_id, quantity)
VALUES
('Yutian', 1, 10),
('Yutian', 2, 4),
('jack01', 3, 2),
('bobbb', 4, 8),
('either00', 5, 1);

INSERT INTO inventory (model_id, quantity)
VALUES
(1, 100),
(2, 75),
(3, 50),
(4, 25),
(5, 10);

INSERT INTO order_model (order_id, model_id, quantity)
VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 3),
(4, 5, 2);

INSERT INTO model_discount (model_id, discount_code)
VALUES
(1, 'DISCOUNT10'),
(2, 'DISCOUNT20'),
(3, 'DISCOUNT30'),
(4, 'DISCOUNT40'),
(5, 'DISCOUNT50');

INSERT INTO model_feature (model_id, keyword)
VALUES
(1, '5G'),
(1, 'Dual_Camera'),
(1, 'Wireless_Charging'),
(2, '5G'),
(2, 'Dual_Camera'),
(2, 'Water_Resistant'),
(3, '5G'),
(3, 'Dual_Camera'),
(3, 'Wireless_Charging'),
(3, 'Water_Resistant'),
(4, 'Dual_Camera'),
(4, 'Wireless_Charging'),
(4, 'Water_Resistant'),
(5, 'Water_Resistant');

INSERT INTO user_discount (user_name, discount_code)
VALUES
('Yutian', 'DISCOUNT10'),
('bobbb', 'DISCOUNT20'),
('bobbb', 'DISCOUNT30'),
('either00', 'DISCOUNT40'),
('cj345', 'DISCOUNT50');


INSERT INTO user_payment (user_name, card_no)
VALUES
('Yutian', 12345678901),
('jack01', 23456789012),
('bobbb', 34567890123),
('bobbb', '45678901234'),
('either00', '56789012345'),
('cj345', '67890123456'),
('cj345', '78901234567');

