Question Set 1: 
Question 1 Slide 1
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

SELECT f.title AS film_title, c.name AS category_name, COUNT (*) AS rental_count
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1,2
ORDER BY 2,1


********************************************************************************
Question 2 Slide 2
Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories?

SELECT f.title AS film_title, c.name AS category_name, f.rental_duration, NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

*********************************************************************************
Question 3 Slide 3
Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category

SELECT category_name, standard_quartile, COUNT(*)
FROM 
    (SELECT f.title AS film_title, c.name AS category_name, f.rental_duration AS rental_duration, NTILE(4) OVER (ORDER BY      f.rental_duration) AS standard_quartile
     FROM film f
     JOIN film_category fc
     ON f.film_id = fc.film_id
     JOIN category c
     ON fc.category_id = c.category_id
     WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) t1
GROUP BY 1,2                 
ORDER BY 1,2


==========================================================================================================================================

Question Set 2:

********************************************************************************
Question 4 Slide 4
Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?


WITH top10 AS (SELECT c.customer_id AS customer_id, SUM(p.amount) AS total_amount FROM customer c
              JOIN payment p
              ON c.customer_id = p.customer_id
              GROUP BY 1
               ORDER BY 2 DESC
               LIMIT 10)
SELECT DATE_TRUNC('month', p.payment_date) AS pay_mon,(c.first_name ||' '||c.last_name) AS customer_full_name, COUNT(p.amount) AS pay_countpermon, SUM(p.amount) AS pay_amount
FROM customer c
JOIN top10 
ON c.customer_id = top10.customer_id
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY 1,2
ORDER BY 2,1

********************************************************************************
