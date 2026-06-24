SELECT
    users.id AS user_id, -- pk
    users.first_name,
    users.last_name,
    users.email,
    users.phone_number,
    users.organisation_id,
    organisations.organisation_name,
    organisations.pricing_plan,
    organisations.subscribed_at
FROM {{ source('modelisation_sources', 'users') }} AS users
LEFT JOIN {{ source('modelisation_sources', 'organisations') }} AS organisations
    ON users.organisation_id = organisations.id