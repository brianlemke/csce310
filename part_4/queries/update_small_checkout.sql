SELECT * from Checkout;
update Checkout set dateDue = '2013-01-22' where libraryName = 'Creative Name Library' and itemID = 'MOOO-1940-0000-0202A' and dateOut = '2012-12-29';
select * from Checkout;