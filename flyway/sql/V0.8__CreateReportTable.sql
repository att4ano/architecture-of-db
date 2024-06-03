BEGIN;

CREATE TABLE IF NOT EXISTS report
(
    id               SERIAL PRIMARY KEY,
    admin_id         BIGINT,
    reporter_id      BIGINT,
    reported_user_id BIGINT,
    reported_pin_id  BIGINT,
    description      VARCHAR(255)
);

COMMIT;