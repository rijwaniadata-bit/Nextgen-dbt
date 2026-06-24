WITH hotel_bookings_payments AS (
    -- use distinct because income is per booking_ref (and not booking_ref x user_id)
    SELECT DISTINCT
        booking_reference,
        'hotel' AS product_type,
        booking_price * commission_percentage AS booking_income,
        DATE(payment_done_at) AS day,
        organisation_id,
        organisation_name,
    FROM {{ ref('fact_travel_hotel_booking') }}
    WHERE booking_status = 'VALIDATED'
        AND payment_done_at IS NOT NULL
)

, car_bookings_payments AS (
    -- use distinct because income is per booking_ref (and not booking_ref x user_id)
    SELECT DISTINCT
        booking_reference,
        'car' AS product_type,
        booking_price * commission_percentage AS booking_income,
        DATE(payment_done_at) AS day,
        organisation_id,
        organisation_name,
    FROM {{ ref('fact_travel_car_booking') }}
    WHERE booking_status = 'VALIDATED'
        AND payment_done_at IS NOT NULL
)

SELECT 
    day,
    product_type,
    SUM(booking_income) AS income, 
    organisation_id,
    organisation_name,
FROM (
    SELECT booking_reference, product_type, booking_income, day, organisation_id, organisation_name FROM hotel_bookings_payments
    UNION ALL 
    SELECT booking_reference, product_type, booking_income, day, organisation_id, organisation_name FROM car_bookings_payments
)
GROUP BY 1, 2, 4, 5