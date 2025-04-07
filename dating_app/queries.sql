CREATE DATABASE dating_app;
CREATE TABLE dating_app_behavior (
	gender VARCHAR(100),
    sexual_orientation VARCHAR(100),
    location_type VARCHAR(100),
    income_bracket VARCHAR(100),
    education_level VARCHAR(100),
    interest_tags VARCHAR(100),
    app_usage_time_min FLOAT,
    app_usage_time_label VARCHAR(100),
    swipe_right_ratio FLOAT,
    swipe_right_label VARCHAR(100),
    likes_received INT,
    mutual_matches INT,
    profile_pics_count INT,
    bio_length INT,
    message_sent_count INT,
    emoji_usage_rate FLOAT,
    last_active_hour SMALLINT,
    swipe_time_of_day VARCHAR(100),
    match_outcome VARCHAR(100)
);

SELECT * FROM dating_app_behavior;