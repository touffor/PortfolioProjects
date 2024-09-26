-- Sakila database to be used
USE Sakila;		

-- Select *
-- From actor;

-- Looking at the list of actors available on the database table and last updated date
SELECT actor_id, (concat(first_name,'  ',last_name)) as Actor_name, last_update	
FROM actor;		
				
-- Looking at actor's with the same first name and last names
SELECT a.first_name, a.last_name, count(*)	
FROM actor a		
JOIN actor b		
ON a.actor_id <> b.actor_id		
AND a.first_name = b.first_name		
AND a.last_name = b.last_name;		
		
		
-- Actors with unique names and how many are there in the database
SELECT count(DISTINCT (concat(first_name,'  ',last_name)))		
		AS Actor_Unique_name_Count	
FROM actor;		


-- Actors who share a name with someone and a list of those with unique name		
SELECT concat(first_name,' ',last_name) AS Shared_Name_Actor
FROM actor		
GROUP BY Shared_Name_Actor		
HAVING count(first_name) > 1 		
AND count(last_name) > 1;

-- List of Actor's with unique name	
SELECT DISTINCT concat(first_name,'  ',last_name) 		
		AS Actors_With_Unique_Name	
from actor;		
		

-- Detailed overview of films based on the actors' preferences,	
SELECT name AS Categories, count(concat(first_name,'  ',last_name))		
        AS Actor_Count			
FROM actor a			
JOIN film_actor fa ON a.actor_id = fa.actor_id		
JOIN film f ON f.film_id = fa.film_id		
JOIN film_category fc ON f.film_id = fc.film_id		
JOIN category c ON fc.category_id = c.category_id		
GROUP BY Categories			
ORDER BY Actor_Count DESC;		
		
        
-- Analyzing trend for movies based on their categories and determine which movie category is the largest.
SELECT Name AS Category, rating, count(title) AS Film_Count			
FROM film f	
JOIN  film_category fc ON f.film_id = fc.film_id		
JOIN category c ON fc.category_id = c.category_id		
GROUP BY Category, rating				
ORDER BY Film_Count DESC;		
		

-- Looking at movie titles where the replacement cost is up to $9.99.
SELECT title AS Movie_Title, replacement_cost
FROM film			
WHERE replacement_cost <= 9.99;		
	
-- Movie titles where the replacement coast is between $15 and $20.		
SELECT title AS Movie_Title, replacement_cost
FROM film		 		
WHERE replacement_cost BETWEEN 15 AND 20		
ORDER BY replacement_cost DESC;	
		
		
-- Movie with the highest replacement cost but the lowest rental cost.
SELECT title, MAX(replacement_cost), MIN(rental_rate)
FROM film;		
		
		
-- Looking at the list of all films along with the number of actors	listed for each film.	
SELECT title AS List_of_all_films, count(actor_id) AS Number_of_Actors			
FROM film f			
JOIN film_actor fa		
ON f.film_id = fa.film_id			
GROUP BY List_of_all_films	
ORDER BY Number_of_Actors DESC;		
		
		
-- Displaying the titles of movies starting with the letter `K` and `Q`	
SELECT title AS Movie_Title	
FROM film		
WHERE title LIKE 'K%' OR title LIKE 'Q%'		
GROUP BY Movie_Title;	
		
		
-- List of all the actors who appeared in the film 'AGENT TRUMAN'.
SELECT CONCAT(first_name,' ',last_name)	AS Actors_In_AGENT_TRUMAN	
FROM actor a		
JOIN film_actor fa ON a.actor_id = fa.actor_id		
JOIN film f ON fa.film_id = f.film_id			
WHERE title = 'AGENT TRUMAN';		
		

-- Identifying all the movies categorized as family films	
SELECT title AS Family_Films
FROM film f	
JOIN film_category fc ON f.film_id = fc.film_id		
JOIN category c ON fc.category_id = c.category_id
WHERE name = 'Family';		
		
		
-- Displaying the most frequently rented movies in descending order
SELECT title AS Movie_Title, count(rental_date) AS Rented_Time	
FROM film f		
JOIN inventory i		
ON f.film_id = i.film_id		
JOIN rental r		
ON i.inventory_id = r.inventory_id			
GROUP BY Movie_Title	
ORDER BY Rented_Time DESC;		
		
		
-- Films categories was the average difference between the film replacement cost and the rental rate greater than $15
SELECT name AS Film_categories, AVG(replacement_cost) - AVG(rental_rate) 
	AS Average_Difference	
FROM category c		
JOIN film_category fc		
ON c.category_id = fc.category_id		
JOIN film f		
ON f.film_id = fc.film_id			
GROUP BY Film_categories				
HAVING Average_Difference > 15			
ORDER BY Average_Difference DESC;		
		

-- Identify the genres containing 60-70 and the number of film per category
SELECT name AS category, count(title) AS Number_of_Film
FROM film f		
JOIN film_category fc ON f.film_id = fc.film_id		
JOIN category c ON fc.category_id = c.category_id			
GROUP BY category	
HAVING Number_of_Film BETWEEN 60 AND 70		
ORDER BY Number_of_Film DESC; 
