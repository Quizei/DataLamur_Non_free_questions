/*
Problem: Cumulative Song Plays up to August 4th, 2022

You are given two tables containing Spotify users’ streaming data:

songs_history: Contains historical play counts for each user-song combination up to July 31st, 2022.

songs_weekly: Contains timestamped streaming events for the week of August 1st to August 7th, 2022.

Your task is to write a SQL query that outputs the cumulative number of times each user played each song up to and including August 4th, 2022.
*/


--Create Statement
        CREATE TABLE songs_history (
        user_id INT,
        song_id INT,
        song_plays INT
        );

        CREATE TABLE songs_weekly (
        user_id INT,
        song_id INT,
        listen_time TIMESTAMP
        );

--Insert Statement
        INSERT INTO songs_history (user_id, song_id, song_plays) VALUES
        (105, 4520, 20),
        (105, 1238, 1),
        (125, 9630, 3),
        (695, 9852, 1),
        (695, 4520, 1),
        (695, 1238, 7),
        (777, 1238, 10);

        INSERT INTO songs_weekly (user_id, song_id, listen_time) VALUES
        (695, 1238, '2022-08-01 12:00:00'),
        (695, 1238, '2022-08-02 13:00:00'),
        (695, 4520, '2022-08-03 14:00:00'),
        (777, 1238, '2022-08-04 15:00:00'),
        (785, 4123, '2022-08-03 12:00:00'),
        (785, 4123, '2022-08-04 15:00:00'),
        (785, 4123, '2022-08-04 15:30:00'),
        (785, 4123, '2022-08-04 16:00:00'),
        (785, 4123, '2022-08-04 16:30:00');


--Solution 
        WITH cte AS (
        SELECT user_id, song_id, COUNT(*) AS cnt
        FROM songs_weekly
        WHERE listen_time::DATE <= DATE '2022-08-04'
        GROUP BY user_id, song_id
        )
        SELECT
        COALESCE(h.user_id, w.user_id) AS user_id,
        COALESCE(h.song_id, w.song_id) AS song_id,
        COALESCE(h.song_plays, 0) + COALESCE(w.cnt, 0) AS total_plays
        FROM songs_history h
        FULL JOIN cte w ON h.user_id = w.user_id AND h.song_id = w.song_id
        ORDER BY user_id, song_id;
