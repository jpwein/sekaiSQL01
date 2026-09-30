
USE master;
GO

DECLARE @OnlyTime TIME = '14:30:15.1234567';
DECLARE @OnlyDate DATE = '2026-09-09';
DECLARE @StandardDateTime DATETIME = GETDATE();
DECLARE @ExtendedDateTime2 DATETIME2 = SYSDATETIME();
DECLARE @WithOffset DATETIMEOFFSET = SYSDATETIMEOFFSET();

SELECT 
    @OnlyTime AS [TIME],
    @OnlyDate AS [DATE],
    @StandardDateTime AS [DATETIME],
    @ExtendedDateTime2 AS [DATETIME2],
    @WithOffset AS [DATETIMEOFFSET];

SELECT 
    CAST(@StandardDateTime AS VARCHAR(20)) AS [CAST DateTime -> VARCHAR],
    CAST(@StandardDateTime AS DATE) AS [CAST DateTime -> DATE],
    CAST(@ExtendedDateTime2 AS TIME) AS [CAST DateTime2 -> TIME];

SELECT 
    CONVERT(VARCHAR(20), @StandardDateTime, 104) AS [CONVERT Style 104 (dd.mm.yyyy)],
    CONVERT(VARCHAR(20), @StandardDateTime, 101) AS [CONVERT Style 101 (mm/dd/yyyy)],
    CONVERT(VARCHAR(20), @StandardDateTime, 108) AS [CONVERT Style 108 (hh:mi:ss)],
    CONVERT(VARCHAR(30), @WithOffset, 127)      AS [CONVERT Style 127 (ISO8601 с часовым поясом)];
GO