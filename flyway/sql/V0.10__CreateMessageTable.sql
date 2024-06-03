BEGIN;

CREATE TABLE IF NOT EXISTS message
(
    id          SERIAL PRIMARY KEY,
    sender_id   BIGINT,
    receiver_id BIGINT,
    content     VARCHAR(255),
    times   DATE
);

COMMIT;