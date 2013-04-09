create table Library (
  name      varchar(255) primary key,
  address   varchar(255),
  city      varchar(100),
  zip       varchar(100)
);

create table Customer (
  customerID  char(20) primary key,
  lastName    varchar(100),
  firstName   varchar(100),
  birthDate   date
);

create table Item (
  itemID        char(20),
  libraryName   varchar(255),
  author        varchar(255),
  title         varchar(100),
  year          year,
  length        int,
  genre         varchar(20),
  artist        varchar(255),
  primary key (itemID, libraryName)
);

create table Employee (
  employeeID    char(20) primary key,
  lastName      varchar(100),
  firstName     varchar(100),
  title         varchar(50),
  salary        float,
  libraryName   varchar(255)
);

create table Accesses (
  customerID    char(20),
  libraryName   varchar(255),
  primary key (customerID, libraryName)
);

create table Loan (
  lendingLibrary    varchar(255),
  borrowingLibrary  varchar(255),
  dateOut           date,
  itemID            char(20),
  primary key(lendingLibrary, dateOut, itemID)
);

create table Checkout (
  libraryName   varchar(255),
  customerID    char(20),
  itemID        char(20),
  fineAmount    float,
  dateOut       date,
  dateDue       date,
  primary key (libraryName, itemID, dateOut)
);
