-- #1757 recyclable and low fat products
-- Retrieves the IDs of products that are both low in fats and recyclable.
SELECT product_id
FROM products
WHERE low_fats = 'Y'
	AND recyclable = 'Y';

-- #584 find customer referee
-- Selects names of customers who either have no referee or their referee's ID is not 2.
SELECT name
FROM customer
WHERE referee_id <> 2
	OR referee_id IS NULL;

-- #595 big countries
-- Gets the name, population, and area of countries that are either large in area (3,000,000+ sq km) or population (25,000,000+).
SELECT name
	, population
	, area
FROM world
WHERE area >= 3000000
	OR population >= 25000000;

-- #1148 article views i
-- Retrieves the author ID for cases where the author of the content is also the viewer.
SELECT autor_id AS id
FROM VIEWS
WHERE author_id = viewer_id;

-- #1683 invalid tweets
-- Fetches tweet IDs for tweets that exceed 15 characters in length.
SELECT tweet_id
FROM tweets
WHERE LENGTH(CONTENT) > 15;
