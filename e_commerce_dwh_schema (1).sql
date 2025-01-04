CREATE TABLE `User_Dimension` (
  `customer_zip_code` VARCHAR PRIMARY KEY,
  `user_name` VARCHAR,
  `customer_city` VARCHAR,
  `customer_state` VARCHAR
);

CREATE TABLE `Product_Dimension` (
  `product_id` INT PRIMARY KEY,
  `product_category` VARCHAR,
  `product_name_lenght` INT,
  `product_description_lenght` INT,
  `product_photos_qty` INT,
  `product_weight_g` FLOAT,
  `product_length_cm` FLOAT,
  `product_height_cm` FLOAT,
  `product_width_cm` FLOAT
);

CREATE TABLE `Seller_Dimension` (
  `seller_id` INT PRIMARY KEY,
  `seller_zip_code` VARCHAR,
  `seller_city` VARCHAR,
  `seller_state` VARCHAR
);

CREATE TABLE `Payments_Dimension` (
  `payment_id` INT PRIMARY KEY,
  `order_id` INT,
  `payment_type` VARCHAR,
  `payment_installments` INT,
  `payment_value` FLOAT
);

CREATE TABLE `Feedbacks_Dimension` (
  `feedback_id` INT PRIMARY KEY,
  `order_id` INT,
  `feedback_score` INT,
  `feedback_form_sent_date` DATE,
  `feedback_answer_date` DATE
);

CREATE TABLE `Order_Fact` (
  `order_id` INT PRIMARY KEY,
  `customer_zip_code` VARCHAR,
  `order_status` VARCHAR,
  `order_date` DATE,
  `order_approved_date` DATE,
  `pickup_date` DATE,
  `delivered_date` DATE,
  `estimated_time_delivery` DATE,
  `payment_id` INT,
  `feedback_id` INT,
  `total_order_price` FLOAT
);

CREATE TABLE `Order_Item_Fact` (
  `order_item_id` INT PRIMARY KEY,
  `order_id` INT,
  `product_id` INT,
  `seller_id` INT,
  `pickup_limit_date` DATE,
  `price` FLOAT,
  `shipping_cost` FLOAT
);

ALTER TABLE `Payments_Dimension` ADD FOREIGN KEY (`order_id`) REFERENCES `Order_Fact` (`order_id`);

ALTER TABLE `Feedbacks_Dimension` ADD FOREIGN KEY (`order_id`) REFERENCES `Order_Fact` (`order_id`);

ALTER TABLE `Order_Fact` ADD FOREIGN KEY (`customer_zip_code`) REFERENCES `User_Dimension` (`customer_zip_code`);

ALTER TABLE `Order_Fact` ADD FOREIGN KEY (`payment_id`) REFERENCES `Payments_Dimension` (`payment_id`);

ALTER TABLE `Order_Fact` ADD FOREIGN KEY (`feedback_id`) REFERENCES `Feedbacks_Dimension` (`feedback_id`);

ALTER TABLE `Order_Item_Fact` ADD FOREIGN KEY (`order_id`) REFERENCES `Order_Fact` (`order_id`);

ALTER TABLE `Order_Item_Fact` ADD FOREIGN KEY (`product_id`) REFERENCES `Product_Dimension` (`product_id`);

ALTER TABLE `Order_Item_Fact` ADD FOREIGN KEY (`seller_id`) REFERENCES `Seller_Dimension` (`seller_id`);
