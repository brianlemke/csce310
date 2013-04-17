SELECT i.mediaType and i.itemId 
	FROM Item as i  
		join Checkout as c on i.itemID = c.itemID 
		join Loan as l on c.itemID = l.itemID;