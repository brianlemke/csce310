select * from Loan;
delete from Loan WHERE lendingLibrary = 'National Public Library' AND dateOut = '2001-09-11' AND itemID = 'FGJA-8410-0000-0010J';
select * from Loan;