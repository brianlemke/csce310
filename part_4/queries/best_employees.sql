-- Find the employees from the libraries that have the most items checked out.
select *
from Employee
where libraryName in (select Library.name
                      from Library, Checkout
                      where Library.name = Checkout.libraryName
                      group by Library.name
                      having count(itemID) >= all (select count(itemID)
                                                   from Library, Checkout
                                                   where Library.name = Checkout.libraryName
                                                   group by Library.name
                                                  )
                     );
