# Movie Analysis
movie-analysis is the final assessment to D191 Advanced Data Management – WGU. The objective is to mimic a real-world business scenario where a summary of data is required from a PostgreSQL database.
## Solution
For this project, pgAdmin is used to access the database. The database contains a large dataset of movie information. The solution provides insight into the movies and their categories or genres. Two tables are created to display the information: a detailed and summary table. The detailed table lists all movies and their respective categories. The summary table contains the total number of movies in each category. Data is queried from three tables in the movie dataset to create the tables. A trigger and trigger function are created to continuously update the summary table as new movies are added. Two procedures are created to refresh the data in both tables by first clearing the contents (solution requirement).

Please refer to `analysis.sql` for the original queries.
