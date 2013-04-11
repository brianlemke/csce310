USE mtm2465-310db;

DROP TABLE IF EXISTS Library;

create table Library (
  name      varchar(255) primary key,
  address   varchar(255),
  city      varchar(100),
  zip       varchar(100)
);

DROP TABLE IF EXISTS Customer;

create table Customer (
  customerID  char(20) primary key,
  lastName    varchar(100),
  firstName   varchar(100),
  birthDate   date
);

DROP TABLE IF EXISTS Item;

create table Item (
  itemID        char(20),
  libraryName   varchar(255),
  mediaType     varchar(20),
  author        varchar(255),
  title         varchar(100),
  year          year,
  length        int,
  genre         varchar(20),
  artist        varchar(255),
  primary key (itemID, libraryName)
);

DROP TABLE IF EXISTS Employee;

create table Employee (
  employeeID    char(20) primary key,
  lastName      varchar(100),
  firstName     varchar(100),
  title         varchar(50),
  salary        float,
  libraryName   varchar(255)
);

DROP TABLE IF EXISTS Accesses;

create table Accesses (
  customerID    char(20),
  libraryName   varchar(255),
  primary key (customerID, libraryName)
);

DROP TABLE IF EXISTS Loan;

create table Loan (
  lendingLibrary    varchar(255),
  borrowingLibrary  varchar(255),
  dateOut           date,
  itemID            char(20),
  primary key(lendingLibrary, dateOut, itemID)
);

DROP TABLE IF EXISTS Checkout;

create table Checkout (
  libraryName   varchar(255),
  customerID    char(20),
  itemID        char(20),
  fineAmount    float,
  dateOut       date,
  dateDue       date,
  primary key (libraryName, itemID, dateOut)
);

INSERT INTO Library
VALUES 
  ('Green Public Library', '1000 N. Main St.', 'Green','76139'),
  ('Yellow Public Library','1000 S. Better St.','Omaha', '68101'),
  ('National Public Library', '80085 America Blvd', 'Cheltenham', '20588'),
  ('John Hopkins Library', '3423 Male Model Rd.', 'San Francisco', '94101'),
  ('Creative Name Library', '6849 Library Ln', 'Paris', '75462');


INSERT INTO Customer
VALUES 
  ('10001100011000110001', 'Granger', 'Hannah', '1992-01-03'),
  ('20002200022000220002', 'Johnny', 'Bravo', '1984-09-15'),
  ('30003300033000330003', 'Joeffery', 'Baratheon', '2006-06-06'),
  ('40004400044000440004', 'John', 'Snow', '2003-08-02'),
  ('50005500055000550005', 'Smith', 'Mary', '1972-01-01');


INSERT INTO Item 
VALUES 
  ('AAAD-1001-0000-1101Z', 'Green Public Library', 'Book' ,'Aleksandr Solzhenitsyn', 'One Day in the Life of Ivan Denisovich', '1962', NULL, 'Fiction', NULL),
  ('ZDAB-8521-0000-0001A', 'Yellow Public Library', 'Movie' ,NULL, 'The Graduate', '1967', 108, 'Drama', NULL),
  ('FGJA-8410-0000-0010J', 'National Public Library', 'Movie' , NULL, 'Live Free or Die Hard', '2007', 129, 'Action', NULL),
  ('APCO-1830-0000-2101A', 'John Hopkins Library', 'Book' ,'Maurice Sendak', 'Where the Wild Things Are', '1963', NULL, 'Fantasy', NULL),
  ('MOOO-1940-0000-0202A', 'Creative Name Library', 'Audio' , 'J.K. Rowling', 'Harry Potter and The Order of the Phoneix', '2003', 27*60, 'Fiction', NULL);


INSERT INTO Employee
VALUES 
  ('10000200003000040000', 'McInnis', 'Jamie', 'Head Librarian', 58000.0, 'Green Public Library'),
  ('20000300004000050000', 'Kramer', 'Arnold', 'Senior Librarian', 45581.0, 'Yellow Public Library'),
  ('30000400005000060000', 'Christmas', 'Mary', 'Stocker', 2250.5, 'National Public Library'),
  ('40000500006000070000', 'Frank', 'James', 'Librarian', 35000.0, 'John Hopkins Library'),
  ('50000600007000080000', 'Babbington', 'Thomas', 'Receptionist', 51000.23, 'Creative Name Library');


INSERT INTO Accesses 
VALUES 
  ('10001100011000110001', 'Green Public Library'),
  ('20002200022000220002', 'Yellow Public Library'),
  ('30003300033000330003', 'National Public Library'),
  ('40004400044000440004', 'John Hopkins Library'),
  ('50005500055000550005', 'Creative Name Library'),
  ('10001100011000110001', 'Yellow Public Library'),
  ('10001100011000110001', 'Creative Name Library');


INSERT INTO Loan
VALUES 
  ('Green Public Library', 'Yellow Public Library', '2009-10-10', 'AAAD-1001-0000-1101Z'),
  ('Yellow Public Library', 'National Public Library', '2012-12-12', 'ZDAB-8521-0000-0001A'),
  ('National Public Library', 'Creative Name Library', '2001-09-11', 'FGJA-8410-0000-0010J'),
  ('John Hopkins Library', 'Green Public Library', '2008-12-29', 'APCO-1830-0000-2101A'),
  ('Creative Name Library', 'John Hopkins Library', '2013-04-10', 'MOOO-1940-0000-0202A');


INSERT INTO Checkout
VALUES 
  ('Green Public Library', '10001100011000110001', 'AAAD-1001-0000-1101Z', 2.53, '2005-08-01', '2005-08-28'),
  ('Yellow Public Library', '20002200022000220002', 'ZDAB-8521-0000-0001A', 0.00, '2013-04-01', '2013-04-28'),
  ('National Public Library', '30003300033000330003', 'FGJA-8410-0000-0010J', 0.53, '2012-06-09', '2012-07-05'),
  ('John Hopkins Library', '40004400044000440004', 'APCO-1830-0000-2101A', 0.0, '2011-08-16', '2011-09-10'),
  ('Creative Name Library', '50005500055000550005', 'MOOO-1940-0000-0202A', 232.23, '2012-12-29', '2013-01-15');

SELECT * FROM Library;
SELECT * FROM Customer;
SELECT * FROM Item;
SELECT * FROM Employee;
SELECT * FROM Accesses;
SELECT * FROM Loan;
SELECT * FROM Checkout;



