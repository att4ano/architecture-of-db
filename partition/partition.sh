#!/bin/bash

user="${POSTGRES_USER}"
password="${POSTGRES_PASSWORD}"

export PGPASSWORD="${password}"

psql -h db5 -U "${user}" -d postgres -W << EOF

BEGIN;

CREATE TABLE IF NOT EXISTS interaction_like (
    CHECK (action = 'like')
) INHERITS (interaction);

CREATE TABLE IF NOT EXISTS interaction_save (
    CHECK (action = 'save')
) INHERITS (interaction);

CREATE TABLE IF NOT EXISTS interaction_comment (
    CHECK (action = 'comment')
) INHERITS (interaction);

CREATE INDEX idx_interaction_like_action ON interaction_like (action);
CREATE INDEX idx_interaction_save_action ON interaction_save (action);
CREATE INDEX idx_interaction_comment_action ON interaction_comment (action);

INSERT INTO interaction_like (id, user_id, pin_id, action)
SELECT id, user_id, pin_id, action
FROM interaction
WHERE action = 'like';

INSERT INTO interaction_save (id, user_id, pin_id, action)
SELECT id, user_id, pin_id, action
FROM interaction
WHERE action = 'save';

INSERT INTO interaction_comment (id, user_id, pin_id, action)
SELECT id, user_id, pin_id, action
FROM interaction
WHERE action = 'comment';

COMMIT;

EOF

unset PGPASSWORD