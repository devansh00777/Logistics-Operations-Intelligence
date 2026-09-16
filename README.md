# FleetFlow Analytics — Logistics Operations Intelligence

End-to-end logistics analytics project built with **PostgreSQL, SQL, Power BI, and DAX**.

This project takes raw logistics CSV data through a structured ETL pipeline, transforms the data into clean and analysis-ready PostgreSQL tables, builds a reporting model for Power BI, and answers six operational business questions covering **customer revenue, delivery reliability, route economics, fleet productivity, maintenance, driver performance, and safety risk**.

---

## Table of Contents

- [Business Problem](#business-problem)
- [Project Objective](#project-objective)
- [Project Scope](#project-scope)
- [Data Overview](#data-overview)
- [End-to-End Architecture](#end-to-end-architecture)
- [ETL Workflow](#etl-workflow)
  - [1. Extract](#1-extract)
  - [2. Raw Layer](#2-raw-layer)
  - [3. Transform](#3-transform)
  - [4. Clean Layer](#4-clean-layer)
  - [5. Reporting Layer](#5-reporting-layer)
  - [6. Power BI](#6-power-bi)
- [Data Quality & Transformation Decisions](#data-quality--transformation-decisions)
  - [Missing Truck Assignments](#1-missing-truck-assignments)
  - [Delivery Event Aggregation](#2-delivery-event-aggregation)
  - [Fuel Aggregation](#3-fuel-aggregation)
  - [Source On-Time Definition](#4-source-on-time-definition)
  - [Fact-Level Grain](#5-fact-level-grain)
- [Reporting Data Model](#reporting-data-model)
- [Business Questions](#business-questions)
  - [1. Customer Revenue & Service](#1-customer-revenue--service)
  - [2. Route Economics](#2-route-economics)
  - [3. Fleet Productivity](#3-fleet-productivity)
  - [4. Maintenance & Downtime](#4-maintenance--downtime)
  - [5. Driver Performance & Fuel Efficiency](#5-driver-performance--fuel-efficiency)
  - [6. Safety & Operational Risk](#6-safety--operational-risk)
- [Power BI Report](#power-bi-report)
- [DAX Measures](#dax-measures)
- [SQL Techniques Used](#sql-techniques-used)
- [Key Findings](#key-findings)
- [Important Analytical Assumptions](#important-analytical-assumptions)
- [Technology Stack](#technology-stack)
- [Repository Structure](#repository-structure)
- [How to Reproduce the Project](#how-to-reproduce-the-project)
- [Project Outcome](#project-outcome)

---

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
