# 🍕 Pizza Place Sales Analysis | SQL & Excel Dashboard <img width="260" height="222" alt="Screenshot_2026-08-29_113110_upscaled" src="https://github.com/user-attachments/assets/e960cba5-b10e-433c-96d1-c0d91acee5a1" />

## Background

Pizza Place is a fictional pizza restaurant with one year of sales data covering orders, pizza types, sizes, prices, and quantities.

The goal of this project was to understand how the business was performing, what was driving revenue, when customers were ordering the most, and which products were contributing the most to sales.

I used **MySQL** to explore and analyze the data and **Excel** to build the dashboard and present the findings.

<img width="669" height="500" alt="Screenshot 2026-08-29 160719" src="https://github.com/user-attachments/assets/d2e95672-a3ed-427f-b981-bb0a9a244b24" />

---

## Executive Summary

* Pizza Place generated **$817.9K in revenue from 21,350 orders**, with customers buying an average of **2.3 pizzas per order**. 
* Large pizzas were the biggest contributor to revenue, accounting for **45.9% of sales**, even though they made up only 38.2% of pizzas sold.
* Demand was strongest on **Friday ($136.1K)**, with the busiest periods occurring around **12–1 PM and 5–7 PM**. 
* At the product level, **Thai Chicken generated the most revenue ($43.4K)**, while **Classic Deluxe sold the most pizzas (2,453)**.

<img width="1359" height="692" alt="Screenshot 2026-08-28 131032" src="https://github.com/user-attachments/assets/39d3583c-e534-49b1-a9b8-df18d99efe35" />

---

# Insights Deep Dive

## 1. Large Pizzas Bring in More Revenue

Large pizzas stand out when looking at the sales by size.

| Size     | Pizzas Sold | Share of Pizzas | Revenue | Share of Revenue |
| -------- | ----------: | --------------: | ------: | ---------------: |
| Large    |      18,956 |           38.2% | $375.3K |        **45.9%** |
| Medium   |      15,635 |           31.5% | $249.4K |            30.5% |
| Small    |      14,403 |           29.1% | $178.1K |            21.8% |
| X Large  |         552 |            1.1% |  $14.1K |             1.7% |
| XX Large |          28 |            0.1% |   $1.0K |             0.1% |

Large pizzas account for **38.2% of the total pizzas sold but 45.9% of revenue**. So while customers don't buy them in a majority of orders, they contribute considerably more to sales.

Looking at category and size together makes this even clearer. The three biggest combinations by revenue are:

* Veggie Large —> **$104.2K**
* Chicken Large —> **$102.3K**
* Supreme Large —> **$94.3K**

These three combinations alone account for about **36.8% of total revenue**.

This makes Large pizzas an important area to focus on when thinking about promotions and inventory.

---

## 2. Friday Is the Busiest Day

Sales vary quite a bit depending on the day of the week.

| Day        |     Revenue |    Orders | Pizzas Sold |
| ---------- | ----------: | --------: | ----------: |
| Sunday     |      $99.2K |     2,624 |       6,035 |
| Monday     |     $107.3K |     2,794 |       6,485 |
| Tuesday    |     $114.1K |     2,973 |       6,895 |
| Wednesday  |     $114.4K |     3,024 |       6,946 |
| Thursday   |     $123.5K |     3,239 |       7,478 |
| **Friday** | **$136.1K** | **3,538** |   **8,242** |
| Saturday   |     $123.2K |     3,158 |       7,493 |

Friday is clearly the strongest day, generating **$136.1K in revenue**, while Sunday is the weakest at $99.2K.

That is a difference of almost **$37K in a single day**.

From an operational point of view, Friday deserves more attention than the other days. It is the day when the restaurant has the most orders and sells the most pizzas, so staffing and ingredient preparation need to be ready for that extra demand.

---

## 3. Most Orders Come Around Lunch and Early Evening

The hourly data shows two noticeable peaks.

The highest revenue hours are:

* **12 PM — $111.9K**
* **1 PM — $106.1K**
* **6 PM — $89.3K**
* **5 PM — $86.2K**

So the busiest periods are roughly:

**Lunch:** 12–1 PM
**Dinner:** 5–7 PM

The restaurant is much quieter outside these periods, especially late at night.

This pattern is useful from an operational perspective. Instead of treating every hour equally, the restaurant can plan staffing and preparation around these predictable peaks.

---

## 4. The Four Categories Are Fairly Balanced

There is no single category that dominates the business.

| Category | Pizzas Sold | Revenue | Revenue Share |
| -------- | ----------: | ------: | ------------: |
| Classic  |      14,888 | $220.1K |       **27%** |
| Supreme  |      11,987 | $208.2K |           25% |
| Chicken  |      11,050 | $195.9K |           24% |
| Veggie   |      11,649 | $193.7K |           24% |

Classic is the largest category, but the difference is fairly small. The other three categories each contribute around a quarter of total revenue.

So I wouldn't recommend focusing the business around one category. The more interesting differences appear when we look at **individual pizzas and sizes** rather than categories alone.

---

## 5. The Pizza That Sells the Most Isn't the One That Makes the Most Money

This was one of the more interesting results from the analysis.

### Top 5 by Revenue

| Rank | Pizza                    |    Revenue |
| ---: | ------------------------ | ---------: |
|    1 | Thai Chicken Pizza       | **$43.4K** |
|    2 | Barbecue Chicken Pizza   |     $42.8K |
|    3 | California Chicken Pizza |     $41.4K |
|    4 | Classic Deluxe Pizza     |     $38.2K |
|    5 | Spicy Italian Pizza      |     $34.8K |

### Top 5 by Quantity

| Rank | Pizza                  | Pizzas Sold |
| ---: | ---------------------- | ----------: |
|    1 | Classic Deluxe Pizza   |   **2,453** |
|    2 | Barbecue Chicken Pizza |       2,432 |
|    3 | Hawaiian Pizza         |       2,422 |
|    4 | Pepperoni Pizza        |       2,418 |
|    5 | Thai Chicken Pizza     |       2,371 |

Classic Deluxe is the **volume leader**, but Thai Chicken is the **revenue leader**.

That difference is worth paying attention to. Looking only at units sold would make Classic Deluxe look like the most important pizza, but revenue tells a slightly different story.

For product decisions, I would look at both measures rather than using one to rank the menu.

---

## 6. Revenue Isn't Dependent on Just a Few Pizzas

I also ran a Pareto analysis to see how concentrated the revenue was.

The result was different from the typical 80/20 pattern.

| Pizza Group | Cumulative Revenue |
| ----------- | -----------------: |
| Top 5       |              24.5% |
| Top 10      |              44.5% |
| Top 20      |              76.1% |
| Top 22      |          **81.2%** |

It takes **22 of the 32 pizza types** to reach roughly 80% of revenue.

So the restaurant isn't relying on just a handful of pizzas. Revenue is spread across a fairly large part of the menu.

The top products are still important, but I wouldn't recommend removing or ignoring the rest of the menu based only on revenue ranking.

---

## 7. Customers Often Order Multiple Pizzas Together

The average order contains **2.3 pizzas**, so it makes sense to look at which pizzas tend to appear together.

Some of the most common combinations were:

| Pizza Pair                     | Orders Together |
| ------------------------------ | --------------: |
| Hawaiian + Thai Chicken        |             270 |
| Barbecue Chicken + Pepperoni   |             269 |
| Hawaiian + Pepperoni           |             259 |
| Pepperoni + Thai Chicken       |             257 |
| California Chicken + Pepperoni |             256 |

These combinations could be useful starting points for testing bundles or cross-selling offers.

I would treat this as an opportunity to test rather than a conclusion by itself. A pair appearing frequently doesn't necessarily mean customers strongly prefer the combination, it could simply be because both pizzas are popular individually.

---

# Recommendations

## 1. Focus Promotions on Large Pizzas

Large pizzas already account for **45.9% of revenue**, and the strongest Large combinations are Veggie, Chicken, and Supreme.

These products would be good candidates for promotions, featured menu positions, or bundle offers.

## 2. Plan Operations Around Friday and Peak Hours

Friday is the busiest day, while **12–1 PM and 5–7 PM** are the strongest hourly periods.

Staffing, ingredient preparation, and kitchen capacity should be planned around these periods so the restaurant can handle the additional demand without putting unnecessary resources into slower hours.

## 3. Test Bundles Using Existing Ordering Patterns

Customers already buy an average of **2.3 pizzas per order**, so there is a natural opportunity to test pizza bundles.

The frequently ordered combinations can be used as a starting point, but the success of these offers should be measured through changes in **AOV, pizzas per order, and total revenue** rather than just the number of bundles sold.

---

# Final Words

The main takeaway from this analysis is that Pizza Place doesn't have one simple sales driver.

Revenue is influenced by **what customers buy, what size they choose, and when they place their orders**. Large pizzas generate a disproportionately high share of revenue, Friday is the busiest day, and demand is concentrated around lunch and early evening.

At the same time, revenue is spread across a large part of the menu, so the business isn't dependent on only a few products.

Overall, the data points toward a fairly simple direction: **protect the products and periods that already perform well, and use customer ordering behavior to test ways of increasing the value of each order.**

---

## Tools Used

**MySQL**

* Data exploration
* Data cleaning and validation
* Table joins
* Aggregations
* Time-based analysis
* Product and category analysis
* Pareto analysis
* Order combination analysis

**Excel**

* Data visualization
* Dashboard development
* KPI reporting
* Business reporting
