-- Reduce every system employee's salary by half
update Employee
set salary = salary / 2
where libraryName is null;
