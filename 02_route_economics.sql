--Which routes generate the highest revenue per mile after fuel costs, and which routes have weak economics?
WITH route_info AS (
    SELECT
        r.route_id,
        r.origin_city,
        r.destination_city,
        SUM(l.revenue) AS total_revenue,
        SUM(t.actual_distance_miles) AS total_miles,
        SUM(t.total_fuel_cost) AS total_fuel_cost
    FROM reporting.fact_trips t
    JOIN reporting.fact_loads l
        ON t.load_id = l.load_id
    JOIN reporting.dim_route r
        ON l.route_id = r.route_id
    GROUP BY
        r.route_id,
        r.origin_city,
        r.destination_city
)

SELECT
    route_id,
    origin_city,
    destination_city,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_miles, 2) AS total_miles,
    ROUND(total_fuel_cost, 2) AS total_fuel_cost,

    ROUND(
        total_revenue / NULLIF(total_miles, 0),
        2
    ) AS revenue_per_mile,

    ROUND(
        total_fuel_cost / NULLIF(total_miles, 0),
        2
    ) AS fuel_cost_per_mile,

    ROUND(
        (total_revenue - total_fuel_cost)
        / NULLIF(total_miles, 0),
        2
    ) AS profit_proxy_per_mile

FROM route_info
ORDER BY profit_proxy_per_mile DESC;

