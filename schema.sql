-- Drop tables if they already exist (for clean re-run)
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS showtime;
DROP TABLE IF EXISTS screen;
DROP TABLE IF EXISTS theatre;
DROP TABLE IF EXISTS movie;
DROP TABLE IF EXISTS user;

-- 1) MOVIE: information about each movie
CREATE TABLE movie (
                       movie_id      INT AUTO_INCREMENT PRIMARY KEY,
                       title         VARCHAR(200) NOT NULL,
                       language      VARCHAR(50)  NOT NULL,
                       certification VARCHAR(10)  NOT NULL,   -- e.g. UA, U, A
                       format        VARCHAR(10)  NOT NULL,   -- e.g. 2D, 3D
                       duration_min  INT          NOT NULL
);

-- 2) THEATRE: cinema / multiplex
CREATE TABLE theatre (
                         theatre_id INT AUTO_INCREMENT PRIMARY KEY,
                         name       VARCHAR(200) NOT NULL,
                         city       VARCHAR(100) NOT NULL,
                         address    VARCHAR(255) NOT NULL
);

-- 3) SCREEN: individual screen inside a theatre
CREATE TABLE screen (
                        screen_id   INT AUTO_INCREMENT PRIMARY KEY,
                        theatre_id  INT NOT NULL,
                        name        VARCHAR(50) NOT NULL,      -- e.g. Screen 1, Audi 2
                        capacity    INT NOT NULL,
                        CONSTRAINT fk_screen_theatre
                            FOREIGN KEY (theatre_id) REFERENCES theatre(theatre_id)
                                ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4) SHOWTIME: one movie show on a screen at a time
CREATE TABLE showtime (
                          showtime_id INT AUTO_INCREMENT PRIMARY KEY,
                          movie_id    INT NOT NULL,
                          screen_id   INT NOT NULL,
                          show_date   DATE NOT NULL,
                          start_time  TIME NOT NULL,
                          base_price  DECIMAL(8,2) NOT NULL,
                          CONSTRAINT fk_showtime_movie
                              FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
                                  ON DELETE CASCADE ON UPDATE CASCADE,
                          CONSTRAINT fk_showtime_screen
                              FOREIGN KEY (screen_id) REFERENCES screen(screen_id)
                                  ON DELETE CASCADE ON UPDATE CASCADE,
                          CONSTRAINT uq_screen_datetime
                              UNIQUE (screen_id, show_date, start_time)
);

-- 5) USER: basic user table (for completeness)
CREATE TABLE user (
                      user_id   INT AUTO_INCREMENT PRIMARY KEY,
                      full_name VARCHAR(100) NOT NULL,
                      email     VARCHAR(150) NOT NULL UNIQUE
);

-- 6) BOOKING: simple booking table (not required for P2 but keeps schema realistic)
CREATE TABLE booking (
                         booking_id   INT AUTO_INCREMENT PRIMARY KEY,
                         user_id      INT NOT NULL,
                         showtime_id  INT NOT NULL,
                         seats_booked INT NOT NULL,
                         total_price  DECIMAL(10,2) NOT NULL,
                         booking_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         CONSTRAINT fk_booking_user
                             FOREIGN KEY (user_id) REFERENCES user(user_id)
                                 ON DELETE CASCADE ON UPDATE CASCADE,
                         CONSTRAINT fk_booking_showtime
                             FOREIGN KEY (showtime_id) REFERENCES showtime(showtime_id)
                                 ON DELETE CASCADE ON UPDATE CASCADE
);

-- Sample data --------------------------------------------------------

-- Movies (from your screenshot)
INSERT INTO movie (title, language, certification, format, duration_min) VALUES
                                                                             ('Dasara',                'Telugu', 'UA', '2D', 150),
                                                                             ('Kisi Ka Bhai Kisi Ki Jaan', 'Hindi',  'UA', '2D', 145),
                                                                             ('Tu Jhoothi Main Makkaar',   'Hindi',  'UA', '2D', 160),
                                                                             ('Avatar: The Way of Water',  'English','UA', '3D', 190);

-- Theatres
INSERT INTO theatre (name, city, address) VALUES
                                              ('PVR: Nexus (Forum Sujana)', 'Hyderabad', 'KPHB, Kukatpally, Hyderabad'),
                                              ('PVR: Inorbit Mall',         'Hyderabad', 'Madhapur, Hyderabad');

-- Screens
INSERT INTO screen (theatre_id, name, capacity) VALUES
                                                    (1, 'Screen 1', 200),
                                                    (1, 'Screen 2', 180),
                                                    (1, 'Screen 3', 150),
                                                    (2, 'Screen 1', 220);

-- Showtimes for 2024-04-25 (example date)
-- Dasara in Telugu 2D
INSERT INTO showtime (movie_id, screen_id, show_date, start_time, base_price) VALUES
    (1, 1, '2024-04-25', '12:15:00', 200.00);

-- Kisi Ka Bhai Kisi Ki Jaan
INSERT INTO showtime (movie_id, screen_id, show_date, start_time, base_price) VALUES
                                                                                  (2, 2, '2024-04-25', '13:10:00', 220.00),
                                                                                  (2, 2, '2024-04-25', '16:10:00', 220.00),
                                                                                  (2, 3, '2024-04-25', '19:10:00', 250.00);

-- Tu Jhoothi Main Makkaar
INSERT INTO showtime (movie_id, screen_id, show_date, start_time, base_price) VALUES
    (3, 1, '2024-04-25', '22:10:00', 230.00);

-- Avatar: The Way of Water
INSERT INTO showtime (movie_id, screen_id, show_date, start_time, base_price) VALUES
    (4, 3, '2024-04-25', '21:20:00', 280.00);

-- Users
INSERT INTO user (full_name, email) VALUES
                                        ('Ravi Kumar',     'ravi@example.com'),
                                        ('Anjali Sharma',  'anjali@example.com');

-- Bookings (just examples)
INSERT INTO booking (user_id, showtime_id, seats_booked, total_price) VALUES
                                                                          (1, 1, 2, 400.00),
                                                                          (2, 5, 3, 840.00);
