CREATE DATABASE dating_app;
USE dating_app;

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

/* What are our demographics like? */
SELECT gender, COUNT(*) AS count
	FROM dating_app_behavior
	GROUP BY gender;
SELECT sexual_orientation, COUNT(*) AS count
	FROM dating_app_behavior
	GROUP BY sexual_orientation;
SELECT location_type, COUNT(*) AS count
	FROM dating_app_behavior
	GROUP BY location_type;
SELECT education_level, COUNT(*) AS count
	FROM dating_app_behavior
	GROUP BY education_level;
SELECT gender, sexual_orientation, location_type, education_level, COUNT(*) count
	FROM dating_app_behavior
	GROUP BY gender, sexual_orientation, location_type, education_level;
/* There are only small differences between population counts; it's likely this synthetic data was generated 
with an equal probability for any feature to occur, which is not realistic to real-life conditions. */

/* What are the most common interests? */
SELECT interest_tags, COUNT(*)
FROM dating_app_behavior
GROUP BY interest_tags;
-- interest_tags is in list form; we have to separate them into individual rows to count them

-- For identification, we create a primary key column
ALTER TABLE dating_app_behavior
ADD COLUMN user_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY;

-- Next, we write the logic to separate our user_tags into distinct rows
-- Each user has exactly three tags, so the logic is simple and discrete
-- In MySQL, temp tables cannot be self-joined, so we use a CTE instead
WITH user_tags AS (
	SELECT user_id, SUBSTRING_INDEX(interest_tags, ",", 1) AS interest_tags
	FROM dating_app_behavior
	UNION
	SELECT user_id, SUBSTRING_INDEX(SUBSTRING_INDEX(interest_tags, ",", 2), ",", -1) AS interest_tags
	FROM dating_app_behavior
	UNION
	SELECT user_id, SUBSTRING_INDEX(interest_tags, ",", -1) AS interest_tags
	FROM dating_app_behavior
	ORDER BY user_id)

-- Now, we can count our interests
SELECT interest_tags, count(*) as count
FROM user_tags
GROUP BY interest_tags
ORDER BY count DESC;
/* This is a little more interesting than our demographics.*/

/* Which interests occur the most often together, pair-wise?*/
WITH user_tags AS (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY user_ID ORDER BY user_id DESC) AS tag_id
    FROM (
		SELECT user_id, SUBSTRING_INDEX(interest_tags, ",", 1) AS interest_tags
		FROM dating_app_behavior
		UNION
		SELECT user_id, SUBSTRING_INDEX(SUBSTRING_INDEX(interest_tags, ",", 2), ",", -1) AS interest_tags
		FROM dating_app_behavior
		UNION
		SELECT user_id, SUBSTRING_INDEX(interest_tags, ",", -1) AS interest_tags
		FROM dating_app_behavior
		ORDER BY user_id
        ) AS split_tags
    )

SELECT ut1.interest_tags, ut2.interest_tags, COUNT(*) as count
FROM user_tags ut1
JOIN user_tags ut2
	ON ut1.user_id = ut2.user_id
    AND ut1.tag_id < ut2.tag_id
GROUP BY ut1.interest_tags, ut2.interest_tags
ORDER BY count DESC;
/* Skating often occurs with Yoga
...
Tech occurs rarely with Gardening*/
SELECT * FROM dating_app_behavior;

/* How much usage is typical of each app_usage_time_label group?*/
SELECT app_usage_time_label, AVG(app_usage_time_min) avg_usage
FROM dating_app_behavior
GROUP BY app_usage_time_label
ORDER BY avg_usage DESC;

/* Does time of day impact successful matches?*/
SELECT swipe_time_of_day, match_outcome, COUNT(*)
FROM dating_app_behavior
GROUP BY swipe_time_of_day, match_outcome
ORDER BY match_outcome;
/* It does not. */

/* Does education level impact their income bracket?*/
SELECT income_bracket, education_level, count(*)
FROM dating_app_behavior
GROUP BY income_bracket, education_level
ORDER BY income_bracket;
/* According to this dataset, no. */

/* Are people who get matches often likelier to get better match_outcomes? */
SELECT *, count/(SUM(count) OVER(PARTITION BY num_matches_category)) percent_of_category
FROM (
	SELECT CASE WHEN mutual_matches <= 5 THEN "Few Matches"
				WHEN mutual_matches <= 10 THEN "Moderate Matches"
				WHEN mutual_matches <= 20 THEN "Many Matches"
				WHEN mutual_matches <= 30  THEN "Many Many Matches"
				END AS num_matches_category,
			match_outcome,
			COUNT(*) count
	FROM dating_app_behavior
    GROUP BY num_matches_category, match_outcome
	ORDER BY num_matches_category, match_outcome
) AS atable
/* Not according to this data; every group gets the same proportion of outcomes. */