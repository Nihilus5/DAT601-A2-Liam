USE master;
GO

IF DB_ID('CoastandCanopy_DAT601') IS NOT NULL
BEGIN
    ALTER DATABASE CoastandCanopy_DAT601 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CoastandCanopy_DAT601;
END
GO

CREATE DATABASE CoastandCanopy_DAT601;
GO

USE CoastandCanopy_DAT601;
GO

CREATE TABLE Address (
    AddressID     INT NOT NULL,
    StreetNumber  VARCHAR(40) NOT NULL,
    StreetName    VARCHAR(40) NOT NULL,
    Suburb        VARCHAR(40) NOT NULL,
    City          VARCHAR(40) NOT NULL,
    PostCode      VARCHAR(5) NOT NULL,
    CountryCode   VARCHAR(5) NOT NULL,
    CONSTRAINT PK_Address PRIMARY KEY (AddressID)
);

CREATE TABLE Organisation (
    OrganisationID   INT NOT NULL,
    AddressID        INT NOT NULL,
    OrganisationName VARCHAR(40) NOT NULL,
    ContractStart    DATE,
    ContractEnd      DATE,
    Phone            VARCHAR(12) NOT NULL,
    Email            VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Organisation PRIMARY KEY (OrganisationID),
    CONSTRAINT FK_Organisation_Address FOREIGN KEY (AddressID)
        REFERENCES Address (AddressID)
);

CREATE TABLE Department (
    DepartmentID INT NOT NULL,
    DeptName     VARCHAR(30) NOT NULL,
    DepLocation  VARCHAR(60),
    Budget       DECIMAL(15, 2),
    Email        VARCHAR(80) NOT NULL,
    Phone        VARCHAR(12) NOT NULL,
    CONSTRAINT PK_Department PRIMARY KEY (DepartmentID)
);

CREATE TABLE Person (
    PersonID  INT NOT NULL,
    AddressID INT NOT NULL,
    NameFirst VARCHAR(45) NOT NULL,
    NameLast  VARCHAR(45) NOT NULL,
    Phone     VARCHAR(10) NOT NULL,
    Email     VARCHAR(80) NOT NULL,
    CONSTRAINT PK_Person PRIMARY KEY (PersonID),
    CONSTRAINT FK_Person_Address FOREIGN KEY (AddressID)
        REFERENCES Address (AddressID)
);

CREATE TABLE Employee (
    EmployeeID   INT NOT NULL,
    PersonID     INT NOT NULL,
    DepartmentID INT NOT NULL,
    TaxCode      VARCHAR(10) NOT NULL,
    Salary       DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Employee_Person FOREIGN KEY (PersonID)
        REFERENCES Person (PersonID),
    CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID)
);

CREATE TABLE Director (
    EmployeeID   INT NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT PK_Director PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Director_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID),
    CONSTRAINT FK_Director_Department FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID)
);

CREATE TABLE TechnicalEngineer (
    EmployeeID   INT NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT PK_TechnicalEngineer PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_TechnicalEngineer_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID),
    CONSTRAINT FK_TechnicalEngineer_Department FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID)
);

CREATE TABLE Salesperson (
    EmployeeID   INT NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT PK_Salesperson PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Salesperson_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID),
    CONSTRAINT FK_Salesperson_Department FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID)
);

CREATE TABLE AdministrativeExecutive (
    EmployeeID   INT NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT PK_AdministrativeExecutive PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_AdministrativeExecutive_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID),
    CONSTRAINT FK_AdministrativeExecutive_Department FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID)
);

CREATE TABLE Supplier (
    SupplierID     INT NOT NULL,
    OrganisationID INT NOT NULL,
    CONSTRAINT PK_Supplier PRIMARY KEY (SupplierID),
    CONSTRAINT FK_Supplier_Organisation FOREIGN KEY (OrganisationID)
        REFERENCES Organisation (OrganisationID)
);

CREATE TABLE Maintainer (
    MaintainerID   INT NOT NULL,
    OrganisationID INT NOT NULL,
    CONSTRAINT PK_Maintainer PRIMARY KEY (MaintainerID),
    CONSTRAINT FK_Maintainer_Organisation FOREIGN KEY (OrganisationID)
        REFERENCES Organisation (OrganisationID)
);

CREATE TABLE Part (
    PartID              INT NOT NULL,
    PartName            VARCHAR(50) NOT NULL,
    MaintenanceSchedule INT NOT NULL CONSTRAINT DF_Part_Schedule DEFAULT 5,  -- years; default 5
    CONSTRAINT PK_Part PRIMARY KEY (PartID)
);

CREATE TABLE PartSupplier (
    PartID     INT NOT NULL,
    SupplierID INT NOT NULL,
    Price      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_PartSupplier PRIMARY KEY (PartID, SupplierID),
    CONSTRAINT FK_PartSupplier_Part FOREIGN KEY (PartID)
        REFERENCES Part (PartID),
    CONSTRAINT FK_PartSupplier_Supplier FOREIGN KEY (SupplierID)
        REFERENCES Supplier (SupplierID)
);

CREATE TABLE HARV (
    HarvID            INT NOT NULL,
    EmployeeID        INT NOT NULL,
    SerialNumber      VARCHAR(12) NOT NULL,
    ConfigurationType VARCHAR(50) NOT NULL,
    CONSTRAINT PK_HARV PRIMARY KEY (HarvID),
    CONSTRAINT FK_HARV_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
);

CREATE TABLE HARV_Part (
    PartID              INT NOT NULL,
    HarvID              INT NOT NULL,
    SKU                 INT NOT NULL,
    Height              INT NOT NULL,
    HarvLength          INT NOT NULL,
    Width               INT NOT NULL,
    LastMaintenanceDate DATE NOT NULL,
    CONSTRAINT PK_HARV_Part PRIMARY KEY (PartID, HarvID),
    CONSTRAINT FK_HARV_Part_Part FOREIGN KEY (PartID)
        REFERENCES Part (PartID),
    CONSTRAINT FK_HARV_Part_HARV FOREIGN KEY (HarvID)
        REFERENCES HARV (HarvID)
);


CREATE TABLE Service (
    ServiceID   INT NOT NULL,
    ServiceName VARCHAR(60) NOT NULL,
    CONSTRAINT PK_Service PRIMARY KEY (ServiceID)
);

CREATE TABLE Zone (
    ZoneID       INT NOT NULL,
    ZoneName     VARCHAR(40) NOT NULL,
    Hectares     DECIMAL(10, 2),
    ZoneLocation VARCHAR(40) NOT NULL,
    CONSTRAINT PK_Zone PRIMARY KEY (ZoneID)
);

CREATE TABLE Subscriber (
    SubscriberID INT NOT NULL,
    PersonID     INT NOT NULL,
    EmployeeID   INT NOT NULL,
    CONSTRAINT PK_Subscriber PRIMARY KEY (SubscriberID),
    CONSTRAINT FK_Subscriber_Person FOREIGN KEY (PersonID)
        REFERENCES Person (PersonID),
    CONSTRAINT FK_Subscriber_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
);

CREATE TABLE Subscription (
    SubscriptionID INT NOT NULL,
    OrganisationID INT NOT NULL,
    SubscriberID   INT NOT NULL,
    Discount       INT NOT NULL,
    AnnualMonthly  VARCHAR(7) NOT NULL,
    ContractStart  DATE,
    ContractEnd    DATE,
    CONSTRAINT PK_Subscription PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_Subscription_Organisation FOREIGN KEY (OrganisationID)
        REFERENCES Organisation (OrganisationID),
    CONSTRAINT FK_Subscription_Subscriber FOREIGN KEY (SubscriberID)
        REFERENCES Subscriber (SubscriberID)
);
 
CREATE TABLE SubStandard (
    SubscriptionID INT NOT NULL,
    EmployeeID     INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubStandard PRIMARY KEY (SubscriptionID, EmployeeID),
    CONSTRAINT FK_SubStandard_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID),
    CONSTRAINT FK_SubStandard_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
);
 
CREATE TABLE SubGold (
    SubscriptionID INT NOT NULL,
    EmployeeID     INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubGold PRIMARY KEY (SubscriptionID, EmployeeID),
    CONSTRAINT FK_SubGold_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID),
    CONSTRAINT FK_SubGold_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
);
 
CREATE TABLE SubPlatinum (
    SubscriptionID INT NOT NULL,
    EmployeeID     INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubPlatinum PRIMARY KEY (SubscriptionID, EmployeeID),
    CONSTRAINT FK_SubPlatinum_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID),
    CONSTRAINT FK_SubPlatinum_adminexec FOREIGN KEY (EmployeeID)
        REFERENCES AdministrativeExecutive (EmployeeID)
);
 
CREATE TABLE SubSuperPlatinum (
    SubscriptionID INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubSuperPlatinum PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_SubSuperPlatinum_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID)
);

CREATE TABLE SubscriptionZone (
    ZoneID         INT NOT NULL,
    SubscriptionID INT NOT NULL,
    CONSTRAINT PK_SubscriptionZone PRIMARY KEY (ZoneID, SubscriptionID),
    CONSTRAINT FK_SubscriptionZone_Zone FOREIGN KEY (ZoneID)
        REFERENCES Zone (ZoneID),
    CONSTRAINT FK_SubscriptionZone_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID)
);

CREATE TABLE SubscriptionService (
    SubscriptionID INT NOT NULL,
    ZoneID         INT NOT NULL,
    ServiceID      INT NOT NULL,
    CONSTRAINT PK_SubscriptionService PRIMARY KEY (SubscriptionID, ZoneID, ServiceID),
    CONSTRAINT FK_SubService_SubZone FOREIGN KEY (ZoneID, SubscriptionID)
        REFERENCES SubscriptionZone (ZoneID, SubscriptionID),
    CONSTRAINT FK_SubService_Service FOREIGN KEY (ServiceID)
        REFERENCES Service (ServiceID)
);

CREATE TABLE HARV_Assigned (
    SubscriptionID INT NOT NULL,
    HarvID         INT NOT NULL,
    StartDate      DATE NOT NULL,
    EndDate        DATE NOT NULL,
    AssignedStatus VARCHAR(20) NOT NULL,
    CONSTRAINT PK_HARV_Assigned PRIMARY KEY (SubscriptionID, HarvID),
    CONSTRAINT FK_HARV_Assigned_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID),
    CONSTRAINT FK_HARV_Assigned_HARV FOREIGN KEY (HarvID)
        REFERENCES HARV (HarvID)
);

CREATE TABLE HARV_SensorData (
    DataID              INT NOT NULL,
    HarvID              INT NOT NULL,
    SubscriptionID      INT NULL,
    Temperature         DECIMAL(5, 2),
    Humidity            DECIMAL(5, 2),
    AmbientSpectralData FLOAT,
    OrganicSpectralData FLOAT,
    DateOfTake          DATE,
    Latitude            DECIMAL(9, 6),
    Longitude           DECIMAL(9, 6),
    Altitude            DECIMAL(10, 2),
    Depth               DECIMAL(10, 2),
    HDateTime            DATETIME2,
    CONSTRAINT PK_HARV_SensorData PRIMARY KEY (DataID),
    CONSTRAINT FK_HARV_SensorData_HARV FOREIGN KEY (HarvID)
        REFERENCES HARV (HarvID),
    CONSTRAINT FK_HARV_SensorData_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID)
);

CREATE TABLE ServiceVisit (
    VisitID        INT NOT NULL,
    HarvID         INT NOT NULL,
    SubscriptionID INT NOT NULL,
    ZoneID         INT NOT NULL,
    ServiceID      INT NOT NULL,
    VisitDateTime  DATETIME2 NOT NULL,
    CONSTRAINT PK_ServiceVisit PRIMARY KEY (VisitID),
    CONSTRAINT FK_ServiceVisit_HARV FOREIGN KEY (HarvID)
        REFERENCES HARV (HarvID),
    CONSTRAINT FK_ServiceVisit_SubService FOREIGN KEY (SubscriptionID, ZoneID, ServiceID)
        REFERENCES SubscriptionService (SubscriptionID, ZoneID, ServiceID)
);

CREATE TABLE Maintenance (
    MaintenanceID       INT NOT NULL,
    HarvID              INT NOT NULL,
    MaintainerID        INT NOT NULL,
    OrganisationID      INT NOT NULL,
    PartID              INT NOT NULL,
    SupplierID          INT NOT NULL,
    Cost                DECIMAL(10, 2),
    MaintenanceType     VARCHAR(40),
    MDateTime           DATETIME2,
    MHours              INT,
    Notes               VARCHAR(255),
    CONSTRAINT PK_Maintenance PRIMARY KEY (MaintenanceID),
    CONSTRAINT FK_Maintenance_HARV FOREIGN KEY (HarvID)
        REFERENCES HARV (HarvID),
    CONSTRAINT FK_Maintenance_Maintainer FOREIGN KEY (MaintainerID)
        REFERENCES Maintainer (MaintainerID),
    CONSTRAINT FK_Maintenance_Organisation FOREIGN KEY (OrganisationID)
        REFERENCES Organisation (OrganisationID),
    CONSTRAINT FK_Maintenance_HARVPart FOREIGN KEY (PartID, HarvID)
        REFERENCES HARV_Part (PartID, HarvID),
    CONSTRAINT FK_Maintenance_PartSupplier FOREIGN KEY (PartID, SupplierID)
        REFERENCES PartSupplier (PartID, SupplierID)
);

CREATE TABLE Invoice (
    InvoiceID      INT NOT NULL,
    SubscriberID   INT NOT NULL,
    SubscriptionID INT NOT NULL,
    GST            DECIMAL(15, 2) NOT NULL,
    Total          DECIMAL(15, 2) NOT NULL,
    CONSTRAINT PK_Invoice PRIMARY KEY (InvoiceID),
    CONSTRAINT FK_Invoice_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID),
    CONSTRAINT FK_Invoice_Subscriber FOREIGN KEY (SubscriberID)
        REFERENCES Subscriber (SubscriberID)
);
GO

INSERT INTO Address (AddressID, StreetNumber, StreetName, Suburb, City, PostCode, CountryCode) VALUES
 (1,  '12',  'Trafalgar St',   'Nelson Central', 'Nelson',     '7010', 'NZ'),
 (2,  '45',  'Aranui Rd',      'Mapua',          'Tasman',     '7005', 'NZ'),
 (3,  '189', 'Queen St',       'Richmond',       'Tasman',     '7020', 'NZ'),
 (4,  '8',   'Forests Rd',     'Wakefield',      'Tasman',     '7025', 'NZ'),
 (5,  '320', 'Main Rd',        'Stoke',          'Nelson',     '7011', 'NZ'),
 (6,  '56',  'Vickerman St',   'Port Nelson',    'Nelson',     '7010', 'NZ'),
 (7,  '14',  'Gladstone Rd',   'Richmond',       'Tasman',     '7020', 'NZ'),
 (8,  '77',  'High St',        'Motueka',        'Tasman',     '7120', 'NZ'),
 (9,  '23',  'Hardy St',       'Nelson Central', 'Nelson',     '7010', 'NZ'),
 (10, '5',   'Seaton Valley Rd','Mapua',         'Tasman',     '7005', 'NZ'),
 (11, '101', 'Songer St',      'Stoke',          'Nelson',     '7011', 'NZ'),
 (12, '9',   'Pah St',         'Motueka',        'Tasman',     '7120', 'NZ'),
 (13, '67',  'Salisbury Rd',   'Richmond',       'Tasman',     '7020', 'NZ'),
 (14, '31',  'Brougham St',    'Nelson Central', 'Nelson',     '7010', 'NZ'),
 (15, '2',   'Bronte Rd East', 'Mapua',          'Tasman',     '7005', 'NZ'),
 (16, '88',  'Lower Queen St', 'Richmond',       'Tasman',     '7020', 'NZ'),
 (17, '19',  'Tahunanui Dr',   'Tahunanui',      'Nelson',     '7011', 'NZ'),
 (18, '44',  'Whakatu Dr',     'Stoke',          'Nelson',     '7011', 'NZ'),
 (19, '6',   'Old Coach Rd',   'Wakefield',      'Tasman',     '7025', 'NZ'),
 (20, '150', 'Trafalgar St',   'Nelson Central', 'Nelson',     '7010', 'NZ'),
 (21, '27',  'Beach Rd',       'Kaiteriteri',    'Tasman',     '7197', 'NZ'),
 (22, '3',   'Iwa Rd',         'Mapua',          'Tasman',     '7005', 'NZ'),
 (23, '12',  'Scott St',       'Blenheim',       'Marlborough','7201', 'NZ'),
 (24, '90',  'Maxwell Rd',     'Blenheim',       'Marlborough','7201', 'NZ'),
 (25, '7',   'Rapaura Rd',     'Renwick',        'Marlborough','7204', 'NZ');

INSERT INTO Organisation (OrganisationID, AddressID, OrganisationName, ContractStart, ContractEnd, Phone, Email) VALUES
 (1, 1, 'Riverside Orchards Ltd', '2023-01-15', '2026-01-14', '035390101', 'accounts@riversideorchards.co.nz'),
 (2, 2, 'Bayview Vineyards',      '2023-03-01', '2026-02-28', '035400202', 'admin@bayviewvines.co.nz'),
 (3, 3, 'Tasman District Council','2022-07-01', '2027-06-30', '035430303', 'procurement@tasman.govt.nz'),
 (4, 4, 'Canopy Forestry Group',  '2024-02-10', '2027-02-09', '035410404', 'ops@canopyforestry.co.nz'),
 (5, 5, 'SensorTech NZ Ltd',      '2023-05-20', '2026-05-19', '0800736768', 'sales@sensortech.co.nz'),
 (6, 6, 'RoboParts Distribution', '2023-06-01', '2026-05-31', '0800762787', 'orders@roboparts.co.nz'),
 (7, 7, 'FieldServ Maintenance',  '2023-08-15', '2026-08-14', '035460707', 'service@fieldserv.co.nz'),
 (8, 8, 'Precision Ag Supplies',  '2024-01-05', '2027-01-04', '035470808', 'hello@precisionag.co.nz');

INSERT INTO Department (DepartmentID, DeptName, DepLocation, Budget, Email, Phone) VALUES
 (1, 'Engineering',           'Port Nelson HQ, Level 2', 1250000.00, 'engineering@coastcanopy.co.nz', '035500001'),
 (2, 'Sales',                 'Port Nelson HQ, Level 1', 480000.00,  'sales@coastcanopy.co.nz',       '035500002'),
 (3, 'Administration',        'Port Nelson HQ, Level 1', 320000.00,  'admin@coastcanopy.co.nz',       '035500003'),
 (4, 'Field Operations',      'Richmond Depot',          760000.00,  'fieldops@coastcanopy.co.nz',    '035500004'),
 (5, 'Research & Development', 'Port Nelson HQ, Level 3', 1500000.00, 'rnd@coastcanopy.co.nz',         '035500005'),
 (6, 'Customer Support',      'Port Nelson HQ, Level 1', 210000.00,  'support@coastcanopy.co.nz',     '035500006');

INSERT INTO Person (PersonID, AddressID, NameFirst, NameLast, Phone, Email) VALUES
 (1,  1,  'Aroha',     'Williams',  '0211000001', 'aroha.williams@coastcanopy.co.nz'),
 (2,  2,  'James',     'Chen',      '0211000002', 'james.chen@coastcanopy.co.nz'),
 (3,  3,  'Mere',      'Tipene',    '0211000003', 'mere.tipene@coastcanopy.co.nz'),
 (4,  4,  'Liam',      'OConnor',   '0211000004', 'liam.oconnor@coastcanopy.co.nz'),
 (5,  5,  'Sophie',    'Patel',     '0211000005', 'sophie.patel@coastcanopy.co.nz'),
 (6,  6,  'Tane',      'Walker',    '0211000006', 'tane.walker@coastcanopy.co.nz'),
 (7,  7,  'Emma',      'Thompson',  '0211000007', 'emma.thompson@coastcanopy.co.nz'),
 (8,  8,  'Wiremu',    'Ngata',     '0211000008', 'wiremu.ngata@coastcanopy.co.nz'),
 (9,  9,  'Olivia',    'Brown',     '0211000009', 'olivia.brown@coastcanopy.co.nz'),
 (10, 10, 'Hemi',      'Rangi',     '0211000010', 'hemi.rangi@coastcanopy.co.nz'),
 (11, 11, 'Charlotte', 'Wilson',    '0211000011', 'charlotte.wilson@coastcanopy.co.nz'),
 (12, 12, 'Ben',       'Taylor',    '0211000012', 'ben.taylor@coastcanopy.co.nz'),
 (13, 13, 'Anahera',   'Cooper',    '0211000013', 'anahera.cooper@coastcanopy.co.nz'),
 (14, 14, 'Jack',      'Robinson',  '0211000014', 'jack.robinson@coastcanopy.co.nz'),
 (15, 15, 'Ruby',      'Clarke',    '0211000015', 'ruby.clarke@coastcanopy.co.nz'),
 (16, 16, 'Manaia',    'Hughes',    '0211000016', 'manaia.hughes@coastcanopy.co.nz'),
 (17, 17, 'Grace',     'Mitchell',  '0211000017', 'grace.mitchell@coastcanopy.co.nz'),
 (18, 18, 'Nikau',     'Edwards',   '0211000018', 'nikau.edwards@coastcanopy.co.nz'),
 (19, 19, 'Lucy',      'Anderson',  '0211000019', 'lucy.anderson@coastcanopy.co.nz'),
 (20, 20, 'Rawiri',    'Smith',     '0211000020', 'rawiri.smith@coastcanopy.co.nz'),
 (21, 21, 'Isla',      'Murphy',    '0211000021', 'isla.murphy@coastcanopy.co.nz'),
 (22, 22, 'Kauri',     'Davis',     '0211000022', 'kauri.davis@coastcanopy.co.nz'),
 (23, 23, 'Daniel',    'Lee',       '0211000023', 'daniel.lee@riversideorchards.co.nz'),
 (24, 24, 'Hannah',    'White',     '0211000024', 'hannah.white@bayviewvines.co.nz'),
 (25, 25, 'Marama',    'Jones',     '0211000025', 'marama.jones@tasman.govt.nz');

INSERT INTO Employee (EmployeeID, PersonID, DepartmentID, TaxCode, Salary) VALUES
 (1,  1,  1, 'M',  145000.00),
 (2,  2,  2, 'M',  138000.00),
 (3,  3,  3, 'M',  142000.00),
 (4,  4,  4, 'M',  150000.00),
 (5,  5,  5, 'M',  135000.00),
 (6,  6,  1, 'ME', 78000.00),
 (7,  7,  1, 'ME', 82000.00),
 (8,  8,  5, 'ME', 85000.00),
 (9,  9,  4, 'ME', 79000.00),
 (10, 10, 5, 'ME', 88000.00),
 (11, 11, 2, 'S',  65000.00),
 (12, 12, 2, 'S',  68000.00),
 (13, 13, 2, 'S',  72000.00),
 (14, 14, 2, 'S',  70000.00),
 (15, 15, 2, 'S',  66000.00),
 (16, 16, 3, 'M',  60000.00),
 (17, 17, 3, 'M',  62000.00),
 (18, 18, 6, 'M',  64000.00),
 (19, 19, 3, 'M',  61000.00),
 (20, 20, 6, 'M',  63000.00),
 (21, 21, 4, 'SB', 58000.00),
 (22, 22, 4, 'SH', 59000.00);

INSERT INTO Director (EmployeeID, DepartmentID) VALUES
 (1,1),(2,2),(3,3),(4,4),(5,5);

INSERT INTO TechnicalEngineer (EmployeeID, DepartmentID) VALUES
 (6,1),(7,1),(8,5),(9,4),(10,5);

INSERT INTO Salesperson (EmployeeID, DepartmentID) VALUES
 (11,2),(12,2),(13,2),(14,2),(15,2);

INSERT INTO AdministrativeExecutive (EmployeeID, DepartmentID) VALUES
 (16,3),(17,3),(18,6),(19,3),(20,6);

INSERT INTO Supplier (SupplierID, OrganisationID) VALUES
 (1,5),(2,6),(3,8),(4,5),(5,6);

INSERT INTO Maintainer (MaintainerID, OrganisationID) VALUES
 (1,7),(2,7),(3,4),(4,7),(5,3);

INSERT INTO Part (PartID, PartName, MaintenanceSchedule) VALUES
 (1, 'Multispectral Camera',  5),
 (2, 'LiDAR Sensor',          5),
 (3, 'Lithium Battery Pack',  2),
 (4, 'Drive Motor',           4),
 (5, 'RTK GPS Module',        5),
 (6, 'Soil Moisture Probe',   3),
 (7, 'Robotic Arm Actuator',  4),
 (8, 'Onboard Compute Unit',  6);

INSERT INTO PartSupplier (PartID, SupplierID, Price) VALUES
 (1,1, 4200.00),
 (2,1, 8750.00),
 (3,2, 950.00),
 (4,2, 1850.00),
 (5,3, 2300.00),
 (6,3, 480.00),
 (7,4, 3600.00),
 (8,5, 2950.00);

INSERT INTO HARV (HarvID, EmployeeID, SerialNumber, ConfigurationType) VALUES
 (1, 6,  'HRV0001', 'Vineyard Scout'),
 (2, 7,  'HRV0002', 'Orchard Canopy'),
 (3, 8,  'HRV0003', 'Forestry Survey'),
 (4, 9,  'HRV0004', 'Soil Sampler'),
 (5, 10, 'HRV0005', 'Multi-Crop'),
 (6, 21, 'HRV0006', 'Vineyard Scout'),
 (7, 22, 'HRV0007', 'Orchard Canopy'),
 (8, 6,  'HRV0008', 'Greenhouse Unit');

INSERT INTO HARV_Part (PartID, HarvID, SKU, Height, HarvLength, Width, LastMaintenanceDate) VALUES
 (1, 1, 100101, 18, 22, 14, '2025-11-02'),
 (3, 1, 100301, 10, 15, 12, '2025-10-15'),
 (2, 2, 100202, 20, 25, 16, '2025-09-28'),
 (4, 3, 100403, 12, 18, 12, '2025-12-01'),
 (5, 4, 100504, 6,  8,  6,  '2025-11-20'),
 (6, 5, 100605, 8,  10, 7,  '2025-10-30'),
 (7, 6, 100706, 30, 24, 18, '2025-12-10'),
 (8, 7, 100807, 9,  12, 11, '2025-11-08');

INSERT INTO Service (ServiceID, ServiceName) VALUES
 (1, 'Crop Health Monitoring'),
 (2, 'Soil Analysis'),
 (3, 'Pest & Disease Detection'),
 (4, 'Yield Estimation'),
 (5, 'Canopy Mapping'),
 (6, 'Irrigation Assessment');

INSERT INTO Zone (ZoneID, ZoneName, Hectares, ZoneLocation) VALUES
 (1, 'North Vineyard Block', 12.50, 'Renwick'),
 (2, 'South Orchard',        8.75,  'Mapua'),
 (3, 'Riverside Plot',       15.20, 'Wakefield'),
 (4, 'Hill Forest Stand',    42.00, 'Wakefield'),
 (5, 'Coastal Terrace',      6.30,  'Kaiteriteri'),
 (6, 'Greenhouse Complex',   2.10,  'Motueka');

 INSERT INTO Subscriber (SubscriberID, PersonID, EmployeeID) VALUES
 (1, 23, 11),
 (2, 24, 12),
 (3, 25, 13),
 (4, 23, 14),
 (5, 24, 15),
 (6, 21, 11),
 (7, 22, 12),
 (8, 9,  13);

INSERT INTO Subscription (SubscriptionID, OrganisationID, SubscriberID, Discount, AnnualMonthly, ContractStart, ContractEnd) VALUES
 (1,  1, 1, 5,  'Annual',  '2025-01-01', '2025-12-31'),
 (2,  2, 2, 0,  'Monthly', '2025-01-15', '2026-01-14'),
 (3,  3, 3, 10, 'Monthly', '2025-02-01', '2026-01-31'),
 (4,  4, 4, 0,  'Monthly', '2025-02-10', '2025-08-09'),
 (5,  1, 5, 5,  'Monthly', '2025-03-01', '2026-02-28'),
 (6,  2, 6, 8,  'Annual',  '2025-03-15', '2027-03-14'),
 (7,  3, 7, 12, 'Annual',  '2025-04-01', '2026-03-31'),
 (8,  4, 8, 0,  'Annual',  '2025-04-20', '2026-04-19'),
 (9,  1, 1, 5,  'Monthly', '2025-05-01', '2027-04-30'),
 (10, 2, 2, 10, 'Monthly', '2025-05-15', '2026-05-14'),
 (11, 3, 3, 15, 'Annual',  '2025-06-01', '2028-05-31'),
 (12, 4, 4, 10, 'Monthly', '2025-06-15', '2027-06-14'),
 (13, 1, 5, 8,  'Annual',  '2025-07-01', '2026-06-30'),
 (14, 2, 6, 12, 'Monthly', '2025-07-15', '2027-07-14'),
 (15, 3, 7, 20, 'Annual',  '2025-08-01', '2028-07-31');

INSERT INTO SubStandard (SubscriptionID, EmployeeID, BasePrice) VALUES
 (1, 11, 2500.00),
 (2, 12, 2500.00),
 (3, 13, 2500.00),
 (4, 14, 2500.00),
 (5, 15, 2500.00),
 (6, 11, 2500.00);

INSERT INTO SubGold (SubscriptionID, EmployeeID, BasePrice) VALUES
 (7, 12, 4500.00),
 (8, 13, 4500.00),
 (9, 14, 4500.00);

INSERT INTO SubPlatinum (SubscriptionID, EmployeeID, BasePrice) VALUES
 (10, 16, 7000.00),
 (11, 17, 7000.00),
 (12, 18, 7000.00);

INSERT INTO SubSuperPlatinum (SubscriptionID, BasePrice) VALUES
 (13, 9500.00),
 (14, 9500.00),
 (15, 9500.00);

INSERT INTO SubscriptionZone (ZoneID, SubscriptionID) VALUES
 (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(1,7),(2,8);

INSERT INTO SubscriptionService (SubscriptionID, ZoneID, ServiceID) VALUES
 (1, 1, 1),
 (2, 2, 2),
 (3, 3, 3),
 (4, 4, 4),
 (5, 5, 5),
 (6, 6, 6),
 (7, 1, 1),
 (8, 2, 3);

INSERT INTO HARV_Assigned (SubscriptionID, HarvID, StartDate, EndDate, AssignedStatus) VALUES
 (1, 1, '2025-01-05', '2025-12-31', 'Active'),
 (2, 2, '2025-01-20', '2026-01-14', 'Active'),
 (3, 3, '2025-02-05', '2026-01-31', 'Active'),
 (4, 4, '2025-02-12', '2025-08-09', 'Completed'),
 (5, 5, '2025-03-05', '2026-02-28', 'Active'),
 (6, 6, '2025-03-20', '2027-03-14', 'Active');

INSERT INTO HARV_SensorData (DataID, HarvID, SubscriptionID, Temperature, Humidity, AmbientSpectralData, OrganicSpectralData, DateOfTake, Latitude, Longitude, Altitude, Depth, HDateTime) VALUES
 (1,  1, 1,  18.40, 62.50, 0.4521, 0.7812, '2025-03-10', -41.512300, 173.857600, 45.20, 0.15, '2025-03-10 09:14:22'),
 (2,  2, 2,  21.10, 58.20, 0.5103, 0.6940, '2025-03-11', -41.245700, 173.105400, 12.80, 0.20, '2025-03-11 10:02:48'),
 (3,  3, 3,  16.75, 71.30, 0.3987, 0.8255, '2025-03-12', -41.398200, 172.978100, 88.60, 0.30, '2025-03-12 08:47:05'),
 (4,  4, 4,  19.90, 55.60, 0.4760, 0.7401, '2025-03-13', -41.401900, 172.965300, 90.10, 0.45, '2025-03-13 11:30:19'),
 (5,  5, 5,  22.30, 49.80, 0.5288, 0.6122, '2025-03-14', -41.520100, 173.860400, 44.90, 0.10, '2025-03-14 13:05:51'),
 (6,  6, 6,  17.20, 66.40, 0.4109, 0.7990, '2025-03-15', -41.246000, 173.104900, 13.10, 0.25, '2025-03-15 07:58:33'),
 (7,  7, 7,  20.05, 60.00, 0.4900, 0.7150, '2025-03-16', -41.247800, 173.106200, 12.50, 0.18, '2025-03-16 12:21:09'),
 (8,  8, 8,  24.60, 45.20, 0.5530, 0.5880, '2025-03-17', -41.110400, 173.012700,  8.40, 0.05, '2025-03-17 14:44:27'),
 (9,  1, 9,  19.30, 63.10, 0.4700, 0.7600, '2025-03-18', -41.512500, 173.857800, 45.10, 0.14, '2025-03-18 08:20:00'),
 (10, 2, 10, 21.80, 57.40, 0.5150, 0.6880, '2025-03-19', -41.245900, 173.105600, 12.70, 0.19, '2025-03-19 09:45:00'),
 (11, 3, 11, 16.20, 72.10, 0.3950, 0.8300, '2025-03-20', -41.398400, 172.978300, 88.40, 0.31, '2025-03-20 10:10:00'),
 (12, 4, 12, 20.40, 54.90, 0.4810, 0.7350, '2025-03-21', -41.402100, 172.965500, 90.30, 0.46, '2025-03-21 11:05:00'),
 (13, 5, 13, 23.10, 48.60, 0.5330, 0.6050, '2025-03-22', -41.520300, 173.860600, 44.70, 0.11, '2025-03-22 12:30:00'),
 (14, 6, 14, 17.90, 65.80, 0.4160, 0.7940, '2025-03-23', -41.246200, 173.105100, 13.00, 0.24, '2025-03-23 07:40:00'),
 (15, 7, 15, 22.70, 46.30, 0.5480, 0.5920, '2025-03-24', -41.247600, 173.106400, 12.40, 0.17, '2025-03-24 13:15:00'); 

INSERT INTO ServiceVisit (VisitID, HarvID, SubscriptionID, ZoneID, ServiceID, VisitDateTime) VALUES
 (1, 1, 1, 1, 1, '2025-04-02 09:00:00'),
 (2, 2, 2, 2, 2, '2025-04-03 09:30:00'),
 (3, 3, 3, 3, 3, '2025-04-04 10:00:00'),
 (4, 4, 4, 4, 4, '2025-04-05 10:30:00'),
 (5, 5, 5, 5, 5, '2025-04-06 11:00:00'),
 (6, 6, 6, 6, 6, '2025-04-07 11:30:00');

INSERT INTO Maintenance (MaintenanceID, HarvID, MaintainerID, OrganisationID, PartID, SupplierID, Cost, MaintenanceType, MDateTime, MHours, Notes) VALUES
 (1, 1, 1, 7, 1, 1, 320.00,  'Scheduled',  '2025-05-10 08:00:00', 2, 'Camera lens recalibration and firmware update.'),
 (2, 1, 2, 7, 3, 2, 180.00,  'Replacement','2025-05-12 09:15:00', 1, 'Battery pack swap, old unit recycled.'),
 (3, 2, 1, 7, 2, 1, 540.00,  'Scheduled',  '2025-05-15 08:30:00', 3, 'LiDAR alignment after vibration warning.'),
 (4, 3, 3, 4, 4, 2, 410.00,  'Repair',      '2025-05-18 10:00:00', 4, 'Drive motor bearing replacement.'),
 (5, 4, 4, 7, 5, 3, 260.00,  'Scheduled',  '2025-05-20 11:00:00', 2, 'RTK GPS module re-survey of base station.'),
 (6, 5, 5, 3, 6, 3, 95.00,   'Inspection', '2025-05-22 13:00:00', 1, 'Soil probe seal check, no fault found.');


INSERT INTO Invoice (InvoiceID, SubscriberID, SubscriptionID, GST, Total) VALUES
 (1, 1, 1, 375.00,  2875.00),
 (2, 2, 2, 375.00,  2875.00),
 (3, 3, 3, 337.50,  2587.50),
 (4, 4, 4, 375.00,  2875.00),
 (5, 5, 5, 356.25,  2731.25),
 (6, 6, 6, 1035.00, 7935.00);
GO

-- A. A salesperson subscribes a new standard subscription to a HARV. The transaction
-- receives the salesperson Id, a discount %, all subscriber details, and a HARV ID

CREATE OR ALTER PROCEDURE dbo.usp_SubscribeStandard
    @SalespersonID   INT,
    @Discount        INT,
    @HarvID          INT,
    @NameFirst       VARCHAR(45),
    @NameLast        VARCHAR(45),
    @Phone           VARCHAR(10),
    @Email           VARCHAR(80),
    @StreetNumber    VARCHAR(40),
    @StreetName      VARCHAR(40),
    @Suburb          VARCHAR(40),
    @City            VARCHAR(40),
    @PostCode        VARCHAR(5),
    @CountryCode     VARCHAR(5),
    @OrganisationID  INT,
    @BasePrice       DECIMAL(10,2),
    @AnnualMonthly   VARCHAR(7),
    @ContractStart   DATE = NULL,
    @ContractEnd     DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM Salesperson WHERE EmployeeID = @SalespersonID)
        THROW 50001, 'Employee is not a Salesperson - only salespeople sell Standard subscriptions.', 1;

    IF NOT EXISTS (SELECT 1 FROM HARV WHERE HarvID = @HarvID)
        THROW 50002, 'HARV ID does not exist.', 1;

    IF @Discount < 0 OR @Discount > 3
        THROW 50003, 'A salesperson may only discount between 0 and 3 percent.', 1;

    IF @AnnualMonthly NOT IN ('Annual','Monthly')
        THROW 50004, 'AnnualMonthly must be ''Annual'' or ''Monthly''.', 1;

    IF NOT EXISTS (SELECT 1 FROM Organisation WHERE OrganisationID = @OrganisationID)
        THROW 50005, 'Organisation ID does not exist.', 1;

    SET @ContractStart = ISNULL(@ContractStart, CAST(GETDATE() AS DATE));
    SET @ContractEnd = ISNULL(@ContractEnd, DATEADD(YEAR, 1, @ContractStart));

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @AddressID      INT = (SELECT ISNULL(MAX(AddressID),0)+1      FROM Address);
        DECLARE @PersonID       INT = (SELECT ISNULL(MAX(PersonID),0)+1       FROM Person);
        DECLARE @SubscriberID   INT = (SELECT ISNULL(MAX(SubscriberID),0)+1   FROM Subscriber);
        DECLARE @SubscriptionID INT = (SELECT ISNULL(MAX(SubscriptionID),0)+1 FROM Subscription);

        INSERT INTO Address (AddressID, StreetNumber, StreetName, Suburb, City, PostCode, CountryCode)
        VALUES (@AddressID, @StreetNumber, @StreetName, @Suburb, @City, @PostCode, @CountryCode);

        INSERT INTO Person (PersonID, AddressID, NameFirst, NameLast, Phone, Email)
        VALUES (@PersonID, @AddressID, @NameFirst, @NameLast, @Phone, @Email);

        INSERT INTO Subscriber (SubscriberID, PersonID, EmployeeID)
        VALUES (@SubscriberID, @PersonID, @SalespersonID);

        INSERT INTO Subscription (SubscriptionID, OrganisationID, SubscriberID, Discount, AnnualMonthly, ContractStart, ContractEnd)
        VALUES (@SubscriptionID, @OrganisationID, @SubscriberID, @Discount, @AnnualMonthly, @ContractStart, @ContractEnd);

        INSERT INTO SubStandard (SubscriptionID, EmployeeID, BasePrice)
        VALUES (@SubscriptionID, @SalespersonID, @BasePrice);

        INSERT INTO HARV_Assigned (SubscriptionID, HarvID, StartDate, EndDate, AssignedStatus)
        VALUES (@SubscriptionID, @HarvID, @ContractStart, @ContractEnd, 'Active');

        COMMIT TRANSACTION;

        SELECT @SubscriptionID AS NewSubscriptionID,
               @SubscriberID   AS NewSubscriberID;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

EXEC dbo.usp_SubscribeStandard
    @SalespersonID = 11, @Discount = 3, @HarvID = 8,
    @NameFirst='Nina', @NameLast='Patel', @Phone='0211234567', @Email='nina@example.co.nz',
    @StreetNumber='4', @StreetName='Vista Rd', @Suburb='Stoke', @City='Nelson',
    @PostCode='7011', @CountryCode='NZ',
    @OrganisationID=1, @BasePrice=2500.00, @AnnualMonthly='Monthly';

-- B. For each salesperson list the subscribers they have sold a subscription to. The
-- transaction receives the salesperson's name as input, and presents each subscriber's
-- name, address, and the % they were discounted.

CREATE OR ALTER PROCEDURE dbo.usp_SubscribersBySalesperson
    @NameFirst VARCHAR(45),
    @NameLast  VARCHAR(45)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmployeeID INT;

    SELECT @EmployeeID = sp.EmployeeID
    FROM Salesperson sp
    JOIN Employee e
    ON e.EmployeeID = sp.EmployeeID
    JOIN Person p
    ON p.PersonID   = e.PersonID
    WHERE p.NameFirst = @NameFirst
      AND p.NameLast  = @NameLast;

    IF @EmployeeID IS NULL
        THROW 50010, 'No salesperson found with that name.', 1;

    IF (SELECT COUNT(*)
        FROM Salesperson sp
        JOIN Employee e
        ON e.EmployeeID = sp.EmployeeID
        JOIN Person p
        ON p.PersonID   = e.PersonID
        WHERE p.NameFirst = @NameFirst AND p.NameLast = @NameLast) > 1
        THROW 50011, 'That name matches more than one salesperson, narrow it down by ID.', 1;

    SELECT
        subP.NameFirst + ' ' + subP.NameLast AS SubscriberName,
        a.StreetNumber + ' ' + a.StreetName + ', '
            + a.Suburb + ', ' + a.City + ' ' + a.PostCode AS SubscriberAddress,
        s.Discount AS DiscountPercent
    FROM Subscriber sub
    JOIN Person subP
    ON subP.PersonID = sub.PersonID
    JOIN Address a
    ON a.AddressID = subP.AddressID
    JOIN Subscription s
    ON s.SubscriberID = sub.SubscriberID
    WHERE sub.EmployeeID = @EmployeeID
    ORDER BY subP.NameLast, subP.NameFirst;
END;
GO

EXEC dbo.usp_SubscribersBySalesperson @NameFirst = 'Charlotte', @NameLast = 'Wilson';

-- C. Write a query to be used to insert data from a HARV to its stored data on the Coast
-- & Canopy database. The transaction receives the HARV ID and all the data from a
-- data stream. That is made up of one or more records of Temperature,
-- Humidity/Salinity, Ambient light strength, and organic spectral data, time, longitude,
-- latitude, altitude/depth and date time.

CREATE TYPE dbo.SensorReading AS TABLE (
    Temperature         DECIMAL(5,2),
    Humidity            DECIMAL(5,2),
    AmbientSpectralData FLOAT,
    OrganicSpectralData FLOAT,
    DateOfTake          DATE,
    Latitude            DECIMAL(9,6),
    Longitude           DECIMAL(9,6),
    Altitude            DECIMAL(10,2),
    Depth               DECIMAL(10,2),
    HDateTime           DATETIME2
);
GO

CREATE OR ALTER PROCEDURE dbo.usp_InsertHarvData
    @HarvID   INT,
    @Readings dbo.SensorReading READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM HARV WHERE HarvID = @HarvID)
        THROW 50020, 'HARV ID does not exist.', 1;

    DECLARE @SubscriptionID INT = (
        SELECT TOP (1) SubscriptionID
        FROM HARV_Assigned
        WHERE HarvID = @HarvID AND AssignedStatus = 'Active'
        ORDER BY StartDate DESC
    );

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @NextID INT = (SELECT ISNULL(MAX(DataID),0) FROM HARV_SensorData);

        INSERT INTO HARV_SensorData
            (DataID, HarvID, SubscriptionID, Temperature, Humidity,
             AmbientSpectralData, OrganicSpectralData, DateOfTake,
             Latitude, Longitude, Altitude, Depth, HDateTime)
        SELECT
            @NextID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
            @HarvID,
            @SubscriptionID,
            r.Temperature, r.Humidity, r.AmbientSpectralData, r.OrganicSpectralData,
            r.DateOfTake, r.Latitude, r.Longitude, r.Altitude, r.Depth, r.HDateTime
        FROM @Readings r;

        COMMIT TRANSACTION;

        SELECT @@ROWCOUNT AS ReadingsInserted;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

--Before--
SELECT COUNT(*) AS RowCountBefore FROM HARV_SensorData;

DECLARE @batch dbo.SensorReading;
INSERT INTO @batch VALUES
(19.5, 60.0, 0.48, 0.72, '2025-06-01', -41.5123, 173.8576, 45.2, 0.15, '2025-06-01 09:00:00'),
(19.8, 59.2, 0.49, 0.71, '2025-06-01', -41.5124, 173.8577, 45.3, 0.16, '2025-06-01 09:00:01');

EXEC dbo.usp_InsertHarvData @HarvID = 1, @Readings = @batch;

-- D. For a Platinum subscription list all the data collected. The transaction receives the
-- contracting organisation's name and presents for each collected data record: the
-- contracting organisation's name, a HARV ID, Temperature, Humidity/Salinity, Ambient
-- light strength, and organic spectral data, Latitude, Longitude, Altitude/Depth, Date
-- and time of the data sample

CREATE OR ALTER PROCEDURE dbo.usp_PlatinumDataByOrg
    @OrganisationName VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Organisation WHERE OrganisationName = @OrganisationName)
        THROW 50030, 'No organisation found with that name.', 1;

    SELECT
        o.OrganisationName AS ContractingOrganisation,
        sd.HarvID AS HarvID,
        sd.Temperature,
        sd.Humidity AS HumiditySalinity,
        sd.AmbientSpectralData AS AmbientLightStrength,
        sd.OrganicSpectralData,
        sd.Latitude,
        sd.Longitude,
        sd.Altitude,
        sd.Depth,
        sd.HDateTime AS DataSampleDateTime
    FROM Organisation o
    JOIN Subscription s
    ON s.OrganisationID = o.OrganisationID
    JOIN SubPlatinum pl
    ON pl.SubscriptionID = s.SubscriptionID
    JOIN HARV_SensorData sd
    ON sd.SubscriptionID = s.SubscriptionID
    WHERE o.OrganisationName = @OrganisationName
    ORDER BY sd.HarvID, sd.HDateTime;
END;
GO

EXEC dbo.usp_PlatinumDataByOrg @OrganisationName = 'Tasman District Council';

-- E. For each subscription produce an invoice for the current month. The transaction
-- produces an output from separate queries that lists the Date, Subscriber Name,
-- Address, the subscription level (Standard, Gold, Platinum, or Super Platinum), followed
-- by the list of Zones, services provided in the last month, and the total exclusive of
-- GST, the total inclusive of GST, and the total tax. NOTE: In SQL Server you should use
-- a series of PRINT commands within at least one CURSOR.

CREATE OR ALTER PROCEDURE dbo.usp_MonthlyInvoices
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SubscriptionID INT, @SubscriberName VARCHAR(100), @Address VARCHAR(200),
            @Level VARCHAR(20), @BasePrice DECIMAL(10,2), @Discount INT;

    DECLARE @ExGST DECIMAL(10,2), @Tax DECIMAL(10,2), @IncGST DECIMAL(10,2);

    DECLARE @ZoneName VARCHAR(40), @ServiceName VARCHAR(60), @line VARCHAR(200);

    DECLARE invoice_cursor CURSOR FOR
        SELECT
            s.SubscriptionID,
            p.NameFirst + ' ' + p.NameLast,
            a.StreetNumber + ' ' + a.StreetName + ', ' + a.Suburb + ', ' + a.City + ' ' + a.PostCode,
            CASE
                WHEN ssp.SubscriptionID IS NOT NULL THEN 'Super Platinum'
                WHEN pl.SubscriptionID  IS NOT NULL THEN 'Platinum'
                WHEN g.SubscriptionID   IS NOT NULL THEN 'Gold'
                WHEN st.SubscriptionID  IS NOT NULL THEN 'Standard'
                ELSE 'Unknown'
            END AS SubLevel,
            COALESCE(ssp.BasePrice, pl.BasePrice, g.BasePrice, st.BasePrice, 0),
            s.Discount
        FROM Subscription s
        JOIN Subscriber sub
        ON sub.SubscriberID = s.SubscriberID
        JOIN Person p
        ON p.PersonID = sub.PersonID
        JOIN Address a 
        ON a.AddressID = p.AddressID
        LEFT JOIN SubStandard st
        ON st.SubscriptionID = s.SubscriptionID
        LEFT JOIN SubGold g
        ON g.SubscriptionID = s.SubscriptionID
        LEFT JOIN SubPlatinum pl
        ON pl.SubscriptionID = s.SubscriptionID
        LEFT JOIN SubSuperPlatinum ssp
        ON ssp.SubscriptionID = s.SubscriptionID;

    OPEN invoice_cursor;
    FETCH NEXT FROM invoice_cursor
        INTO @SubscriptionID, @SubscriberName, @Address, @Level, @BasePrice, @Discount;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ExGST  = @BasePrice - (@BasePrice * @Discount / 100.0);
        SET @Tax    = @ExGST * 0.15;
        SET @IncGST = @ExGST + @Tax;

        -- Header
        PRINT '========================================';
        PRINT 'INVOICE - Date: ' + CONVERT(VARCHAR(10), GETDATE(), 103);
        PRINT 'Subscription #: ' + CAST(@SubscriptionID AS VARCHAR(10));
        PRINT 'Subscriber:     ' + @SubscriberName;
        PRINT 'Address:        ' + @Address;
        PRINT 'Level:          ' + @Level;
        PRINT '----------------------------------------';

        PRINT 'Zones:';
        DECLARE zone_cursor CURSOR FOR
            SELECT z.ZoneName
            FROM SubscriptionZone sz
            JOIN Zone z
            ON z.ZoneID = sz.ZoneID
            WHERE sz.SubscriptionID = @SubscriptionID;
        OPEN zone_cursor;
        FETCH NEXT FROM zone_cursor INTO @ZoneName;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT '   - ' + @ZoneName;
            FETCH NEXT FROM zone_cursor INTO @ZoneName;
        END
        CLOSE zone_cursor;
        DEALLOCATE zone_cursor;

        PRINT 'Services provided (last month):';
        DECLARE service_cursor CURSOR FOR
            SELECT DISTINCT sv.ServiceName
            FROM ServiceVisit v
            JOIN Service sv
            ON sv.ServiceID = v.ServiceID
            WHERE v.SubscriptionID = @SubscriptionID
            AND v.VisitDateTime >= DATEADD(MONTH, -1, GETDATE());
        OPEN service_cursor;
        FETCH NEXT FROM service_cursor INTO @ServiceName;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT '   - ' + @ServiceName;
            FETCH NEXT FROM service_cursor INTO @ServiceName;
        END
        CLOSE service_cursor;
        DEALLOCATE service_cursor;

        PRINT '----------------------------------------';
        PRINT 'Total (excl GST): $' + CAST(@ExGST  AS VARCHAR(20));
        PRINT 'GST (15%):        $' + CAST(@Tax    AS VARCHAR(20));
        PRINT 'Total (incl GST): $' + CAST(@IncGST AS VARCHAR(20));
        PRINT '========================================';
        PRINT '';

        FETCH NEXT FROM invoice_cursor
            INTO @SubscriptionID, @SubscriberName, @Address, @Level, @BasePrice, @Discount;
    END

    CLOSE invoice_cursor;
    DEALLOCATE invoice_cursor;
END;
GO

EXEC dbo.usp_MonthlyInvoices;

-- F. For a given HARV list all the suppliers of parts and the last time they were
-- maintained. The transaction receives the HARV ID, and presents the Supplier Name,
-- Part Name, Last Maintenance

CREATE OR ALTER PROCEDURE dbo.usp_HarvSuppliersAndMaintenance
    @HarvID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM HARV WHERE HarvID = @HarvID)
        THROW 50040, 'HARV ID does not exist.', 1;

    SELECT
        o.OrganisationName AS SupplierName,
        p.PartName AS PartName,
        hp.LastMaintenanceDate AS LastMaintenance
    FROM HARV_Part hp
    JOIN Part p
    ON p.PartID = hp.PartID
    JOIN PartSupplier ps
    ON ps.PartID = p.PartID
    JOIN Supplier su
    ON su.SupplierID = ps.SupplierID
    JOIN Organisation o
    ON o.OrganisationID = su.OrganisationID
    WHERE hp.HarvID = @HarvID
    ORDER BY p.PartName, o.OrganisationName;
END;
GO

EXEC dbo.usp_HarvSuppliersAndMaintenance @HarvID = 1;

-- G. Find the locations and Zones that a HARV is contracted to, that have not been
-- visited to service in the last 5 days. The transaction receives the HARV ID. The
-- transaction lists the HARV ID, Contracting Organisation's Name, Zone, and Service
-- that has not been undertaken

CREATE OR ALTER PROCEDURE dbo.usp_HarvUnservicedZones
    @HarvID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM HARV WHERE HarvID = @HarvID)
        THROW 50050, 'HARV ID does not exist.', 1;

    SELECT
        @HarvID AS HarvID,
        o.OrganisationName AS ContractingOrganisation,
        z.ZoneName AS Zone,
        z.ZoneLocation AS Location,
        sv_service.ServiceName AS Service
    FROM HARV_Assigned ha
    JOIN Subscription s
    ON s.SubscriptionID = ha.SubscriptionID
    JOIN Organisation o
    ON o.OrganisationID = s.OrganisationID
    JOIN SubscriptionService ss
    ON ss.SubscriptionID = s.SubscriptionID
    JOIN Zone z
    ON z.ZoneID = ss.ZoneID
    JOIN Service sv_service  ON sv_service.ServiceID = ss.ServiceID
    WHERE ha.HarvID = @HarvID
      AND NOT EXISTS (
          SELECT 1
          FROM ServiceVisit v
          WHERE v.HarvID         = @HarvID
            AND v.SubscriptionID = ss.SubscriptionID
            AND v.ZoneID         = ss.ZoneID
            AND v.ServiceID      = ss.ServiceID
            AND v.VisitDateTime >= DATEADD(DAY, -5, GETDATE())
      )
    ORDER BY z.ZoneName, sv_service.ServiceName;
END;
GO

INSERT INTO ServiceVisit (VisitID, HarvID, SubscriptionID, ZoneID, ServiceID, VisitDateTime)
VALUES (7, 1, 1, 1, 1, GETDATE());

EXEC dbo.usp_HarvUnservicedZones @HarvID = 1;

-- H. Delete the data collected for a given Contract. The transaction receives a Contract
-- ID; the data collected for a Contract is deleted.

CREATE OR ALTER PROCEDURE dbo.usp_DeleteContractData
    @SubscriptionID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM Subscription WHERE SubscriptionID = @SubscriptionID)
        THROW 50070, 'Contract (Subscription) ID does not exist.', 1;

    DECLARE @RowsToDelete INT =
        (SELECT COUNT(*) FROM HARV_SensorData WHERE SubscriptionID = @SubscriptionID);

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM HARV_SensorData
        WHERE SubscriptionID = @SubscriptionID;

        COMMIT TRANSACTION;

        PRINT 'Deleted ' + CAST(@RowsToDelete AS VARCHAR(10))
            + ' sensor data record(s) for contract ' + CAST(@SubscriptionID AS VARCHAR(10)) + '.';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

--before
SELECT COUNT(*) AS Before FROM HARV_SensorData WHERE SubscriptionID = 1;

EXEC dbo.usp_DeleteContractData @SubscriptionID = 1;

--after
SELECT COUNT(*) AS After  FROM HARV_SensorData WHERE SubscriptionID = 1;

-- I. Write a query that displays the total cost of all parts replaced in maintenance of a
-- HARV in the last ten years. The transaction displays the HARV ID, the name of the
-- Engineer who built the HARV, the beginning date, end date and Total Cost of replaced
-- parts, for every HARV.

CREATE OR ALTER PROCEDURE dbo.usp_HarvPartsReplacedCost
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        h.HarvID AS HarvID,
        p.NameFirst + ' ' + p.NameLast AS EngineerName,
        MIN(m.MDateTime) AS BeginningDate,
        MAX(m.MDateTime) AS EndDate,
        SUM(m.Cost) AS TotalCost
    FROM HARV h
    JOIN Employee e
    ON e.EmployeeID = h.EmployeeID
    JOIN Person p
    ON p.PersonID = e.PersonID
    JOIN Maintenance m
    ON m.HarvID = h.HarvID
    WHERE m.MDateTime >= DATEADD(YEAR, -10, GETDATE())
    GROUP BY h.HarvID, p.NameFirst, p.NameLast
    ORDER BY h.HarvID;
END;
GO

INSERT INTO Maintenance (MaintenanceID, HarvID, MaintainerID, OrganisationID, PartID, SupplierID, Cost, MaintenanceType, MDateTime, MHours, Notes) VALUES
(7, 1, 1, 7, 1, 1, 999.00, 'Replacement', '2014-05-10 08:00:00', 4, 'Old replacement, should be excluded by the 10 year filter.');

EXEC dbo.usp_HarvPartsReplacedCost;

-- J. Log a completed 5-year scheduled maintenance task for a HARV in the field. The
-- transaction receives the HARV ID, the Third-Party Maintainer ID, the Part ID, the
-- Supplier ID, and the current Date. The transaction updates the last maintenance date
-- for that specific HARV's part and records the specific purchase cost of the
-- replacement part from that chosen supplier.

CREATE OR ALTER PROCEDURE dbo.usp_LogScheduledMaintenance
    @HarvID       INT,
    @MaintainerID INT,
    @PartID       INT,
    @SupplierID   INT,
    @CurrentDate  DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM HARV_Part WHERE HarvID = @HarvID AND PartID = @PartID)
        THROW 50060, 'That part is not fitted to that HARV.', 1;

    IF NOT EXISTS (SELECT 1 FROM Maintainer WHERE MaintainerID = @MaintainerID)
        THROW 50061, 'Maintainer ID does not exist.', 1;

    IF NOT EXISTS (SELECT 1 FROM PartSupplier WHERE PartID = @PartID AND SupplierID = @SupplierID)
        THROW 50062, 'That supplier does not supply that part.', 1;

    DECLARE @Cost DECIMAL(10,2) = (
        SELECT Price
        FROM PartSupplier
        WHERE PartID = @PartID AND SupplierID = @SupplierID
    );

    DECLARE @OrganisationID INT = (
        SELECT OrganisationID
        FROM Maintainer
        WHERE MaintainerID = @MaintainerID
    );

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE HARV_Part
        SET LastMaintenanceDate = @CurrentDate
        WHERE HarvID = @HarvID AND PartID = @PartID;

        DECLARE @NextID INT = (SELECT ISNULL(MAX(MaintenanceID),0)+1
                               FROM Maintenance);

        INSERT INTO Maintenance
            (MaintenanceID, HarvID, MaintainerID, OrganisationID, PartID, SupplierID,
             Cost, MaintenanceType, MDateTime, MHours, Notes)
        VALUES
            (@NextID, @HarvID, @MaintainerID, @OrganisationID, @PartID, @SupplierID,
             @Cost, 'Scheduled', @CurrentDate, NULL, '5-year scheduled maintenance completed in field.');

        COMMIT TRANSACTION;

        SELECT @NextID AS NewMaintenanceID, @Cost AS RecordedCost;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

SELECT HarvID, PartID, LastMaintenanceDate
FROM HARV_Part
WHERE HarvID = 1 AND PartID = 1;

EXEC dbo.usp_LogScheduledMaintenance
    @HarvID = 1, @MaintainerID = 1, @PartID = 1, @SupplierID = 1, @CurrentDate = '2026-06-20';