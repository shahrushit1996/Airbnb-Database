BACKUP DATABASE Airbnb_Proj TO DISK = 'C:\sql\Airbnb_Proj_BKP.bak'

BACKUP DATABASE Airbnb_Proj TO DISK = 'C:\sql\Airbnb_Proj_BKP.bak' WITH DIFFERENTIAL


USE MASTER
--DROP DATABASE Airbnb_Proj
--CREATE DATABASE Airbnb_Proj

Use Airbnb_Proj

--DDL Statements

CREATE TABLE tblCustomerType(
CustomerTypeID INT IDENTITY(1,1) PRIMARY KEY,
CustomerType VARCHAR(20) NOT NULL
)
GO

INSERT INTO tblCustomerType(CustomerType) VALUES ('Youth'),('Senior'), ('Standard'), ('Premium')

CREATE TABLE tblAmenityType(
AmenityTypeID int IDENTITY(1,1) PRIMARY KEY,
AmenityType VARCHAR(20) NOT NULL,
AmenityTypeDesc VARCHAR(1000)
)

INSERT INTO tblAmenityType(AmenityType) VALUES ('Standard'), ('Deluxe'), ('Gold'), ('Platinum')


CREATE TABLE tblGender (
    GenderID int IDENTITY(1,1) PRIMARY KEY,
    GenderName varchar(50) NOT NULL
);

INSERT INTO tblGender(GenderName)
VALUES ('Male'),('Female'),('Trans'),('Neutral')


CREATE TABLE tblRating(
    RatingID int IDENTITY(1,1) PRIMARY KEY,
    RatingName varchar(50) NOT NULL,
	Rating int NOT NULL
);

INSERT INTO tblRating(RatingName, Rating)
VALUES('Excellent', 5),('Good', 4),('Satisfactory', 3),('Bad', 2),('Lousy', 1)


Create TABLE tblPaymentType (
PaymentTypeID int IDENTITY PRIMARY KEY,
PaymentTypename VARCHAR (20) NOT NULL
)

Insert into tblPaymentType(PaymentTypename)
VALUES ('Deposit'), ('Pending Amount')

CREATE TABLE tblState(
	StateID varchar(2) PRIMARY KEY,
    State varchar(50) NOT NULL
);



INSERT INTO tblSTATE(StateID,State)
SELECT StateID, State from dbo.Tmp_State


CREATE TABLE tblCity (
    CityID int IDENTITY(1,1) PRIMARY KEY,
    City varchar(50) NOT NULL,
	StateID varchar(2) FOREIGN KEY REFERENCES tblState(StateID)
);

INSERT INTO tblCity(City, StateID)
SELECT City, StateID FROM dbo.tmp_city

CREATE TABLE tblAmenity(
AmenityID INT IDENTITY(1,1) PRIMARY KEY,
AmenityName VARCHAR(50) NOT NULL,
AmenityDesc VARCHAR(1000), 
AmenityTypeID INT FOREIGN KEY REFERENCES tblAmenityType(AmenityTypeID) not null
)

INSERT INTO tblAmenity(AmenityName, AmenityTypeID) 
VALUES ('Bedroom',1),('Bathroom',1),('Dining',1),('Shower',1), ('Kitchen',1),('Smoke alarm',1), 
('Washer', 2), ('Dryer', 2), ('Refrigerator', 2), ('Stove', 2), 
('Indoor Fireplace', 3), ('Coffee Maker', 3), ('First Aid Kit', 3), ('Dishwasher', 3), 
('BBQ', 4), ('Oven', 4), ('Private Patio', 4), ('Security Cameras', 4), ('Air Conditioning', 4)

Create TABLE tblHost (
    HostID int IDENTITY(1,1) PRIMARY KEY,
    HostFname VARCHAR (50) NOT NULL,
    HostLname VARCHAR (50) NOT NULL,
    HostDOB DATE NOT NULL,
    GenderID int FOREIGN KEY REFERENCES tblGENDER (GenderID) not null,
    HostAddress VARCHAR (100) NOT NULL,
	HostZipcode VARCHAR(10) NOT NULL,
    CityID int FOREIGN KEY REFERENCES tblCity (CityID) not null
)


Create TABLE tblCustomer (
    CustomerID int IDENTITY(1,1) PRIMARY KEY,
    CustomerFname VARCHAR (20) NOT NULL,
    CustomerLname VARCHAR (20) NOT NULL,
    CustomerAddress VARCHAR (100) NOT NULL,
	CustomerZipcode VARCHAR(10) NOT NULL,
    CustomerBirth DATE NOT NULL,
	CustomerAge int,
    AvgCustomerRating NUMERIC (8,2) not NULL,
    GenderID int FOREIGN KEY REFERENCES tblGENDER (GenderID) not null,
    CityID int FOREIGN KEY REFERENCES tblCity (CityID) not null,
    CustomerTypeID int FOREIGN KEY REFERENCES tblCustomerType (CustomerTypeID) not null
	
)


CREATE TABLE tblListing(
ListingID INT IDENTITY(1,1) PRIMARY KEY,   
CityID INT FOREIGN KEY REFERENCES tblCity(CityID) not null,
HostID INT FOREIGN KEY REFERENCES tblHost(HostID) not null,
ListingName VARCHAR(100) NOT NULL,
ListingAddress VARCHAR(100) NOT NULL,
ListingZipcode VARCHAR(10) NOT NULL,
AvgListingRating NUMERIC(8,2),
Price NUMERIC(8,2) NOT NULL
)

CREATE TABLE tblListingAmenity(
ListingAmenityID INT IDENTITY(1,1) PRIMARY KEY,
Quantity INT,
ListingID INT FOREIGN KEY REFERENCES tblListing(ListingID) not null,
AmenityID INT FOREIGN KEY REFERENCES tblAmenity(AmenityID) not null
)

CREATE TABLE tblBooking
(
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    ListingID INT FOREIGN KEY REFERENCES tblListing (ListingID),
    CustomerID INT FOREIGN KEY REFERENCES tblCustomer (CustomerID),
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    BookingDays INT
)

CREATE TABLE tblPayment(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentTypeID INT FOREIGN KEY REFERENCES tblPaymentType (PaymentTypeID),
    OriginalAmount NUMERIC(8,2),
    TaxAmount NUMERIC(8,2),
    FinalAmount NUMERIC(8,2),
    BookingID INT FOREIGN KEY REFERENCES tblBooking (BookingID)
)

CREATE TABLE tblReview(
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ReviewDate DATE NOT NULL,
    ReviewText VARCHAR(2000),
    RatingID INT FOREIGN KEY REFERENCES tblRating (RatingID),
    BookingID INT FOREIGN KEY REFERENCES tblBooking (BookingID)
)

DELETE FROM tblCity
WHERE city in
(select city from tblCity
group by city
having count(stateid)>1
)

create table peeps
(
    PeepID int IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Address VARCHAR(255),
    DOB DATE,
    City VARCHAR(100),
    State VARCHAR(100),
    Gender VARCHAR(20),
    Zipcode VARCHAR(20),
	Listing VARCHAR(100)

)

insert into Peeps(FirstName, LastName, Address, DOB, City, State, Gender, Zipcode, Listing)
Select CustomerFname, CustomerLname, CustomerAddress, DateOfBirth, CustomerCity, CustomerState, 'Female' as Gender, CustomerZip, BusinessName as Listing
FROM Peeps.dbo.tblCUSTOMER peeps


Create Table tempPeepsrawCustomer(
    PeepID int IDENTITY(1,1) PRIMARY Key,
    CustomerFname VARCHAR(255),
    CustomerLname VARCHAR(255),
    Address VARCHAR(255),
    DOB DATE,
    City VARCHAR(100),
    Gender VARCHAR(20),
    ctype VARCHAR(255),
    zipcode VARCHAR(20),
    Rating NUMERIC(4,2)
)


insert into tempPeepsrawCustomer(CustomerFname, CustomerLname, Address, DOB, City, Gender, ctype, zipcode, Rating)
Select p.FirstName, p.LastName, Address, DOB, p.City, Gender, 
case when DATEDIFF(YEAR, DOB, GETDATE()) <= 25 then 'Youth'
when DATEDIFF(YEAR, DOB, GETDATE()) >= 60 then 'Senior' else 'Standard' END as CType, 
zipcode, ROUND((RAND(convert(varbinary, newid()))*10)/2,2) as Rating
FROM Peeps p
inner join tblCity c on p.City = c.City
WHERE YEAR(DOB) NOT IN (1987, 1988)


Select* into tempPeepsrawCustomer_bkp
from tempPeepsrawCustomer


CREATE TABLE tempPeepsrawHost(
    PeepID int IDENTITY(1,1) PRIMARY Key,
    HostFname VARCHAR(255),
    HostLname VARCHAR(255),
    HostAddress VARCHAR(255),
    HostDOB DATE,
    City VARCHAR(100),
    Gender VARCHAR(20),
    Zipcode VARCHAR(20)

)


insert into tempPeepsrawHost(HostFname, HostLname, HostAddress, HostDOB, City, Gender, Zipcode)
Select FirstName, LastName, Address, DOB, p.City, Gender, zipcode
FROM Peeps p  inner join tblCity c ON p.City = c.City
where YEAR(DOB) IN (1987, 1988)

Select* into tempPeepsrawHost_bkp
from tempPeepsrawHost


Create Table tempPeepsrawListing(
    ListID int IDENTITY (1,1) primary KEY,
    ListName  VARCHAR(255),
    ListAddress VARCHAR(500),
    ListZip VARCHAR(20),
    ListCity VARCHAR(50),
    HFname VARCHAR (255),
    HLname  VARCHAR (255),
    HDOB Date,
    LPrice NUMERIC (10,2)
)

INSERT into tempPeepsrawListing(ListName, ListAddress, ListZip, ListCity, HFname, HLname, HDOB, LPrice)
Select Listing, Address, Zipcode, p.City, FirstName, LastName, DOB,
ABS(CHECKSUM(NEWID()))%900 + 100 AS Price 
FROM peeps p inner join tblCity c ON p.City = c.City
where  YEAR(DOB) IN (1987, 1988)


Select* into tempPeepsrawListing_bkp
from tempPeepsrawListing


GO
CREATE PROCEDURE GetGender
@GName VARCHAR(50),
@G_ID INT OUTPUT
AS
SET @G_ID = (SELECT GenderID FROM tblGender WHERE GenderName = @GName)

Go
CREATE PROCEDURE GetCity
@City_name VARCHAR(50),
@City_ID INT OUTPUT
AS
SET @City_ID = (SELECT CityID FROM tblCity WHERE City = @City_name)

GO
CREATE PROCEDURE GetCustomerType
@CT_Type VARCHAR(30),
@CT_ID INT OUTPUT
AS
SET @CT_ID = (Select CustomerTypeID
                from tblCustomerType
                where CustomerType = @CT_Type)

GO
CREATE PROC GetRatingID
@Rating INT,
@R_ID INT OUTPUT
AS
SET @R_ID = (SELECT RatingID FROM tblRating WHERE Rating = @Rating)

--business rules

BEGIN TRANSACTION T5
ALTER TABLE tblCustomer
ADD CHECK (CustomerBirth <= GetDate())
COMMIT TRANSACTION T5

BEGIN TRANSACTION T6
ALTER TABLE tblGender
ADD CHECK (GenderName IN ('Male','Female','Trans','Neutral'))
COMMIT TRANSACTION T6

BEGIN TRANSACTION T7
ALTER TABLE tblCustomer
ADD CHECK (CustomerAge >= 13)
COMMIT TRANSACTION T7

BEGIN TRANSACTION T8
ALTER TABLE tblHost
ADD CHECK(dbo.CalcAge(HostDOB) >= 21)
COMMIT TRANSACTION T8

BEGIN TRANSACTION T9
ALTER TABLE tblListing
ADD CHECK(Price <= 1000.00)
COMMIT TRANSACTION T9

BEGIN TRANSACTION T10
ALTER TABLE tblBooking
ADD CHECK(BookingDays <= 10)
COMMIT TRANSACTION T10

BEGIN TRANSACTION T11
ALTER TABLE tblBooking
add CHECK(CheckInDate < CheckOutDate)
COMMIT TRANSACTION T11

BEGIN TRANSACTION T12
ALTER TABLE tblListing
add CHECK(AvgListingRating BETWEEN 0 and 5)
COMMIT TRANSACTION T12


GO
CREATE FUNCTION CalcAge(@DOB Date)
RETURNS INT AS
BEGIN 
	DECLARE @AGE INT;
	SET @AGE = DATEDIFF(Year,@DOB, GETDATE());

	RETURN @AGE
END;

GO
CREATE FUNCTION CalcBookingDays (@Checkin DATE, @Checkout DATE)
RETURNS INT AS
BEGIN
    DECLARE @Days INT;
    SET @Days = DATEDIFF(DAY, @Checkin, @Checkout);

    RETURN @Days
END;

GO
CREATE FUNCTION CalcOGAmt (@Days INT, @Price NUMERIC(8,2))
RETURNS NUMERIC(8,2) AS
BEGIN
    DECLARE @OGAmt NUMERIC(8,2);
    SET @OGAmt = (@Days * @Price);

    RETURN @OGAmt
END;

GO

CREATE FUNCTION CalcTaxAmt (@OGAmt NUMERIC(8,2), @State VARCHAR(4))
RETURNS NUMERIC(8,2) AS
BEGIN
    DECLARE @TaxAmt NUMERIC(8,2);
    SET @TaxAmt = (SELECT CASE WHEN @State IN ('CA') THEN @OGAmt * 0.0725
                               WHEN @State IN ('TN','RI', 'MS', 'IN') THEN @OGAmt * 0.007
                               WHEN @State IN ('MN') THEN @OGAmt * 0.0688
                               WHEN @State IN ('NV') THEN @OGAmt * 0.0685
                               WHEN @State IN ('NJ') THEN @OGAmt * 0.0663
                               WHEN @State IN ('WA', 'AR', 'KS') THEN @OGAmt * 0.0650
                               WHEN @State IN ('CT') THEN @OGAmt * 0.0635
                               WHEN @State IN ('TX', 'MA', 'IL') THEN @OGAmt * 0.0625
                               WHEN @State IN ('WV', 'VT', 'SC', 'PA', 'MI', 'MD', 'KY', 'IA', 'FL', 'ID') THEN @OGAmt * 0.0600
                               WHEN @State IN ('UT') THEN @OGAmt * 0.0595
                               WHEN @State IN ('OH') THEN @OGAmt * 0.0575
                               WHEN @State IN ('AZ') THEN @OGAmt * 0.0560
                               WHEN @State IN ('NE', 'ME') THEN @OGAmt * 0.0550
                               WHEN @State IN ('VA') THEN @OGAmt * 0.0530
                               WHEN @State IN ('NM') THEN @OGAmt * 0.0513
                               WHEN @State IN ('WI', 'ND') THEN @OGAmt * 0.0500
                               WHEN @State IN ('NC') THEN @OGAmt * 0.0475
                               WHEN @State IN ('SD', 'OK') THEN @OGAmt * 0.0450
                               WHEN @State IN ('LA') THEN @OGAmt * 0.0445
                               WHEN @State IN ('MO') THEN @OGAmt * 0.0423
                               WHEN @State IN ('WY', 'NY', 'HI', 'GA', 'AL') THEN @OGAmt * 0.0400
                               WHEN @State IN ('CO') THEN @OGAmt * 0.029
                               WHEN @State IN ('OR', 'NH', 'MT', 'DE', 'AK') THEN @OGAmt * 0.00
                               ELSE @OGAmt * 0.00
                               END AS Tax);
    RETURN @TaxAmt
END;

GO
CREATE FUNCTION CalcFinalAmt (@OGAmt NUMERIC(8,2), @TaxAmt NUMERIC(8,2))
RETURNS NUMERIC(8,2) AS
BEGIN
    DECLARE @FinalAmt NUMERIC(8,2);
    SET @FinalAmt = (@OGAmt + @TaxAmt);

    RETURN @FinalAmt
END;

GO
CREATE FUNCTION CalcDeposit (@OGAmt NUMERIC(8,2))
RETURNS NUMERIC(8,2) AS
BEGIN
    DECLARE @Deposit NUMERIC(8,2);
    SET @Deposit = (@OGAmt * 0.10)

    RETURN @Deposit
END;



go
CREATE FUNCTION CalcPendingAmt(@OG_amt NUMERIC(8,2), @Deposit NUMERIC(8,2))
RETURNS NUMERIC (8,2) AS
BEGIN 
    DECLARE @PendAmt NUMERIC(8,2);
    SET @PendAmt = (@OG_amt - @Deposit)

    RETURN @PendAmt
END;


go
CREATE FUNCTION Calclistrating(@listingid int)
RETURNS NUMERIC(8,2) AS
BEGIN 
	DECLARE @rating NUMERIC(8,2);
	SET @rating = (Select  Avg(x.Ratings*1.0) as Rating
    from tblListing l 
    INNER join 
    (Select T3.ListingID, T3.BookingID, avg(T1.rating*1.0) as Ratings
    from tblRating T1
    inner join tblReview T2 on T2.ratingID = T1.ratingID
    inner join tblBooking T3 on T2.BookingID = T3.BookingID
    group by T3.ListingID, T3.BookingID
    )x on l.ListingID = x.ListingID
    where l.ListingID = @listingid
    group by l.ListingID
    )

	RETURN @rating
END;



--tblCustomer
go
CREATE proc Wrapper_InsertCustomer
as
DECLARE @cFname varchar(255), @cLname varchar(255), @cAddress VARCHAR(500), @cBirth date, @cAge int, 
		@cRating NUMERIC(4,2), @cGender VARCHAR(50), @cCity varchar(100), @cZipcode varchar(20), @cCtype varchar(50)
DECLARE @MinPK INT
DECLARE @RUN INT = (Select count(*) from tempPeepsrawCustomer)
DECLARE @G1_ID INT, @City1_ID INT, @CT1_ID INT
WHILE @RUN>0
BEGIN
Set @MinPK = (select min(PeepID) 
                from tempPeepsrawCustomer) 

Set @cFname =(Select CustomerFname from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cLname =(Select CustomerLname from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cAddress =(Select Address from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cBirth =(Select DOB from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cRating =(Select Rating from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cGender = (Select Gender from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cCity =(Select City from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cZipcode =(Select zipcode from tempPeepsrawCustomer where PeepID = @MinPK)
Set @cCtype =(Select ctype from tempPeepsrawCustomer where PeepID = @MinPK) 
SET @cAge = (Select dbo.CalcAge(@cBirth))


exec GetGender
@GName = @cGender,
@G_ID = @G1_ID OUTPUT

exec GetCity
@City_name = @cCity,
@City_ID = @City1_ID output

exec GetCustomerType
@CT_Type = @cCtype,
@CT_ID = @CT1_ID OUTPUT

BEGIN TRANSACTION T1
insert into tblCustomer 
(CustomerFname, CustomerLname, CustomerAddress, CustomerBirth, CustomerAge, AvgCustomerRating, GenderID, CityID, CustomerTypeID, CustomerZipcode)
VALUES (@cFname, @cLname, @cAddress, @cBirth, @cAge, @cRating, @G1_ID, @City1_ID, @CT1_ID, @cZipcode)
IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR <> 0; terminating process'
		ROLLBACK TRANSACTION T1
	END
ELSE 
COMMIT TRANSACTION T1

DELETE from tempPeepsrawCustomer
WHERE PeepID = @MinPK

Set @RUN = @RUN-1
END

exec wrapper_InsertCustomer

--tblHost & tbllisting
GO
CREATE PROC wrapper_InsertHost_Listing
AS
DECLARE @hFname VARCHAR(100), @hLname VARCHAR(100), @hBirth DATE, @hGender VARCHAR(50), @hAddress VARCHAR(500), 
@hCity VARCHAR(100), @hZipcode VARCHAR(10)
DECLARE @MinPK INT
DECLARE @RUN INT = (SELECT COUNT(*) FROM tempPeepsrawHost)
DECLARE @Gndr_ID INT, @Cty_ID INT, @Host_ID INT
WHILE @RUN > 0
BEGIN
SET @MinPK = (SELECT MIN(PeepID) FROM tempPeepsrawHost)
SET @hFname = (SELECT HostFName FROM tempPeepsrawHost WHERE PeepID = @MinPK)
SET @hLname = (SELECT HostLName FROM tempPeepsrawHost WHERE PeepID = @MinPK)
SET @hBirth = (SELECT HostDOB FROM tempPeepsrawHost WHERE PeepID = @MinPK)
SET @hGender = (SELECT Gender FROM tempPeepsrawHost WHERE PeepID = @MinPK)
SET @hAddress = (SELECT HostAddress FROM tempPeepsrawHost WHERE PeepID = @MinPK)
SET @hCity = (SELECT City FROM tempPeepsrawHost WHERE PeepID = @MinPK)
SET @hZipcode = (SELECT Zipcode FROM tempPeepsrawHost WHERE PeepID = @MinPK)

exec GetGender
@GName = @hGender,
@G_ID = @Gndr_ID OUTPUT

exec GetCity
@City_name = @hCity,
@City_ID = @Cty_ID OUTPUT

BEGIN TRANSACTION T1
INSERT INTO tblHost (HostFName, HostLName, HostDOB, GenderID, HostAddress, CityID, HostZipcode)
VALUES (@hFname, @hLname, @hBirth, @Gndr_ID, @hAddress, @Cty_ID, @hZipcode)


SET @Host_ID = (SELECT Scope_Identity())

INSERT INTO tblListing (CityID, HostID, ListingName, ListingAddress, Price, ListingZipcode)
SELECT @Cty_ID, @Host_ID, ListName, ListAddress, LPrice, ListZip 
FROM tempPeepsrawListing
WHERE HFname = @hFname
AND HLname = @hLname
AND HDOB = @hBirth

IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR <> 0; terminating process'
		ROLLBACK TRANSACTION T1
	END
ELSE 
COMMIT TRANSACTION T1

DELETE FROM tempPeepsrawHost
WHERE PeepID = @MinPK

set @RUN = @RUN - 1
END


exec wrapper_InsertHost_Listing

--tblBooking
GO
CREATE PROC Wrapper_InsertBooking
@RUN INT
AS
DECLARE @L_ID INT, @Cust_ID INT, @InDate DATE, @OutDate DATE, @NDays INT
DECLARE @Key_L INT, @Key_Cust INT
DECLARE @L_count INT = (SELECT COUNT(*) FROM tblListing) 
DECLARE @Cust_count INT = (SELECT COUNT(*) FROM tblCustomer)
DECLARE @Min_L INT = (SELECT MIN(ListingID) FROM tblListing)
DECLARE @Min_Cust INT = (SELECT MIN(CustomerID) FROM tblCustomer)
DECLARE @DateStart	Date = '2020-01-01' ,@DateEnd	Date = GETDATE()
WHILE @RUN > 0
BEGIN
DECLARE @N1 INT = Rand() * DateDiff(Day, @DateStart, @DateEnd)
DECLARE @N2 INT = (RAND() * 10) + 1
SET @Key_L = (SELECT (RAND() * @L_count) + @Min_L)
SET @Key_Cust = (SELECT (RAND() * @Cust_count) + @Min_Cust)

SET @L_ID = (SELECT ListingID FROM tblListing WHERE ListingID = @Key_L)
SET @Cust_ID = (SELECT CustomerID FROM tblCustomer WHERE CustomerID = @Key_Cust)
SET @InDate = (SELECT DATEADD(DAY, @N1, @DateStart))
SET @OutDate = (SELECT DATEADD(DAY, @N2, @InDate)) 
SET @NDays = (SELECT dbo.CalcBookingDays(@InDate, @OutDate))

BEGIN TRANSACTION T3
INSERT INTO tblBooking (ListingID, CustomerID, CheckInDate, CheckOutDate, BookingDays)
VALUES (@L_ID, @Cust_ID, @InDate, @OutDate, @NDays)
IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR <> 0; terminating process'
		ROLLBACK TRANSACTION T3
	END
ELSE 
COMMIT TRANSACTION T3

SET @RUN = @RUN - 1
END

EXEC Wrapper_InsertBooking 100000


CREATE TABLE TempReview (
    ReviewID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    ReviewText VARCHAR (1000),
    Rating INT
)

INSERT into TempReview (ReviewText, Rating)
VALUES ('Hospitable hosts', 4), 
('Amazing views from the stay', 5),
('Good stay but stay was not cleaned well', 3),
('Did not enjoy the stay at all', 1),
('Definitely recommend this 10/10 stay', 5),
('Rooms were too stuffy', 2),
('Smooth check in and check out of the building. Enjoyed the amenities', 4),
('Bathroom appliances were not functional', 2),
('Kitchen cutlery was not provided, however apart from that the stay was good', 3),
('Pictures of the building are deceptive, the stay was not good', 1),
('Board games provided with the stay was a nice touch, really had a fun weekend', 4),
('Thanks for stocking the apartment with DVDs, had a fun movie marathon', 4),
('Extremely serene and peaceful stay, felt one with nature at this stay', 5),
('The wifi of the place was not functional. Wanted a staycation but was disappointed', 2),
('Host was not very prompt with the communication, had to wait outside for a very long time to get into the apartment', 1)


--tblReview
CREATE TABLE TEMP1 (ReviewText VARCHAR(1000), RatingID INT)

GO
CREATE PROC Wrapper_InsertReview
@RUN INT
AS
DECLARE @RDate DATE, @Rating_ID INT, @B_ID INT, @Rat INT, @RT VARCHAR(1000)
DECLARE @Min_R INT = (SELECT MIN(ReviewID) FROM TempReview)
DECLARE @Min_B INT = (SELECT MIN(BookingID) FROM tblBooking)
DECLARE @R_count INT = (SELECT COUNT(*) FROM TempReview) 
DECLARE @B_count INT = (SELECT COUNT(*) FROM tblBooking)

DECLARE @Key_B INT, @Key_R INT
DECLARE @iRun INT

WHILE @RUN > 0
BEGIN

SET @Key_B = (select (RAND() * @B_count) + @Min_B)
SET @B_ID = (select BookingID from tblBooking WHERE BookingID = @Key_B)
SET @RDate = (select DATEADD(Day, (RAND() * 10) + 1, CheckOutDate) FROM tblBooking WHERE BookingID = @Key_B)
SET @iRun = (select ((RAND() * 10) + 1)/2)

    WHILE @iRun > 0
    BEGIN
    SET @Key_R = (select (RAND() * @R_count) + @Min_R)
    SET @Rat = (select Rating from tempreview where ReviewID = @Key_R)
    SET @RT = (select ReviewText from tempreview where ReviewID = @Key_R)

    EXEC GetRatingID
    @Rating = @Rat,
    @R_ID = @Rating_ID OUTPUT

	BEGIN TRANSACTION T4
    INSERT INTO TEMP1
    VALUES (@RT , @Rating_ID )

	IF @@ERROR <> 0
		BEGIN
			PRINT '@@ERROR <> 0; terminating process'
			ROLLBACK TRANSACTION T4
		END
	ELSE 
		COMMIT TRANSACTION T4


    SET @iRun = @iRun -1
    END

BEGIN TRANSACTION T5
INSERT into tblReview(ReviewDate, ReviewText, RatingID, BookingID)
SELECT @RDate, T1.ReviewText, T1.RatingID, @B_ID
FROM Temp1 T1

IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR <> 0; terminating process'
		ROLLBACK TRANSACTION T5
	END
ELSE 
	COMMIT TRANSACTION T5

DELETE FROM Temp1

SET @RUN = @RUN-1

END

EXEC Wrapper_InsertReview 75000


--tblAmenityListing
Create TABLE Temp2(A_ID INT, Q INT)

GO
ALTER PROC Wrapper_InsertListingAmenity

AS
DECLARE @Listing_ID INT, @Amenity_ID INT, @Qty INT
DECLARE @AmenityPK INT
DECLARE @List_Count INT = (SELECT COUNT(*) FROM tblListing)
DECLARE @Amenity_Count INT = (SELECT COUNT(*) FROM tblAmenity)
DECLARE @Min_list INT = (Select min(ListingID) from tblListing)
DECLARE @Min_Amenity INT = (Select min(AmenityID) from tblAmenity)
DECLARE @RunAmenity INT


WHILE @List_Count > 0
BEGIN

SET @Listing_ID = (SELECT ListingID FROM tblListing WHERE ListingID = @Min_list)
SET @RUNAmenity = (Select floor(Rand()*(10-2+1))+1)


        While @RUNAmenity > 0
        BEGIN 
        SET @AmenityPK = (Select (Rand() * @Amenity_Count) + @Min_Amenity)
        SET @Amenity_ID = (Select AmenityID from tblAmenity where AmenityID = @AmenityPK)
        SET @Qty = (Select floor(Rand()*(10-2+1))+1)

		BEGIN TRANSACTION T6
        Insert into Temp2 (A_ID, Q)
        VALUES (@Amenity_ID, @Qty)

		IF @@ERROR <> 0
			BEGIN
				PRINT '@@ERROR <> 0; terminating process'
				ROLLBACK TRANSACTION T6
			END
		ELSE 
			COMMIT TRANSACTION T6


		Set @RUNAmenity = @RUNAmenity - 1
		END


BEGIN TRANSACTION T7
INSERT INTO tblListingAmenity (ListingID, AmenityID, Quantity)
Select @Listing_ID, T1.A_ID, T1.Q
from Temp2 T1

IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR <> 0; terminating process'
		ROLLBACK TRANSACTION T7
	END
ELSE 
COMMIT TRANSACTION T7

Delete from Temp2

SET @Min_list = @Min_list + 1
SET @List_Count = @List_Count - 1
END

EXEC Wrapper_InsertListingAmenity

GO

ALTER PROC Wrapper_InsertPayment

AS

DECLARE @OGAmt NUMERIC(8,2), @Tax NUMERIC(8,2), @Final NUMERIC(8,2), @Bk_ID INT
DECLARE @RUN INT, @MinPK INT
DECLARE @Deposit NUMERIC(8,2), @Pending NUMERIC(8,2)
DECLARE @LPrice NUMERIC(8,2), @BDays INT, @StateAbb VARCHAR(4)

SET @MinPK = (SELECT MIN(BookingID) FROM tblBooking)
SET @RUN = (SELECT COUNT(*) FROM tblBooking)

WHILE @RUN > 0
BEGIN

SET @Bk_ID = (SELECT BookingID FROM tblBooking WHERE BookingID = @MinPK)
SET @LPrice = (SELECT L.Price FROM tblListing as L
                INNER JOIN tblBooking as B ON L.ListingID = B.ListingID
                WHERE B.BookingID = @Bk_ID)
SET @BDays = (SELECT BookingDays FROM tblBooking WHERE BookingID = @Bk_ID)
SET @OGAmt = (SELECT dbo.CalcOGAmt(@BDays,@LPrice))
SET @StateAbb = (SELECT C.StateID FROM 
					tblCity as C 
					inner join tblListing as L on C.CityID = L.CityID
					inner join tblBooking as B on L.ListingID = B.ListingID
					where B.BookingID = @Bk_ID)


SET @Tax = (SELECT dbo.CalcTaxAmt(@OGAmt,@StateAbb))
SET @Deposit = (SELECT dbo.CalcDeposit(@OGAmt))
SET @Pending = (SELECT dbo.CalcPendingAmt(@OGAmt,@Deposit)) 
SET @Final = (SELECT dbo.CalcFinalAmt(@OGAmt,@Tax)) 

BEGIN TRANSACTION T8
INSERT INTO tblPayment (PaymentTypeID, OriginalAmount, TaxAmount, FinalAmount, BookingID)
VALUES (1, @Deposit, 0.00, @Deposit, @Bk_ID)
IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR <> 0; terminating process'
		ROLLBACK TRANSACTION T8
	END
ELSE
COMMIT TRANSACTION T8

BEGIN TRANSACTION T9
INSERT INTO tblPayment (PaymentTypeID, OriginalAmount, TaxAmount, FinalAmount, BookingID)
VALUES (2, @Pending, @Tax, @Final, @Bk_ID)
IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR <> 0; terminating process'
		ROLLBACK TRANSACTION T9
	END
ELSE

COMMIT TRANSACTION T9

SET @MinPK = @MinPK + 1
SET @RUN = @RUN -1
END

EXEC Wrapper_InsertPayment

UPDATE tblListing
SET AvgListingRating = dbo.Calclistrating(ListingID)

---COMPLEX QUERIES


-- most popular city in each state for airbnb bookings
WITH CTE_Popular_City (State, City, Bookings, Rnk)
AS
(
SELECT S.State, C.City, COUNT(B.BookingID) Bookings,
RANK() OVER (PARTITION BY S.State ORDER BY COUNT(B.BookingID) DESC) Rnk
FROM tblBooking B
INNER JOIN tblListing L ON B.ListingID = L.ListingID
INNER JOIN tblHost H ON L.HostID = H.HostID
INNER JOIN tblCity C ON H.CityID = C.CityID
INNER JOIN tblState S ON C.StateID = S.StateID
GROUP BY S.State, C.City
)

SELECT State, City, Bookings, Rnk FROM CTE_Popular_City WHERE Rnk = 1

--- rank each season based on the money made in each year

SELECT YEAR(B.CheckInDate) Year, 
CASE WHEN MONTH(CheckInDate) IN (6,7,8) THEN 'Summer'
	WHEN MONTH(CheckInDate) IN (9,10,11) THEN 'Fall'
	WHEN MONTH(CheckInDate) IN (12,1,2) THEN 'Winter'
	WHEN MONTH(CheckInDate) IN (3,4,5) THEN 'Spring'
END Season,
SUM(P.FinalAmount) As FinalAmt,
RANK() OVER (PARTITION BY YEAR(B.CheckInDate) ORDER BY SUM(P.FinalAmount) DESC) Rnk
FROM
tblBooking B 
INNER JOIN tblPayment P ON B.BookingID = P.BookingID
GROUP BY YEAR(B.CheckInDate),CASE WHEN MONTH(CheckInDate) IN (6,7,8) THEN 'Summer'
	WHEN MONTH(CheckInDate) IN (9,10,11) THEN 'Fall'
	WHEN MONTH(CheckInDate) IN (12,1,2) THEN 'Winter'
	WHEN MONTH(CheckInDate) IN (3,4,5) THEN 'Spring'
END


-- Percentage of Customer Type 'Senior' that have booked for over 7 days

Select z.Booking7Days, z.TotalBooking, ROUND((z.Booking7Days*1.0/z.TotalBooking*1.0)*100,2) as PercentSenior
FROM
(
SELECT COUNT(CASE WHEN B.BookingDays > 7 then B.BookingID end) as Booking7Days, 
COUNT(B.BookingID) as TotalBooking 
FROM tblBooking as B 
INNER JOIN tblCustomer as Cust ON Cust.CustomerID = B.CustomerID
INNER JOIN tblCustomerType as CT on Cust.CustomerTypeID = CT.CustomerTypeID
WHERE CT.CustomerType = 'Senior'
)z

-- middle third states based on number of customers 
select * from 
(
SELECT S.State, COUNT(Cu.CustomerID) as CustCount, 
NTILE(3) OVER (ORDER BY COUNT(Cu.CustomerID) DESC) AS Percentile  
FROM tblCity as C 
INNER JOIN tblState S ON C.StateID = S.StateID
INNER JOIN tblCustomer as Cu ON C.CityID = Cu.CityID
GROUP BY S.State
)x
WHERE Percentile = 2


--Select the 8th city having most number of hosts who have listings that have both barbecues and patios

go
with cte as (Select S.State, count(H.HostID) as Number_of_hosts, 
DENSE_RANK() over (order by count(H.HostID) Desc) as Rnk
from tblState S
INNER join tblCity CY on S.StateID = CY.StateID
INNER JOIN tblHost H on CY.CityID = H.CityID
INNER JOIN tblListing L on H.HostID = L.HostID
INNER JOIN tblListingAmenity LA on LA.ListingID = L.ListingID
INNER JOIN tblAmenity A on A.AmenityID = LA.AmenityID
WHERE A.AmenityName in ('BBQ', 'Private Patio')
GROUP by S.State
)


Select * 
from cte 
where Rnk = 8

--- For each rating get the top 3 listings

with cte8 as (Select L.ListingName, R.Rating, count(R.rating) as Rating_count,
Row_number() over (partition by R.Rating order by count(R.rating)Desc) as Rnk
from tblListing L
INNER JOIN tblBooking B on L.ListingID = B.ListingID
INNER join tblReview RW on B.BookingID = RW.BookingID
INNER join tblRating R on RW.RatingID = R.RatingID
group by L.ListingName, R.Rating
)

Select *
from cte8
where Rnk <=3
order by Rating

--- top 5 loyal customers based on money spent
with cte88 as(
select concat(C.CustomerFname, ' ', C.CustomerLname) as Customer_Name , P.FinalAmount, 
DENSE_RANK() OVER (ORDER BY P.FinalAmount DESC) as Rank
from tblCustomer C join tblBooking b on C.CustomerID = B.CustomerID
join tblListing L on B.ListingID = L.ListingID
join tblPayment P on P.BookingID = B.BookingID
group by concat(C.CustomerFname, ' ', C.CustomerLname), P.FinalAmount)

Select *
from cte88
where Rank<6
order by Rank


-- top 10 percentile of states that have bookings through "Youth" during winter
select * from (
select cy.City, NTILE(100) OVER (ORDER BY Count(b.BookingID) desc) TopStates from tblState s
join tblCity cy on cy.StateID = s.StateID
join tblListing l on l.CityID = cy.CityID
join tblBooking b on l.ListingID = b.ListingID
join tblCustomer c on c.CustomerID = b.CustomerID
join tblCustomerType ct on ct.CustomerTypeID = c.CustomerTypeID
where ct.CustomerType = 'Youth' and MONTH(b.CheckInDate) IN (12,1,2)
GROUP BY cy.City) x
where TopStates <= 10
order by TopStates

----Vizualizations

SELECT Year(a.CheckInDate) as Year, 
CASE WHEN Month(a.CheckInDate) in (12,1,2) THEN 'Winter'
	WHEN Month(a.CheckInDate) in (3,4,5) THEN 'Spring'
	WHEN Month(a.CheckInDate) in (6,7,8) THEN 'Summer'
	WHEN Month(a.CheckInDate) in (9,10,11) THEN 'Autumn'
END as Season, 
COUNT(BookingID) Booking_Count
FROM tblBooking a
GROUP BY Year(a.CheckInDate), CASE WHEN Month(a.CheckInDate) in (12,1,2) THEN 'Winter'
	WHEN Month(a.CheckInDate) in (3,4,5) THEN 'Spring'
	WHEN Month(a.CheckInDate) in (6,7,8) THEN 'Summer'
	WHEN Month(a.CheckInDate) in (9,10,11) THEN 'Autumn'
END

-----

SELECT CASE WHEN b.Price BETWEEN 100 AND 250 THEN '<250'
			WHEN b.Price BETWEEN 251 AND 500 THEN '251-500'
			WHEN b.Price BETWEEN 501 AND 750 THEN '501-750'
			WHEN b.Price BETWEEN 751 AND 1000 THEN '>750'
END as Price_Range,
d.CustomerType,
COUNT(a.BookingID) as Booking_Count
FROM tblBooking a
INNER JOIN tblListing b ON a.ListingID = b.ListingID
INNER JOIN tblCustomer c ON a.CustomerID = c.CustomerID
INNER JOIN tblCustomerType d ON c.CustomerTypeID = d.CustomerTypeID
GROUP BY CASE WHEN b.Price BETWEEN 100 AND 250 THEN '<250'
			WHEN b.Price BETWEEN 251 AND 500 THEN '251-500'
			WHEN b.Price BETWEEN 501 AND 750 THEN '501-750'
			WHEN b.Price BETWEEN 751 AND 1000 THEN '>750'
END,
d.CustomerType

---

SELECT x.State as Booking_State, ISNULL(y.Customer_Count,0) Cust_Count
FROM tblState x
LEFT JOIN 
(
SELECT d.State as Booking_State,  Count(e.CustomerID) Customer_Count
FROM tblBooking a 
INNER JOIN tblListing b ON a.ListingID = b.ListingID
INNER JOIN tblCity c ON b.CityID = c.CityID
INNER JOIN tblState d ON c.StateID = d.StateID
INNER JOIN tblCustomer e ON a.CustomerID = e.CustomerID
INNER JOIN tblCity f ON e.CityID = f.CityID
INNER JOIN tblState g ON f.StateID = g.StateID
WHERE g.StateID = 'WA'
GROUP BY d.State
)y ON x.State = y.Booking_State
ORDER BY Cust_Count


SELECT * FROM tblBooking