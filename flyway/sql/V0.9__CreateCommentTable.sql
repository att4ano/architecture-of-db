BEGIN;

CREATE TABLE IF NOT EXISTS comment
(
    id        SERIAL PRIMARY KEY,
    user_id   BIGINT,
    pin_id    BIGINT,
    content   VARCHAR(255),
    times DATE
);

COMMIT;