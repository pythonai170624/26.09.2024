CREATE TABLE random_numbers (
    id SERIAL PRIMARY KEY,
    random_value double precision
);

INSERT INTO random_numbers (random_value)
SELECT ROUND((RANDOM() * 100)::numeric, 2) -- create random number
FROM generate_series(1, 5); -- range

SELECT * FROM random_numbers;

SELECT * FROM random_numbers
ORDER BY RANDOM() -- get the list in a random order
LIMIT 3;

UPDATE random_numbers
SET random_value = ROUND((RANDOM() * 100)::numeric, 2)
WHERE id = 1;


SELECT * FROM random_numbers;