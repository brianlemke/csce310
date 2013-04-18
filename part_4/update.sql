-- UPDATE 1
select * from Employee;
-- Reduce every system employee's salary by half
update Employee
set salary = salary / 2
where libraryName is null;

select * from Employee;


-- UPDATE 2
select * from Item;
-- Surround all movie titles with quotes (if not already quoted)
update Item
set title = concat('"', title, '"')
where mediaType = 'movie' and
      title not like '"%"';

select * from Item;



-- DELETE 1
-- Delete all items that have never been checked out
select * from Item;
delete from Item
where not exists (select *
                  from Checkout
                  where Checkout.itemID = Item.itemID and
                        Checkout.libraryName = Item.libraryName
                 );

select * from Item;


-- DELETE 2
select * from Customer;
-- Delete all customers that don't have access to any libraries
delete from Customer
where not exists (select *
                  from Accesses
                  where Customer.customerID = Accesses.customerID
                 );

select * from Customer;


-- INSERT 1
select * from Accesses;
-- Give all the customers access to all the libraries
insert into Accesses(customerID, libraryName)
select customerID, name
from Customer, Library
where not exists (select *
                  from Accesses
                  where Accesses.customerID = Customer.customerID and
                        Accesses.libraryName = Library.name
                 );

select * from Accesses;


-- INSERT 2
select * from Checkout;
-- Have the oldest customers check out the longest movies from the system
insert into Checkout(libraryName, customerID, itemID, fineAmount, dateOut, dateDue)
select libraryName, customerID, itemID, 0.0, curdate(), date_add(curdate(), interval 10 day)
from Item, Customer
where mediaType = 'movie' and
      length >= all (select length from Item where mediaType = 'movie') and
      birthDate <= all (select birthDate from Customer);

select * from Checkout;
