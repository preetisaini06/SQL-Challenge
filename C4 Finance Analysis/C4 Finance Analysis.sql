

---------------------------------------- SQL Case Study -  Finance Analysis ---------------------------------------------------------

CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);

INSERT INTO Customers (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');

CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);

INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');

CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);

CREATE TABLE Transactions (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);

------------------------------------- Case study Question --------------------------------------------------------

/*
1. What are the names of all the customers who live in New York?
2. What is the total number of accounts in the Accounts table?
3. What is the total balance of all checking accounts?
4. What is the total balance of all accounts associated with customers who live in Los Angeles?
5. Which branch has the highest average account balance?
6. Which customer has the highest current balance in their accounts?
7. Which customer has made the most transactions in the Transactions table?
8.Which branch has the highest total balance across all of its accounts?
9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
10. Which branch has the highest number of transactions in the Transactions table?
*/

------------------------------------------------ Solution -------------------------------------------------

/* 1. What are the names of all the customers who live in New York? */

select firstname from customers
where city = 'New York'

/* 2. What is the total number of accounts in the Accounts table? */

select count(*) as No_of_account from accounts

/* 3. What is the total balance of all checking accounts? */

select sum(balance) as total_balance from accounts
where accounttype = 'Checking'

/* 4. What is the total balance of all accounts associated with customers who live in Los Angeles? */

select sum(a.balance) as total_balance from customers as c
join accounts as a on c.CUSTOMERID = a.CUSTOMERID
where city = 'Los Angeles'

/* 5. Which branch has the highest average account balance? */

select b.branchname,round(avg(a.balance),2)as avg_accountbalance from branches as b
join accounts as a on b.branchid = accountid
group by 1
order by 2 desc
limit 1

/* 6. Which customer has the highest current balance in their accounts? */

select c.firstname,c.lastname,sum(a.balance)as current_balance from customers as c
join accounts as a on c.customerid = a.customerid
group by 1,2
order by 3 desc
limit 1

/* 7. Which customer has made the most transactions in the Transactions table? */

select c.customerid,c.firstname,count(t.*)as transaction_count from customers as c
join accounts as a on c.customerid = a.customerid
join transactions as t on a.accountid = t.accountid
group by 1
order by 3 desc
limit 2

/* 8. Which branch has the highest total balance across all of its accounts? */

select b.branchname,sum(a.balance) as total_balance from branches as b
join accounts as a on b.branchid = a.branchid
group by 1
order by 2 desc
limit 1

/* 9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts? */

select c.firstname,c.lastname,sum(a.balance)as total_balance from customers as c
join accounts as a on c.customerid = a.customerid
group by 1,2
order by 3 desc
limit 1

/* 10. Which branch has the highest number of transactions in the Transactions table? */

/* Method 1 : Joins */

select b.branchname,count(t.*) as no_of_trans from branches as b
join accounts as a on b.branchid = a.branchid
join transactions as t on a.accountid = t.accountid
group by 1
order by 2 desc
limit 2
 
/* Method 2 : Subquery + Joins */

select
    b.branchname,
    (select count(*) from accounts a
     join transactions t on a.accountid = t.accountid
     where a.branchid = b.branchid) as no_of_trans
from branches b
order by no_of_trans desc
limit 2



