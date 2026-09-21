--Which drivers have the highest safety risk, based on incident frequency, preventability, at-fault incidents, and injuries?
WITH driver_activity AS (
    SELECT
        driver_id,
        COUNT(DISTINCT trip_id) AS total_trips,
        SUM(actual_distance_miles) AS total_miles
    FROM clean.trips
    WHERE trip_status = 'Completed'
    GROUP BY driver_id
),

driver_incidents AS (
    SELECT
        driver_id,
        COUNT(*) AS total_incidents,
        SUM(CASE WHEN preventable_flag = TRUE THEN 1 ELSE 0 END) AS preventable_incidents,
        SUM(CASE WHEN at_fault_flag = TRUE THEN 1 ELSE 0 END) AS at_fault_incidents,
        SUM(CASE WHEN injury_flag = TRUE THEN 1 ELSE 0 END) AS injury_incidents
    FROM clean.safety_incidents
    GROUP BY driver_id
)

SELECT
    d.driver_id,
    d.first_name,
    d.last_name,
    a.total_trips,
    ROUND(a.total_miles, 0) AS total_miles,
    i.total_incidents,

    ROUND(
        100000.0 * i.total_incidents / NULLIF(a.total_miles, 0),
        2
    ) AS incidents_per_100k_miles,

    ROUND(
        100.0 * i.preventable_incidents
        / NULLIF(i.total_incidents, 0),
        2
    ) AS preventable_pct,

    -- Matches the live Power BI "Risk Score" DAX measure:
    -- (preventable*10) + (at_fault*5) + (injury*20) + incidents_per_100K_miles
    ROUND(
        i.preventable_incidents * 10 +
        i.at_fault_incidents * 5 +
        i.injury_incidents * 20 +
        (100000.0 * i.total_incidents / NULLIF(a.total_miles, 0)),
        2
    ) AS risk_score

FROM clean.drivers d
JOIN driver_activity a
    ON d.driver_id = a.driver_id
JOIN driver_incidents i
    ON d.driver_id = i.driver_id

ORDER BY risk_score DESC, incidents_per_100k_miles DESC
LIMIT 25;