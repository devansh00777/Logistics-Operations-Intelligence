# FleetFlow Analytics — Logistics Operations Intelligence

End-to-end logistics analytics project built with **PostgreSQL, SQL, Power BI, and DAX**.

This project takes raw logistics CSV data through a structured ETL pipeline, transforms the data into clean and analysis-ready PostgreSQL tables, builds a reporting model for Power BI, and answers six operational business questions covering **customer revenue, delivery reliability, route economics, fleet productivity, maintenance, driver performance, and safety risk**.



# Business Problem

A logistics operation generates large amounts of operational data across customers, loads, trips, drivers, trucks, routes, delivery events, fuel purchases, maintenance records, and safety incidents.

The challenge is not simply storing this information. The larger challenge is turning these separate operational datasets into a consistent analytical view of the business.

Management needs to understand where revenue is being generated, whether important customers are receiving reliable service, which transportation lanes are economically attractive, how individual trucks are performing, where maintenance and downtime are creating operational concerns, how driver performance differs, and where safety risk is concentrated.

Because these questions require information from multiple operational datasets, analyzing each table independently can produce incomplete or misleading conclusions.

FleetFlow Analytics was built to solve this problem by creating a complete analytical workflow:

```text
Raw Logistics Data
        ↓
Data Cleaning
        ↓
Data Transformation
        ↓
Reporting Model
        ↓
Business Analysis
        ↓
Interactive Power BI Reporting



# Star Schema

The final reporting layer is organized as a **star schema** for Power BI reporting.

The model separates descriptive business entities into dimension tables and operational events into fact tables.

```text
                         ┌──────────────────┐
                         │  dim_customer    │
                         └────────┬─────────┘
                                  │
                                  │
                         ┌────────▼─────────┐
                         │   fact_loads     │
                         │                  │
                         │ • load_id        │
                         │ • customer_id    │
                         │ • route_id       │
                         │ • load_date      │
                         │ • revenue        │
                         │ • delivered_on_  │
                         │   time           │
                         └────────┬─────────┘
                                  │
                                  │
                         ┌────────▼─────────┐
                         │    dim_route     │
                         └──────────────────┘


      ┌──────────────────┐
      │    dim_driver    │
      └────────┬─────────┘
               │
               │
      ┌────────▼─────────┐
      │    fact_trips    │
      │                  │
      │ • trip_id        │
      │ • load_id        │
      │ • driver_id      │
      │ • truck_id       │
      │ • route_id       │
      │ • distance       │
      │ • duration       │
      │ • average_mpg    │
      │ • fuel_cost      │
      │ • revenue        │
      │ • delivered_on_  │
      │   time           │
      └────────┬─────────┘
               │
      ┌────────┴───────────────┐
      │                        │
┌─────▼──────────┐      ┌──────▼───────────┐
│   dim_truck    │      │    dim_route     │
└────────────────┘      └──────────────────┘


      ┌──────────────────┐
      │    dim_driver    │
      └────────┬─────────┘
               │
      ┌────────▼─────────┐
      │  fact_safety     │
      │                  │
      │ • incident_id    │
      │ • driver_id      │
      │ • truck_id       │
      │ • preventable    │
      │ • at_fault       │
      │ • injury         │
      └──────────────────┘


      ┌──────────────────┐
      │    dim_truck     │
      └────────┬─────────┘
               │
      ┌────────▼───────────────┐
      │   fact_maintenance     │
      │                        │
      │ • maintenance_id       │
      │ • truck_id             │
      │ • total_cost           │
      │ • downtime_hours       │
      └────────────────────────┘


      ┌──────────────────┐
      │     dim_date     │
      └────────┬─────────┘
               │
               ▼
          fact_loads
