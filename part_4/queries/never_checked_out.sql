-- Find all items that have never been checked out
select *
from Item
where not exists(select *
                 from Checkout
                 where Checkout.itemID = Item.itemID and
                       Checkout.libraryName = Item.libraryName
                );
