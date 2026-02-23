SELECT*FROM customer; 

-- Q1.What is the total revenue gemerated by male vs. female customers!

select gender,sum(purchase_amount) as revenue 
from customer
group by gender; 

-- Q2.which customer used a discount but still spent more than the avg purchase amount!
 
 select customer_id, purchase_amount
 from customer
 where discount_applied = 'Yes' AND purchase_amount >= (select AVG(purchase_amount) from customer);
 
 -- Q3.which are the top 5 products with the highest avg rating!
 
 SELECT item_purchased,ROUND(AVG(review_rating),2) AS "Average product rating"
 from customer
 group by item_purchased
 order by AVG(review_rating) desc
 limit 5;
 
 -- Q4.compare the avg purchase_amount b/w Standard and Express shipping!
 
 select shipping_type,AVG(purchase_amount) FROM customer
 WHERE shipping_type in ('Standard','Express')
 group by shipping_type;
 
 -- Q5.Do subscribed customers spend more! compare avg spend and total revenue b/w subsribers and non subscribers!
 
 SELECT subscription_status,COUNT(customer_id) AS  total_customers,
 round(AVG(purchase_amount),2) AS avg_spend,
 round(SUM(purchase_amount),2) AS total_revenue
 FROM customer
 group by subscription_status
 order by total_revenue,avg_spend desc;
 
 -- Q6.which 5 products have the highest percentage of purchases with discount applied!
 
  select item_purchased,
 ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) * 100,2) AS discount_rate
 FROM customer
 GROUP BY  item_purchased
 ORDER BY discount_rate DESC
 LIMIT 5;
 
 -- Q7.segment customers into new ,returning,and loyal based on their total number of previous purchases,and hsow the count of each segment!
 
 WITH customer_type AS(
 SELECT customer_id,previous_purchases,
 CASE
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases between 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM customer
)
SELECT customer_segment,COUNT(*) AS "Number of Customers"
FROM customer_type
group by customer_segment;    

-- Q8.what are the top 3 most purchased products within each category!

WITH item_counts AS (
SELECT category,item_purchased,COUNT(customer_id) AS total_orders,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM customer
GROUP BY category,item_purchased
)
SELECT item_rank,category,item_purchased,total_orders
FROM item_counts
WHERE item_rank <=3;

-- Q9.Are customers who are repeat buyers(more than 5 previous purchases) also likely to subsribe!

SELECT subscription_status,
COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
group by  subscription_status;

-- Q10.what is the revenue contribution of each age group!

SELECT age_group,SUM(purchase_amount) AS revenue_contribution
FROM customer
group by age_group;