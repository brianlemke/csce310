-- Give all the customers access to all the libraries
insert into Accesses(customerID, libraryName)
select customerID, name
from Customer, Library
where not exists (select *
                  from Accesses
                  where Accesses.customerID = Customer.customerID and
                        Accesses.libraryName = Library.name
                 );
