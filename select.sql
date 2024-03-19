-- #1757 recyclable and low fat products
SELECT
    product_id
FROM
    products
WHERE
    low_fats = 'Y'
    AND recyclable = 'Y'
    
-- #584 find customer referee
SELECT
    name
FROM
    customer
WHERE
    referee_id <> 2
    OR referee_id IS NULL

-- #595 big countries
SELECT
    name,
    population,
    area
FROM
    world
WHERE
    area >= 3000000
    OR population >= 25000000

-- #1148 article views i
SELECT
    autor_id AS id
FROM
    VIEWS
WHERE
    author_id = viewer_id

-- #1683 invalid tweets
SELECT
    tweet_id
FROM
    tweets
WHERE
    LENGTH(CONTENT) > 15
