BEGIN;

CREATE TABLE IF NOT EXISTS users
(
    id                SERIAL PRIMARY KEY,
    email             VARCHAR(255),
    phone_number      VARCHAR(255),
    username          VARCHAR(255),
    password_hash     VARCHAR(255),
    profile_photo_url VARCHAR(255),
    description       VARCHAR(255)
);

COMMIT;