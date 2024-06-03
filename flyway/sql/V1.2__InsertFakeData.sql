CREATE OR REPLACE FUNCTION insert_fake_users(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_count INT := 0;
    batch_username VARCHAR(255)[];
    batch_password_hash VARCHAR(255)[];
    batch_email VARCHAR(255)[];
    batch_phone_number VARCHAR(255)[];
    batch_profile_photo_url VARCHAR(255)[];
    batch_description VARCHAR(255)[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_username[batch_count] := faker.name();
        batch_password_hash[batch_count] := md5(faker.password());
        batch_email[batch_count] := faker.email();
        batch_phone_number[batch_count] := faker.phone_number();
        batch_profile_photo_url[batch_count] := faker.image_url();
        batch_description[batch_count] := faker.sentence();
        batch_count := batch_count + 1;

        IF batch_count >= batch_size THEN
            INSERT INTO users (username, password_hash, email, phone_number, profile_photo_url, description)
            SELECT unnest(batch_username), unnest(batch_password_hash), unnest(batch_email),
                   unnest(batch_phone_number), unnest(batch_profile_photo_url), unnest(batch_description);
            batch_count := 0;
            batch_username := '{}';
            batch_password_hash := '{}';
            batch_email := '{}';
            batch_phone_number := '{}';
            batch_profile_photo_url := '{}';
            batch_description := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF batch_count > 0 THEN
        INSERT INTO users (username, password_hash, email, phone_number, profile_photo_url, description)
        SELECT unnest(batch_username), unnest(batch_password_hash), unnest(batch_email),
               unnest(batch_phone_number), unnest(batch_profile_photo_url), unnest(batch_description);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_admins(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_username VARCHAR(255)[];
    batch_password_hash VARCHAR(255)[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_username[(i - 1) % batch_size + 1] := faker.name();
        batch_password_hash[(i - 1) % batch_size + 1] := md5(faker.password());

        IF i % batch_size = 0 THEN
            INSERT INTO admins (username, password_hash)
            SELECT unnest(batch_username), unnest(batch_password_hash);
            batch_username := '{}';
            batch_password_hash := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO admins (username, password_hash)
        SELECT unnest(batch_username[1:((i - 1) % batch_size)]), unnest(batch_password_hash[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_boards(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_user_id BIGINT[];
    batch_title VARCHAR(255)[];
    batch_privacy_level VARCHAR(20)[];
    privacy_levels VARCHAR[] := ARRAY['public', 'private'];
BEGIN
    WHILE i <= num_rows LOOP
        batch_user_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_title[(i - 1) % batch_size + 1] := faker.sentence();
        batch_privacy_level[(i - 1) % batch_size + 1] := privacy_levels[floor(random() * array_length(privacy_levels, 1)) + 1];

        IF i % batch_size = 0 THEN
            INSERT INTO board (user_id, title, privacy_level)
            SELECT unnest(batch_user_id), unnest(batch_title), unnest(batch_privacy_level);
            batch_user_id := '{}';
            batch_title := '{}';
            batch_privacy_level := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO board (user_id, title, privacy_level)
        SELECT unnest(batch_user_id[1:((i - 1) % batch_size)]), unnest(batch_title[1:((i - 1) % batch_size)]), unnest(batch_privacy_level[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_pins(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_board_id BIGINT[];
    batch_user_id BIGINT[];
    batch_media_url VARCHAR(255)[];
    batch_description VARCHAR(255)[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_board_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_user_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_media_url[(i - 1) % batch_size + 1] := faker.image_url();
        batch_description[(i - 1) % batch_size + 1] := faker.sentence();

        IF i % batch_size = 0 THEN
            INSERT INTO pin (board_id, user_id, media_url, description)
            SELECT unnest(batch_board_id), unnest(batch_user_id), unnest(batch_media_url), unnest(batch_description);
            batch_board_id := '{}';
            batch_user_id := '{}';
            batch_media_url := '{}';
            batch_description := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO pin (board_id, user_id, media_url, description)
        SELECT unnest(batch_board_id[1:((i - 1) % batch_size)]), unnest(batch_user_id[1:((i - 1) % batch_size)]),
               unnest(batch_media_url[1:((i - 1) % batch_size)]), unnest(batch_description[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_interactions(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_user_id BIGINT[];
    batch_pin_id BIGINT[];
    batch_action VARCHAR(20)[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_user_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_pin_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_action[(i - 1) % batch_size + 1] := CASE floor(random() * 3) + 1
                                                   WHEN 1 THEN 'like'
                                                   WHEN 2 THEN 'comment'
                                                   ELSE 'save'
                                                   END;

        IF i % batch_size = 0 THEN
            INSERT INTO interaction (user_id, pin_id, action)
            SELECT unnest(batch_user_id), unnest(batch_pin_id), unnest(batch_action);
            batch_user_id := '{}';
            batch_pin_id := '{}';
            batch_action := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO interaction (user_id, pin_id, action)
        SELECT unnest(batch_user_id[1:((i - 1) % batch_size)]), unnest(batch_pin_id[1:((i - 1) % batch_size)]),
               unnest(batch_action[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_notifications(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_user_id BIGINT[];
    batch_type VARCHAR(20)[];
    batch_message_id BIGINT[];
    batch_seen BOOLEAN[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_user_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_type[(i - 1) % batch_size + 1] := CASE floor(random() * 3) + 1
                                                WHEN 1 THEN 'like'
                                                WHEN 2 THEN 'comment'
                                                ELSE 'follow'
                                                END;
        batch_message_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_seen[(i - 1) % batch_size + 1] := random() < 0.5;

        IF i % batch_size = 0 THEN
            INSERT INTO notification (user_id, type, message_id, seen)
            SELECT unnest(batch_user_id), unnest(batch_type), unnest(batch_message_id), unnest(batch_seen);
            batch_user_id := '{}';
            batch_type := '{}';
            batch_message_id := '{}';
            batch_seen := '{}';
        END IF;

        i := i + 1;
    END LOOP;
    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO notification (user_id, type, message_id, seen)
        SELECT unnest(batch_user_id[1:((i - 1) % batch_size)]), unnest(batch_type[1:((i - 1) % batch_size)]),
               unnest(batch_message_id[1:((i - 1) % batch_size)]), unnest(batch_seen[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_business_accounts(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_user_id BIGINT[];
    batch_business_name VARCHAR(255)[];
    batch_catalog_url VARCHAR(255)[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_user_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_business_name[(i - 1) % batch_size + 1] := faker.company();
        batch_catalog_url[(i - 1) % batch_size + 1] := faker.url();

        IF i % batch_size = 0 THEN
            INSERT INTO business_account (user_id, business_name, catalog_url)
            SELECT unnest(batch_user_id), unnest(batch_business_name), unnest(batch_catalog_url);
            batch_user_id := '{}';
            batch_business_name := '{}';
            batch_catalog_url := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO business_account (user_id, business_name, catalog_url)
        SELECT unnest(batch_user_id[1:((i - 1) % batch_size)]), unnest(batch_business_name[1:((i - 1) % batch_size)]),
               unnest(batch_catalog_url[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_reports(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_admin_id BIGINT[];
    batch_reporter_id BIGINT[];
    batch_reported_user_id BIGINT[];
    batch_reported_pin_id BIGINT[];
    batch_description VARCHAR(255)[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_admin_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_reporter_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_reported_user_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_reported_pin_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_description[(i - 1) % batch_size + 1] := faker.sentence();

        IF i % batch_size = 0 THEN
            INSERT INTO report (admin_id, reporter_id, reported_user_id, reported_pin_id, description)
            SELECT unnest(batch_admin_id), unnest(batch_reporter_id), unnest(batch_reported_user_id),
                   unnest(batch_reported_pin_id), unnest(batch_description);
            batch_admin_id := '{}';
            batch_reporter_id := '{}';
            batch_reported_user_id := '{}';
            batch_reported_pin_id := '{}';
            batch_description := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO report (admin_id, reporter_id, reported_user_id, reported_pin_id, description)
        SELECT unnest(batch_admin_id[1:((i - 1) % batch_size)]), unnest(batch_reporter_id[1:((i - 1) % batch_size)]),
               unnest(batch_reported_user_id[1:((i - 1) % batch_size)]), unnest(batch_reported_pin_id[1:((i - 1) % batch_size)]),
               unnest(batch_description[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_comments(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_user_id BIGINT[];
    batch_pin_id BIGINT[];
    batch_content VARCHAR(255)[];
    batch_times TIMESTAMP[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_user_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_pin_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_content[(i - 1) % batch_size + 1] := faker.sentence();
        batch_times[(i - 1) % batch_size + 1] := NOW() - ((random() * 365 * 24 * 60 * 60)::INT || ' seconds')::INTERVAL;

        IF i % batch_size = 0 THEN
            INSERT INTO comment (user_id, pin_id, content, times)
            SELECT unnest(batch_user_id), unnest(batch_pin_id), unnest(batch_content), unnest(batch_times);
            batch_user_id := '{}';
            batch_pin_id := '{}';
            batch_content := '{}';
            batch_times := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO comment (user_id, pin_id, content, times)
        SELECT unnest(batch_user_id[1:((i - 1) % batch_size)]), unnest(batch_pin_id[1:((i - 1) % batch_size)]),
               unnest(batch_content[1:((i - 1) % batch_size)]), unnest(batch_times[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_fake_messages(num_rows INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
    batch_size INT := 1000;
    batch_sender_id BIGINT[];
    batch_receiver_id BIGINT[];
    batch_content VARCHAR(255)[];
    batch_times TIMESTAMP[];
BEGIN
    WHILE i <= num_rows LOOP
        batch_sender_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_receiver_id[(i - 1) % batch_size + 1] := floor(random() * 1000000) + 1;
        batch_content[(i - 1) % batch_size + 1] := faker.sentence();
        batch_times[(i - 1) % batch_size + 1] := NOW() - ((random() * 365 * 24 * 60 * 60)::INT || ' seconds')::INTERVAL;

        IF i % batch_size = 0 THEN
            INSERT INTO message (sender_id, receiver_id, content, times)
            SELECT unnest(batch_sender_id), unnest(batch_receiver_id), unnest(batch_content), unnest(batch_times);
            batch_sender_id := '{}';
            batch_receiver_id := '{}';
            batch_content := '{}';
            batch_times := '{}';
        END IF;

        i := i + 1;
    END LOOP;

    IF (i - 1) % batch_size > 0 THEN
        INSERT INTO message (sender_id, receiver_id, content, times)
        SELECT unnest(batch_sender_id[1:((i - 1) % batch_size)]), unnest(batch_receiver_id[1:((i - 1) % batch_size)]),
               unnest(batch_content[1:((i - 1) % batch_size)]), unnest(batch_times[1:((i - 1) % batch_size)]);
    END IF;
END;
$$ LANGUAGE plpgsql;



SELECT insert_fake_users(1000000);
SELECT insert_fake_admins(1000000);
SELECT insert_fake_boards(1000000);
SELECT insert_fake_pins(1000000);
SELECT insert_fake_interactions(1000000);
SELECT insert_fake_notifications(1000000);
SELECT insert_fake_business_accounts(1000000);
SELECT insert_fake_reports(1000000);
SELECT insert_fake_comments(1000000);
SELECT insert_fake_messages(1000000);