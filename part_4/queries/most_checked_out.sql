-- Retrieve all the items in the system in the order of the number of times they
-- have been checked out.
select Item.itemID, Item.libraryName, Item.title, count(Checkout.dateOut) as timesCheckedOut
from Item left join Checkout on
     Item.itemID = Checkout.itemID and Item.libraryName = Checkout.libraryName
group by Item.itemID, Item.libraryName, Item.title
order by count(Checkout.dateOut) desc;
