USE ShopDB;
GO

-- Добавление записей в таблицу Products
INSERT INTO Products (ProductName, Category, Price, Rating, IsAvailable)
VALUES 
    (N'Ноутбук Lenovo', 'Electronics', 55000.50, 4.8, 1),
    (N'Беспроводная мышь', 'Electronics', 1250.00, 4.5, 1),
    (N'Клавиатура механическая', 'Electronics', 3499.99, 4.2, 0),
    (N'Кофейная кружка', 'Home', 450.00, 4.9, 1);
GO

-- Проверка внесенных данных
SELECT * FROM Products;
GO