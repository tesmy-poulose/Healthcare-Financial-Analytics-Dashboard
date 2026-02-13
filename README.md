# 🏥 Healthcare Financial Performance & Cost Optimization Analytics

## 📌 Project Overview

This project analyzes hospital financial performance using real-world healthcare financial reporting data from the CMS Hospital Provider Cost Report dataset.

The objective is to transform complex regulatory financial reporting data into executive decision intelligence to support cost optimization, profitability improvement, and operational efficiency strategy.

## 🎯 Business Objectives

- Identify profit vs loss hospitals

- Detect high financial risk regions

- Evaluate operational efficiency using infrastructure utilization metrics

- Support data-driven healthcare financial strategy

## 📂 Real World Dataset
Dataset: Hospital Provider Cost Report

Source: Data.gov (US Government Open Data Portal)

Publisher: Centers for Medicare & Medicaid Services (CMS)

# Dataset Includes:

- Hospital Revenue
- Operating Costs
- Net Income
- Bed Capacity
- Fiscal Reporting Period

## 🧱 Project Architecture

Raw Data → Python Cleaning → SQL Analysis → Power BI Dashboard → Business Case Study

## 🛠 Tools & Technologies

- Python (Pandas)-Data Cleaning
- SQL (MySQL)-Financial Analysis
- Power BI-Dashboard Visualization
- DAX-KPI Calculations

## 🗄 SQL Database Setup
### Step 1 — Create Database
CREATE DATABASE healthcare_finance;
USE healthcare_finance;

### Step 2 — Create Table
CREATE TABLE hospital_finance (
    provider_ccn VARCHAR(50),
    hospital_name VARCHAR(255),
    state_code VARCHAR(10),
    fiscal_year_begin DATE,
    fiscal_year_end DATE,
    number_of_beds INT,
    total_costs DOUBLE,
    inpatient_revenue DOUBLE,
    outpatient_revenue DOUBLE,
    total_patient_revenue DOUBLE,
    net_patient_revenue DOUBLE,
    total_operating_expense DOUBLE,
    net_income DOUBLE
);

## 🧹 Data Cleaning Using Python (Google Colab)
### Load Dataset
import pandas as pd
df = pd.read_csv('/content/CostReport_2023_Final.csv')
df.head()

### Clean Column Names
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("[^a-zA-Z0-9_]", "", regex=True)
)

### Remove High Null Columns
threshold = len(df) * 0.9
df = df.dropna(thresh=threshold, axis=1)

### Select Business Columns
important_cols = [
    "provider_ccn",
    "hospital_name",
    "state_code",
    "city",
    "fiscal_year_begin_date",
    "fiscal_year_end_date",
    "number_of_beds",
    "total_costs",
    "inpatient_total_charges",
    "combined_outpatient__inpatient_total_charges",
    "inpatient_revenue",
    "total_patient_revenue",
    "net_patient_revenue",
    "less_total_operating_expense",
    "net_income_from_service_to_patients"
]

df_final = df[important_cols].copy()


### Create KPI Metrics
df_final["profit_margin"] = (
    df_final["net_income_from_service_to_patients"] /
    df_final["total_patient_revenue"]
) * 100

df_final["cost_to_revenue_ratio"] = (
    df_final["total_costs"] /
    df_final["total_patient_revenue"]
)

df_final["revenue_per_bed"] = (
    df_final["total_patient_revenue"] /
    df_final["number_of_beds"]
)

### Export Clean Dataset
df_final.to_csv("healthcare_finance_clean.csv", index=False)


## 📊 SQL Business Analysis Queries

### Top Profitable Hospitals

SELECT
    hospital_name,
    state_code,
    (net_income_from_service_to_patients / total_patient_revenue) * 100 AS profit_margin
FROM healthcare_raw
WHERE total_patient_revenue > 0
ORDER BY profit_margin DESC
LIMIT 10;


### Loss Making Hospitals
SELECT
    hospital_name,
    state_code,
    net_income_from_service_to_patients
FROM healthcare_raw
WHERE net_income_from_service_to_patients < 0;


### State Financial Performance
SELECT
    state_code,
    COUNT(*) AS total_hospitals,
    SUM(net_income_from_service_to_patients) AS total_state_net_income
FROM healthcare_raw
GROUP BY state_code
ORDER BY total_state_net_income DESC;


### Cost Efficiency Leaders
SELECT
    hospital_name,
    total_patient_revenue / total_costs AS revenue_to_cost_ratio
FROM healthcare_raw
ORDER BY revenue_to_cost_ratio DESC;


## 📈 Power BI Dashboard Development

### Core KPI Measures
Total Revenue
Total Revenue = SUM(Data[total_patient_revenue])

Total Cost
Total Cost = SUM(Data[total_costs])

Total Profit
Total Profit = SUM(Data[net_income])

Profit Margin %
Profit Margin % =
DIVIDE([Total Profit], [Total Revenue]) * 100


## 📊 Dashboard Pages

### Page 1 — Financial Overview
- KPI Cards
- Revenue vs Cost vs Profit
- Revenue by State
- Profit by State

### Page 2 — Profitability & Efficiency
-Revenue Per Bed
-Cost Per Bed
- Efficiency Scatter Plot

### Page 3 — Risk & Opportunity
- Loss vs Profit Hospital Counts
- Risk Distribution

### Page 4 — Performance Deep Dive
- Waterfall Financial Flow
- Heatmap Matrix
- Geographic Map
- Profit Distribution

## 📊 Key Analytical Findings

- Revenue growth does not guarantee profitability
- Cost structure is primary profit driver
- Profitability varies significantly across regions
- Operational efficiency drives financial performance
- Healthcare operates on thin margins

## 🚀 Strategic Recommendations
- Cost Optimization
    - Benchmark hospital operating costs
    - Identify top cost drivers
- Regional Strategy
    - State-level performance monitoring
    - Region-specific cost programs
- Efficiency Optimization
    - Monitor Revenue Per Bed KPI
    - Optimize infrastructure utilization

## 📊 Business Value Delivered
✔ Financial visibility
✔ Risk monitoring capability
✔ Cost optimization opportunity identification
✔ Executive decision support

