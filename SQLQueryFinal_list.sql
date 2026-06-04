-- ============================================
-- DATABASE: VendorApprovalDB
-- PURPOSE: BSPTCL Vendor Approval & Adoption Checklist System
-- ============================================

-- 1. CREATE DATABASE
CREATE DATABASE VendorApprovalDB;
GO

USE VendorApprovalDB;
GO

-- ============================================
-- 2. CREATE TABLES (in dependency order)
-- ============================================

-- ---------- SECTION A: PROPOSER/EPC CONTRACTOR ----------
CREATE TABLE EPC_Contractor (
    EPC_ID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Proposer (
    Proposer_ID INT IDENTITY(1,1) PRIMARY KEY,
    EPC_ID INT FOREIGN KEY REFERENCES EPC_Contractor(EPC_ID),
    FullName NVARCHAR(200) NOT NULL,
    Designation NVARCHAR(100) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Pincode NVARCHAR(10) NOT NULL,
    State NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    MobileCountryCode NVARCHAR(5) NOT NULL,
    MobileNumber NVARCHAR(15) NOT NULL,
    Email NVARCHAR(200) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- SECTION B: MANUFACTURER DETAILS ----------
CREATE TABLE Manufacturer_Category (
    Category_ID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Manufacturer (
    Manufacturer_ID INT IDENTITY(1,1) PRIMARY KEY,
    Proposer_ID INT FOREIGN KEY REFERENCES Proposer(Proposer_ID),
    Category_ID INT FOREIGN KEY REFERENCES Manufacturer_Category(Category_ID),
    ManufacturerName NVARCHAR(200) NOT NULL,
    Website NVARCHAR(500) NULL,
    WorksAddress NVARCHAR(500) NOT NULL,
    WorksCity NVARCHAR(100) NOT NULL,
    WorksState NVARCHAR(100) NOT NULL,
    WorksPincode NVARCHAR(10) NOT NULL,
    WorksCountry NVARCHAR(100) NOT NULL,
    PlantHeadName NVARCHAR(200) NOT NULL,
    PlantHeadDesignation NVARCHAR(100) NOT NULL,
    PlantHeadMobileCode NVARCHAR(5) NOT NULL,
    PlantHeadMobileNumber NVARCHAR(15) NOT NULL,
    PlantHeadEmail NVARCHAR(200) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- SECTION C: ITEM DETAILS ----------
CREATE TABLE NIT_Details (
    NIT_ID INT IDENTITY(1,1) PRIMARY KEY,
    NIT_Number NVARCHAR(100) NOT NULL UNIQUE,
    NIT_Description NVARCHAR(500) NOT NULL,
    NOA_Number NVARCHAR(100) NOT NULL,
    NOA_PageNo NVARCHAR(50) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Item_Category (
    ItemCategory_ID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Voltage_Level (
    Voltage_ID INT IDENTITY(1,1) PRIMARY KEY,
    VoltageValue NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Item_Rating (
    Rating_ID INT IDENTITY(1,1) PRIMARY KEY,
    RatingValue NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Item (
    Item_ID INT IDENTITY(1,1) PRIMARY KEY,
    Manufacturer_ID INT FOREIGN KEY REFERENCES Manufacturer(Manufacturer_ID),
    NIT_ID INT FOREIGN KEY REFERENCES NIT_Details(NIT_ID),
    ItemCategory_ID INT FOREIGN KEY REFERENCES Item_Category(ItemCategory_ID),
    Voltage_ID INT FOREIGN KEY REFERENCES Voltage_Level(Voltage_ID),
    Rating_ID INT FOREIGN KEY REFERENCES Item_Rating(Rating_ID),
    ItemName NVARCHAR(200) NOT NULL,
    BriefDescription NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- EARLIER ASSESSMENT ----------
CREATE TABLE Earlier_Assessment_Outcome (
    Outcome_ID INT IDENTITY(1,1) PRIMARY KEY,
    OutcomeName NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Earlier_Assessment (
    Assessment_ID INT IDENTITY(1,1) PRIMARY KEY,
    Item_ID INT FOREIGN KEY REFERENCES Item(Item_ID),
    PreviousRefDate DATE NULL,
    Outcome_ID INT FOREIGN KEY REFERENCES Earlier_Assessment_Outcome(Outcome_ID),
    Remarks NVARCHAR(MAX) NULL,
    ReferencePageNo NVARCHAR(50) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- BSPTCL APPROVAL STATUS ----------
CREATE TABLE Approval_Status (
    Status_ID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE BSPTCL_Approval (
    Approval_ID INT IDENTITY(1,1) PRIMARY KEY,
    Item_ID INT FOREIGN KEY REFERENCES Item(Item_ID),
    IsAlreadyApproved BIT NOT NULL,
    ApprovalOrderNo NVARCHAR(200) NULL,
    ApprovalDate DATE NULL,
    ReferencePageNo NVARCHAR(50) NULL,
    ConsolidatedAttachmentPath NVARCHAR(500) NULL,
    Status_ID INT FOREIGN KEY REFERENCES Approval_Status(Status_ID) DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- SECTION D: TYPE TEST REPORTS ----------
CREATE TABLE Laboratory (
    Laboratory_ID INT IDENTITY(1,1) PRIMARY KEY,
    LabName NVARCHAR(200) NOT NULL,
    LabAddress NVARCHAR(500) NOT NULL,
    AccreditationDetails NVARCHAR(500) NULL,
    ReferencePageNo NVARCHAR(50) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Type_Test_Report (
    TestReport_ID INT IDENTITY(1,1) PRIMARY KEY,
    Item_ID INT FOREIGN KEY REFERENCES Item(Item_ID),
    Laboratory_ID INT FOREIGN KEY REFERENCES Laboratory(Laboratory_ID),
    IsValidReportsEnclosed BIT NOT NULL,
    IsAsPerCEAGuidelines BIT NOT NULL,
    IsAllTestReportsSubmitted BIT NOT NULL,
    TestName NVARCHAR(200) NOT NULL,
    ReportNo NVARCHAR(100) NOT NULL,
    ReportDate DATE NOT NULL,
    MaterialDescription NVARCHAR(500) NULL,
    ReferencePageNo NVARCHAR(50) NULL,
    IsSpecSameOrHigher BIT NOT NULL,
    OfferedSpecification NVARCHAR(500) NULL,
    TypeTestedSpecification NVARCHAR(500) NULL,
    OfferedRating NVARCHAR(200) NULL,
    TypeTestedRating NVARCHAR(200) NULL,
    IsSameModelAsTested BIT NOT NULL,
    ConsolidatedAttachmentPath NVARCHAR(500) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- SECTION E: PAST CREDENTIALS ----------
CREATE TABLE Central_State_Utility (
    Utility_ID INT IDENTITY(1,1) PRIMARY KEY,
    UtilityName NVARCHAR(200) NOT NULL UNIQUE
);
GO

CREATE TABLE Vendor_Approval_History (
    ApprovalHistory_ID INT IDENTITY(1,1) PRIMARY KEY,
    Item_ID INT FOREIGN KEY REFERENCES Item(Item_ID),
    Utility_ID INT FOREIGN KEY REFERENCES Central_State_Utility(Utility_ID),
    ApprovalLetterNo NVARCHAR(200) NOT NULL,
    MaterialEquipment NVARCHAR(500) NOT NULL,
    ReferencePageNo NVARCHAR(50) NULL,
    IsPerformanceCertificateProvided BIT NOT NULL,
    PerfCertReferencePageNo NVARCHAR(50) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Manufacturing_Experience (
    Experience_ID INT IDENTITY(1,1) PRIMARY KEY,
    Item_ID INT FOREIGN KEY REFERENCES Item(Item_ID),
    YearsInManufacturing INT NOT NULL,
    YearsInSupply INT NOT NULL,
    MajorClients NVARCHAR(MAX) NULL,
    ReferencePageNo NVARCHAR(50) NULL,
    IsAdequateExperience BIT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Financial_Soundness (
    Financial_ID INT IDENTITY(1,1) PRIMARY KEY,
    Item_ID INT FOREIGN KEY REFERENCES Item(Item_ID),
    IsFinanciallySound BIT NOT NULL,
    AuditBalanceSheetRefPageNo NVARCHAR(500) NULL,
    ConsolidatedAttachmentPath NVARCHAR(500) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- SECTION F: DECLARATION ----------
CREATE TABLE Declaration (
    Declaration_ID INT IDENTITY(1,1) PRIMARY KEY,
    Proposer_ID INT FOREIGN KEY REFERENCES Proposer(Proposer_ID),
    IsDetailsTrueCorrect BIT NOT NULL,
    IsNotBlacklisted BIT NOT NULL,
    UndertakingAttachmentPath NVARCHAR(500) NULL,
    AuthorisedSignatoryName NVARCHAR(200) NOT NULL,
    AuthorisedSignatoryDesignation NVARCHAR(100) NOT NULL,
    SubmissionDate DATE NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ---------- APPROVED VENDOR LIST (from second sheet) ----------
CREATE TABLE Approved_Vendor_List (
    ApprovedVendor_ID INT IDENTITY(1,1) PRIMARY KEY,
    ItemDescription NVARCHAR(200) NOT NULL,
    ManufacturerVendorName NVARCHAR(300) NOT NULL,
    Location NVARCHAR(200) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ============================================
-- 3. INSERT MASTER DATA (Lookup Tables)
-- ============================================

-- Manufacturer Category
INSERT INTO Manufacturer_Category (CategoryName) VALUES 
('MICRO'), ('SMALL'), ('MEDIUM'), ('OTHER');
GO

-- Earlier Assessment Outcome
INSERT INTO Earlier_Assessment_Outcome (OutcomeName) VALUES 
('Approved'), ('Rejected'), ('Pending');
GO

-- Approval Status
INSERT INTO Approval_Status (StatusName) VALUES 
('Pending'), ('Approved'), ('Rejected'), ('Under Review');
GO

-- Voltage Levels
INSERT INTO Voltage_Level (VoltageValue) VALUES 
('11kV'), ('33kV'), ('66kV'), ('132kV'), ('220kV'), ('400kV'), ('765kV'), ('Not Applicable');
GO

-- Item Ratings (sample)
INSERT INTO Item_Rating (RatingValue) VALUES 
('100 MVA'), ('200 MVA'), ('500 MVA'), ('1000 A'), ('2000 A'), ('Not Specified');
GO

-- Item Categories
INSERT INTO Item_Category (CategoryName) VALUES 
('Conductor'), ('Transformer'), ('Switchgear'), ('Insulator'), ('Cable'), 
('Hardware Fittings'), ('Protection Device'), ('Communication Equipment'), 
('Testing Equipment'), ('Structure'), ('Accessories');
GO

-- Central/State Utilities
INSERT INTO Central_State_Utility (UtilityName) VALUES 
('BSPTCL'), ('POWERGRID'), ('UPPTCL'), ('MPPTCL'), ('TSTRANSCO'), ('GETCO'), ('MSETCL');
GO

-- ============================================
-- 4. INSERT SAMPLE DATA FROM YOUR EXCEL (APPROVED VENDOR LIST)
-- ============================================

INSERT INTO Approved_Vendor_List (ItemDescription, ManufacturerVendorName, Location) VALUES
('Joint Box for Optical Fiber', 'M/s Sicame India', 'Kanchipuram'),
('Joint Box for Optical Fiber', 'M/s Opterna Technology Pvt. Ltd.', 'Kerala'),
('Joint Box for Optical Fiber', 'M/s LS Cable & system', 'Gurgaon'),
('Joint Box for Optical Fiber', 'M/s Legion energy products pvt. Ltd.', 'Bengaluru'),
('FODP', 'M/s Opterna Technology Pvt. Ltd.', 'Kerala'),
('FODP', 'M/s ADH Services pvt. Ltd.', 'Delhi'),
('FODP', 'M/s LS Cable & system', 'Gurgaon'),
('24F Approach Cable', 'M/s Sterlite Power Transmission Ltd.', 'Gurugram'),
('24F Approach Cable', 'M/s LS Cable & system', 'Gurgaon'),
('24F Approach Cable', 'M/s AKS Optifiber Ltd.', 'Delhi'),
('24F Approach Cable', 'M/s Apar Industries Ltd.', 'Vadodara'),
('ACSR Panther', 'M/s Mahavir Transmission Ltd.', 'Noida'),
('ACSR Panther', 'M/s Haryana Conductors', 'Haryana'),
('ACSR Panther', 'M/s Shashi Cables Ltd', 'Lucknow'),
('ACSR Panther', 'M/s Venkateswara wires (P) Ltd.', 'Jaipur'),
('ACSR Panther', 'M/s Nirmal Wires Pvt. Ltd.', 'Kolkata'),
('Power Transformer', 'M/s Kanohar Electricals Ltd.', 'Meerut'),
('Power Transformer', 'M/s ECE Industries Pvt. Ltd.', ''),
('Power Transformer', 'M/s Bharat Bijli', ''),
('Power Transformer', 'M/s CG Power & Industrial Solution Ltd.', 'Nasik'),
('Power Transformer', 'M/s Siemens', ''),
('CT', 'M/s Mehru Elec. & Mech. Enggs. Pvt. Ltd.', 'Bhiwadi'),
('CT', 'M/s CG Power and Industrial Solution Ltd.', 'Nashik'),
('CT', 'M/s HIVOLTRANS Electricals Pvt. Ltd.', 'Halol'),
('Lightning Arrester', 'M/s CG Power and Industrial Solution Ltd.', 'Nashik'),
('Lightning Arrester', 'M/s Oblum Electrical Industries Pvt. Ltd.', 'Hyderabad'),
('Lightning Arrester', 'M/s Lamco Indust. Pvt. Ltd.', 'Hyderabad');
GO

-- ============================================
-- 5. STORED PROCEDURES FOR DATA ENTRY
-- ============================================

-- Stored Procedure to insert complete vendor application
CREATE OR ALTER PROCEDURE sp_InsertVendorApplication
    -- EPC Contractor
    @EPC_FullName NVARCHAR(200),
    -- Proposer Details
    @Proposer_FullName NVARCHAR(200),
    @Proposer_Designation NVARCHAR(100),
    @Proposer_Address NVARCHAR(500),
    @Proposer_City NVARCHAR(100),
    @Proposer_Pincode NVARCHAR(10),
    @Proposer_State NVARCHAR(100),
    @Proposer_Country NVARCHAR(100),
    @Proposer_MobileCode NVARCHAR(5),
    @Proposer_MobileNumber NVARCHAR(15),
    @Proposer_Email NVARCHAR(200),
    -- Manufacturer Details
    @Manufacturer_Category NVARCHAR(50),
    @Manufacturer_Name NVARCHAR(200),
    @Manufacturer_Website NVARCHAR(500),
    @Works_Address NVARCHAR(500),
    @Works_City NVARCHAR(100),
    @Works_State NVARCHAR(100),
    @Works_Pincode NVARCHAR(10),
    @Works_Country NVARCHAR(100),
    @PlantHead_Name NVARCHAR(200),
    @PlantHead_Designation NVARCHAR(100),
    @PlantHead_MobileCode NVARCHAR(5),
    @PlantHead_MobileNumber NVARCHAR(15),
    @PlantHead_Email NVARCHAR(200)
AS
BEGIN
    DECLARE @EPC_ID INT, @Proposer_ID INT, @Category_ID INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insert EPC Contractor
        INSERT INTO EPC_Contractor (FullName) VALUES (@EPC_FullName);
        SET @EPC_ID = SCOPE_IDENTITY();
        
        -- Insert Proposer
        INSERT INTO Proposer (EPC_ID, FullName, Designation, Address, City, Pincode, State, Country, MobileCountryCode, MobileNumber, Email)
        VALUES (@EPC_ID, @Proposer_FullName, @Proposer_Designation, @Proposer_Address, @Proposer_City, @Proposer_Pincode, @Proposer_State, @Proposer_Country, @Proposer_MobileCode, @Proposer_MobileNumber, @Proposer_Email);
        SET @Proposer_ID = SCOPE_IDENTITY();
        
        -- Get Category ID
        SELECT @Category_ID = Category_ID FROM Manufacturer_Category WHERE CategoryName = @Manufacturer_Category;
        
        -- Insert Manufacturer
        INSERT INTO Manufacturer (Proposer_ID, Category_ID, ManufacturerName, Website, WorksAddress, WorksCity, WorksState, WorksPincode, WorksCountry, PlantHeadName, PlantHeadDesignation, PlantHeadMobileCode, PlantHeadMobileNumber, PlantHeadEmail)
        VALUES (@Proposer_ID, @Category_ID, @Manufacturer_Name, @Manufacturer_Website, @Works_Address, @Works_City, @Works_State, @Works_Pincode, @Works_Country, @PlantHead_Name, @PlantHead_Designation, @PlantHead_MobileCode, @PlantHead_MobileNumber, @PlantHead_Email);
        
        COMMIT TRANSACTION;
        
        SELECT 'Application submitted successfully' AS Message, @Proposer_ID AS ProposerID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- Stored Procedure to get Approved Vendors by Item
CREATE OR ALTER PROCEDURE sp_GetApprovedVendorsByItem
    @ItemDescription NVARCHAR(200)
AS
BEGIN
    SELECT 
        ItemDescription,
        ManufacturerVendorName,
        Location
    FROM Approved_Vendor_List
    WHERE ItemDescription LIKE '%' + @ItemDescription + '%'
    ORDER BY ManufacturerVendorName;
END;
GO

-- Stored Procedure to get Complete Application Status
CREATE OR ALTER PROCEDURE sp_GetApplicationStatus
    @Proposer_ID INT
AS
BEGIN
    SELECT 
        p.FullName AS ProposerName,
        p.Email,
        p.MobileNumber,
        m.ManufacturerName,
        i.ItemName,
        i.BriefDescription,
        bs.ApprovalOrderNo,
        bs.ApprovalDate,
        ast.StatusName AS ApprovalStatus
    FROM Proposer p
    JOIN Manufacturer m ON p.Proposer_ID = m.Proposer_ID
    LEFT JOIN Item i ON m.Manufacturer_ID = i.Manufacturer_ID
    LEFT JOIN BSPTCL_Approval bs ON i.Item_ID = bs.Item_ID
    LEFT JOIN Approval_Status ast ON bs.Status_ID = ast.Status_ID
    WHERE p.Proposer_ID = @Proposer_ID;
END;
GO

-- ============================================
-- 6. USEFUL VIEWS
-- ============================================

-- View: Complete Vendor Application Summary
CREATE OR ALTER VIEW vw_CompleteVendorApplication
AS
SELECT 
    epc.FullName AS EPC_Contractor,
    p.FullName AS ProposerName,
    p.Designation,
    p.City,
    p.State,
    p.Email,
    p.MobileNumber,
    mc.CategoryName AS ManufacturerCategory,
    m.ManufacturerName,
    m.WorksCity AS ManufacturingCity,
    m.WorksState AS ManufacturingState,
    i.ItemName,
    i.BriefDescription,
    vl.VoltageValue,
    ir.RatingValue,
    ast.StatusName AS CurrentStatus
FROM EPC_Contractor epc
JOIN Proposer p ON epc.EPC_ID = p.EPC_ID
JOIN Manufacturer m ON p.Proposer_ID = m.Proposer_ID
JOIN Manufacturer_Category mc ON m.Category_ID = mc.Category_ID
LEFT JOIN Item i ON m.Manufacturer_ID = i.Manufacturer_ID
LEFT JOIN Voltage_Level vl ON i.Voltage_ID = vl.Voltage_ID
LEFT JOIN Item_Rating ir ON i.Rating_ID = ir.Rating_ID
LEFT JOIN BSPTCL_Approval ba ON i.Item_ID = ba.Item_ID
LEFT JOIN Approval_Status ast ON ba.Status_ID = ast.Status_ID;
GO

-- View: Approved Vendors Summary
CREATE OR ALTER VIEW vw_ApprovedVendorsSummary
AS
SELECT 
    ItemDescription,
    COUNT(*) AS NumberOfApprovedVendors,
    STRING_AGG(ManufacturerVendorName + ' (' + ISNULL(Location, 'N/A') + ')', '; ') AS VendorsList
FROM Approved_Vendor_List
GROUP BY ItemDescription;
GO

-- ============================================
-- 7. INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IX_Proposer_Email ON Proposer(Email);
CREATE INDEX IX_Proposer_Mobile ON Proposer(MobileNumber);
CREATE INDEX IX_Manufacturer_Name ON Manufacturer(ManufacturerName);
CREATE INDEX IX_Item_Name ON Item(ItemName);
CREATE INDEX IX_ApprovedVendor_Item ON Approved_Vendor_List(ItemDescription);
CREATE INDEX IX_NIT_Number ON NIT_Details(NIT_Number);
GO

-- ============================================
-- 8. TRIGGER FOR AUDIT LOGGING
-- ============================================

CREATE TABLE Audit_Log (
    Audit_ID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100),
    ActionPerformed NVARCHAR(50),
    RecordID INT,
    ChangedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

CREATE OR ALTER TRIGGER trg_Audit_Proposer
ON Proposer
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    INSERT INTO Audit_Log (TableName, ActionPerformed, RecordID)
    SELECT 'Proposer', 
           CASE 
               WHEN EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'UPDATE'
               WHEN EXISTS (SELECT * FROM inserted) THEN 'INSERT'
               ELSE 'DELETE'
           END,
           COALESCE(i.Proposer_ID, d.Proposer_ID)
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.Proposer_ID = d.Proposer_ID;
END;
GO

-- ============================================
-- 9. SAMPLE QUERIES FOR TESTING
-- ============================================

-- Query 1: Get all approved vendors for a specific item
SELECT * FROM vw_ApprovedVendorsSummary WHERE ItemDescription LIKE '%Conductor%';
GO

-- Query 2: Get all applications pending approval
SELECT * FROM vw_CompleteVendorApplication WHERE CurrentStatus = 'Pending';
GO

-- Query 3: Search vendor by name
SELECT * FROM Manufacturer WHERE ManufacturerName LIKE '%Sterlite%';
GO

-- Query 4: Count applications by status
SELECT ast.StatusName, COUNT(*) AS ApplicationCount
FROM BSPTCL_Approval ba
JOIN Approval_Status ast ON ba.Status_ID = ast.Status_ID
GROUP BY ast.StatusName;
GO

-- Query 5: Test the stored procedure - Insert a sample vendor application
EXEC sp_InsertVendorApplication 
    'EPC Solutions Pvt Ltd',
    'Rajesh Kumar',
    'Project Manager',
    '123, Business Park',
    'Patna',
    '800001',
    'Bihar',
    'India',
    '+91',
    '9876543210',
    'rajesh@epcsolutions.com',
    'MEDIUM',
    'ABC Electricals Ltd',
    'www.abcelectricals.com',
    'Industrial Area Phase 2',
    'Noida',
    'Uttar Pradesh',
    '201301',
    'India',
    'Sunil Sharma',
    'Plant Head',
    '+91',
    '9988776655',
    'plant@abcelectricals.com';
GO

-- Query 6: Test get approved vendors by item
EXEC sp_GetApprovedVendorsByItem 'Transformer';
GO

PRINT 'Database VendorApprovalDB created successfully!';
PRINT 'All tables, relationships, stored procedures, and views are ready.';
GO