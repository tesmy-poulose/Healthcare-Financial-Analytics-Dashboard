# case 1: Which hospitals are most profitable?
SELECT
    hospital_name,
    state_code,
    (net_income_from_service_to_patients / total_patient_revenue) * 100 AS profit_margin
FROM healthcare_raw
WHERE total_patient_revenue > 0
ORDER BY profit_margin DESC
LIMIT 10;

# case 2: Which Hospitals Are Loss Making?
SELECT
    hospital_name,
    state_code,
    net_income_from_service_to_patients,
    total_patient_revenue
FROM healthcare_raw
WHERE net_income_from_service_to_patients < 0
ORDER BY net_income_from_service_to_patients ASC;

# case 3: Which states generate the highest hospital net income overall?
SELECT
    state_code,
    COUNT(*) AS total_hospitals,
    SUM(net_income_from_service_to_patients) AS total_state_net_income,
    AVG(net_income_from_service_to_patients) AS avg_hospital_net_income
FROM healthcare_raw
GROUP BY state_code
ORDER BY total_state_net_income DESC;

# case 4: Which hospitals generate highest revenue relative to cost?
SELECT
    hospital_name,
    state_code,
    total_costs,
    total_patient_revenue,
    total_patient_revenue / total_costs AS revenue_to_cost_ratio
FROM healthcare_raw
WHERE total_costs > 0
ORDER BY revenue_to_cost_ratio DESC
LIMIT 10;

# case 5: Which hospitals convert revenue into profit most efficiently?
SELECT
    hospital_name,
    state_code,
    net_income_from_service_to_patients,
    total_patient_revenue,
    (net_income_from_service_to_patients / total_patient_revenue) * 100 AS profit_margin_pct
FROM healthcare_raw
WHERE total_patient_revenue > 0
ORDER BY profit_margin_pct DESC
LIMIT 10;

# case 6: Which states generate the most hospital profit overall?
SELECT
    state_code,
    COUNT(*) AS hospital_count,
    SUM(net_income_from_service_to_patients) AS total_state_profit,
    AVG(net_income_from_service_to_patients) AS avg_hospital_profit
FROM healthcare_raw
GROUP BY state_code
ORDER BY total_state_profit DESC;

# case 7:  Are hospitals using beds efficiently? and Are high bed hospitals actually profitable?
SELECT
    hospital_name,
    state_code,
    number_of_beds,
    total_costs,
    total_patient_revenue,

    (total_patient_revenue / number_of_beds) AS revenue_per_bed,
    (total_costs / number_of_beds) AS cost_per_bed

FROM healthcare_raw
WHERE number_of_beds > 0
ORDER BY revenue_per_bed DESC;








