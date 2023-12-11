/*The capitalize_category() function performs a transform to capitalize the category names so they are easily distinguishable from movie names.*/
CREATE OR REPLACE FUNCTION capitalize_category(category VARCHAR)
RETURNS VARCHAR
LANGUAGE PLPGSQL
AS $$
BEGIN
RETURN UPPER(category);
END; $$

/*Creating the detailed and summary tables to hold the report table sections.*/
-- Detailed table:
CREATE TABLE IF NOT EXISTS detailed (
"category"	VARCHAR(25),
"movie_title"	VARCHAR(255)
);
-- Summary table:
CREATE TABLE IF NOT EXISTS summary (
"category"	VARCHAR(25),
"movie_count"	INTEGER
);

/*Extracting the raw data for the detailed section of the report from the source database.*/
INSERT INTO detailed
SELECT name, title
FROM category, film, film_category
WHERE film.film_id = film_category.film_id
AND film_category.category_id = category.category_id;

/*The update_summary trigger and update_summary_func() trigger function continually update the summary table as data is added to the detailed table.*/
-- Trigger:
CREATE TRIGGER update_summary
AFTER INSERT ON detailed
FOR EACH STATEMENT
EXECUTE PROCEDURE update_summary_func();
-- Trigger Function:
CREATE OR REPLACE FUNCTION update_summary_func()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
DELETE FROM summary;
INSERT INTO summary
SELECT category, COUNT(movie_title)
FROM detailed
GROUP BY category;
RETURN NEW;
END; $$

/*The update_proced() procedure refreshes the data in both the detailed and summary tables. The procedure clears the contents of both tables and reperforms the raw data extraction.*/
CREATE OR REPLACE PROCEDURE update_proced()
LANGUAGE PLPGSQL
AS $$
BEGIN
-- Refreshing detailed
DELETE FROM detailed;
INSERT INTO detailed
SELECT name, title
FROM category, film, film_category
WHERE film.film_id = film_category.film_id
AND film_category.category_id = category.category_id;
UPDATE detailed
SET category = capitalize_category(category);
-- Refreshing summary
DELETE FROM summary;
INSERT INTO summary
SELECT category, COUNT(movie_title)
FROM detailed
GROUP BY category;
END; $$
