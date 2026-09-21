--Q5 Which drivers have the highest on-time delivery rates, and how does their fuel efficiency compare?

WITH driver_performance AS (
    SELECT
        t.driver_id,
        COUNT(DISTINCT t.load_id) AS total_deliveries,

        COUNT(
            CASE
                WHEN de.delivered_on_time = 1 THEN 1
            END
        ) AS on_time_deliveries,

        ROUND(
            100.0 *
            COUNT(
                CASE
                    WHEN de.delivered_on_time = 1 THEN 1
                END
            )
            / NULLIF(COUNT(DISTINCT t.load_id), 0),
            2
        ) AS on_time_rate,

        ROUND(AVG(t.average_mpg), 2) AS average_mpg

    FROM clean.trips t

    JOIN clean.delivery_events de
        ON t.load_id = de.load_id

    WHERE t.trip_status = 'Completed'

    GROUP BY t.driver_id
)

SELECT
    d.driver_id,
    d.first_name,
    d.last_name,
    dp.total_deliveries,
    dp.on_time_deliveries,
    dp.on_time_rate,
    dp.average_mpg

FROM clean.drivers d

JOIN driver_performance dp
    ON d.driver_id = dp.driver_id

ORDER BY
    dp.on_time_rate DESC,
    dp.average_mpg DESC;


