WITH travel_income_monthly AS (
    SELECT
        DATE_TRUNC(day, MONTH) AS month,
        CASE 
            WHEN product_type = 'car' THEN 'TRAVEL_CAR'
            WHEN product_type = 'hotel' THEN 'TRAVEL_HOTEL'
            ELSE NULL
        END AS product_type,
        ROUND(SUM(income), 2) AS income
    FROM {{ ref('fact_travel_income') }}
    GROUP BY 1, 2
)

, corpo_income_monnthly AS (
    SELECT
        month,
        'CORPO_SUBSCRIPTION' AS product_type,
        ROUND(SUM(income), 2) AS income
    FROM {{ ref('fact_corpo_subscription_income') }}
    GROUP BY 1, 2  
)

SELECT
    month,
    product_type,
    income
FROM (
    SELECT month, product_type, income FROM travel_income_monthly
    UNION ALL
    SELECT month, product_type, income FROM corpo_income_monnthly
)
ORDER BY 1, 2