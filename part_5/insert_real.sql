use csce310;

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
  ('AAAD-1001-0000-1101Z', 'Green Public Library', 'book' ,'Aleksandr Solzhenitsyn', 'One Day in the Life of Ivan Denisovich', '1962', NULL, 'fiction', NULL),
  ('ZDAB-8521-0000-0001A', 'Yellow Public Library', 'movie' ,NULL, 'The Graduate', '1967', 108, 'drama', NULL),
  ('FGJA-8410-0000-0010J', 'National Public Library', 'movie' , NULL, 'Live Free or Die Hard', '2007', 129, 'action', NULL),
  ('APCO-1830-0000-2101A', 'John Hopkins Library', 'book' ,'Maurice Sendak', 'Where the Wild Things Are', '1963', NULL, 'fantasy', NULL),
  ('MOOO-1940-0000-0202A', 'Creative Name Library', 'audio' , 'J.K. Rowling', 'Harry Potter and The Order of the Phoneix', '2003', 27*60, 'fiction', NULL);


INSERT INTO Employee
VALUES 
  ('10000200003000040000', 'McInnis', 'Jamie', 'Head Librarian', 58000.0, 'Green Public Library'),
  ('20000300004000050000', 'Kramer', 'Arnold', 'Senior Librarian', 45581.0, 'Yellow Public Library'),
  ('30000400005000060000', 'Christmas', 'Mary', 'Stocker', 2250.5, 'National Public Library'),
  ('40000500006000070000', 'Frank', 'James', 'Librarian', 35000.0, 'John Hopkins Library'),
  ('50000600007000080000', 'Babbington', 'Thomas', 'Receptionist', 51000.23, 'Creative Name Library'),
  ('84297293194873240982', 'MacRyrie', 'George', 'Security Guard', 4000.00, NULL);


INSERT INTO Accesses 
VALUES 
  ('10001100011000110001', 'Green Public Library'),
  ('20002200022000220002', 'Yellow Public Library'),
  ('30003300033000330003', 'National Public Library'),
  ('50005500055000550005', 'Creative Name Library'),
  ('10001100011000110001', 'Yellow Public Library'),
  ('10001100011000110001', 'Creative Name Library'),
  ('30003300033000330003', 'John Hopkins Library');


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
  ('John Hopkins Library', '30003300033000330003', 'APCO-1830-0000-2101A', 0.4, '2012-06-14', '2012-07-10');
