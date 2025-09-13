-- EDA
SELECT COUNT(*)
FROM spotify;

SELECT COUNT(DISTINCT(artist))
FROM spotify;

SELECT COUNT(DISTINCT(album))
FROM spotify;

SELECT *
FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT *
FROM spotify
WHERE stream > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT DISTINCT album, artist 
FROM spotify;

-- 3. Find all tracks that belong to the album type single
SELECT *
FROM spotify
WHERE album_type LIKE '%single%';

-- 4. Count the total number of tracks by each artist.
SELECT artist, COUNT(track) AS total_no_of_songs
FROM spotify
GROUP BY 1
ORDER BY 1;

-- 5. Calculate the average danceability of tracks in each album.
SELECT album, COUNT(track) AS no_of_tracks, ROUND(AVG(danceability), 3) AS AVG_danceability_of_tracks
FROM spotify
GROUP BY 1
ORDER BY 3 DESC;

-- 6. Find the top 5 tracks with the highest energy values.
SELECT *
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 7. For each album, calculate the total views of all associated tracks.
SELECT album, COUNT(track) AS no_of_tracks, SUM(views) AS total_views
FROM spotify
GROUP BY 1
ORDER BY 3 DESC;

-- 8. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT track
FROM spotify
WHERE most_played_on LIKE '%spotify%';

-- 9. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT artist, track, views
FROM (
    SELECT 
        artist,
        track,
        views,
        ROW_NUMBER() OVER (
            PARTITION BY artist 
            ORDER BY views DESC
        ) AS row_num
    FROM spotify
) AS ranked
WHERE row_num <= 3
ORDER BY artist, views DESC;

-- 10. Write a query to find tracks where the liveness score is above the average.
SELECT * 
FROM spotify 
WHERE liveness >
(SELECT AVG(liveness) AS avg_liveness
FROM spotify)
ORDER BY liveness DESC;

-- 11. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH album_energy AS (
    SELECT 
        album,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT 
    album,
    max_energy,
    min_energy,
    (max_energy - min_energy) AS energy_difference
FROM album_energy
ORDER BY energy_difference DESC;

-- 12. Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT 
	track, 
    artist, 
    energy, 
    liveness, 
    (energy / liveness) AS energy_to_liveness_ratio
FROM spotify
WHERE energy/liveness > 1.2
ORDER BY energy_to_liveness_ratio DESC;

-- 13. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions
SELECT 
    track,
    artist,
    views,
    likes,
    SUM(likes) OVER (
        ORDER BY views
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_likes
FROM spotify
ORDER BY views;
