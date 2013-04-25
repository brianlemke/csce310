USE csce310;

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



