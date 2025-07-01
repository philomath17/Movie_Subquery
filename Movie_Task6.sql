CREATE DATABASE MovieFlix;
USE MovieFlix;

-- Users Table
CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  name VARCHAR(50),
  city VARCHAR(50)
);

-- Movies Table
CREATE TABLE Movies (
  movie_id INT PRIMARY KEY,
  title VARCHAR(100),
  genre VARCHAR(30),
  release_year INT
);

-- Subscriptions Table
CREATE TABLE Subscriptions (
  sub_id INT PRIMARY KEY,
  user_id INT,
  plan_type VARCHAR(20),
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Reviews Table
CREATE TABLE Reviews (
  review_id INT PRIMARY KEY,
  user_id INT,
  movie_id INT,
  rating INT,
  comment TEXT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Users
INSERT INTO Users VALUES (1, 'Aanya', 'Mumbai');
INSERT INTO Users VALUES (2, 'Kabir', 'Pune');
INSERT INTO Users VALUES (3, 'Sara', 'Delhi');

-- Movies
INSERT INTO Movies VALUES (101, 'Interstellar', 'Sci-Fi', 2014);
INSERT INTO Movies VALUES (102, 'Tamasha', 'Drama', 2015);
INSERT INTO Movies VALUES (103, 'Andhadhun', 'Thriller', 2018);

-- Subscriptions
INSERT INTO Subscriptions VALUES (201, 1, 'Premium', '2025-01-01', '2025-12-31');
INSERT INTO Subscriptions VALUES (202, 2, 'Basic', '2025-06-01', '2025-08-31');

-- Reviews
INSERT INTO Reviews VALUES (301, 1, 101, 5, 'Mind-blowing!');
INSERT INTO Reviews VALUES (302, 1, 102, 4, 'Beautifully shot!');
INSERT INTO Reviews VALUES (303, 2, 103, 3, 'Interesting plot.');

-- Subquery in SELECT
SELECT 
  name,
  (SELECT COUNT(*) 
   FROM Reviews r 
   WHERE r.user_id = u.user_id) AS total_reviews
FROM Users u;

-- 	in 
SELECT name 
FROM Users 
WHERE user_id IN (
  SELECT user_id 
  FROM Reviews 
  WHERE movie_id = (
    SELECT movie_id FROM Movies WHERE title = 'Interstellar'
  )
);

-- Exists 
SELECT title 
FROM Movies m
WHERE EXISTS (
  SELECT 1 
  FROM Reviews r 
  WHERE r.movie_id = m.movie_id
);

-- subquery in where
SELECT review_id, user_id, rating 
FROM Reviews r1
WHERE rating > (
  SELECT AVG(rating) 
  FROM Reviews r2 
  WHERE r2.user_id = r1.user_id
);

-- subquery in From
SELECT u.name, avg_rating
FROM (
  SELECT user_id, AVG(rating) AS avg_rating
  FROM Reviews
  GROUP BY user_id
) AS sub
JOIN Users u ON u.user_id = sub.user_id
WHERE avg_rating > 4.0;