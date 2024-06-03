BEGIN;

CREATE TABLE IF NOT EXISTS interaction
(
    id      SERIAL PRIMARY KEY,
    user_id BIGINT,
    pin_id  BIGINT,
    action  VARCHAR(20)
);

COMMIT;