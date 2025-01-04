-- SQLite

-- Query 1: Peak season of ecommerce
SELECT 
    strftime('%Y-%m', order_date) AS month_year,
    COUNT(order_id) AS total_orders
FROM 
    Order_Fact
GROUP BY 
    month_year
ORDER BY 
    total_orders DESC
LIMIT 1;


-- Query 2: Time users are most likely to make an order
SELECT 
    strftime('%H', order_date) AS hour_of_day,
    COUNT(order_id) AS total_orders
FROM 
    Order_Fact
GROUP BY 
    hour_of_day
ORDER BY 
    total_orders DESC
LIMIT 1;

-- Query 3: Preferred way to pay in the ecommerce
SELECT 
    payment_type,
    COUNT(payment_id) AS total_payments
FROM 
    Payments_Dimension
GROUP BY 
    payment_type
ORDER BY 
    total_payments DESC
LIMIT 1;


-- Query 4: Number of installments usually done
SELECT 
    payment_installments,
    COUNT(payment_id) AS total
FROM 
    Payments_Dimension
GROUP BY 
    payment_installments
ORDER BY 
    total DESC
LIMIT 1;


-- Query 5: Average spending time for users
SELECT 
    AVG(julianday(order_approved_date) - julianday(order_date)) AS avg_spending_time
FROM 
    Order_Fact;


-- Query 6: Frequency of purchase in each state
SELECT 
    customer_state,
    COUNT(order_id) AS total_orders
FROM 
    Order_Fact
JOIN 
    User_Dimension ON Order_Fact.customer_zip_code = User_Dimension.customer_zip_code
GROUP BY 
    customer_state
ORDER BY 
    total_orders DESC;

-- Query 7: Logistic routes with heavy traffic
SELECT sd.seller_state, ud.customer_state, COUNT(oif.order_id) AS total_orders
FROM Order_Item_Fact oif
JOIN Seller_Dimension sd ON oif.seller_id = sd.seller_id
JOIN Order_Fact of ON oif.order_id = of.order_id
JOIN User_Dimension ud ON of.customer_zip_code = ud.customer_zip_code
GROUP BY sd.seller_state, ud.customer_state
ORDER BY total_orders DESC
LIMIT 1;


-- Query 8: Late delivered orders and customer satisfaction
SELECT 
    COUNT(of.order_id) AS late_orders,
    AVG(fd.feedback_score) AS avg_feedback_late
FROM Order_Fact of
JOIN Feedbacks_Dimension fd ON of.feedback_id = fd.feedback_id
WHERE delivered_date > estimated_time_delivery;

-- Query 9: Delivery delays by state
SELECT 
    customer_state,
    AVG(julianday(delivered_date) - julianday(estimated_time_delivery)) AS avg_estimate_diff
FROM 
    Order_Fact
JOIN 
    User_Dimension ON Order_Fact.customer_zip_code = User_Dimension.customer_zip_code
GROUP BY 
    customer_state
ORDER BY 
    avg_estimate_diff DESC;

-- Query 10: Difference between estimated and actual delivery times
SELECT 
    ud.customer_state,
    AVG(julianday(delivered_date) - julianday(estimated_time_delivery)) AS avg_estimated_vs_actual
FROM Order_Fact of
JOIN User_Dimension ud ON of.customer_zip_code = ud.customer_zip_code
GROUP BY ud.customer_state
ORDER BY avg_estimated_vs_actual DESC;

