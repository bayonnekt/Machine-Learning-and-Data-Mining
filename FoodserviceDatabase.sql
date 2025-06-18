-- Create database 
CREATE DATABASE Foodservicedb 

-- Use database 
USE Foodservicedb

-- Creating primary and foreign keys

-- Add primary key to the restaurants table
ALTER TABLE restaurants
ADD PRIMARY KEY (Restaurant_id);

-- Add primary key to the consumers table
ALTER TABLE consumers
ADD PRIMARY KEY (Consumer_id);

-- Add primary key, foreign keys and reference to the ratings table
ALTER TABLE ratings
ADD PRIMARY KEY (Consumer_id, Restaurant_id), FOREIGN KEY (Consumer_id) REFERENCES consumers(Consumer_id), FOREIGN KEY (Restaurant_id) REFERENCES restaurants(Restaurant_id);

-- Add primary and foreign keys to the Restaurant_Cuisines table
ALTER TABLE restaurant_cuisines
ADD PRIMARY KEY (Restaurant_id, Cuisine), FOREIGN KEY (Restaurant_id) REFERENCES restaurants(Restaurant_id);

-- Part 2

-- Write a query that lists all restaurants with a Medium range price with open area, serving Mexican food.
SELECT r.*
FROM restaurants r
JOIN restaurant_cuisines rc ON r.Restaurant_id = rc.Restaurant_id
WHERE r.Price = 'Medium' 
AND r.Area = 'Open' 
AND rc.Cuisine = 'Mexican';

-- Total number of restaurants with overall rating 1 serving Mexican food
SELECT COUNT(*) AS mexican_count
FROM restaurants r
JOIN ratings ra ON r.Restaurant_id = ra.Restaurant_id
JOIN Restaurant_Cuisines rc ON r.Restaurant_id = rc.Restaurant_id
WHERE ra.Overall_Rating = 1
AND rc.Cuisine = 'Mexican';

-- Total number of restaurants with overall rating 1 serving Italian food
SELECT COUNT(*) AS italian_count
FROM restaurants r
JOIN ratings ra ON r.Restaurant_id = ra.Restaurant_id
JOIN Restaurant_Cuisines rc ON r.Restaurant_id = rc.Restaurant_id
WHERE ra.Overall_Rating = 1
AND rc.Cuisine = 'Italian';

-- 3. Calculate the average age of consumers who have given a 0 rating to the 'Service_rating' column. (NB: round off the value if it is a decimal)
SELECT ROUND(AVG(c.Age), 0) AS average_age
FROM consumers c
JOIN ratings r ON c.Consumer_id = r.Consumer_id
WHERE r.Service_Rating = 0;

-- 4. Write a query that returns the restaurants ranked by the youngest consumer. 
-- You should include the restaurant name and food rating that is given by that customer to the restaurant in your result.
-- Sort the results based on food rating from high to low
SELECT 
    r.Name AS Restaurant_Name,
    MIN(c.Age) AS Youngest_Consumer_Age,
    ra.Food_Rating
FROM 
    restaurants r
JOIN 
    ratings ra ON r.Restaurant_id = ra.Restaurant_id
JOIN 
    consumers c ON ra.Consumer_id = c.Consumer_id
GROUP BY 
    r.Restaurant_id, r.Name, ra.Food_Rating
ORDER BY 
    ra.Food_Rating DESC;

-- 5. Write a stored procedure for the query given as:
-- Update the service_rating of all restaurants to '2' if they have parking available, either as 'yes' or 'public'

CREATE PROCEDURE UpdateServiceRatingWithParking
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update Service_Rating for restaurants with parking available
    UPDATE ratings
    SET Service_Rating = '2'
    WHERE Restaurant_id IN (
        SELECT r.Restaurant_id
        FROM restaurants r
        WHERE r.Parking IN ('yes', 'public')
    );
END;

-- 6. Four queries You

-- Nested queries-EXISTS
SELECT Name, City, State
FROM restaurants r
WHERE EXISTS (
    SELECT 1
    FROM Ratings ra
    WHERE ra.Restaurant_id = r.Restaurant_id
    AND ra.Overall_Rating < 2
);

-- Nested queries-IN
SELECT Name, City, State
FROM restaurants r
WHERE r.Area IN (
    SELECT Area
    FROM restaurants
    WHERE Price = 'High'
);

SELECT Name, Price
FROM restaurants
WHERE Price IN ('Medium', 'High')
ORDER BY Name;

-- System functions 
SELECT Name, City, State, LEN(Name) AS Name_Length
FROM restaurants

SELECT Name, City, State
FROM restaurants
WHERE Restaurant_id IN (
    SELECT Restaurant_id
    FROM ratings
    GROUP BY Restaurant_id
    HAVING AVG(Overall_Rating) < 3
);

-- Use of GROUP BY, HAVING and ORDER BY clauses
SELECT COUNT(*), Price
FROM restaurants
GROUP BY Price
HAVING COUNT(*) > 10;
