-- I've created database HELLAS_CAMP
-- Then i started using the database

USE HELLAS_CAMP;

-- Load data from GeneratedData.txt into MainTable through a script(BulkLoad.sql) .

-- Channel data to the rest of the tables from MainTable

INSERT INTO Staff 
SELECT DISTINCT StaffNo, StaffName, StaffSurname
FROM MainTable;

INSERT INTO Payment
SELECT DISTINCT payCode, payMethod
FROM MainTable;

INSERT INTO Customer
SELECT DISTINCT custCode, custName, custSurname, custPhone
FROM MainTable;

INSERT INTO Booking
SELECT DISTINCT bookCode, bookDt, payCode, custCode, staffNo
FROM MainTable;

INSERT INTO Camping
SELECT DISTINCT campCode, campName, numOfEmp 
FROM MainTable;

INSERT INTO Category
SELECT DISTINCT catCode, areaM2, unitCost
FROM MainTable;

INSERT INTO Emplacement
SELECT DISTINCT campCode, empNo, catCode
FROM MainTable;

INSERT INTO Rental
SELECT DISTINCT bookCode, campCode, empNo, startDt, endDt, noPers
FROM MainTable;

-- Queries

-- a

SELECT paycode,COUNT(bookCode) as totalBookings FROM Booking GROUP BY payCode;

-- b

SELECT Staff.staffName,Staff.staffSurname,COUNT(*) AS Max_Bookings
FROM Booking,Staff
WHERE Booking.staffNo=Staff.staffNo
GROUP BY Booking.staffNo,Staff.staffName,Staff.staffSurname
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM Booking GROUP BY Booking.staffNo)

-- c

SELECT COUNT(DISTINCT Booking.bookCode) AS TOTAL FROM Booking,Rental,Emplacement
WHERE Booking.bookCode IN 
(SELECT Booking.bookCode FROM Booking,Rental,Emplacement 
WHERE Booking.bookCode=Rental.bookCode AND Rental.campCode=Emplacement.campCode AND Rental.empNo=Emplacement.empNo AND Emplacement.catCode='A') 
AND Booking.bookCode NOT IN 
(SELECT Booking.bookCode FROM Booking,Rental,Emplacement 
WHERE Booking.bookCode=Rental.bookCode AND Rental.campCode=Emplacement.campCode AND Rental.empNo=Emplacement.empNo AND Emplacement.catCode!='A')

-- d

SELECT Customer.custName,Customer.custSurname, COUNT(Booking.bookCode) AS NUM_OF_BOOKINGS FROM Customer,Booking,Rental
WHERE Booking.custCode=Customer.custCode AND Rental.bookCode=Booking.bookCode AND YEAR(Booking.bookDt)=2000
GROUP BY Booking.custCode,Customer.custName,Customer.custSurname
ORDER BY Customer.custSurname

-- e

SELECT Camping.campName,SUM(Category.unitCost*DATEDIFF(DAY,Rental.startDt,Rental.endDt)*Rental.noPers) AS Income FROM Category,Rental,Emplacement,Camping
WHERE Emplacement.catCode=Category.catCode AND Emplacement.campCode=Rental.campCode AND Emplacement.empNo=Rental.empNo AND Emplacement.campCode=Camping.campCode
GROUP BY Camping.campName

-- Create indexes to speed up the last two queries : d and e

CREATE INDEX IX_Customer ON Customer(custCode) INCLUDE (custName,custSurname)
CREATE INDEX IX_Cust_Book ON Booking(custCode,bookDt)
CREATE INDEX IX_Rental ON Rental(campCode,empNo) INCLUDE (startDt,endDt,noPers)