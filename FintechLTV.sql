-- ================================================================
-- PROJECT  : Fintech Digital Wallet — Customer LTV Analysis
-- DATABASE : fintech
-- AUTHOR   : Nithin Sebastian
-- TOOL     : MySQL 8.0
-- ================================================================


-- ================================================================
-- SECTION 1: DATABASE & TABLE SETUP
-- ================================================================

CREATE DATABASE fintech;
USE fintech;

CREATE TABLE fin_ltv (
    Customer_ID                  VARCHAR(100),
    Age                          FLOAT,
    Location                     VARCHAR(100),
    Income_Level                 VARCHAR(100),
    Total_Transactions           FLOAT,
    Avg_Transaction_Value        FLOAT,
    Max_Transaction_Value        FLOAT,
    Min_Transaction_Value        FLOAT,
    Total_Spent                  FLOAT,
    Active_Days                  FLOAT,
    Last_Transaction_Days_Ago    FLOAT,
    Loyalty_Points_Earned        FLOAT,
    Referral_Count               FLOAT,
    Cashback_Received            FLOAT,
    App_Usage_Frequency          VARCHAR(100),
    Preferred_Payment_Method     VARCHAR(100),
    Support_Tickets_Raised       FLOAT,
    Issue_Resolution_Time        FLOAT,
    Customer_Satisfaction_Score  FLOAT,
    LTV                          FLOAT
);


-- ================================================================
-- SECTION 2: DATA INGESTION
-- ================================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/digital_wallet_ltv_dataset.csv'
INTO TABLE fin_ltv
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Customer_ID,
    Age,
    Location,
    Income_Level,
    Total_Transactions,
    Avg_Transaction_Value,
    Max_Transaction_Value,
    Min_Transaction_Value,
    Total_Spent,
    Active_Days,
    Last_Transaction_Days_Ago,
    Loyalty_Points_Earned,
    Referral_Count,
    Cashback_Received,
    App_Usage_Frequency,
    Preferred_Payment_Method,
    Support_Tickets_Raised,
    Issue_Resolution_Time,
    Customer_Satisfaction_Score,
    LTV
);

-- Quick row count check
SELECT COUNT(*) AS total_rows FROM fin_ltv;
-- Result: 7,000

-- Duplicate Customer ID check
SELECT
    Customer_ID,
    COUNT(*) AS occurrences
FROM fin_ltv
GROUP BY Customer_ID
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


-- ================================================================
-- SECTION 3: DATA CLEANING
-- ================================================================

-- Step 1: Add primary key
ALTER TABLE fin_ltv
ADD PRIMARY KEY (Customer_ID);

-- Step 2: Null audit across all 20 columns
SELECT
    SUM(CASE WHEN Customer_ID                 IS NULL OR Customer_ID                 = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN Age                         IS NULL                                     THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN Location                    IS NULL OR Location                    = '' THEN 1 ELSE 0 END) AS missing_location,
    SUM(CASE WHEN Income_Level                IS NULL OR Income_Level                = '' THEN 1 ELSE 0 END) AS missing_income_level,
    SUM(CASE WHEN Total_Transactions          IS NULL                                     THEN 1 ELSE 0 END) AS missing_total_transactions,
    SUM(CASE WHEN Avg_Transaction_Value       IS NULL                                     THEN 1 ELSE 0 END) AS missing_avg_transaction_value,
    SUM(CASE WHEN Max_Transaction_Value       IS NULL                                     THEN 1 ELSE 0 END) AS missing_max_transaction_value,
    SUM(CASE WHEN Min_Transaction_Value       IS NULL                                     THEN 1 ELSE 0 END) AS missing_min_transaction_value,
    SUM(CASE WHEN Total_Spent                 IS NULL                                     THEN 1 ELSE 0 END) AS missing_total_spent,
    SUM(CASE WHEN Active_Days                 IS NULL                                     THEN 1 ELSE 0 END) AS missing_active_days,
    SUM(CASE WHEN Last_Transaction_Days_Ago   IS NULL                                     THEN 1 ELSE 0 END) AS missing_last_transaction_days_ago,
    SUM(CASE WHEN Loyalty_Points_Earned       IS NULL                                     THEN 1 ELSE 0 END) AS missing_loyalty_points_earned,
    SUM(CASE WHEN Referral_Count              IS NULL                                     THEN 1 ELSE 0 END) AS missing_referral_count,
    SUM(CASE WHEN Cashback_Received           IS NULL                                     THEN 1 ELSE 0 END) AS missing_cashback_received,
    SUM(CASE WHEN App_Usage_Frequency         IS NULL OR App_Usage_Frequency         = '' THEN 1 ELSE 0 END) AS missing_app_usage_frequency,
    SUM(CASE WHEN Preferred_Payment_Method    IS NULL OR Preferred_Payment_Method    = '' THEN 1 ELSE 0 END) AS missing_preferred_payment_method,
    SUM(CASE WHEN Support_Tickets_Raised      IS NULL                                     THEN 1 ELSE 0 END) AS missing_support_tickets_raised,
    SUM(CASE WHEN Issue_Resolution_Time       IS NULL                                     THEN 1 ELSE 0 END) AS missing_issue_resolution_time,
    SUM(CASE WHEN Customer_Satisfaction_Score IS NULL                                     THEN 1 ELSE 0 END) AS missing_satisfaction_score,
    SUM(CASE WHEN LTV                         IS NULL                                     THEN 1 ELSE 0 END) AS missing_ltv
FROM fin_ltv;

-- Step 3: Validate categorical columns — confirm distinct values
SELECT DISTINCT Location             FROM fin_ltv;  -- Urban, Suburban, Rural
SELECT DISTINCT Income_Level         FROM fin_ltv;  -- Low, Middle, High
SELECT DISTINCT App_Usage_Frequency  FROM fin_ltv;  -- Daily, Weekly, Monthly
SELECT DISTINCT Preferred_Payment_Method FROM fin_ltv;  -- Credit Card, Debit Card, UPI, Wallet Balance

-- Step 4: Confirm Customer_Satisfaction_Score range
SELECT
    MIN(Customer_Satisfaction_Score) AS min_score,
    MAX(Customer_Satisfaction_Score) AS max_score
FROM fin_ltv;
-- Range: 1 to 10

-- Confirm final schema
DESCRIBE fin_ltv;


-- ================================================================
-- SECTION 4: EXPLORATORY DATA ANALYSIS
-- ================================================================

-- ------------------------------------------------------------
-- 4.1 Dataset Overview — Size, age range, and spend range
-- ------------------------------------------------------------
SELECT COUNT(*)             AS total_customers FROM fin_ltv;
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers FROM fin_ltv;
-- Both return 7,000 — no duplicates

SELECT
    ROUND(AVG(Age), 1)            AS avg_age,
    MIN(Age)                      AS min_age,
    MAX(Age)                      AS max_age
FROM fin_ltv;
-- avg_age: 42.6 | min_age: 16 | max_age: 69

SELECT
    ROUND(AVG(Total_Spent), 0)    AS avg_total_spent,
    MIN(Total_Spent)              AS min_total_spent,
    MAX(Total_Spent)              AS max_total_spent
FROM fin_ltv;
-- avg: ~5M | min: 1,498 | max: 19.5M — very wide distribution

SELECT
    ROUND(AVG(LTV), 0)            AS avg_ltv,
    MIN(LTV)                      AS min_ltv,
    MAX(LTV)                      AS max_ltv
FROM fin_ltv;
-- avg_ltv: 511,920 | min: 3,771 | max: 1,956,990


-- ------------------------------------------------------------
-- 4.2 Demographic Distribution
-- ------------------------------------------------------------
SELECT Location, COUNT(*) AS count
FROM fin_ltv
GROUP BY Location
ORDER BY count DESC;
-- Urban: 2,368 | Suburban: 2,320 | Rural: 2,312
-- Finding: nearly even three-way split — no geographic concentration bias

SELECT Income_Level, COUNT(*) AS count
FROM fin_ltv
GROUP BY Income_Level
ORDER BY count DESC;
-- Middle: 2,391 | Low: 2,311 | High: 2,298
-- Finding: balanced across income bands — no skew in customer acquisition

SELECT App_Usage_Frequency, COUNT(*) AS count
FROM fin_ltv
GROUP BY App_Usage_Frequency
ORDER BY count DESC;
-- Daily: 2,346 | Weekly: 2,325 | Monthly: 2,329
-- Finding: usage frequency is evenly distributed — no dominant engagement pattern


-- ------------------------------------------------------------
-- 4.3 Age Group Analysis — Distribution and LTV
-- ------------------------------------------------------------
SELECT
    FLOOR(Age / 10) * 10   AS age_group,
    COUNT(*)               AS customer_count,
    ROUND(AVG(LTV), 0)     AS avg_ltv
FROM fin_ltv
GROUP BY age_group
ORDER BY age_group;

-- Findings:
-- Age 10s: only 519 customers (youngest cohort, smallest group) — avg LTV 475,889 (lowest)
-- Age 20s and 30s: largest customer counts (1,246 and 1,326) — acquisition peaks early
-- Age 40s: highest avg LTV at 523,286 — mid-career earners at peak spending power
-- Age 50s and 60s: stable LTV (~507K–517K) — retained but not highest value
-- Takeaway: acquisition is front-loaded but value peaks in the 40s


-- ------------------------------------------------------------
-- 4.4 Location and Income Segmentation
-- ------------------------------------------------------------
SELECT Location, ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Location
ORDER BY avg_ltv DESC;
-- Suburban: 520,381 | Rural: 507,814 | Urban: 507,639
-- Finding: suburban customers marginally outperform urban and rural — counter-intuitive

SELECT Income_Level, ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Income_Level
ORDER BY avg_ltv DESC;
-- Middle: 522,912 | Low: 510,054 | High: 502,359
-- Finding: middle-income customers have the highest avg LTV — high-income customers do not
--          spend proportionally more, suggesting ceiling on transaction-driven LTV

SELECT
    Location,
    Income_Level,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Location, Income_Level
ORDER BY Location, Income_Level;

-- Findings:
-- Rural + Middle income: 525,495 — highest LTV segment
-- Rural + High income:   477,065 — surprisingly the lowest segment overall
-- Suburban + Middle:     530,019 — consistently strong across income bands
-- Urban segments cluster tightly (499K–513K) — urban LTV is stable but not exceptional
-- Takeaway: middle income across all locations delivers the best LTV
--           targeting high-income urban users may be less effective than expected


-- ------------------------------------------------------------
-- 4.5 Payment Method Analysis
-- ------------------------------------------------------------
SELECT
    Preferred_Payment_Method,
    COUNT(*)               AS customer_count,
    ROUND(AVG(LTV), 0)     AS avg_ltv
FROM fin_ltv
GROUP BY Preferred_Payment_Method
ORDER BY avg_ltv DESC;

-- Findings:
-- Credit Card:    avg LTV 521,824 | count 1,712
-- Wallet Balance: avg LTV 509,799 | count 1,736
-- UPI:            avg LTV 508,490 | count 1,791
-- Debit Card:     avg LTV 507,869 | count 1,761
-- Customer counts are near-equal across methods (~1,700–1,800 each)
-- Credit Card users are modestly more valuable but the gap is not dramatic
-- Takeaway: no single method dominates — platform should support all four equally,
--           with premium incentives nudging users toward Credit Card


-- ================================================================
-- PAYMENT METHOD × AGE GROUP — Avg LTV breakdown
-- ================================================================
SELECT
    Age,
    Preferred_Payment_Method,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Age, Preferred_Payment_Method
ORDER BY Age;

-- ================================================================
-- KEY FINDINGS — Payment method × age
-- ================================================================
-- UPI and Wallet Balance lead in younger cohorts (16–25)
-- Credit Card strengthens in mid-career brackets (40–59)
-- No payment method consistently dominates across all ages

-- YOUNG ADULTS (16–25)
-- Age 16: Wallet Balance leads (462K) | Credit Card lowest (405K)
-- Age 17: UPI peaks at 594K — highest UPI value in this band
-- Age 18: UPI (639K) and Wallet Balance (601K) dominate; Credit Card drops to 333K (lowest overall)
-- Age 20: Credit Card surges to 640K — band high; UPI also strong at 611K
-- Age 25: Wallet Balance spikes to 631K; Credit Card drops to 379K

-- WORKING AGE — EARLY (26–40)
-- Age 26: Debit Card leads (586K); Wallet Balance collapses to 305K — band low
-- Age 27: Credit Card highest at 647K; all methods relatively balanced
-- Age 37: Debit Card peaks at 655K; Credit Card also strong at 572K
-- Age 39: UPI rebounds to 603K after a mid-band dip

-- WORKING AGE — PEAK (41–55)
-- Age 43: Credit Card dataset high at 660K
-- Age 45: UPI spikes to 685K — one of the highest UPI values overall
-- Age 46: Credit Card strong at 676K; Debit Card drops sharply to 363K
-- Age 48: Debit Card peaks at 688K — highest Debit Card value in entire dataset
-- Age 51: Credit Card at 676K; Debit Card softens to 462K

-- MATURE WORKING AGE (56–69)
-- Age 58: Most uniformly high-spending age group — Credit Card 664K, UPI 678K, Debit Card 631K
-- Age 60: Wallet Balance spikes to 723K — highest Wallet Balance in entire dataset
-- Age 69: Wallet Balance elevated (573K); Credit Card softest at 464K

-- OUTLIERS
-- Highest Credit Card avg  → Age 43: 660K
-- Highest Debit Card avg   → Age 48: 688K
-- Highest UPI avg          → Age 45: 685K
-- Highest Wallet Balance   → Age 60: 723K
-- Lowest Credit Card avg   → Age 18: 333K
-- Lowest Debit Card avg    → Age 46: 363K
-- Lowest Wallet Balance    → Age 26: 305K


-- ------------------------------------------------------------
-- 4.6 App Usage Frequency
-- ------------------------------------------------------------
SELECT
    App_Usage_Frequency,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY App_Usage_Frequency
ORDER BY avg_ltv DESC;
-- Weekly:  514,094
-- Monthly: 512,932
-- Daily:   508,761
-- Finding: daily users do NOT have the highest LTV — counter-intuitive
--          weekly engagement may reflect quality usage rather than habitual open-and-close
--          Takeaway: engagement quality matters more than raw frequency


-- ------------------------------------------------------------
-- 4.7 Referral Program Analysis
-- ------------------------------------------------------------
SELECT
    Referral_Count,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Referral_Count
ORDER BY Referral_Count;

-- Findings:
-- Referral 0:  avg LTV 565,612 — highest of any referral count
-- Referral 20: avg LTV 595,923 — mid-band spike (possible power-user cohort)
-- Referral 24: avg LTV 580,561 — another secondary peak
-- Referral 36: avg LTV 404,943 — sharpest dip in dataset
-- Referral 50: avg LTV 476,686 — high referrers trend lower
-- Takeaway: referral count does not linearly drive LTV
--           zero-referral customers are most valuable — likely organic high-spenders
--           heavy referrers (40–50) show diminishing returns — possible incentive-gaming behaviour


-- ------------------------------------------------------------
-- 4.8 Loyalty Points vs LTV
-- ------------------------------------------------------------
SELECT
    Loyalty_Points_Earned,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Loyalty_Points_Earned
ORDER BY Loyalty_Points_Earned DESC
LIMIT 10;

-- Findings:
-- Loyalty 5,000: avg LTV 711,675
-- Loyalty 4,999: avg LTV  33,937 — extreme dip (possible redemption reset or data anomaly)
-- Loyalty 4,992: avg LTV 808,594
-- Loyalty 4,989: avg LTV 1,080,608 — highest in dataset
-- Takeaway: LTV is not linear across loyalty tiers
--           specific thresholds (4,989–4,992) deliver outsized value
--           4,999 is a likely anomaly — worth investigating before using in a model
--           reward program design should target the 4,989–4,992 threshold band


-- ------------------------------------------------------------
-- 4.9 Cashback Received vs LTV
-- ------------------------------------------------------------
SELECT
    Cashback_Received,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Cashback_Received
ORDER BY Cashback_Received DESC
LIMIT 10;

-- Findings:
-- Cashback 4,993.14: avg LTV 887,414 — highest in dataset
-- Cashback 4,996.74: avg LTV 816,712 — second peak
-- Cashback 4,997.28: avg LTV 211,743 — sharpest drop
-- Cashback 4,999.70: avg LTV 338,544
-- Takeaway: cashback thresholds around 4,993–4,997 act as inflection points
--           customers just above 4,997 show a dramatic LTV drop — possibly program tier boundary
--           non-linear behaviour suggests customers optimise cashback strategically


-- ------------------------------------------------------------
-- 4.10 Support Tickets vs Customer Satisfaction
-- ------------------------------------------------------------
SELECT
    Support_Tickets_Raised,
    ROUND(AVG(Customer_Satisfaction_Score), 2) AS avg_satisfaction
FROM fin_ltv
GROUP BY Support_Tickets_Raised
ORDER BY Support_Tickets_Raised;

-- Findings:
-- 0 tickets: avg satisfaction 5.38 — not the highest
-- 4 tickets: avg satisfaction 5.15 — lowest in dataset
-- 5 tickets: avg satisfaction 5.74
-- 8 tickets: avg satisfaction 5.79 — highest in dataset
-- 15 tickets: avg satisfaction 5.71 — still elevated
-- Takeaway: zero tickets does not equal highest satisfaction
--           customers who engage with support at moderate frequency (5–8 tickets)
--           report the highest satisfaction — active engagement signals responsiveness
--           beyond 15 tickets, satisfaction stabilises rather than declining sharply


-- ------------------------------------------------------------
-- 4.11 Issue Resolution Time vs Customer Satisfaction
-- ------------------------------------------------------------
SELECT
    Issue_Resolution_Time,
    ROUND(AVG(Customer_Satisfaction_Score), 2) AS avg_satisfaction
FROM fin_ltv
GROUP BY Issue_Resolution_Time
ORDER BY Issue_Resolution_Time;

-- Findings:
-- Fast resolution (1–3 units): satisfaction ~5.38–5.43
-- Resolution time 8: satisfaction 5.79 — highest in dataset
-- Resolution time 17: satisfaction 5.33 — drops after the 15-unit mark
-- Takeaway: faster is not always better — structured resolution at moderate timelines
--           (around 8 units) correlates with the best outcomes
--           likely reflects thorough handling rather than rushed closures
--           very long resolution (>15 units) does reduce satisfaction


-- ------------------------------------------------------------
-- 4.12 Retention Analysis — Active Days vs LTV
-- ------------------------------------------------------------
SELECT
    Active_Days,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Active_Days
ORDER BY Active_Days DESC
LIMIT 10;

-- Findings:
-- 360 active days: avg LTV 620,302 — highest in dataset
-- 363 active days: avg LTV 560,713
-- 365 active days (full year): avg LTV 393,132 — surprisingly low
-- 364 active days: avg LTV 357,396 — lowest in top-10 band
-- Takeaway: maximum activity (365 days) does not yield maximum LTV
--           near-daily engagement (~360–363 days) is the sweet spot
--           possible explanation: always-on users may be low-value frequent micro-transactors
--           while 360-day users reflect consistent but purposeful spend patterns


-- ------------------------------------------------------------
-- 4.13 Recency Analysis — Last Transaction Days Ago vs LTV
-- ------------------------------------------------------------
SELECT
    Last_Transaction_Days_Ago,
    ROUND(AVG(LTV), 0) AS avg_ltv
FROM fin_ltv
GROUP BY Last_Transaction_Days_Ago
ORDER BY Last_Transaction_Days_Ago;

-- Findings:
-- Recent inactivity (1–10 days): high LTV — 598K–657K range
-- Mid inactivity peaks: 143 days → 829,838 (highest) | 127 days → 805,029
-- Long inactivity (190+ days): very low LTV (~290K–310K) — likely churned
-- Takeaway: two distinct customer archetypes emerge
--           1. Recently inactive high-value customers — strong re-engagement targets
--           2. Long-dormant low-value customers — likely permanent churn
--           Re-engagement campaigns should prioritise 7–143 day inactive windows


-- ------------------------------------------------------------
-- 4.14 High-Value Customers — Top 10 by LTV
-- ------------------------------------------------------------
SELECT
    Customer_ID,
    LTV,
    Total_Spent,
    Referral_Count,
    Loyalty_Points_Earned
FROM fin_ltv
ORDER BY LTV DESC
LIMIT 10;

-- Findings:
-- All top-10 customers have Total_Spent in the 18.9M–19.5M range
-- Referral counts vary widely (2 to 44) — high LTV is not tied to referral volume
-- Loyalty points range from 432 to 4,981 — no single engagement driver
-- Takeaway: multiple pathways to high LTV (spending volume, referrals, or loyalty)
--           cust_4961 leads with 1,956,990 LTV — balanced across all three dimensions
--           cust_6101 reached top-10 with only 2 referrals — pure spend-driven value
--           cust_3348 holds 4,981 loyalty points — standout programme engagement

-- OUTLIERS
-- Highest LTV:       cust_4961 → 1,956,990
-- Highest referrals: cust_6110 and cust_1980 → 44 each
-- Highest loyalty:   cust_3348 → 4,981 points
-- Lowest referrals in top-10: cust_6101 → only 2


-- ------------------------------------------------------------
-- 4.15 Outlier Detection — Top and Bottom Spenders
-- ------------------------------------------------------------
SELECT Customer_ID, Total_Spent
FROM fin_ltv
ORDER BY Total_Spent DESC
LIMIT 10;
-- Top spender: cust_4961 → 19,467,700
-- All top-10 fall in the 18.9M–19.5M range — no extreme outlier above the rest

SELECT Customer_ID, Total_Spent
FROM fin_ltv
ORDER BY Total_Spent ASC
LIMIT 10;
-- Bottom spender: cust_5336 → 1,498
-- Sharp contrast with top band — bottom-10 all below 4,200
-- Takeaway: spend distribution is highly right-skewed
--           top-10 spenders outspend bottom-10 by ~5,000x
--           LTV modelling should account for this skew (log transform or tier segmentation)


-- ================================================================
-- END OF SCRIPT
-- ================================================================