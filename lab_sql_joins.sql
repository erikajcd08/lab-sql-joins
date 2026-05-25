USE sakila;

SHOW TABLES;

SELECT * FROM film_category LIMIT 5;
SELECT * FROM category LIMIT 5;

SELECT c.name, COUNT(fc.film_id)
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
GROUP BY c.name;

SELECT * FROM store LIMIT 3;
SELECT * FROM address LIMIT 3;
SELECT * FROM city LIMIT 3;
SELECT * FROM country LIMIT 3;

SELECT s.store_id, ci.city, co.country
FROM store AS s
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS ci ON a.city_id = ci.city_id
INNER JOIN country AS co ON ci.country_id = co.country_id;

SELECT * FROM payment LIMIT 3;
SELECT * FROM staff LIMIT 3;

SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

SELECT * FROM film_text LIMIT 3;
SELECT * FROM film LIMIT 3;

SELECT c.name, ROUND(AVG(f.length), 2) AS avg_running_time
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY c.name;

SELECT AVG(f.length) AS avg_length
FROM film_category AS fc
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY fc.category_id;
SELECT MAX(avg_length)
FROM (
    SELECT AVG(f.length) AS avg_length
    FROM film_category AS fc
    INNER JOIN film AS f ON fc.film_id = f.film_id
    GROUP BY fc.category_id
) AS subquery;

SELECT c.name, ROUND(AVG(f.length), 2) AS avg_running_time
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING ROUND(AVG(f.length), 2) = (
    SELECT MAX(avg_length)
    FROM (
        SELECT ROUND(AVG(f2.length), 2) AS avg_length
        FROM film_category AS fc2
        INNER JOIN film AS f2 ON fc2.film_id = f2.film_id
        GROUP BY fc2.category_id
    ) AS subquery
);

SELECT * FROM rental LIMIT 3;
SELECT * FROM inventory LIMIT 3;

SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film AS f
INNER JOIN inventory AS i ON i.film_id = f.film_id
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC
LIMIT 10;

SELECT DISTINCT f.title,
       CASE WHEN IFNULL(i.inventory_id, 0) = 0 THEN 'NOT available'
            ELSE 'Available'
       END AS availability
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id = i.film_id
ORDER BY f.title;