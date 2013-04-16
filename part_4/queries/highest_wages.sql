-- Find the libraries that pay the highest average wages to their employees.
select Library.name, avg(Employee.salary) as averageSalary
from Library, Employee
where Library.name = Employee.libraryName
group by Library.name
having avg(Employee.salary) >= all (select avg(Employee.salary)
                                    from Library, Employee
                                    where Library.name = Employee.libraryName
                                    group by Library.name);
