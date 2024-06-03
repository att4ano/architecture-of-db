BEGIN;

CREATE TABLE IF NOT EXISTS pin
(
    id          SERIAL PRIMARY KEY,
    board_id    BIGINT,
    user_id     BIGINT,
    media_url   VARCHAR(255),
    description VARCHAR(255)
);

COMMIT;