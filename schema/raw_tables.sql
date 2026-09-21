
CREATE TABLE raw.drivers (
    driver_id VARCHAR(30) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    hire_date DATE,
    termination_date DATE,
    license_number VARCHAR(50),
    license_state VARCHAR(10),
    date_of_birth DATE,
    home_terminal VARCHAR(100),
    employment_status VARCHAR(50),
    cdl_class VARCHAR(10),
    years_experience INT
);


-- -------------------------
-- Trucks
-- -------------------------

CREATE TABLE raw.trucks (
    truck_id VARCHAR(30) PRIMARY KEY,
    unit_number VARCHAR(50),
    make VARCHAR(50),
    model_year INT,
    vin VARCHAR(50),
    acquisition_date DATE,
    acquisition_mileage NUMERIC,
    fuel_type VARCHAR(20),
    tank_capacity_gallons NUMERIC,
    status VARCHAR(50),
    home_terminal VARCHAR(100)
);


-- -------------------------
-- Trailers
-- -------------------------

CREATE TABLE raw.trailers (
    trailer_id VARCHAR(30) PRIMARY KEY,
    trailer_number VARCHAR(50),
    trailer_type VARCHAR(50),
    length_feet NUMERIC,
    model_year INT,
    vin VARCHAR(50),
    acquisition_date DATE,
    status VARCHAR(50),
    current_location VARCHAR(100)
);


-- -------------------------
-- Customers
-- -------------------------

CREATE TABLE raw.customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_type VARCHAR(50),
    credit_terms_days INT,
    primary_freight_type VARCHAR(50),
    account_status VARCHAR(50),
    contract_start_date DATE,
    annual_revenue_potential NUMERIC
);


-- -------------------------
-- Routes
-- -------------------------

CREATE TABLE raw.routes (
    route_id VARCHAR(30) PRIMARY KEY,
    origin_city VARCHAR(100),
    origin_state VARCHAR(50),
    destination_city VARCHAR(100),
    destination_state VARCHAR(50),
    typical_distance_miles NUMERIC,
    base_rate_per_mile NUMERIC,
    fuel_surcharge_rate NUMERIC,
    typical_transit_days INT
);


-- -------------------------
-- Facilities
-- -------------------------

CREATE TABLE raw.facilities (
    facility_id VARCHAR(30) PRIMARY KEY,
    facility_name VARCHAR(255),
    facility_type VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(50),
    latitude NUMERIC,
    longitude NUMERIC,
    dock_doors INT,
    operating_hours VARCHAR(100)
);


-- -------------------------
-- Loads
-- -------------------------

CREATE TABLE raw.loads (
    load_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(30)
        REFERENCES raw.customers(customer_id),
    route_id VARCHAR(30)
        REFERENCES raw.routes(route_id),
    load_date DATE,
    load_type VARCHAR(50),
    weight_lbs NUMERIC,
    pieces INT,
    revenue NUMERIC,
    fuel_surcharge NUMERIC,
    accessorial_charges NUMERIC,
    load_status VARCHAR(50),
    booking_type VARCHAR(50)
);


-- -------------------------
-- Trips
-- -------------------------

CREATE TABLE raw.trips (
    trip_id VARCHAR(30) PRIMARY KEY,
    load_id VARCHAR(30)
        REFERENCES raw.loads(load_id),
    driver_id VARCHAR(30)
        REFERENCES raw.drivers(driver_id),
    truck_id VARCHAR(30)
        REFERENCES raw.trucks(truck_id),
    trailer_id VARCHAR(30)
        REFERENCES raw.trailers(trailer_id),
    dispatch_date DATE,
    actual_distance_miles NUMERIC,
    actual_duration_hours NUMERIC,
    fuel_gallons_used NUMERIC,
    average_mpg NUMERIC,
    idle_time_hours NUMERIC,
    trip_status VARCHAR(50)
);


CREATE TABLE raw.delivery_events (
    event_id VARCHAR(30) PRIMARY KEY,
    load_id VARCHAR(30) REFERENCES raw.loads(load_id),
    trip_id VARCHAR(30) REFERENCES raw.trips(trip_id),
    event_type VARCHAR(50),
    facility_id VARCHAR(30) REFERENCES raw.facilities(facility_id),
    scheduled_datetime TIMESTAMP,
    actual_datetime TIMESTAMP,
    detention_minutes INT,
    on_time_flag BOOLEAN,
    location_city VARCHAR(100),
    location_state VARCHAR(50)
);

-- -------------------------
-- Fuel Purchases
-- -------------------------

CREATE TABLE raw.fuel_purchases (
    fuel_purchase_id VARCHAR(30) PRIMARY KEY,
    trip_id VARCHAR(30)
        REFERENCES raw.trips(trip_id),
    truck_id VARCHAR(30)
        REFERENCES raw.trucks(truck_id),
    driver_id VARCHAR(30)
        REFERENCES raw.drivers(driver_id),
    purchase_date DATE,
    location_city VARCHAR(100),
    location_state VARCHAR(50),
    gallons NUMERIC,
    price_per_gallon NUMERIC,
    total_cost NUMERIC,
    fuel_card_number VARCHAR(50)
);


-- -------------------------
-- Maintenance
-- -------------------------

CREATE TABLE raw.maintenance_records (
    maintenance_id VARCHAR(30) PRIMARY KEY,
    truck_id VARCHAR(30)
        REFERENCES raw.trucks(truck_id),
    maintenance_date DATE,
    maintenance_type VARCHAR(50),
    odometer_reading NUMERIC,
    labor_hours NUMERIC,
    labor_cost NUMERIC,
    parts_cost NUMERIC,
    total_cost NUMERIC,
    facility_location VARCHAR(100),
    downtime_hours NUMERIC,
    service_description VARCHAR(500)
);


-- -------------------------
-- Safety Incidents
-- -------------------------

CREATE TABLE raw.safety_incidents (
    incident_id VARCHAR(30) PRIMARY KEY,
    trip_id VARCHAR(30)
        REFERENCES raw.trips(trip_id),
    truck_id VARCHAR(30)
        REFERENCES raw.trucks(truck_id),
    driver_id VARCHAR(30)
        REFERENCES raw.drivers(driver_id),
    incident_date DATE,
    incident_type VARCHAR(50),
    location_city VARCHAR(100),
    location_state VARCHAR(50),
    at_fault_flag BOOLEAN,
    injury_flag BOOLEAN,
    vehicle_damage_cost NUMERIC,
    cargo_damage_cost NUMERIC,
    claim_amount NUMERIC,
    preventable_flag BOOLEAN,
    description VARCHAR(500)
);


-- -------------------------
-- Driver Monthly Metrics
-- -------------------------

CREATE TABLE raw.driver_monthly_metrics (
    driver_id VARCHAR(30)
        REFERENCES raw.drivers(driver_id),
    month DATE,
    trips_completed INT,
    total_miles NUMERIC,
    total_revenue NUMERIC,
    average_mpg NUMERIC,
    total_fuel_gallons NUMERIC,
    on_time_delivery_rate NUMERIC,
    average_idle_hours NUMERIC,
    PRIMARY KEY (driver_id, month)
);


-- -------------------------
-- Truck Utilization Metrics
-- -------------------------

CREATE TABLE raw.truck_utilization_metrics (
    truck_id VARCHAR(30)
        REFERENCES raw.trucks(truck_id),
    month DATE,
    trips_completed INT,
    total_miles NUMERIC,
    total_revenue NUMERIC,
    average_mpg NUMERIC,
    maintenance_events INT,
    maintenance_cost NUMERIC,
    downtime_hours NUMERIC,
    utilization_rate NUMERIC,
    PRIMARY KEY (truck_id, month)
);