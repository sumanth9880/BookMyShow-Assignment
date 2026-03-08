# BookMyShow Ticketing Platform – DB Design

This repository contains a normalized MySQL schema for a simplified BookMyShow‑like movie ticket booking system and example queries for the assignment.

## Part 1 – Tables and Normalization

Entities modeled:

- **movie**: details of each movie (title, language, certification, format, duration).
- **theatre**: multiplex / cinema details (name, city, address).
- **screen**: individual screens/auditoria inside a theatre.
- **showtime**: each scheduled show of a movie on a screen at a particular date and time.
- **user**: basic user information.
- **booking**: simple booking records for users.

Normalization:

- All tables are in **1NF**: atomic columns, no repeating groups.
- **2NF**: every non‑key attribute depends on the whole key (no partial dependency).
- **3NF**: no transitive dependency (non‑key attributes depend only on the key).
- **BCNF**: in every table, each determinant is a candidate key (e.g., `showtime` uses a surrogate key and unique `(screen_id, show_date, start_time)`).

Refer to `schema.sql` for full DDL and sample inserts.

## Part 2 – Query: Shows on a Date at a Theatre

The main query for P2 is in `queries.sql`:

```sql
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
    t.name     = 'PVR: Nexus (Forum Sujana)'
    AND s.show_date = '2024-04-25'
ORDER BY
    s.start_time, movie_title;
