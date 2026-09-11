-- =========================================================
-- CLEAN / ANALYSIS LAYER
-- Useful columns only
-- Raw data remains untouched
-- =========================================================


-- =========================================================
-- 1. CUSTOMERS
-- Customer revenue and service analysis
-- =========================================================

DROP TABLE IF EXISTS clean.customers;

CREATE TABLE clean.customers AS
SELECT
    TRIM(customer_id) AS customer_id,
    NULLIF(TRIM(customer_name), '') AS customer_name,
    NULLIF(TRIM(customer_type), '') AS customer_type,
    NULLIF(TRIM(primary_freight_type), '') AS primary_freight_type,
    NULLIF(TRIM(account_status), '') AS account_status
FROM raw.customers;


-- =========================================================
-- 2. DRIVERS
-- Driver performance, fuel and safety analysis
-- =========================================================

DROP TABLE IF EXISTS clean.drivers;

CREATE TABLE clean.drivers AS
SELECT
    TRIM(driver_id) AS driver_id,
    NULLIF(TRIM(first_name), '') AS first_name,
    NULLIF(TRIM(last_name), '') AS last_name,
    years_experience,
    NULLIF(TRIM(home_terminal), '') AS home_terminal,
    NULLIF(TRIM(employment_status), '') AS employment_status
FROM raw.drivers;


-- =========================================================
-- 3. TRUCKS
-- Fleet productivity and maintenance analysis
-- =========================================================

DROP TABLE IF EXISTS clean.trucks;

CREATE TABLE clean.trucks AS
SELECT
    TRIM(truck_id) AS truck_id,
    NULLIF(TRIM(unit_number), '') AS unit_number,
    NULLIF(TRIM(make), '') AS make,
    model_year,
    NULLIF(TRIM(fuel_type), '') AS fuel_type,
    NULLIF(TRIM(status), '') AS status,
    NULLIF(TRIM(home_terminal), '') AS home_terminal
FROM raw.trucks;


-- =========================================================
-- 4. ROUTES
-- Route economics and service analysis
-- =========================================================

DROP TABLE IF EXISTS clean.routes;

CREATE TABLE clean.routes AS
SELECT
    TRIM(route_id) AS route_id,
    NULLIF(TRIM(origin_city), '') AS origin_city,
    NULLIF(TRIM(origin_state), '') AS origin_state,
    NULLIF(TRIM(destination_city), '') AS destination_city,
    NULLIF(TRIM(destination_state), '') AS destination_state,
    typical_distance_miles,
    base_rate_per_mile,
    fuel_surcharge_rate,
    typical_transit_days
FROM raw.routes;


-- =========================================================
-- 5. LOADS
-- Revenue, customer, route and demand analysis
-- =========================================================

DROP TABLE IF EXISTS clean.loads;

CREATE TABLE clean.loads AS
SELECT
    TRIM(load_id) AS load_id,
    NULLIF(TRIM(customer_id), '') AS customer_id,
    NULLIF(TRIM(route_id), '') AS route_id,
    load_date,
    NULLIF(TRIM(load_type), '') AS load_type,
    weight_lbs,
    pieces,
    revenue,
    fuel_surcharge,
    accessorial_charges,
    NULLIF(TRIM(load_status), '') AS load_status,
    NULLIF(TRIM(booking_type), '') AS booking_type
FROM raw.loads;


-- =========================================================
-- 6. TRIPS
-- Fleet, driver and fuel analysis
-- Keep missing truck assignments
-- =========================================================

DROP TABLE IF EXISTS clean.trips;

CREATE TABLE clean.trips AS
SELECT
    TRIM(trip_id) AS trip_id,
    NULLIF(TRIM(load_id), '') AS load_id,
    NULLIF(TRIM(driver_id), '') AS driver_id,
    NULLIF(TRIM(truck_id), '') AS truck_id,
    dispatch_date,
    actual_distance_miles,
    actual_duration_hours,
    fuel_gallons_used,
    average_mpg,
    idle_time_hours,
    NULLIF(TRIM(trip_status), '') AS trip_status,

    CASE
        WHEN truck_id IS NULL OR TRIM(truck_id) = ''
            THEN 'Missing truck assignment'
        ELSE 'Valid'
    END AS truck_assignment_status

FROM raw.trips;


-- =========================================================
-- 7. DELIVERY EVENTS
-- One row per load
-- Prevents duplicate load/revenue counting
-- =========================================================

DROP TABLE IF EXISTS clean.delivery_events;

CREATE TABLE clean.delivery_events AS
SELECT
    load_id,

    MAX(
        CASE
            WHEN event_type = 'Pickup'
            THEN actual_datetime
        END
    ) AS pickup_actual,

    MAX(
        CASE
            WHEN event_type = 'Delivery'
            THEN actual_datetime
        END
    ) AS delivery_actual,

    MAX(
        CASE
            WHEN event_type = 'Delivery'
            THEN on_time_flag::INT
        END
    ) AS delivered_on_time,

    SUM(detention_minutes) AS total_detention_minutes

FROM raw.delivery_events
GROUP BY load_id;


-- =========================================================
-- 8. FUEL PURCHASES
-- Keep only columns needed for fuel cost analysis
-- =========================================================

DROP TABLE IF EXISTS clean.fuel_purchases;

CREATE TABLE clean.fuel_purchases AS
SELECT
    fuel_purchase_id,
    trip_id,
    truck_id,
    driver_id,
    purchase_date,
    gallons,
    price_per_gallon,
    total_cost
FROM raw.fuel_purchases;


-- =========================================================
-- 9. FUEL BY TRIP
-- Aggregate fuel purchases before joining to trips
-- Prevents fuel/revenue duplication
-- =========================================================

DROP TABLE IF EXISTS clean.fuel_by_trip;

CREATE TABLE clean.fuel_by_trip AS
SELECT
    trip_id,
    SUM(gallons) AS total_fuel_gallons,
    SUM(total_cost) AS total_fuel_cost
FROM clean.fuel_purchases
GROUP BY trip_id;


-- =========================================================
-- 10. MAINTENANCE
-- Fleet maintenance and downtime analysis
-- =========================================================

DROP TABLE IF EXISTS clean.maintenance_records;

CREATE TABLE clean.maintenance_records AS
SELECT
    maintenance_id,
    truck_id,
    maintenance_date,
    NULLIF(TRIM(maintenance_type), '') AS maintenance_type,
    odometer_reading,
    total_cost,
    downtime_hours
FROM raw.maintenance_records;


-- =========================================================
-- 11. SAFETY INCIDENTS
-- Safety analysis
-- =========================================================

DROP TABLE IF EXISTS clean.safety_incidents;

CREATE TABLE clean.safety_incidents AS
SELECT
    incident_id,
    trip_id,
    truck_id,
    driver_id,
    incident_date,
    NULLIF(TRIM(incident_type), '') AS incident_type,
    at_fault_flag,
    injury_flag,
    vehicle_damage_cost,
    cargo_damage_cost,
    claim_amount,
    preventable_flag
FROM raw.safety_incidents;


-- =========================================================
-- 12. DRIVER MONTHLY METRICS
-- Useful pre-aggregated driver performance data
-- =========================================================

DROP TABLE IF EXISTS clean.driver_monthly_metrics;

CREATE TABLE clean.driver_monthly_metrics AS
SELECT
    driver_id,
    month,
    trips_completed,
    total_miles,
    total_revenue,
    average_mpg,
    total_fuel_gallons,
    on_time_delivery_rate,
    average_idle_hours
FROM raw.driver_monthly_metrics;


-- =========================================================
-- 13. TRUCK UTILIZATION METRICS
-- Useful pre-aggregated fleet performance data
-- =========================================================

DROP TABLE IF EXISTS clean.truck_utilization_metrics;

CREATE TABLE clean.truck_utilization_metrics AS
SELECT
    truck_id,
    month,
    trips_completed,
    total_miles,
    total_revenue,
    average_mpg,
    maintenance_events,
    maintenance_cost,
    downtime_hours,
    utilization_rate
FROM raw.truck_utilization_metrics;