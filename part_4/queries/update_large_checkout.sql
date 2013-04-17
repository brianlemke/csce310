SELECT * from Checkout;
update Checkout set dateDue = '2013-01-22' where libraryName = 'Zemlak Group' and itemID = '44941136973721702730' and dateOut = '1998-11-27';
select * from Checkout;