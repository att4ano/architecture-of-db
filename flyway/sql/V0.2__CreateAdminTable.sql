BEGIN;

CREATE TABLE IF NOT EXISTS admins
(
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(255),
    password_hash VARCHAR(255)
);

COMMIT;