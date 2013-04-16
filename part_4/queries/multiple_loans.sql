-- Show all items that have been loaned out more than once
select *
from Item
where (select count(itemID)
       from Loan
       where Loan.itemID = Item.itemID and
             Loan.lendingLibrary = Item.libraryName
      ) > 1;
