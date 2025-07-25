
-- 1. Most Common Dispute Reasons
SELECT dispute_reason, COUNT(*) AS total_cases
FROM chargeback_disputes
GROUP BY dispute_reason
ORDER BY total_cases DESC;

-- 2. Average Response Time by Industry
SELECT industry, ROUND(AVG(response_time_days), 2) AS avg_response_time
FROM chargeback_disputes
GROUP BY industry
ORDER BY avg_response_time DESC;

-- 3. Monthly Trend in Dispute Volume
SELECT 
    STRFTIME('%Y-%m', transaction_date) AS month,
    COUNT(*) AS total_disputes
FROM chargeback_disputes
GROUP BY month
ORDER BY month;

-- 4. Total Dispute Amount by Industry
SELECT industry, SUM(amount) AS total_disputed_amount
FROM chargeback_disputes
GROUP BY industry
ORDER BY total_disputed_amount DESC;

-- 5. Top Customers by Number of Disputes
SELECT customer_id, COUNT(*) AS dispute_count
FROM chargeback_disputes
GROUP BY customer_id
ORDER BY dispute_count DESC
LIMIT 10;

-- 6. Clients with Highest Win Rates
SELECT 
    customer_id,
    COUNT(*) AS total_disputes,
    SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) AS won_cases,
    ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_rate
FROM chargeback_disputes
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY win_rate DESC
LIMIT 10;

-- 7. Dispute Rejection Rate by Reason
SELECT 
    dispute_reason,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN status = 'Rejected' THEN 1 ELSE 0 END) AS rejected_cases,
    ROUND(100.0 * SUM(CASE WHEN status = 'Rejected' THEN 1 ELSE 0 END) / COUNT(*), 2) AS rejection_rate
FROM chargeback_disputes
GROUP BY dispute_reason
ORDER BY rejection_rate DESC;

-- 8. Running Total of Disputes Over Time
SELECT 
    transaction_date,
    COUNT(*) AS daily_disputes,
    SUM(COUNT(*)) OVER (ORDER BY transaction_date) AS running_total
FROM chargeback_disputes
GROUP BY transaction_date
ORDER BY transaction_date;

-- 9. Customer's First and Last Dispute Dates
SELECT 
    customer_id,
    MIN(transaction_date) AS first_dispute,
    MAX(transaction_date) AS last_dispute,
    COUNT(*) AS total_disputes
FROM chargeback_disputes
GROUP BY customer_id;

-- 10. Industry with Highest Win Rate
SELECT 
    industry,
    ROUND(100.0 * SUM(CASE WHEN outcome = 'Won' THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_rate
FROM chargeback_disputes
GROUP BY industry
ORDER BY win_rate DESC;
