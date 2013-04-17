-- Find all the items that have been either loaned or checked out within the last
-- year.
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
