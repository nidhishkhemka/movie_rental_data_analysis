-- 1. Find the total number of movie rentals, the total number of ratings and the average rating of all movies since the beginning of 2019.

SELECT 
	COUNT(*) AS number_renting,
	AVG(rating) AS average_rating, 
    COUNT(rating) AS number_ratings
FROM renting
WHERE date_renting >= '2019-01-01'
;

-- 2. Conduct an analysis to see when the first customer accounts were created for each country.

SELECT 
	country, 
	MIN(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account
;

-- 3. For each movie, find the average rating, the number of ratings and the number of views.

SELECT 
	movie_id, 
    AVG(rating) AS avg_rating,
    COUNT(rating) AS number_ratings,
    COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
ORDER BY avg_rating DESC
; 

-- 4. Find the average movie rating per customer, along with the number of ratings given, and the number of movies rented (for customers with more than 7 movie rentals). 

SELECT 
	customer_id,
	AVG(rating) AS avg_rating,
	COUNT(rating) AS num_rating,
	COUNT(renting_id) AS num_rentals
FROM renting
GROUP BY customer_id
HAVING COUNT(renting_id) > 7 
ORDER BY avg_rating
;

-- 5. The management of MovieNow wants to report key performance indicators (KPIs) for the performance of the company in 2018. Find the revenue coming from movie rentals, the number of movie rentals and the number of active customers.

SELECT 
	SUM(m.renting_price) AS total_revenue, 
	COUNT(*) AS num_rentals, 
	COUNT(DISTINCT r.customer_id) AS num_active_customers
FROM renting AS r
LEFT JOIN movies AS m
	ON r.movie_id = m.movie_id
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' 
;

-- 6. Overview of which actors play in which movie.

SELECT 
	title AS movie_name, 
	name AS actor_name
FROM actsin AS ai
LEFT JOIN movies AS m
    ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
    ON a.actor_id = ai.actor_id
ORDER BY movie_name
;

-- 7. How much income did each movie generate?

SELECT 
	title AS movie_name, 
    SUM(renting_price) AS income_movie
FROM (
	SELECT 
		m.title,  
        m.renting_price
	FROM renting AS r
	LEFT JOIN movies AS m
		ON r.movie_id=m.movie_id
	) AS rm
GROUP BY title
ORDER BY income_movie
;

-- 8. Which is the favorite movie on MovieNow for all customers born in the 70s.

SELECT 
	m.title AS movie_name, 
	COUNT(*) AS count_rent,
	ROUND(AVG(r.rating),2) AS avg_rating
FROM renting AS r
LEFT JOIN customers AS c
	ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
	ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING COUNT(*) <> 1 
ORDER BY AVG(r.rating) DESC, count_rent DESC
; 

-- 9. Find the total number of movie rentals, the average rating of all movies and the total revenue for each country since the beginning of 2019.

SELECT 
	country,                
	COUNT(renting_id) AS number_renting, 
	AVG(rating) AS average_rating, 
	SUM(renting_price) AS revenue         
FROM renting AS r
LEFT JOIN customers AS c
	ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
	ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
GROUP BY country;

-- 10. 
