-- Find the customer for each library who has checked out the most movies.
select customerID, firstName, lastName, libraryName, count(itemID) as numMovies
from Customer natural join Checkout c1 natural join Item
where mediaType = 'movie'
group by customerID, firstName, lastName, libraryName
having count(itemID) >= all (select count(itemID)
                             from Checkout natural join Item
                             where libraryName = c1.libraryName and
                                   mediaType = 'movie'
                             group by customerID
                            )
order by libraryName;
