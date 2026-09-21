--Which customers generate the most revenue, and are our highest-value customers receiving reliable service?
SELECT
    customer_id,
    SUM(revenue) AS total_revenue,
    ROUND(
        100.0 * SUM(delivered_on_time)
        / NULLIF(COUNT(delivered_on_time), 0),
        2
    ) AS on_time_delivery_percentage
FROM reporting.fact_loads
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;
