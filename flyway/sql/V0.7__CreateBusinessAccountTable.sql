BEGIN;

CREATE TABLE IF NOT EXISTS business_account
(
    id            SERIAL PRIMARY KEY,
    user_id       BIGINT,
    business_name VARCHAR(255),
    catalog_url   VARCHAR(255)
);

COMMIT;