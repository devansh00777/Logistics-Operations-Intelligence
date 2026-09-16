# Logistics-Operations-Intelligence
from pathlib import Path

readme = r"""# FleetFlow Analytics
### Logistics Operations Intelligence

An end-to-end logistics analytics project that transforms operational CSV data into a structured PostgreSQL reporting model and an interactive Power BI report for business analysis.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4D4D4D?style=flat-square)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat-square&logo=powerbi&logoColor=000000)
![DAX](https://img.shields.io/badge/DAX-5C2D91?style=flat-square)

---

## Business Problem

Logistics operations generate large volumes of data across customers, loads, trips, fleet assets, drivers, maintenance activities, fuel usage, delivery events, and safety incidents. Raw operational records are useful for transaction processing, but they do not provide management with a single, reliable view of operational performance.

The purpose of this project is to transform the source data into a structured analytical environment that can be used to evaluate performance, identify operational issues, and support business decision-making through SQL analysis and an interactive Power BI report.

---

## Project Objective

The project was designed to:

- Build a structured PostgreSQL environment for the logistics data.
- Preserve the source data while creating analysis-ready tables.
- Apply SQL transformations while controlling data grain and avoiding double counting.
- Create a reporting model suitable for Power BI.
- Analyse the operation through six practical business questions.
- Deliver an interactive Power BI report that communicates the results clearly.

---

## End-to-End Workflow

```text
CSV Source Data
      │
      ▼
PostgreSQL Raw Layer
      │
      ▼
SQL Transformation / Clean Layer
      │
      ▼
PostgreSQL Reporting Layer
      │
      ▼
Power BI Data Model
      │
      ▼
DAX Measures + Interactive Report
      │
      ▼
Business Insights
