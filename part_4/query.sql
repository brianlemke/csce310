-- 1: Find the number of books that each library owns
-- Features: grouping, aggregation
select name as libraryName, count(itemID) as numBooks
from Library, Item
where Library.name = Item.libraryName and Item.mediaType = 'book'
group by Library.name;


-- 2: Find all the items that have never been checked out
-- Features: subquery, exists
select *
from Item
where not exists(select *
                 from Checkout
                 where Checkout.itemID = Item.itemID and
                       Checkout.libraryName = Item.libraryName
                );


-- 3: Find all customers that have excessively high fines
-- Features: grouping, aggregation, having
select Customer.customerID, firstName, lastName, sum(fineAmount) as totalFines
from Customer, Checkout
where Customer.customerID = Checkout.customerID
group by Customer.customerID, firstName, lastName
having sum(fineAmount) > 200.00;


-- 4: Find the libraries that pay the highest average wages to their employees
-- Features: having, grouping, aggregation
select Library.name, avg(Employee.salary) as averageSalary
from Library, Employee
where Library.name = Employee.libraryName
group by Library.name
having avg(Employee.salary) >= all (select avg(Employee.salary)
                                    from Library, Employee
                                    where Library.name = Employee.libraryName
                                    group by Library.name);


-- 5: Find all the items that have been either loaned or checked out within the
-- last year
-- Features: union, MySQL date functions, many conditions
select Item.itemID, Item.libraryName, Item.title
from Item, Checkout
where Item.itemID = Checkout.itemID and
      Item.libraryName = Checkout.libraryName and
      Checkout.dateOut >= date_sub(curdate(), interval 1 year)
union
select Item.itemID, Item.libraryName, Item.title
from Item, Loan
where Item.itemID = Loan.itemID and
      Item.libraryName = Loan.lendingLibrary and
      Loan.dateOut >= date_sub(curdate(), interval 1 year);


-- 6: Find all the authors of any book in the library system in alphabetical order
-- Features: distinct, order by
select distinct author
from Item
where mediaType = 'book'
order by author;


-- 7: Retrieve all the items in the system in the order of the number of times
-- they have been checked out
-- Features: order by, outer theta join, grouping, aggregation
select Item.itemID, Item.libraryName, Item.title, count(Checkout.dateOut) as timesCheckedOut
from Item left join Checkout on
     Item.itemID = Checkout.itemID and Item.libraryName = Checkout.libraryName
group by Item.itemID, Item.libraryName, Item.title
order by count(Checkout.dateOut) desc;


-- 8: Find the customers for each library who have checked out the most movies
-- Features: 3-table natural join, grouping, having, aggregation, ordering, subquery
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


-- 9: Find the employees from the libraries that have the most items checked out
-- Features: nested sub-queries, grouping, having, aggregation
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


-- 10: Find the items that have been both loaned and checked out
-- Features: 3-table theta join
select Item.itemID, title, mediaType
from Item join
     Checkout on Item.itemID = Checkout.itemID join
     Loan on Checkout.itemID = Loan.itemID;
