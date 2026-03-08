-- P2: List all shows on a given date at a given theatre
-- Replace values in WHERE as needed

SELECT
    t.name           AS theatre_name,
    s.show_date,
    m.title          AS movie_title,
    m.language,
    m.certification,
    m.format,
    sc.name          AS screen_name,
    s.start_time,
    s.base_price
FROM showtime s
         JOIN movie   m  ON s.movie_id  = m.movie_id
         JOIN screen  sc ON s.screen_id = sc.screen_id
         JOIN theatre t  ON sc.theatre_id = t.theatre_id
WHERE
    t.name     = 'PVR: Nexus (Forum Sujana)'   -- given theatre
  AND s.show_date = '2024-04-25'            -- given date
ORDER BY
    s.start_time, movie_title;

-- Same query, but with placeholders (for application code)
-- WHERE t.name = ? AND s.show_date = ?;

-- Extra: list all future show dates for a theatre
SELECT DISTINCT s.show_date
FROM showtime s
         JOIN screen sc ON s.screen_id = sc.screen_id
         JOIN theatre t ON sc.theatre_id = t.theatre_id
WHERE t.name = 'PVR: Nexus (Forum Sujana)'
ORDER BY s.show_date;

-- Extra: list all movies playing at a theatre on any date
SELECT DISTINCT m.title, m.language, m.certification, m.format
FROM showtime s
         JOIN movie m   ON s.movie_id = m.movie_id
         JOIN screen sc ON s.screen_id = sc.screen_id
         JOIN theatre t ON sc.theatre_id = t.theatre_id
WHERE t.name = 'PVR: Nexus (Forum Sujana)'
ORDER BY m.title;
