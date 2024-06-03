BEGIN;

CREATE TABLE IF NOT EXISTS board
(
    id            SERIAL PRIMARY KEY,
    user_id       BIGINT,
    title         VARCHAR(255),
    privacy_level VARCHAR(20)
);

COMMIT;