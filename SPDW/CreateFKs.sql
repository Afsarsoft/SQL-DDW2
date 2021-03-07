CREATE OR ALTER PROCEDURE ddw2DW.CreateFKs
AS
/***************************************************************************************************
File: CreateFKs.sql
----------------------------------------------------------------------------------------------------
Procedure:      ddw2DW.CreateFKs
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Creates FKs for all needed ddw2DW tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC ddw2DW.CreateFKs
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50)

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();
   
SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');   
RAISERROR (@Message, 0,1) WITH NOWAIT;

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table ddw2DW.FactSales.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'ddw2DW.FK_FactSales_DimCustomer_CustomerID')
  AND parent_object_id = OBJECT_ID(N'ddw2DW.FactSales')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table ddw2DW.FactSales already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE ddw2DW.FactSales
   ADD CONSTRAINT FK_FactSales_DimCustomer_CustomerID FOREIGN KEY (CustomerID)
      REFERENCES ddw2DW.DimCustomer (CustomerID),
    CONSTRAINT FK_FactSales_DimProduct_ProductID FOREIGN KEY (ProductID)
      REFERENCES ddw2DW.DimProduct (ProductID),
    CONSTRAINT FK_FactSales_DimTime_TimeKey FOREIGN KEY (TimeKey)
      REFERENCES ddw2DW.DimTime (TimeKey);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE ddw2DW.FactSales.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));    
RAISERROR(@Message, 0,1) WITH NOWAIT;

END TRY

BEGIN CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

SET @ErrorText = 'Error: '+CONVERT(VARCHAR,ISNULL(ERROR_NUMBER(),'NULL'))      
                  +', Severity = '+CONVERT(VARCHAR,ISNULL(ERROR_SEVERITY(),'NULL'))      
                  +', State = '+CONVERT(VARCHAR,ISNULL(ERROR_STATE(),'NULL'))      
                  +', Line = '+CONVERT(VARCHAR,ISNULL(ERROR_LINE(),'NULL'))      
                  +', Procedure = '+CONVERT(VARCHAR,ISNULL(ERROR_PROCEDURE(),'NULL'))      
                  +', Server Error Message = '+CONVERT(VARCHAR(100),ISNULL(ERROR_MESSAGE(),'NULL'))      
                  +', SP Defined Error Text = '+@ErrorText;

RAISERROR(@ErrorText,18,127) WITH NOWAIT;
END CATCH;      

