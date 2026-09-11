--Which trucks generate the most revenue per month, and how many miles do they run compared with the fleet average?
WITH monthly_truck_performance AS (
    SELECT
        truck_id,
        month,
        total_revenue,
        total_miles,
        utilization_rate
    FROM clean.truck_utilization_metrics
    WHERE truck_id IS NOT NULL
)

SELECT
    truck_id,
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_miles, 2) AS total_miles,
    ROUND(utilization_rate * 100, 2) AS utilization_percentage,

    ROUND(
        AVG(total_miles) OVER (PARTITION BY month),
        2
    ) AS fleet_avg_miles,

    ROUND(
        total_miles
        - AVG(total_miles) OVER (PARTITION BY month),
        2
    ) AS miles_vs_fleet_avg,

    RANK() OVER (
        PARTITION BY month
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM monthly_truck_performance
ORDER BY month, revenue_rank;