-- Find all customers that have excessively high fines
select Customer.customerID, firstName, lastName, sum(fineAmount) as totalFines
from Customer, Checkout
where Customer.customerID = Checkout.customerID
group by Customer.customerID, firstName, lastName
having sum(fineAmount) > 200.00;
