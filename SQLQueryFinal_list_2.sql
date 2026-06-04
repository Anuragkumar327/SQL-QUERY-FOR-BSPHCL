-- First, make sure you're using the correct database
USE VendorApprovalDB;
GO

-- Check all tables created
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Check all stored procedures
SELECT name FROM sys.procedures;
GO

-- Check all views
SELECT name FROM sys.views;
GO

-- Test: View all approved vendors summary
SELECT * FROM vw_ApprovedVendorsSummary;
GO

-- Test: Search for specific items
EXEC sp_GetApprovedVendorsByItem 'Transformer';
GO

-- Test: Search for cable vendors
EXEC sp_GetApprovedVendorsByItem 'Cable';
GO

-- Check manufacturer categories
SELECT * FROM Manufacturer_Category;
GO

-- Check voltage levels
SELECT * FROM Voltage_Level;
GO

-- Check approval status types
SELECT * FROM Approval_Status;
GO