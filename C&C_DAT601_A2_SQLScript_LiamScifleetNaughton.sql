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

CREATE TABLE Subscription (
    SubscriptionID INT NOT NULL,
    OrganisationID INT NOT NULL,
    Discount       INT NOT NULL,
    AnnualMonitor  INT NOT NULL,
    ContractStart  DATE,
    ContractEnd    DATE,
    CONSTRAINT PK_Subscription PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_Subscription_Organisation FOREIGN KEY (OrganisationID)
        REFERENCES Organisation (OrganisationID)
);

CREATE TABLE SubStandard (
    SubscriptionID INT NOT NULL,
    EmployeeID     INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubStandard PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_SubStandard_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
);

CREATE TABLE SubGold (
    SubscriptionID INT NOT NULL,
    EmployeeID     INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubGold PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_SubGold_SubStandard FOREIGN KEY (SubscriptionID)
        REFERENCES SubStandard (SubscriptionID),
    CONSTRAINT FK_SubGold_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
);

CREATE TABLE SubSuperPlatinum (
    SubscriptionID INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubSuperPlatinum PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_SubSuperPlatinum_SubGold FOREIGN KEY (SubscriptionID)
        REFERENCES SubGold (SubscriptionID)
);

CREATE TABLE SubPlatinum (
    SubscriptionID INT NOT NULL,
    EmployeeID     INT NOT NULL,
    BasePrice      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_SubPlatinum PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_SubPlatinum_SubGold FOREIGN KEY (SubscriptionID)
        REFERENCES SubGold (SubscriptionID),
    CONSTRAINT FK_SubPlatinum_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
);

CREATE TABLE Subscriber (
    SubscriberID   INT NOT NULL,
    SubscriptionID INT NOT NULL,
    PersonID       INT NOT NULL,
    EmployeeID     INT NOT NULL,
    CONSTRAINT PK_Subscriber PRIMARY KEY (SubscriberID),
    CONSTRAINT FK_Subscriber_Subscription FOREIGN KEY (SubscriptionID)
        REFERENCES Subscription (SubscriptionID),
    CONSTRAINT FK_Subscriber_Person FOREIGN KEY (PersonID)
        REFERENCES Person (PersonID),
    CONSTRAINT FK_Subscriber_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee (EmployeeID)
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

INSERT INTO Subscription (SubscriptionID, OrganisationID, Discount, AnnualMonitor, ContractStart, ContractEnd) VALUES
 (1,  1, 5,  12, '2025-01-01', '2025-12-31'),
 (2,  2, 0,  24, '2025-01-15', '2026-01-14'),
 (3,  3, 10, 12, '2025-02-01', '2026-01-31'),
 (4,  4, 0,  6,  '2025-02-10', '2025-08-09'),
 (5,  1, 5,  12, '2025-03-01', '2026-02-28'),
 (6,  2, 8,  24, '2025-03-15', '2027-03-14'),
 (7,  3, 12, 12, '2025-04-01', '2026-03-31'),
 (8,  4, 0,  12, '2025-04-20', '2026-04-19'),
 (9,  1, 5,  24, '2025-05-01', '2027-04-30'),
 (10, 2, 10, 12, '2025-05-15', '2026-05-14'),
 (11, 3, 15, 36, '2025-06-01', '2028-05-31'),
 (12, 4, 10, 24, '2025-06-15', '2027-06-14'),
 (13, 1, 8,  12, '2025-07-01', '2026-06-30'),
 (14, 2, 12, 24, '2025-07-15', '2027-07-14'),
 (15, 3, 20, 36, '2025-08-01', '2028-07-31');

INSERT INTO SubStandard (SubscriptionID, EmployeeID, BasePrice) VALUES
 (1,  11, 2500.00),
 (2,  12, 2500.00),
 (3,  13, 2500.00),
 (4,  14, 2500.00),
 (5,  15, 2500.00),
 (6,  11, 2500.00),
 (7,  12, 2500.00),
 (8,  13, 2500.00),
 (9,  14, 2500.00),
 (10, 15, 2500.00),
 (11, 11, 2500.00),
 (12, 12, 2500.00),
 (13, 13, 2500.00),
 (14, 14, 2500.00),
 (15, 15, 2500.00);

INSERT INTO SubGold (SubscriptionID, EmployeeID, BasePrice) VALUES
 (6,  11, 4500.00),
 (7,  12, 4500.00),
 (8,  13, 4500.00),
 (9,  14, 4500.00),
 (10, 15, 4500.00),
 (11, 11, 4500.00),
 (12, 12, 4500.00),
 (13, 13, 4500.00),
 (14, 14, 4500.00),
 (15, 15, 4500.00);

INSERT INTO SubSuperPlatinum (SubscriptionID, BasePrice) VALUES
 (6,  9500.00),
 (7,  9500.00),
 (8,  9500.00),
 (9,  9500.00),
 (10, 9500.00);

INSERT INTO SubPlatinum (SubscriptionID, EmployeeID, BasePrice) VALUES
 (11, 11, 7000.00),
 (12, 12, 7000.00),
 (13, 13, 7000.00),
 (14, 14, 7000.00),
 (15, 15, 7000.00);

INSERT INTO Subscriber (SubscriberID, SubscriptionID, PersonID, EmployeeID) VALUES
 (1, 1, 23, 11),
 (2, 2, 24, 12),
 (3, 3, 25, 13),
 (4, 4, 23, 14),
 (5, 5, 24, 15),
 (6, 6, 21, 11),
 (7, 7, 22, 12),
 (8, 8, 9,  13);

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
 (1, 1, 1,    18.40, 62.50, 0.4521, 0.7812, '2025-03-10', -41.512300, 173.857600, 45.20,  0.15, '2025-03-10 09:14:22'),
 (2, 2, 2,    21.10, 58.20, 0.5103, 0.6940, '2025-03-11', -41.245700, 173.105400, 12.80,  0.20, '2025-03-11 10:02:48'),
 (3, 3, 3,    16.75, 71.30, 0.3987, 0.8255, '2025-03-12', -41.398200, 172.978100, 88.60,  0.30, '2025-03-12 08:47:05'),
 (4, 4, 4,    19.90, 55.60, 0.4760, 0.7401, '2025-03-13', -41.401900, 172.965300, 90.10,  0.45, '2025-03-13 11:30:19'),
 (5, 5, 5,    22.30, 49.80, 0.5288, 0.6122, '2025-03-14', -41.520100, 173.860400, 44.90,  0.10, '2025-03-14 13:05:51'),
 (6, 6, 6,    17.20, 66.40, 0.4109, 0.7990, '2025-03-15', -41.246000, 173.104900, 13.10,  0.25, '2025-03-15 07:58:33'),
 (7, 7, NULL, 20.05, 60.00, 0.4900, 0.7150, '2025-03-16', -41.247800, 173.106200, 12.50,  0.18, '2025-03-16 12:21:09'),
 (8, 8, NULL, 24.60, 45.20, 0.5530, 0.5880, '2025-03-17', -41.110400, 173.012700, 8.40,   0.05, '2025-03-17 14:44:27');

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