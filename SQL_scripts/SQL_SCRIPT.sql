Create Database Pakwheels;
select name from sys.databases;

Use Pakwheels;
Select DB_NAME() as currentdatabase;

--------------------------------------
--             USER                 --
--------------------------------------
create table P_User(
UserID int Primary key identity(1,1),
UserName varchar(30) not null,
Email varchar (50) Unique not null,
Phone varchar(30) not null,
Verified char(3) not null default('yes'),
S_Location varchar(50) not null
);

--------------------------------------
--             STAFF                --
--------------------------------------
create table P_Staff(
StaffID int primary key identity(1,1),
StaffName varchar(30) not null,
Email varchar (50) Unique not null,
Phone varchar(30) not null,
Verified char(3) not null default('yes'),
S_Location varchar(50) not null
);

--------------------------------------
--             Buyer                --
--------------------------------------
create table P_Buyer(
Buyer_ID int primary key foreign key References P_User(UserID) on delete cascade ,
);

--------------------------------------
--             Seller               --
--------------------------------------
create table P_Seller(
Seller_ID int primary key foreign key References P_User(UserID) on delete cascade,
);

--------------------------------------
--             Vehicle              --
--------------------------------------
create table P_Vehicle(
VehicleID int identity(1,1) Primary key,
SellerID int not null foreign key references P_Seller(Seller_ID) on delete cascade, 
V_Location varchar(50) not null,
RegisteredIn varchar(20),
Model varchar(30) not null,
Brand varchar(20) not null,
ExteriorColor varchar(10) not null,
KMs_driven int default (0),
EngineCC int not null,
YearMade int not null,
Mileage  int not null,
Price int not null,
VehicleType varchar(10) not null,
FuelType varchar(10) default null,
TransmissionType varchar(30) not null check(TransmissionType in ('Automatic','Manual')),
V_Description varchar(300)
);

--------------------------------------
--             Autopart             --
--------------------------------------
create table P_AutoPart (
PartID int primary key identity(1,1),
SellerID int not null foreign key references P_Seller(Seller_ID) on delete cascade, 
A_Name varchar(60) not null,
A_Description varchar(300) ,
Price int not null,
Stock int not null check (Stock >= 0),
Shipping_cost int not null,
Shipping_time varchar(100) not null,
Return_Policy varchar(100) not null default (' No Return '),
Return_Address varchar(200) not null ,
Rating int default (0) check(rating between 0 and 5)
);

--------------------------------------
--           Advertisement          --
--------------------------------------
create table P_Advertisements (
AdID int identity(1,1) Primary key,
Title varchar(50) not null,
A_Description varchar(300) not null,
AutoPartID int foreign key references P_AutoPart(PartID),
VehicleID int foreign key references P_Vehicle(VehicleID),
SellerID int not null foreign key references P_Seller(Seller_ID) on delete cascade, 
A_Status varchar(10) default 'active',
Verification varchar(50) not null,
CONSTRAINT CHK_Ad_Type CHECK (
        (AutoPartID IS NOT NULL AND VehicleID IS NULL) OR 
        (AutoPartID IS NULL AND VehicleID IS NOT NULL)
   )
);

--------------------------------------
--              Cars                --
--------------------------------------
create table P_Car(
CarID int primary key foreign key references P_Vehicle(VehicleID)
);

--------------------------------------
--              Bikes               --
--------------------------------------
create table P_Bike(
BikeID int primary key foreign key references P_Vehicle(VehicleID)
);

--------------------------------------
--             ChatBoX              --
--------------------------------------
CREATE TABLE P_ChatBox (
ChatBoxID INT PRIMARY KEY IDENTITY(1,1),
CarID int  FOREIGN KEY REFERENCES P_Car(CarID),
BikeID int  FOREIGN KEY REFERENCES P_Bike(BikeID),
BuyerID INT NOT NULL FOREIGN KEY REFERENCES P_Buyer(Buyer_ID),
SellerID INT NOT NULL FOREIGN KEY REFERENCES P_Seller(Seller_ID),
MessageText VARCHAR(200) NOT NULL,
MessageTime DATETIME NOT NULL DEFAULT(GETDATE()),
CONSTRAINT CHK_VehicleType CHECK (
    (CarID IS NOT NULL AND BikeID IS NULL) OR 
    (CarID IS NULL AND BikeID IS NOT NULL)
)
);

--------------------------------------
--             NewCars              --
--------------------------------------
create table P_NewCar(
NewCarID int primary key foreign key references P_Vehicle(VehicleID),
Rating int default (0) check (Rating between 0 and 5)
);

--------------------------------------
--            Insurance             --
--------------------------------------
create table P_Insurance(
CarInsuranceID int Primary key identity(1,1),
InsuranceRate decimal(2,1) not null,
MonthlyPayment int not null,
No_ofInstallments int not null,
BuyerID int foreign key references P_Buyer(Buyer_ID),
B_Location varchar(100) not null,
CarID int foreign key references P_Car(CarID),
NewCarID int foreign key references P_NewCar(NewCarID),
PaymentMethod varchar(30) not null check (PaymentMethod in ('easypaisa','jazzcash','debitcard')),
Payment_Successful varchar(50) not null default('Successful'),
CONSTRAINT CHK_Insurance_Vehicle CHECK (
        (CarID IS NOT NULL AND NewCarID IS NULL) OR 
        (CarID IS NULL AND NewCarID IS NOT NULL)
    )
);

--------------------------------------
--            Inspection            --
--------------------------------------
create table P_Inspection(
CarInspectionID int primary key identity(1,1),
StaffID int foreign key references P_Staff(StaffID),
BuyerID int foreign key references P_Buyer(Buyer_ID),
B_Location varchar(100) not null,
CarID int foreign key references P_Car(CarID),
I_Price int not null,
PaymentMethod varchar(30) not null check (PaymentMethod in ('easypaisa','jazzcash','debitcard')),
Payment_Successful varchar(50) not null default('Successful')
);

--------------------------------------
--              Search              --
--------------------------------------
create table P_Search (
SearchID INT PRIMARY KEY IDENTITY(1,1),
UserID INT NOT NULL FOREIGN KEY REFERENCES P_User(UserID),
SearchKeywords VARCHAR(200) NOT NULL,
SearchTime DATETIME NOT NULL DEFAULT(GETDATE())
);

--------------------------------------
--             BuyNow               --
--------------------------------------
create table P_Buy_Now(
Buy_NowID int primary key identity(1,1),
PartID int not null foreign key references P_AutoPart(PartID) ,
PaymentMethod varchar(30) not null check (PaymentMethod in ('easypaisa','jazzcash','debitcard')),
BuyerID int foreign key references P_Buyer(Buyer_ID) on delete cascade, 
Payment_Successful varchar(50) not null default('Successful')
);

INSERT INTO P_User ( UserName, Email, Phone, Verified,S_Location) VALUES
('Irfan', 'irfan.malik@example.com', '+92-300-7777777', 'yes', 'Islamabad'),
('Javed', 'javeria.khan@example.com', '+92-300-8888888', 'yes','Lahore'),
('Ali', 'kamran.q@example.com', '+92-300-9999999', 'yes','Rawalpindi'),
('Hassan', 'laila.riaz@example.com', '+92-301-1010101', 'yes','Faisalabad'),
('Mohsin ', 'mohsin.ali@example.com', '+92-301-2020202', 'yes','Multan'),
('Maryam', 'nida.farooq@example.com', '+92-301-3030303', 'yes','Peshawar'),
('Rohan', 'omer.sheikh@example.com', '+92-301-4040404', 'yes', 'Karachi'),
('Sabahat', 'parvez.khan@example.com', '+92-301-5050505', 'yes', 'Lahore'),
('Muaz', 'quratulain@example.com', '+92-301-6060606', 'yes', 'Islamabad'),
('Raza Ahmad', 'raza.ahmad@example.com', '+92-301-7070707', 'yes', 'Rawalpindi'),
('Ihtesham', 'sana.mir@example.com', '+92-301-8080808', 'yes', 'Faisalabad'),
('Umair', 'tariq.javed@example.com', '+92-301-9090909', 'yes', 'Multan'),
('Ahmed', 'umer.farid@example.com', '+92-302-1111212', 'yes' ,'Peshawar'),
('Umar', 'vaneeza@example.com', '+92-302-1313131', 'yes', 'Quetta'),
('Saleem', 'waseem.akram@example.com', '+92-302-1414141', 'yes','Gujranwala'),
('Adeel', 'xaria.bilal@example.com', '+92-302-1515151', 'yes', 'Islamabad');

-- Insert Staff (6 staff members)
INSERT INTO P_Staff (StaffName, Email, Phone, Verified,S_Location) VALUES
('Achu', 'ali.khan@example.com', '+92-300-1111111', 'yes', 'Karachi'),
('Gafoor', 'ayesha.ahmed@example.com', '+92-300-2222222', 'yes', 'Lahore'),
('Shakoor', 'bilal.shah@example.com', '+92-300-3333333', 'yes','Islamabad'),
('Mushtaq', 'fatima.noor@example.com', '+92-300-4444444', 'yes', 'Rawalpindi'),
('Hamza', 'hamza.raza@example.com', '+92-300-5555555', 'yes','Faisalabad'),
('Ahmad', 'hina.s@example.com', '+92-300-6666666', 'yes', 'Multan');

-- Insert Buyers (7 buyers)
INSERT INTO P_Buyer (Buyer_ID) VALUES
(1),(2),(3),(4),(5),(6),(7);

-- Insert Sellers (10 sellers)
INSERT INTO P_Seller (Seller_ID) VALUES
(8),(9),(10),(11),(12),(13),(14),(15),(16);

-- Insert Vehicles (23 vehicles: 10 cars, 8 bikes, 5 new cars)
INSERT INTO P_Vehicle (SellerID, V_Location, RegisteredIn, Model, Brand, ExteriorColor, KMs_driven, EngineCC, YearMade, Mileage, Price, VehicleType, FuelType, TransmissionType, V_Description) VALUES
-- Cars (10)
(8, 'Karachi', 'Sindh', 'Civic', 'Honda', 'White', 50000, 1800, 2020, 15, 3500000, 'Car', 'Petrol', 'Automatic', 'Well maintained Honda Civic with low mileage'),
(9, 'Lahore', 'Punjab', 'Corolla', 'Toyota', 'Black', 60000, 1600, 2019, 14, 2800000, 'Car', 'Petrol', 'Manual', 'Toyota Corolla in excellent condition'),
(10, 'Islamabad', 'Islamabad', 'City', 'Honda', 'Silver', 45000, 1300, 2021, 16, 2200000, 'Car', 'Petrol', 'Automatic', 'Honda City with modern features'),
(11, 'Rawalpindi', 'Punjab', 'Mehran', 'Suzuki', 'Red', 80000, 800, 2018, 20, 800000, 'Car', 'Petrol', 'Manual', 'Economical Suzuki Mehran'),
(12, 'Faisalabad', 'Punjab', 'Cultus', 'Suzuki', 'Blue', 55000, 1000, 2020, 18, 1500000, 'Car', 'Petrol', 'Automatic', 'Suzuki Cultus with great fuel efficiency'),
(13, 'Multan', 'Punjab', 'Swift', 'Suzuki', 'Gray', 40000, 1300, 2021, 17, 1800000, 'Car', 'Petrol', 'Manual', 'Suzuki Swift in perfect condition'),
(14, 'Peshawar', 'KPK', 'Alto', 'Suzuki', 'White', 70000, 660, 2017, 22, 600000, 'Car', 'Petrol', 'Manual', 'Reliable Suzuki Alto'),
(15, 'Quetta', 'Balochistan', 'Prius', 'Toyota', 'Green', 30000, 1800, 2020, 25, 4200000, 'Car', 'Hybrid', 'Automatic', 'Toyota Prius hybrid car'),
(16, 'Gujranwala', 'Punjab', 'BR-V', 'Honda', 'Brown', 35000, 1500, 2021, 14, 3200000, 'Car', 'Petrol', 'Automatic', 'Honda BR-V SUV'),
(8, 'Karachi', 'Sindh', 'Sportage', 'Kia', 'Black', 25000, 2000, 2022, 12, 5500000, 'Car', 'Petrol', 'Automatic', 'Kia Sportage with premium features'),
-- Bikes (8)
(9, 'Lahore', 'Punjab', 'CD-70', 'Honda', 'Red', 15000, 70, 2020, 50, 80000, 'Bike', 'Petrol', 'Manual', 'Honda CD-70 in good condition'),
(10, 'Islamabad', 'Islamabad', '125', 'Yamaha', 'Blue', 10000, 125, 2021, 45, 150000, 'Bike', 'Petrol', 'Manual', 'Yamaha 125 powerful bike'),
(11, 'Rawalpindi', 'Punjab', 'CG-125', 'Honda', 'Black', 20000, 125, 2019, 40, 120000, 'Bike', 'Petrol', 'Manual', 'Honda CG-125 reliable bike'),
(12, 'Faisalabad', 'Punjab', 'GR-150', 'United', 'Green', 8000, 150, 2022, 35, 180000, 'Bike', 'Petrol', 'Manual', 'United GR-150 sports bike'),
(13, 'Multan', 'Punjab', 'Pridor', 'Suzuki', 'Yellow', 12000, 100, 2020, 42, 95000, 'Bike', 'Petrol', 'Manual', 'Suzuki Pridor economical bike'),
(14, 'Peshawar', 'KPK', 'XR-150', 'Honda', 'White', 5000, 150, 2023, 38, 220000, 'Bike', 'Petrol', 'Manual', 'Honda XR-150 adventure bike'),
(15, 'Quetta', 'Balochistan', 'GS-150', 'Suzuki', 'Red', 18000, 150, 2018, 36, 140000, 'Bike', 'Petrol', 'Manual', 'Suzuki GS-150 comfortable ride'),
(16, 'Gujranwala', 'Punjab', 'CB-150F', 'Honda', 'Silver', 9000, 150, 2021, 39, 190000, 'Bike', 'Petrol', 'Manual', 'Honda CB-150F stylish bike'),
-- New Cars (5)
(8, 'Karachi', 'Sindh', 'Civic', 'Honda', 'White', 0, 1800, 2024, 18, 4500000, 'NewCar', 'Petrol', 'Automatic', 'Brand new Honda Civic 2024'),
(9, 'Lahore', 'Punjab', 'Corolla', 'Toyota', 'Gray', 0, 1600, 2024, 16, 3800000, 'NewCar', 'Petrol', 'Automatic', 'New Toyota Corolla 2024'),
(10, 'Islamabad', 'Islamabad', 'City', 'Honda', 'Blue', 0, 1300, 2024, 20, 2800000, 'NewCar', 'Petrol', 'Automatic', 'Honda City 2024 model'),
(11, 'Rawalpindi', 'Punjab', 'Alto', 'Suzuki', 'Red', 0, 660, 2024, 25, 1200000, 'NewCar', 'Petrol', 'Manual', 'New Suzuki Alto 2024'),
(12, 'Faisalabad', 'Punjab', 'Cultus', 'Suzuki', 'Black', 0, 1000, 2024, 22, 2000000, 'NewCar', 'Petrol', 'Automatic', 'Suzuki Cultus 2024 automatic');

-- Insert Cars (10 cars)
INSERT INTO P_Car (CarID) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Insert Bikes (8 bikes)
INSERT INTO P_Bike (BikeID) VALUES (11), (12), (13), (14), (15), (16), (17), (18);

-- Insert New Cars (5 new cars)
INSERT INTO P_NewCar (NewCarID, Rating) VALUES 
(19, 4), (20, 4), (21, 4), (22, 4), (23, 4);

-- Insert Auto Parts (10 parts)
INSERT INTO P_AutoPart (SellerID, A_Name, A_Description, Price, Stock, Shipping_cost, Shipping_time, Return_Policy, Return_Address, Rating) VALUES
(8, 'Car Battery', 'High performance car battery 12V 60Ah', 15000, 50, 500, '2-3 days', '7 days return', 'Shop 15, Tariq Road, Karachi', 4),
(9, 'Engine Oil', 'Fully synthetic engine oil 5W-30', 4500, 100, 300, '1-2 days', 'No Return', 'Main Market, Gulberg, Lahore', 5),
(10, 'Brake Pads', 'Ceramic brake pads for Honda Civic', 8000, 30, 400, '2-3 days', '15 days return', 'Blue Area, Islamabad', 4),
(11, 'Car Tyres', 'All season radial tyres 195/65R15', 25000, 20, 1000, '3-4 days', '30 days return', 'Sadar Road, Rawalpindi', 5),
(12, 'Windshield', 'Front windshield for Toyota Corolla', 18000, 10, 800, '4-5 days', 'No Return', 'Clock Tower, Faisalabad', 3),
(13, 'Headlights', 'LED Headlights pair for Suzuki Mehran', 12000, 25, 600, '2-3 days', '14 days return', 'Bosan Road, Multan', 4),
(14, 'Shock Absorbers', 'Gas filled shock absorbers set of 4', 22000, 15, 700, '3-4 days', '30 days return', 'University Road, Peshawar', 5),
(15, 'Radiator', 'Aluminum radiator for various models', 9500, 12, 550, '2-3 days', 'No Return', 'Jinnah Road, Quetta', 4),
(16, 'Spark Plugs', 'Iridium spark plugs set of 4', 3500, 80, 200, '1-2 days', '7 days return', 'GT Road, Gujranwala', 5),
(8, 'Air Filter', 'High flow air filter for performance', 2500, 60, 250, '1-2 days', 'No Return', 'Shop 15, Tariq Road, Karachi', 4);

-- Insert Advertisements (23 ads for vehicles and 10 for autoparts)
INSERT INTO P_Advertisements (Title, A_Description, AutoPartID, VehicleID, SellerID, A_Status, Verification) VALUES
-- Vehicle Ads (23)
('Honda Civic 2020', 'Well maintained Civic for sale', NULL, 1, 8, 'active', 'Verified'),
('Toyota Corolla 2019', 'Excellent condition Corolla', NULL, 2, 9, 'active', 'Verified'),
('Honda City 2021', 'Modern features available', NULL, 3, 10, 'active', 'Verified'),
('Suzuki Mehran 2018', 'Economical car', NULL, 4, 11, 'active', 'Verified'),
('Suzuki Cultus 2020', 'Great fuel efficiency', NULL, 5, 12, 'active', 'Verified'),
('Suzuki Swift 2021', 'Perfect condition', NULL, 6, 13, 'active', 'Verified'),
('Suzuki Alto 2017', 'Reliable car', NULL, 7, 14, 'active', 'Verified'),
('Toyota Prius 2020', 'Hybrid car', NULL, 8, 15, 'active', 'Verified'),
('Honda BR-V 2021', 'SUV for family', NULL, 9, 16, 'active', 'Verified'),
('Kia Sportage 2022', 'Premium features', NULL, 10, 8, 'active', 'Verified'),
('Honda CD-70 2020', 'Good condition bike', NULL, 11, 9, 'active', 'Verified'),
('Yamaha 125 2021', 'Powerful bike', NULL, 12, 10, 'active', 'Verified'),
('Honda CG-125 2019', 'Reliable bike', NULL, 13, 11, 'active', 'Verified'),
('United GR-150 2022', 'Sports bike', NULL, 14, 12, 'active', 'Verified'),
('Suzuki Pridor 2020', 'Economical bike', NULL, 15, 13, 'active', 'Verified'),
('Honda XR-150 2023', 'Adventure bike', NULL, 16, 14, 'active', 'Verified'),
('Suzuki GS-150 2018', 'Comfortable ride', NULL, 17, 15, 'active', 'Verified'),
('Honda CB-150F 2021', 'Stylish bike', NULL, 18, 16, 'active', 'Verified'),
('Honda Civic 2024', 'Brand new car', NULL, 19, 8, 'active', 'Verified'),
('Toyota Corolla 2024', 'New model', NULL, 20, 9, 'active', 'Verified'),
('Honda City 2024', '2024 model', NULL, 21, 10, 'active', 'Verified'),
('Suzuki Alto 2024', 'New 2024', NULL, 22, 11, 'active', 'Verified'),
('Suzuki Cultus 2024', 'Automatic 2024', NULL, 23, 12, 'active', 'Verified'),
-- AutoPart Ads (10)
('Car Battery Sale', 'High performance battery', 1, NULL, 13, 'active', 'Verified'),
('Engine Oil Special', 'Fully synthetic oil', 2, NULL, 14, 'active', 'Verified'),
('Brake Pads Honda', 'Ceramic brake pads', 3, NULL, 15, 'active', 'Verified'),
('Car Tyres All Season', 'Radial tyres', 4, NULL, 16, 'active', 'Verified'),
('Windshield Toyota', 'Front windshield', 5, NULL, 8, 'active', 'Verified'),
('LED Headlights', 'For Suzuki Mehran', 6, NULL, 9, 'active', 'Verified'),
('Shock Absorbers Set', 'Gas filled', 7, NULL, 10, 'active', 'Verified'),
('Aluminum Radiator', 'For various models', 8, NULL, 11, 'active', 'Verified'),
('Spark Plugs Iridium', 'Set of 4', 9, NULL, 12, 'active', 'Verified'),
('High Flow Air Filter', 'Performance filter', 10, NULL, 13, 'active', 'Verified');

-- Insert Insurance (10 records)
INSERT INTO P_Insurance (InsuranceRate, MonthlyPayment, No_ofInstallments,  BuyerID, B_Location, CarID, NewCarID, PaymentMethod, Payment_Successful) VALUES
(4.5, 15000, 12,  1, 'Karachi', 1, NULL, 'easypaisa', 'Successful'),
(4.2, 12000, 24,  2, 'Lahore', 2, NULL, 'jazzcash', 'Successful'),
(4.7, 18000, 18, 3, 'Islamabad', NULL, 19, 'debitcard', 'Successful'),
(4.0, 8000, 12,  4, 'Rawalpindi', 4, NULL, 'easypaisa', 'Successful'),
(4.8, 20000, 24, 5, 'Faisalabad', NULL, 20, 'jazzcash', 'Successful'),
(4.3, 10000, 12,  6, 'Multan', 6, NULL, 'debitcard', 'Successful'),
(4.6, 16000, 18,  7, 'Peshawar', NULL, 21, 'easypaisa', 'Successful'),
(4.1, 9000, 12, 1, 'Karachi', 8, NULL, 'jazzcash', 'Successful'),
(4.9, 22000, 24,  2, 'Lahore', NULL, 22, 'debitcard', 'Successful'),
(4.4, 11000, 12,  3, 'Islamabad', 10, NULL, 'easypaisa', 'Successful');

-- Insert Inspection (10 records)
INSERT INTO P_Inspection (StaffID, BuyerID, B_Location, CarID, I_Price, PaymentMethod, Payment_Successful) VALUES
(1, 1, 'Karachi', 1, 2000, 'easypaisa', 'Successful'),
(2, 2, 'Lahore', 2, 2000, 'jazzcash', 'Successful'),
(3, 3, 'Islamabad', 3, 2000, 'debitcard', 'Successful'),
(4, 4, 'Rawalpindi', 4, 1500, 'easypaisa', 'Successful'),
(5, 5, 'Faisalabad', 5, 2000, 'jazzcash', 'Successful'),
(6, 6, 'Multan', 6, 2000, 'debitcard', 'Successful'),
(1, 7, 'Peshawar', 7, 1500, 'easypaisa', 'Successful'),
(2, 1, 'Karachi', 8, 2500, 'jazzcash', 'Successful'),
(3, 2, 'Lahore', 9, 2000, 'debitcard', 'Successful'),
(4, 3, 'Islamabad', 10, 2500, 'easypaisa', 'Successful');

INSERT INTO P_ChatBox (CarID, BikeID, BuyerID, SellerID, MessageText, MessageTime) VALUES
-- Cars (CarID not null, BikeID null)
(1, NULL, 1, 8, 'Is the Honda Civic still available?', '2024-01-15 10:30:00'),
(2, NULL, 2, 9, 'What is the best price for Corolla?', '2024-01-16 11:45:00'),
(3, NULL, 5, 10, 'What is the current mileage?', '2024-01-19 09:30:00'),
(4, NULL, 7, 11, 'Can you share more photos?', '2024-01-21 15:20:00'),
(5, NULL, 2, 12, 'Is Cultus automatic?', '2024-01-23 10:15:00'),
(6, NULL, 4, 13, 'What is the fuel average of Swift?', '2024-01-25 16:25:00'),
-- Bikes (CarID null, BikeID not null)
(NULL, 11, 3, 14, 'Can I test drive the CD-70?', '2024-01-17 14:20:00'),
(NULL, 12, 6, 15, 'Is Yamaha 125 imported or local?', '2024-01-20 13:45:00'),
(NULL, 13, 1, 16, 'What is the engine condition?', '2024-01-22 17:30:00'),
(NULL, 14, 3, 8, 'United GR-150 available in other colors?', '2024-01-24 12:40:00');

-- Insert BuyNow (10 records)
INSERT INTO P_Buy_Now (PartID, PaymentMethod, BuyerID, Payment_Successful) VALUES
(1, 'easypaisa', 1, 'Successful'),
(2, 'jazzcash', 2, 'Successful'),
(3, 'debitcard', 3, 'Successful'),
(4, 'easypaisa', 4, 'Successful'),
(5, 'jazzcash', 5, 'Successful'),
(6, 'debitcard', 6, 'Successful'),
(7, 'easypaisa', 7, 'Successful');





--Market Inventory Analysis--
SELECT 
    V_Location AS City, 
    COUNT(VehicleID) AS Total_Vehicles, 
    SUM(Price) AS Total_Market_Value,
    AVG(Price) AS Average_Vehicle_Price
FROM P_Vehicle
GROUP BY V_Location
ORDER BY Total_Market_Value DESC;


--Chat Activity--
SELECT 
    V.Model, 
    V.Brand, 
    V.Price, 
    COUNT(C.ChatBoxID) AS Message_Count
FROM P_Vehicle V
JOIN P_ChatBox C ON V.VehicleID = COALESCE(C.CarID, C.BikeID)
GROUP BY V.Model, V.Brand, V.Price
ORDER BY Message_Count DESC;

--Inspection & Revenue Tracking--

SELECT 
    S.StaffName, 
    COUNT(I.CarInspectionID) AS Inspections_Done, 
    SUM(I.I_Price) AS Total_Revenue_Generated
FROM P_Staff S
JOIN P_Inspection I ON S.StaffID = I.StaffID
WHERE I.Payment_Successful = 'Successful'
GROUP BY S.StaffName;

--High-Value Seller Recognition--

SELECT 
    U.UserName, 
    U.Email, 
    COUNT(DISTINCT V.VehicleID) AS Total_Vehicles_Listed,
    COUNT(DISTINCT A.PartID) AS Total_Parts_Listed
FROM P_User U
JOIN P_Seller S ON U.UserID = S.Seller_ID
LEFT JOIN P_Vehicle V ON S.Seller_ID = V.SellerID
LEFT JOIN P_AutoPart A ON S.Seller_ID = A.SellerID
GROUP BY U.UserName, U.Email
HAVING COUNT(DISTINCT V.VehicleID) > 0 OR COUNT(DISTINCT A.PartID) > 0;

--Insurance Potential Report--

SELECT 
    V.Model, 
    V.Brand, 
    V.Price, 
    U.UserName AS Buyer_Name, 
    U.Phone
FROM P_Vehicle V
JOIN P_Buyer B ON V.VehicleID = B.Buyer_ID -- Assuming a sale happened
JOIN P_User U ON B.Buyer_ID = U.UserID
LEFT JOIN P_Insurance I ON B.Buyer_ID = I.BuyerID
WHERE V.VehicleType = 'NewCar' AND I.CarInsuranceID IS NULL;


