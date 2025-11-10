# Library Customer and Inventory Analysis Report

![Library Analytics Dashboard Gif](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMzRvaWRuOGdqYmRidnkzbzdpZTlzNWhyeGlzaHZ1ZnFpNmpyZHA2NCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/fsXOS3oBboiYf6fSsY/giphy.gif)

## Executive Summary

This report presents a comprehensive exploratory data analysis (EDA) of a library's customer, inventory, and sales performance. A robust SQL-based approach was used to extract key operational, customer, and inventory insights to support strategic decision-making at the director level.

## Database Structure Overview

The library management data is organized across three primary tables:

- **Customers:** Stores customer details including demographic information.
- **Books:** Captures inventory with details like title, author, genre, price, published year, and stock counts.
- **Orders:** Logs transactions, including book quantities and monetary values.

A consolidated view (`masterlibrarydata`) combines all three for cross-sectional analytics.

## Analytical Queries and Insights

### Revenue and Sales Performance

- **Total Revenue:** Calculated to monitor library sales.
- **Top-Spending Customer:** Identifies the customer who contributed the most revenue, useful for loyalty programs.
- **High-Value Orders:** Lists transactions where the order value exceeds a threshold (e.g., 20 currency units).

### Inventory and Stock Analysis

- **Books with Low Stock:** Highlights titles that need reordering (e.g., stock below 5 units).
- **Most Expensive Books:** Assists in inventory valuation and risk assessment.
- **Books by Year:** Supports collection diversity by detailing recent titles (post-1950).
- **Total Stock Remaining:** Accounts for all inventory minus orders, ensuring supply meets demand.

### Customer Segmentation and Behavior

- **Repeat/Loyal Customers:** Quantifies users making frequent or bulk purchases (e.g., ≥7 orders).
- **First-Time Buyers:** Monitors onboarding effectiveness and promotional impact.
- **High Initial Orders:** Tracks customers purchasing high volume (e.g., 10+ books on the first order).

### Genre and Author Trends

- **Books Sold by Author:** Shows which authors drive most sales.
- **Genre Performance:** Average price and sales volume by genre highlight trends and popularity.
- **Top 10 Best-Selling Books:** Directs procurement strategies and targeted marketing.

### Geographic and Demographic Patterns

- **Customer Distribution:** Lists key locations (city/country) with active library members.
- **Order Volume by Region:** Directs outreach and expansion plans.

## Actionable Business Recommendations

- **Inventory Optimization:** Regularly monitor and restock top-selling or low-inventory books to avoid lost sales.
- **Customer Retention:** Develop targeted loyalty programs for high-spending and recurring customers.
- **Genre Expansion:** Invest in popular genres/authors based on demand trends.
- **Data-Driven Promotions:** Target first-time buyers with special offers to encourage repeat business.




If any issue with the report or want some changes to be made please contact - utkarshpal14@gmial.com
