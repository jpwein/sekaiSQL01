USE ShopDB;
GO

PRINT '         1. ПРОВЕРКА КОЛИЧЕСТВА И СПИСКА ТАБЛИЦ В БАЗЕ ДАННЫХ';

SELECT 
    t.name AS [Имя таблицы],
    t.create_date AS [Дата создания],
    COUNT(c.column_id) AS [Количество столбцов]
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
GROUP BY t.name, t.create_date
ORDER BY t.name;

SELECT COUNT(*) AS [Всего пользовательских таблиц] 
FROM sys.tables;
GO

PRINT '         2. ПРОВЕРКА ИНДЕКСОВ И ИХ ТИПОВ ПО ВСЕМ ТАБЛИЦАМ';

SELECT 
    t.name AS [Таблица],
    i.name AS [Название индекса],
    i.type_desc AS [Тип индекса],
    i.is_unique AS [Уникальный],
    i.has_filter AS [Фильтрованный]
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.type > 0 
ORDER BY t.name, i.type;
GO

PRINT '         3. ПРОВЕРКА РАСПРЕДЕЛЕНИЯ ТАБЛИЦ ПО ФАЙЛОВЫМ ГРУППАМ';

SELECT 
    t.name AS [Таблица],
    fg.name AS [Файловая группа],
    f.name AS [Имя файла],
    f.physical_name AS [Физический путь к файлу]
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id AND (i.index_id = 0 OR i.index_id = 1)
JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id
JOIN sys.database_files f ON fg.data_space_id = f.data_space_id
ORDER BY fg.name, t.name;
GO

PRINT '         4. ФОРМИРОВАНИЕ И ПРОВЕРКА ОТЧЕТОВ БАЗЫ ДАННЫХ';

-- Отчет 1: Количество строк в каждой таблице
SELECT 
    t.name AS [Таблица],
    SUM(p.rows) AS [Количество строк]
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY [Количество строк] DESC;

-- Отчет 2: Сводные данные по продажам
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SalesOrders')
BEGIN
    SELECT 
        FORMAT(OrderDate, 'yyyy-MM') AS [Месяц],
        COUNT(SalesOrderID) AS [Всего заказов],
        SUM(TotalDue) AS [Общая сумма продаж],
        AVG(TotalDue) AS [Средний чек]
    FROM dbo.SalesOrders
    GROUP BY FORMAT(OrderDate, 'yyyy-MM')
    ORDER BY [Месяц] DESC;
END
GO