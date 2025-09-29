-- Style lukisan apa yang paling banyak digunakan oleh pelukis pada tiap abad?
WITH artist_counts AS (
    SELECT
        CONCAT(FLOOR(birth / 100) * 100, ' - ', FLOOR(birth / 100) * 100 + 99) AS birth_group,
        style,
        COUNT(*) AS total_artist,
        ROW_NUMBER() OVER (
            PARTITION BY FLOOR(birth / 100)
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM artist
    WHERE birth IS NOT NULL AND birth != 0
    GROUP BY birth_group, style, FLOOR(birth / 100)
)
SELECT 
    birth_group,
    style,
    total_artist
FROM artist_counts
WHERE rn = 1
ORDER BY birth_group


-- Pelukis mana yang memiliki karya lukisan terbanyak
SELECT 
	full_name,
    nationality,
    artist.style,
    birth,
    death,
	COUNT(work_id) AS count
FROM artist JOIN work
ON artist.artist_id = work.artist_id
GROUP BY full_name
ORDER BY count DESC
LIMIT 5

-- Mayoritas pelukis berkewarganegaraan apa?
SELECT nationality, COUNT(artist_id) AS count
FROM artist
GROUP BY nationality
ORDER BY count DESC
LIMIT 5

-- Pelukis mana yang karyanya paling tersebar di banyak negara?
SELECT 
	full_name,
	COUNT(DISTINCT country) AS count
FROM artist 
JOIN  work ON artist.artist_id = work.artist_id
JOIN museum ON work.museum_id = museum.museum_id
GROUP BY full_name
ORDER BY count DESC
LIMIT 5

-- Lukisan mana saja yang memiliki diskon lebih dari 50%
SELECT 
	name,
    size_id,
	ROUND((regular_price - sale_price) / regular_price, 2) AS discount_percentage
FROM work JOIN product_size
ON work.work_id = product_size.work_id
HAVING discount_percentage > 0.50
ORDER BY discount_percentage DESC

-- Pelukis mana yang rata-rata harga karyanya paling mahal?
SELECT
	full_name, 
    artist.style,
    birth,
    death,
    AVG(regular_price) AS average_price
FROM artist JOIN work
ON artist.artist_id = work.artist_id
JOIN product_size
ON work.work_id = product_size.work_id
GROUP BY full_name
ORDER BY average_price DESC
LIMIT 5

-- Museum apa saja yang buka setiap hari?
SELECT name, city, country
FROM museum JOIN museum_hours
ON museum.museum_id = museum_hours.museum_id
GROUP BY museum.museum_id
HAVING COUNT(museum_hours.day) = 7

-- Negara mana yang memiliki jumlah museum terbanyak dan lukisan terbanyak
SELECT 
	country, 
	COUNT(DISTINCT museum.museum_id) AS count_museum,
	COUNT(DISTINCT work_id) AS count_painting
FROM museum JOIN work
ON museum.museum_id = work.museum_id
GROUP BY country
ORDER BY count_museum DESC, count_painting DESC
LIMIT 3

-- Subjek lukisan apa yang paling sering muncul?
SELECT subject, COUNT(work_id) AS count
FROM subject
GROUP BY subject
ORDER BY count DESC
LIMIT 5