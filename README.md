# FinTech-LTV-Project
Fintech Digital Wallet — Customer LTV Analysis

End-to-end SQL + Power BI project analyzing a 7,000-row digital wallet dataset to uncover the drivers behind customer lifetime value (LTV).

📌 Overview

This project explores customer behavior for a fictional digital wallet platform, using MySQL for data cleaning and exploratory analysis, and Power BI for visualization. The goal was to identify which customer attributes — demographics, engagement, referrals, loyalty, and support experience — actually drive LTV, and which commonly assumed drivers don't hold up.

🗂️ Dataset


Rows: 7,000 customers
Columns: 20 (demographics, transaction behavior, loyalty/referral activity, support interactions, LTV)
Tool: MySQL 8.0


🛠️ Tech Stack


SQL (MySQL 8.0) — data ingestion, cleaning, and exploratory analysis
Power BI — dashboard and visual storytelling
Techniques used: aggregations, GROUP BY segmentation, CASE statements, null audits, outlier detection


🔍 Project Workflow


Database & Table Setup — schema design for 20-column customer dataset
Data Ingestion — bulk load via LOAD DATA INFILE, row count validation
Data Cleaning — primary key enforcement, null audits across all columns, categorical value validation
Exploratory Data Analysis

Demographic distribution (age, location, income)
Age group vs. LTV
Location × income segmentation
Payment method analysis (including payment method × age)
App usage frequency vs. LTV
Referral program impact
Loyalty points vs. LTV
Cashback thresholds vs. LTV
Support tickets & resolution time vs. satisfaction
Retention (active days) and recency (days since last transaction) vs. LTV
Top/bottom spender and high-LTV customer outlier detection



Power BI Dashboard — visualizing segments, trends, and outliers for stakeholder-ready reporting


💡 Key Insights


Middle-income customers, not high-income ones, deliver the highest average LTV.
Suburban customers marginally outperform urban and rural segments.
Daily app usage does not equal highest LTV — weekly engagement shows stronger value, suggesting quality of engagement matters more than frequency.
Referral count is not linearly tied to LTV — zero-referral (organic) customers are among the most valuable; heavy referrers show diminishing returns.
Loyalty points and cashback have threshold effects — specific bands drive outsized LTV, with sharp drop-offs just beyond them.
Maximum activity ≠ maximum value — customers active ~360 days outperform those active the full 365, hinting at low-value micro-transactors among "always-on" users.
Recency reveals two customer archetypes: recently inactive high-value customers (strong re-engagement targets) vs. long-dormant low-value customers (likely churned).
