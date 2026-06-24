SELECT
    rooms.booking_reference,
    rooms.booked_at,
    rooms.start_date,
    rooms.end_date,
    rooms.booking_status,
    rooms.room_fee AS booking_price,
    hotels.commission_percentage,
    rooms.organisation_id,
    rooms.organisation_name,
    rooms.user_id,
    rooms.hotel_id,
    hotels.name AS hotel_name,
    rooms.id AS hotel_room_id,
    rooms.payment_done_at
FROM {{ source('modelisation_sources', 'rooms') }} AS rooms
LEFT JOIN {{ source('modelisation_sources', 'hotels') }} AS hotels
    ON hotels.id = rooms.hotel_id