-- =========================================================
-- REPORTING / GOLD
-- Star schema for SQL analysis + Power BI
-- =========================================================

DROP SCHEMA IF EXISTS reporting CASCADE;
CREATE SCHEMA reporting;


-- =========================================================
-- 1. CUSTOMER DIMENSION
-- =========================================================

CREATE TABLE reporting.dim_customer AS
SELECT
    customer_id,
    customer_name,
    customer_type,
    primary_freight_type,
    account_status
FROM clean.customers;

ALTER TABLE reporting.dim_customer
ADD PRIMARY KEY (customer_id);


-- =========================================================
-- 2. DRIVER DIMENSION
-- =========================================================

CREATE TABLE reporting.dim_driver AS
SELECT
    driver_id,
    first_name,
    last_name,
    years_experience,
    home_terminal,
    employment_status
FROM clean.drivers;

ALTER TABLE reporting.dim_driver
ADD PRIMARY KEY (driver_id);


-- =========================================================
-- 3. TRUCK DIMENSION
-- =========================================================

CREATE TABLE reporting.dim_truck AS
SELECT
    truck_id,
    unit_number,
    make,
    model_year,
    fuel_type,
    status,
    home_terminal
FROM clean.trucks;

ALTER TABLE reporting.dim_truck
ADD PRIMARY KEY (truck_id);


-- =========================================================
-- 4. ROUTE DIMENSION
-- =========================================================

CREATE TABLE reporting.dim_route AS
SELECT
    route_id,
    origin_city,
    origin_state,
    destination_city,
    destination_state,
    typical_distance_miles,
    base_rate_per_mile,
    fuel_surcharge_rate,
    typical_transit_days
FROM clean.routes;

ALTER TABLE reporting.dim_route
ADD PRIMARY KEY (route_id);


-- =========================================================
-- 5. DATE DIMENSION
-- =========================================================

CREATE TABLE reporting.dim_date AS
SELECT
    d::DATE AS date,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(MONTH FROM d)::INT AS month_number,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(QUARTER FROM d)::INT AS quarter
FROM generate_series(
    '2022-01-01'::DATE,
    '2024-12-31'::DATE,
    '1 day'
) AS d;

ALTER TABLE reporting.dim_date
ADD PRIMARY KEY (date);


-- =========================================================
-- 6. FACT LOADS
-- Customer + Route + Revenue + Service
-- =========================================================

CREATE TABLE reporting.fact_loads AS
SELECT
    l.load_id,
    l.customer_id,
    l.route_id,
    l.load_date,
    l.load_type,
    l.weight_lbs,
    l.pieces,
    l.revenue,
    l.fuel_surcharge,
    l.accessorial_charges,
    l.load_status,
    l.booking_type,

    d.delivered_on_time,
    d.total_detention_minutes

FROM clean.loads l
LEFT JOIN clean.delivery_events d
    ON l.load_id = d.load_id;

ALTER TABLE reporting.fact_loads
ADD PRIMARY KEY (load_id);


-- =========================================================
-- 7. FACT TRIPS
-- Driver + Truck + Route + Fuel
-- =========================================================

CREATE TABLE reporting.fact_trips AS
SELECT
    t.trip_id,
    t.load_id,
    l.customer_id,
    l.route_id,
    t.driver_id,
    t.truck_id,
    t.dispatch_date,
    t.actual_distance_miles,
    t.actual_duration_hours,
    t.fuel_gallons_used,
    t.average_mpg,
    t.idle_time_hours,
    t.trip_status,
    t.truck_assignment_status,

    COALESCE(f.total_fuel_gallons, 0) AS total_fuel_gallons,
    COALESCE(f.total_fuel_cost, 0) AS total_fuel_cost

FROM clean.trips t

LEFT JOIN clean.loads l
    ON t.load_id = l.load_id

LEFT JOIN clean.fuel_by_trip f
    ON t.trip_id = f.trip_id;

ALTER TABLE reporting.fact_trips
ADD PRIMARY KEY (trip_id);


-- =========================================================
-- 8. FACT MAINTENANCE
-- =========================================================

CREATE TABLE reporting.fact_maintenance AS
SELECT
    maintenance_id,
    truck_id,
    maintenance_date,
    maintenance_type,
    odometer_reading,
    total_cost,
    downtime_hours
FROM clean.maintenance_records;

ALTER TABLE reporting.fact_maintenance
ADD PRIMARY KEY (maintenance_id);


-- =========================================================
-- 9. FACT SAFETY
-- =========================================================

CREATE TABLE reporting.fact_safety AS
SELECT
    incident_id,
    trip_id,
    truck_id,
    driver_id,
    incident_date,
    incident_type,
    at_fault_flag,
    injury_flag,
    vehicle_damage_cost,
    cargo_damage_cost,
    claim_amount,
    preventable_flag
FROM clean.safety_incidents;

ALTER TABLE reporting.fact_safety
ADD PRIMARY KEY (incident_id);