BEGIN;

CREATE TABLE IF NOT EXISTS notification
(
    id         SERIAL PRIMARY KEY,
    user_id    BIGINT,
    type       VARCHAR(20),
    message_id BIGINT,
    seen       BOOLEAN
);

COMMIT;