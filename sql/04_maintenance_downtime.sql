--Which trucks have the highest maintenance cost per mile, and how does downtime affect their revenue contribution?
WITH truck_performance AS (
    SELECT
        t.truck_id,
        COUNT(DISTINCT t.trip_id) AS total_trips,
        SUM(t.actual_distance_miles) AS total_miles,
        SUM(t.actual_duration_hours) AS total_driving_hours,
        SUM(l.revenue) AS total_revenue
    FROM clean.trips t
    JOIN clean.loads l
        ON t.load_id = l.load_id
    WHERE t.truck_id IS NOT NULL
      AND t.trip_status = 'Completed'
    GROUP BY t.truck_id
),

truck_maintenance AS (
    SELECT
        truck_id,
        COUNT(*) AS maintenance_events,
        SUM(total_cost) AS total_maintenance_cost,
        SUM(downtime_hours) AS total_downtime_hours
    FROM clean.maintenance_records
    GROUP BY truck_id
)

SELECT
    t.truck_id,
    t.unit_number,
    t.make,
    t.model_year,

    p.total_trips,
    ROUND(p.total_miles, 2) AS total_miles,
    ROUND(p.total_revenue, 2) AS total_revenue,

    COALESCE(m.maintenance_events, 0) AS maintenance_events,
    ROUND(COALESCE(m.total_maintenance_cost, 0), 2) AS maintenance_cost,

    ROUND(
        COALESCE(m.total_maintenance_cost, 0) /
        NULLIF(p.total_miles, 0),
        4
    ) AS maintenance_cost_per_mile,

    ROUND(COALESCE(m.total_downtime_hours, 0), 2) AS total_downtime_hours,

    ROUND(
        p.total_revenue /
        NULLIF(p.total_driving_hours, 0),
        2
    ) AS revenue_per_driving_hour,

    ROUND(
        p.total_revenue -
        COALESCE(m.total_maintenance_cost, 0),
        2
    ) AS revenue_after_maintenance

FROM clean.trucks t

JOIN truck_performance p
    ON t.truck_id = p.truck_id

LEFT JOIN truck_maintenance m
    ON t.truck_id = m.truck_id

ORDER BY maintenance_cost_per_mile DESC;