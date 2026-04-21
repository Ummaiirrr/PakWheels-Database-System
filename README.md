# PakWheels-Database-System
A Relational Database Management System (RDBMS) for an automotive marketplace.

1. Database Overview
The PakWheels DBMS is a relational database designed to manage an automotive marketplace. It handles multi-type users (Buyers/Sellers/Staff), diverse inventory (Cars, Bikes, Parts), and business workflows like Inspections, Insurance, and Ads.


2. Core Entities & Hierarchies
The User Hierarchy (ISA Relationship)
We utilize Table-per-Type (TPT) inheritance to manage users.
    P_User (Supertype): Contains shared attributes like Email, Phone, and S_Location.
    P_Buyer & P_Seller (Subtypes): These tables share the same Primary Key as P_User (enforced via Foreign Key). This avoids data redundancy while allowing specific relationships (e.g., only Sellers can list Vehicles).
    P_Staff: A separate entity for internal employees who manage P_Inspection services.

The Vehicle Hierarchy
To handle different vehicle types with shared characteristics, we use a disjoint specialization:
    P_Vehicle: The base table storing engine CC, mileage, price, and location.
    P_Car, P_Bike, P_NewCar: Specialized tables that reference P_Vehicle(VehicleID).
    This allows for future expansion (e.g., adding specific attributes for Electric Vehicles) without altering the main table.

3. Key Relationships & Logic
    Relationship	                            Description
    Advertisement Logic         The P_Advertisements table uses a conditional constraint to ensure an ad points to either a Vehicle or an AutoPart, but never both or neither.
    Communication Hub           P_ChatBox facilitates real-time interaction between Buyers and Sellers, linked directly to the specific CarID or BikeID of interest.
    Service Integration         The schema supports third-party-style services: P_Inspection (linked to Staff) and P_Insurance (linked to Buyers and Vehicles).

4. Integrity Constraints & Business Rules
To ensure data quality, the following constraints are implemented:
    Referential Integrity: ON DELETE CASCADE is used on Buyer/Seller IDs so that if a user is deleted, their associated roles and private listings are cleaned up.
    Domain Constraints: * TransmissionType is restricted to ('Automatic', 'Manual').
        Rating fields are capped between 0 and 5 using CHECK constraints.
        Stock for autoparts cannot be negative.
    Disjoint Constraints: SQL logic ensures that a vehicle cannot simultaneously be a Car and a Bike.

5. Security & Verification
The system includes a Verified flag for both Users and Staff, and a Verification status for Advertisements. This allows the front-end to filter for "Featured" or "Trusted" listings, mimicking the real-world PakWheels verification badge.