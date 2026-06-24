-- The first month ie the subscription month, we bill the price_per_month "au prorata" des jours restants
WITH first_month_income AS (
    SELECT 
        month,
        organisation_id,
        organisation_name,
        -- income as prorata of remaining days in first month
        ROUND((price_per_month / total_days_in_month) * remaining_days_in_month, 2) AS income,
        pricing_plan
    FROM (
        SELECT
            organisations.id AS organisation_id,
            organisation_name,
            DATE_TRUNC(subscribed_at, MONTH) AS month,
            EXTRACT(DAY FROM LAST_DAY(subscribed_at, MONTH)) AS total_days_in_month,
            EXTRACT(DAY FROM LAST_DAY(subscribed_at, MONTH)) - EXTRACT(DAY FROM subscribed_at) AS remaining_days_in_month,
            price_per_month,
            pricing_plan        
        FROM {{ source('modelisation_sources', 'organisations') }}
    )
)

-- normal months, the income is just the price per month
, regular_month_income AS (
    SELECT 
        calendrier_months.month,
        organisations.id AS organisation_id,
        organisations.organisation_name,
        organisations.price_per_month AS income,
        organisations.pricing_plan
    FROM {{ source('modelisation_sources', 'organisations') }} AS organisations
    JOIN {{ source('modelisation_sources', 'calendrier_months') }} AS calendrier_months
        ON calendrier_months.month > organisations.subscribed_at 
)

SELECT
    month, 
    organisation_id, 
    organisation_name, 
    income, 
    pricing_plan
FROM (
    SELECT month, organisation_id, organisation_name, income, pricing_plan FROM first_month_income
    UNION ALL
    SELECT month, organisation_id, organisation_name, income, pricing_plan FROM regular_month_income
)
ORDER BY 
    month, organisation_id