-- Delete all items that have never been checked out.
delete from Item
where not exists (select *
                  from Checkout
                  where Checkout.itemID = Item.itemID and
                        Checkout.libraryName = Item.libraryName
                 );
