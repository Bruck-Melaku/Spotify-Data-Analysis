

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```

## 13 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT *
FROM spotify
WHERE stream > 1000000000;
```
2. List all albums along with their respective artists.
```sql
SELECT DISTINCT album, artist 
FROM spotify;
```
3. Find all tracks that belong to the album type `single`.
```sql
SELECT *
FROM spotify
WHERE album_type LIKE '%single%';
```
4. Count the total number of tracks by each artist.
```sql
SELECT artist, COUNT(track) AS total_no_of_songs
FROM spotify
GROUP BY 1
ORDER BY 1;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
```sql
SELECT album, COUNT(track) AS no_of_tracks, ROUND(AVG(danceability), 3) AS AVG_danceability_of_tracks
FROM spotify
GROUP BY 1
ORDER BY 3 DESC;

```
2. Find the top 5 tracks with the highest energy values.
```sql
SELECT *
FROM spotify
ORDER BY energy DESC
LIMIT 5;
```
3. For each album, calculate the total views of all associated tracks.
```sql
SELECT album, COUNT(track) AS no_of_tracks, SUM(views) AS total_views
FROM spotify
GROUP BY 1
ORDER BY 3 DESC;
```
4. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
SELECT track
FROM spotify
WHERE most_played_on LIKE '%spotify%';
```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
```
2. Write a query to find tracks where the liveness score is above the average.
```sql
SELECT * 
FROM spotify 
WHERE liveness >
(SELECT AVG(liveness) AS avg_liveness
FROM spotify)
ORDER BY liveness DESC;
```
3. Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.
```sql
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
```
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
SELECT 
	track, 
    artist, 
    energy, 
    liveness, 
    (energy / liveness) AS energy_to_liveness_ratio
FROM spotify
WHERE energy/liveness > 1.2
ORDER BY energy_to_liveness_ratio DESC;
```
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
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
```




---


## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.
- **Expand Dataset**: Add more rows to the dataset for broader analysis and scalability testing.
- **Advanced Querying**: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.

---

## Contributing
If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.

---

## Author
Bruck Melaku

## Author's Note
I would like to thank ZeroAnalyst for  his help and guidance in this project

