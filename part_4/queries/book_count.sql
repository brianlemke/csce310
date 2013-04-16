-- Find the number of books that each library owns
select name as libraryName, count(itemID) as numBooks
from Library, Item
where Library.name = Item.libraryName and Item.mediaType = 'book'
group by Library.name;
