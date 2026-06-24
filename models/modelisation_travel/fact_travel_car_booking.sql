-- flatten main_driver_ids columns to get a user_id column
WITH flattened_car_hires AS (
    SELECT DISTINCT
        booking_reference,
        booked_at,
        start_date,
        end_date,
        booking_status,
        price,
        commission_percentage,
        organisation_id,
        organisation_name,
        JSON_VALUE(user_id) AS user_id,
        car_rental_company_id,
        car_model_name,
        payment_done_at       
    FROM {{ source('modelisation_sources', 'car_hires') }}
    CROSS JOIN UNNEST(JSON_EXTRACT_ARRAY(main_driver_ids)) AS user_id --convert JSON to array and then UNNEST
)

SELECT
    car_hires.booking_reference,
    car_hires.booked_at,
    car_hires.start_date,
    car_hires.end_date,
    car_hires.booking_status,
    car_hires.price AS booking_price,
    car_hires.commission_percentage,
    car_hires.organisation_id,
    car_hires.organisation_name,
    car_hires.user_id,
    car_hires.car_rental_company_id,
    car_rental_companies.name AS car_rental_company_name,
    car_hires.car_model_name,
    car_hires.payment_done_at
FROM flattened_car_hires AS car_hires
LEFT JOIN {{ source('modelisation_sources', 'car_rental_companies') }} AS car_rental_companies
    ON car_hires.car_rental_company_id = car_rental_companies.id