-- #1757 recyclable and low fat products
SELECT
    product_id
FROM
    Products 
WHERE
    low_fats = 'Y' 
    AND recyclable = 'Y'

-- #584 find customer referee
SELECT name
FROM customer
where referee_id <> 2 or referee_id is null

-- #595 big countries
select name, population, area
from world
where area >= 3000000 or population >= 25000000

-- #1148 article views i
select autor_id as id
from views
where author_id = viewer_id

-- #1683 invalid tweets
select tweet_id
from Tweets
where length(content) > 15
