
-- 1. 
DECLARE @Age INT = 25;
DECLARE @UserCount BIGINT = 1000000;

-- 2.
DECLARE @FirstName NVARCHAR(50) = N'Алексей';
DECLARE @CountryCode CHAR(3) = 'RUS';

-- 3. 
DECLARE @Price DECIMAL(10, 2) = 1299.99;
DECLARE @Pi FLOAT = 3.14159;

-- Вывод 
SELECT 
    @FirstName AS [Имя],
    @Age AS [Возраст],
    @CountryCode AS [Код страны],
    @Price AS [Цена, руб.],
    @Pi AS [Число Пи],
    @UserCount AS [Количество пользователей];