-- Run this first
USE VendorApprovalDB;
GO

-- Then run this
SELECT * FROM vw_ApprovedVendorsSummary;
GO

-- Then run this
EXEC sp_GetApprovedVendorsByItem 'Transformer';
GO