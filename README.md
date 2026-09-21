# 🚛 FleetFlow Analytics

**An end-to-end logistics analytics project** — 85,000+ loads across a 120-truck fleet, analyzed through six business-critical lenses: customer revenue, route economics, fleet productivity, maintenance cost, driver performance, and safety risk. Built entirely on PostgreSQL with a two-page Power BI dashboard on top.

📊 **Dataset:** 85,410 loads/trips · 200 customers · 150 drivers · 120 trucks · 58 routes &nbsp;|&nbsp; 🛠️ **Stack:** PostgreSQL · Power BI (DAX) · SQL

---

## 💡 What This Does

FleetFlow Analytics ingests raw operational data (loads, trips, drivers, trucks, maintenance, safety incidents, fuel purchases) and turns it into six answers a logistics ops team actually needs: *who are our best customers and are we serving them well, which routes make money, which trucks are worth keeping, which drivers need coaching, and where is our real safety risk.*

Every number in this repo was verified against the raw source data before publishing — see the **Key Insights** section for what that surfaced.

## 🔄 Project Pipeline

1. **Raw layer** — source tables loaded 1:1 from CSV, no transformation.
2. **Clean layer** — delivery events deduplicated to one row per load; fuel purchases aggregated to trip level; trip/truck assignment status flagged.
3. **Reporting layer** — star-schema fact/dimension tables (`fact_loads`, `fact_trips`, `dim_customer`, `dim_route`, `dim_driver`, `dim_truck`) built on top of the clean layer.
4. **Analysis** — six standalone SQL scripts, each answering one business question.
5. **Dashboard** — Power BI report built directly on the reporting layer.

## 🗂️ Dashboard Sections

| Page | Visuals |
|---|---|
| 📈 **Executive Overview** | KPI cards · Top 10 Active Customers — Revenue & On-Time Delivery · Route Economics — Profit Proxy per Mile · Fleet Productivity — Revenue vs Miles |
| 🔧 **Fleet & Operations** | Maintenance & Downtime · Top 10 Drivers by Safety Risk · Driver Performance · Safety Detail by Driver (table) |

## 🗄️ Data Model

```
FACT TABLES
├─ trips               → drivers, trucks, trailers, loads
├─ loads               → customers, routes
├─ delivery_events     → loads, trips, facilities
├─ safety_incidents    → trips, trucks, drivers
├─ fuel_purchases      → trips, trucks, drivers
└─ maintenance_records → trucks

DIMENSION TABLES
├─ drivers
├─ trucks
├─ trailers
├─ routes
├─ customers
└─ facilities

REPORTING LAYER (aggregated, built on the star schema)
├─ driver_monthly_metrics     (trips + incidents, rolled up monthly)
└─ truck_utilization_metrics  (trips + maintenance, rolled up monthly)
```

## ❓ Business Questions & SQL Analysis

| # | Question | Script |
|---|---|---|
| 1 | Which customers drive the most revenue, and are they getting reliable service? | `01_customer_revenue.sql` |
| 2 | Which routes are profitable after fuel, and which are underwater? | `02_route_economics.sql` |
| 3 | Which trucks generate the most revenue per mile, relative to the fleet? | `03_fleet_productivity.sql` |
| 4 | Which trucks cost the most to maintain, and how does that hit revenue? | `04_maintenance_downtime.sql` |
| 5 | Which drivers deliver on time most consistently, and how efficient are they? | `05_driver_performance.sql` |
| 6 | Which drivers carry the highest operational risk, and why? | `06_safety_risk.sql` |

## 🧰 SQL Techniques Used

- CTEs and multi-stage aggregation
- Window functions (`RANK() OVER`, `AVG() OVER (PARTITION BY ...)`)
- Conditional aggregation (`CASE WHEN` inside `SUM`/`COUNT`)
- Deliberate `LEFT` vs `INNER JOIN` choices per query
- `NULLIF` / `COALESCE` guarding divide-by-zero and null-sort ranking bugs

## 📐 Key Metrics

| Metric | Formula | What It Tells You |
|---|---|---|
| On-Time Delivery % | On-Time Loads / Total Loads × 100 | Service reliability |
| Revenue per Mile | Total Revenue / Total Miles | Route/fleet efficiency |
| Profit Proxy per Mile | (Revenue − Fuel Cost) / Miles | Route margin after fuel |
| Maintenance Cost per Mile | Maintenance Cost / Miles | Asset cost efficiency |
| Incidents per 100K Miles | Incidents / Miles × 100,000 | Safety exposure, normalized |
| Risk Score | Preventable×10 + At-Fault×5 + Injury×20 + Incidents/100K Miles | Composite driver risk ranking |

## 🔍 Key Insights

**1. 🎯 Top revenue customers aren't getting better service.**
The top 10 accounts each bring in $1.47M–$1.54M, but their on-time rates (39.5%–47.0%) sit right around the company average of 44.6%. No reliability premium for the customers who matter most.

**2. 🛣️ Several short-haul routes look deeply unprofitable after fuel.**
Best routes net $2.05–$2.21/mile after fuel; New York↔Philadelphia comes in at **-$10.30/mile**. Short trip length concentrates fuel cost per mile — worth a per-purchase look before it drives pricing, but it's the clearest red flag in the network.

**3. ⏱️ On-time delivery is a systemic issue, not a driver issue.**
The single best driver in the fleet — out of 150 — tops out at 50.2% on-time. No one clears the low 50s. That flat ceiling points at dispatch/scheduling, not individual performance.

**4. 🔧 Maintenance dollars aren't the real fleet-health signal — downtime is.**
The highest-cost truck to maintain still nets $2.6M in revenue after $71.8K in repairs (2.7% of revenue) — but logged 940 downtime hours. Hours off the road matter more than the repair bill.

**5. 🚨 Safety risk is concentrated in a few drivers, not spread across the fleet.**
Three drivers carry meaningfully higher risk scores than the rest — one with a high incident count, one with only 3 incidents but 100% preventable. Two different problems, two different fixes.

## ✅ Recommendations

- 🎯 Audit service levels for the top 10 revenue accounts — reliability should scale with account value, and currently it doesn't.
- 🛣️ Get a trip-level (not route-aggregate) fuel cost breakdown before renegotiating or dropping short-haul lanes.
- ⏱️ Investigate on-time delivery at the dispatch/scheduling layer — the flat ceiling across all 150 drivers rules out individual performance.
- 🔧 Track downtime hours as a first-class fleet KPI, not a byproduct of maintenance spend.
- 🚨 Split safety interventions by pattern: coaching for low-frequency/high-preventability drivers, closer monitoring for higher-frequency cases.

## 📁 Folder Structure

```
FleetFlow-Analytics/
│
├───sql/
│       01_customer_revenue.sql
│       02_route_economics.sql
│       03_fleet_productivity.sql
│       04_maintenance_downtime.sql
│       05_driver_performance.sql
│       06_safety_risk.sql
│
├───dashboard/
│       Logistics_Operations_Dashboard.pbix
│
└───README.md
```

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| Database | PostgreSQL |
| BI / Dashboard | Power BI (DAX) |
| Query Language | SQL (CTEs, window functions, conditional aggregation) |
| Version Control | Git, GitHub |
