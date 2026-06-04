-- First, check if the database exists
SELECT name FROM sys.databases WHERE name = 'VendorApprovalDB';
GO

-- If it doesn't exist, run the full creation script again from my previous message