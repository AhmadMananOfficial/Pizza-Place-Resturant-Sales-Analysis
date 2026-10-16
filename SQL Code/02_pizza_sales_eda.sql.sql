----------------------------------------------------------------------------------------------------
-- PROJECT: Pizza Restaurant Sales Data Analysis
-- DESCRIPTION: 
--   This script performs an end-to-end exploratory data analysis on a pizza restaurant's transactional 
--   database. The goal is to uncover business insights regarding overall sales performance, temporal 
--   buying patterns, product popularity, category/size preferences, and advanced concepts like 
--   market basket analysis (product pairing) and Pareto (80/20) revenue distribution.
--
-- KEY ANALYTICAL QUESTIONS ADDRESSED:
--   1. What are our core financial and operational KPIs (Revenue, Total Orders, Average Order Value)?
--   2. How do sales fluctuate across months, days of the week, and hours of the day?
--   3. Which individual pizzas and product categories drive the highest and lowest revenue/volume?
--   4. Which pizza sizes and category-size combinations are most favored by customers?
--   5. Which pizzas are frequently ordered together (market basket analysis)?
--   6. Does our revenue follow the Pareto Principle (80/20 rule)?
----------------------------------------------------------------------------------------------------

-- Set active database context[cite: 1]
USE pizza_sales;


----------------------------------------------------------------------------------------------------
-- SECTION 1: DATA MODELING & CORE VIEW CREATION
----------------------------------------------------------------------------------------------------

-- We build a centralized analytical VIEW joining all four tables to streamline subsequent queries,
-- ensuring consistent calculations for revenue and item details across the entire project.
CREATE VIEW pizza_sales_view AS
SELECT
    o.order_id,
    o.date AS order_date,
    o.time AS order_time,
    pt.name AS pizza_name,
    pt.category,
    p.size,
    p.price,
    od.quantity,
    (od.quantity * p.price) AS revenue
FROM order_details AS od
JOIN orders AS o
    ON od.order_id = o.order_id
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id;


----------------------------------------------------------------------------------------------------
-- SECTION 2: EXECUTIVE SUMMARY & CORE KPIs
----------------------------------------------------------------------------------------------------

-- High-level snapshot of total business performance, average order value, and basket size metrics.
SELECT
    ROUND(SUM(revenue), 0) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_pizzas_sold,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 1) AS average_order_value,
    ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 1) AS average_pizzas_per_order,
    ROUND(AVG(price), 1) AS average_pizza_price
FROM pizza_sales_view;


----------------------------------------------------------------------------------------------------
-- SECTION 3: TEMPORAL SALES TRENDS
----------------------------------------------------------------------------------------------------

-- Monthly Revenue Performance
SELECT
    MONTH(order_date) AS order_month,
    ROUND(SUM(revenue), 0) AS total_sales
FROM pizza_sales_view
GROUP BY MONTH(order_date)
ORDER BY order_month;

-- Day of the Week Analysis (Identifying peak operational days)
SELECT
    DAYOFWEEK(order_date) AS day_number,
    DAYNAME(order_date) AS day_name,
    ROUND(SUM(revenue), 0) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS pizzas_sold
FROM pizza_sales_view
GROUP BY DAYOFWEEK(order_date), DAYNAME(order_date)
ORDER BY day_number;

-- Hourly Order Distribution (Pinpointing rush hours for staffing optimization)
SELECT
    HOUR(order_time) AS order_hour,
    ROUND(SUM(revenue), 0) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS pizzas_sold
FROM pizza_sales_view
GROUP BY HOUR(order_time)
ORDER BY order_hour;


----------------------------------------------------------------------------------------------------
-- SECTION 4: PRODUCT PERFORMANCE ANALYSIS
----------------------------------------------------------------------------------------------------

-- Top 5 Best-Selling Pizzas by Revenue
SELECT
    pizza_name,
    ROUND(SUM(revenue), 0) AS total_sales,
    SUM(quantity) AS total_quantity
FROM pizza_sales_view
GROUP BY pizza_name
ORDER BY total_sales DESC
LIMIT 5;

-- Bottom 5 Lowest-Performing Pizzas by Revenue
SELECT
    pizza_name,
    ROUND(SUM(revenue), 0) AS total_sales,
    SUM(quantity) AS total_quantity
FROM pizza_sales_view
GROUP BY pizza_name
ORDER BY total_sales ASC
LIMIT 5;

-- Top 5 Pizzas by Total Quantity Sold
SELECT
    pizza_name,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(revenue), 0) AS total_sales
FROM pizza_sales_view
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

-- Bottom 5 Pizzas by Total Quantity Sold
SELECT
    pizza_name,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(revenue), 0) AS total_sales
FROM pizza_sales_view
GROUP BY pizza_name
ORDER BY total_quantity ASC
LIMIT 5;


----------------------------------------------------------------------------------------------------
-- SECTION 5: CATEGORY & SIZE PREFERENCES
----------------------------------------------------------------------------------------------------

-- Revenue and Volume Contribution by Pizza Category
SELECT
    category,
    SUM(quantity) AS quantity_sold,
    ROUND(SUM(revenue), 0) AS total_revenue,
    ROUND(100 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1) AS revenue_share_pct
FROM pizza_sales_view
GROUP BY category
ORDER BY total_revenue DESC;

-- Revenue and Volume Contribution by Pizza Size
SELECT
    size,
    SUM(quantity) AS quantity_sold,
    ROUND(100 * SUM(quantity) / SUM(SUM(quantity)) OVER (), 1) AS quantity_share_pct,
    ROUND(SUM(revenue), 0) AS total_revenue,
    ROUND(100 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1) AS revenue_share_pct
FROM pizza_sales_view
GROUP BY size
ORDER BY total_revenue DESC;

-- Granular Category and Size Combination Breakdown
SELECT
    category,
    size,
    SUM(quantity) AS quantity_sold,
    ROUND(100 * SUM(quantity) / SUM(SUM(quantity)) OVER (), 1) AS quantity_share_pct,
    ROUND(SUM(revenue), 0) AS total_revenue,
    ROUND(100 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1) AS revenue_share_pct
FROM pizza_sales_view
GROUP BY category, size
ORDER BY category, total_revenue DESC;


----------------------------------------------------------------------------------------------------
-- SECTION 6: ADVANCED ANALYTICS (BASKET ANALYSIS & PARETO)
----------------------------------------------------------------------------------------------------

-- Market Basket Analysis: Top Pizza Pairs Ordered Together[cite: 1]
-- Uses a self-join on order ID to find items purchased within the same transaction.
SELECT
    a.pizza_name AS pizza_item_1,
    b.pizza_name AS pizza_item_2,
    COUNT(DISTINCT a.order_id) AS times_ordered_together
FROM pizza_sales_view AS a
JOIN pizza_sales_view AS b
    ON a.order_id = b.order_id
    AND a.pizza_name < b.pizza_name
GROUP BY a.pizza_name, b.pizza_name
ORDER BY times_ordered_together DESC
LIMIT 10;

-- Enhanced Market Basket Analysis with Attachment Rate Percentage
-- Calculates the exact percentage of a given pizza's orders that also include a paired pizza.
WITH pizza_pairs AS (
    SELECT
        a.pizza_name AS pizza_item_1,
        b.pizza_name AS pizza_item_2,
        COUNT(DISTINCT a.order_id) AS times_ordered_together
    FROM pizza_sales_view AS a
    JOIN pizza_sales_view AS b
        ON a.order_id = b.order_id
        AND a.pizza_name < b.pizza_name
    GROUP BY a.pizza_name, b.pizza_name
),
pizza_total_orders AS (
    SELECT
        pizza_name,
        COUNT(DISTINCT order_id) AS total_orders
    FROM pizza_sales_view
    GROUP BY pizza_name
)
SELECT
    pp.pizza_item_1,
    pp.pizza_item_2,
    pp.times_ordered_together,
    pto.total_orders AS pizza_1_total_orders,
    ROUND(100.0 * pp.times_ordered_together / pto.total_orders, 2) AS pairing_rate_pct
FROM pizza_pairs AS pp
JOIN pizza_total_orders AS pto
    ON pp.pizza_item_1 = pto.pizza_name
ORDER BY pp.times_ordered_together DESC
LIMIT 10;

-- Pareto Analysis (80/20 Rule Verification)
-- Evaluates whether 20% of our menu items drive roughly 80% of total revenue.
WITH pizza_revenue_summary AS (
    SELECT
        pizza_name,
        SUM(revenue) AS total_revenue
    FROM pizza_sales_view
    GROUP BY pizza_name
)
SELECT
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    pizza_name,
    ROUND(total_revenue, 0) AS revenue,
    ROUND(100.0 * total_revenue / SUM(total_revenue) OVER (), 1) AS revenue_share_pct,
    ROUND(100.0 * SUM(total_revenue) OVER (
        ORDER BY total_revenue DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) / SUM(total_revenue) OVER (), 1) AS cumulative_revenue_pct
FROM pizza_revenue_summary;