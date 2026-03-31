DROP TABLE IF EXISTS dancer_dances;
DROP TABLE IF EXISTS high_scores;
DROP TABLE IF EXISTS attempts;
DROP TABLE IF EXISTS dancers;
DROP TABLE IF EXISTS dances;
DROP TABLE IF EXISTS users;
DROP VIEW IF EXISTS DancerDances;

CREATE TABLE dancers (
    dancer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    dancer_name VARCHAR(20) NOT NULL
);

CREATE TABLE dances (
    dance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    dance_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dancer_dances (
	dancer_id INT,
    dance_id INT,
    run_time TIME NOT NULL,
    difficulty VARCHAR(20) CHECK (difficulty IN ('Easy', 'Intermediate', 'Advanced')),
    PRIMARY KEY (dance_id, dancer_id),
    FOREIGN KEY (dancer_id) REFERENCES dancers(dancer_id),
    FOREIGN KEY (dance_id) REFERENCES dances(dance_id)
);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(50) UNIQUE NOT NULL,
    join_date DATE NOT NULL,
    age INT CHECK (age >= 16)
);

CREATE TABLE attempts (
	attempt_id INTEGER PRIMARY KEY AUTOINCREMENT,
	dancer_id INT,
	dance_id INT NOT NULL,
    accuracy INT CHECK (accuracy >= 0 AND accuracy <= 100),
    precision INT CHECK (precision >= 0 AND precision <= 100),
    timing INT CHECK (timing >= 0 AND timing <= 100),
    score INT NOT NULL CHECK (score >= 0 AND score <= 100),
    FOREIGN KEY (dancer_id) REFERENCES dancers(dancer_id),
    FOREIGN KEY (dance_id) REFERENCES dances(dance_id)
);

CREATE TABLE high_scores (
	attempt_id INT,
	dancer_id INT,
	dance_id INT,
    score INT NOT NULL,
    PRIMARY KEY (dance_id, dancer_id),
    FOREIGN KEY (dancer_id) REFERENCES dancers(dancer_id),
    FOREIGN KEY (dance_id) REFERENCES dances(dance_id),
    FOREIGN KEY (attempt_id) REFERENCES attempts(attempt_id)
);


-- Multi Join
SELECT
    dancers.dancer_name,
    dances.dance_name
FROM dancers
JOIN dancer_dances
    ON dancers.dancer_id = dancer_dances.dancer_id
JOIN dances
    ON dancer_dances.dance_id = dances.dance_id;

-- Group By
SELECT
    dance_id,
    AVG(score),
    COUNT(attempt_id)
FROM attempts
GROUP BY dance_id;

-- Subquery
SELECT
    attempt_id,
    score
FROM attempts
WHERE score > (
    SELECT AVG(score)
    FROM attempts
);

-- Case
SELECT
    attempt_id,
    score,
    CASE
        WHEN score < 50 THEN 'poor score'
        WHEN score BETWEEN 50 AND 75 THEN 'average score'
        ELSE 'great score'
    END AS achievement
FROM attempts;

-- Query with view
CREATE VIEW DancerDances AS
SELECT
    dancers.dancer_name,
    dances.dance_name,
    dancer_dances.run_time
FROM dancers
JOIN dancer_dances
    ON dancers.dancer_id = dancer_dances.dancer_id
JOIN dances
    ON dancer_dances.dance_id = dances.dance_id;

SELECT * FROM DancerDances
WHERE run_time < '00:03:00';

-- Insert
INSERT INTO users (email, join_date, age)
VALUES ('yo@gmail.com', '1999-03-28', 68);

-- Query with filter
SELECT
    attempt_id,
    dancer_id,
    dance_id,
    score
FROM high_scores
WHERE dancer_id = 5
    AND dance_id = 2;

-- Query of choice
SELECT
    d.dancer_name,
    COUNT(a.attempt_id) AS total_attempts,
    ROUND(AVG(a.score), 2) AS average_score
FROM dancers d
JOIN attempts a
    ON d.dancer_id = a.dancer_id
GROUP BY
    d.dancer_id,
    d.dancer_name
HAVING
    AVG(a.score) > 85
ORDER BY
    average_score DESC;


-- Extra Credit Delete
DELETE FROM users
WHERE email = 'yo@gmail.com';
