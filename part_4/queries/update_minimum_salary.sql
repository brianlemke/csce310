-- Ensure that every employee is paid at least $10,000 a year.
update Employee
set salary = 10000.0
where salary < 10000.0;
