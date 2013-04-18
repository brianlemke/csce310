-- Delete all customers that don't have access to any libraries.
delete from Customer
where not exists (select *
                  from Accesses
                  where Customer.customerID = Accesses.customerID
                 );
