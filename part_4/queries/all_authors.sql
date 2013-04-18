-- Find all the authors of any book in the library system in alphabetical order
select distinct author
from Item
where mediaType = 'book'
order by author;
