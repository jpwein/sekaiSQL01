USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SteamDB')
BEGIN
    CREATE DATABASE SteamDB;
END
GO

USE SteamDB;
GO


-- Таблица 1
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    WalletBalance DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (WalletBalance >= 0), 
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()                                 
);

-- Таблица 2: 

CREATE TABLE UserProfiles (
    ProfileID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE, 
    RealName NVARCHAR(100) NULL,
    Bio NVARCHAR(MAX) NULL,
    AvatarUrl VARCHAR(255) NULL,
    Level INT NOT NULL DEFAULT 1 CHECK (Level >= 1),                              
    CONSTRAINT FK_UserProfiles_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Таблица 3
CREATE TABLE Publishers (
    PublisherID INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName NVARCHAR(100) NOT NULL,
    Country VARCHAR(50) NULL,
    Website VARCHAR(150) NULL
);

-- Таблица 4
CREATE TABLE Games (
    GameID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(150) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (Price >= 0),              
    ReleaseDate DATE NOT NULL,
    PublisherID INT NOT NULL,
    CONSTRAINT FK_Games_Publishers FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);

-- Таблица 5
CREATE TABLE Genres (
    GenreID INT IDENTITY(1,1) PRIMARY KEY,
    GenreName NVARCHAR(50) NOT NULL UNIQUE
);

-- Таблица 6
CREATE TABLE GameGenres (
    GameID INT NOT NULL,
    GenreID INT NOT NULL,
    PRIMARY KEY (GameID, GenreID),
    CONSTRAINT FK_GameGenres_Games FOREIGN KEY (GameID) REFERENCES Games(GameID),
    CONSTRAINT FK_GameGenres_Genres FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);

-- Таблица 7
CREATE TABLE UserGames (
    UserID INT NOT NULL,
    GameID INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT GETDATE(),
    PlayTimeHours INT NOT NULL DEFAULT 0 CHECK (PlayTimeHours >= 0),
    PRIMARY KEY (UserID, GameID),
    CONSTRAINT FK_UserGames_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_UserGames_Games FOREIGN KEY (GameID) REFERENCES Games(GameID)
);

-- Таблица 8
CREATE TABLE Achievements (
    AchievementID INT IDENTITY(1,1) PRIMARY KEY,
    GameID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    CONSTRAINT FK_Achievements_Games FOREIGN KEY (GameID) REFERENCES Games(GameID)
);

-- Таблица 9
CREATE TABLE UserAchievements (
    UserID INT NOT NULL,
    AchievementID INT NOT NULL,
    UnlockedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (UserID, AchievementID),
    CONSTRAINT FK_UserAchievements_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_UserAchievements_Achievements FOREIGN KEY (AchievementID) REFERENCES Achievements(AchievementID)
);

-- Таблица 10
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    GameID INT NOT NULL,
    ReviewText NVARCHAR(MAX) NULL,
    IsRecommended BIT NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reviews_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Reviews_Games FOREIGN KEY (GameID) REFERENCES Games(GameID)
);
GO

-- 1. Users
INSERT INTO Users (Username, Email, WalletBalance) VALUES
('GamerPro', 'gamerpro@mail.com', 1500.00),
('ShadowNinja', 'shadow@mail.com', 350.50),
('PixelQueen', 'pixel@mail.com', 0.00),
('DragonSlayer', 'dragon@mail.com', 5000.00),
('CyberSamurai', 'cyber@mail.com', 120.00);

-- 2. UserProfiles 
INSERT INTO UserProfiles (UserID, RealName, Bio, Level) VALUES
(1, N'Иван Петров', N'Люблю RPG и стратегии', 15),
(2, N'Алексей Сидоров', N'Pro Gamer', 8),
(3, N'Елена Смирнова', N'Streamer & Designer', 42),
(4, N'Михаил Орлов', N'Hardcore player', 25),
(5, N'Дмитрий Волков', N'No bio...', 3);

-- 3. Publishers
INSERT INTO Publishers (PublisherName, Country, Website) VALUES
('Valve', 'USA', 'https://valvesoftware.com'),
('CD Projekt Red', 'Poland', 'https://cdprojektred.com'),
('Capcom', 'Japan', 'https://capcom.com'),
('Ubisoft', 'France', 'https://ubisoft.com'),
('Bethesda Softworks', 'USA', 'https://bethesda.net');

-- 4. Games
INSERT INTO Games (Title, Price, ReleaseDate, PublisherID) VALUES
('Counter-Strike 2', 0.00, '2023-09-27', 1),
('Dota 2', 0.00, '2013-07-09', 1),
('Cyberpunk 2077', 1999.00, '2020-12-10', 2),
('The Witcher 3: Wild Hunt', 1499.00, '2015-05-18', 2),
('Resident Evil 4', 2499.00, '2023-03-24', 3);

-- 5. Genres
INSERT INTO Genres (GenreName) VALUES
(N'Шутер'),
(N'MOBA'),
(N'RPG'),
(N'Открытый мир'),
(N'Horror');

-- 6. GameGenres 
INSERT INTO GameGenres (GameID, GenreID) VALUES
(1, 1), -- CS2 -> Шутер
(2, 2), -- Dota 2 -> MOBA
(3, 3), -- Cyberpunk -> RPG
(3, 4), -- Cyberpunk -> Открытый мир
(4, 3), -- Witcher 3 -> RPG
(4, 4), -- Witcher 3 -> Открытый мир
(5, 5); -- RE4 -> Horror

-- 7. UserGames 
INSERT INTO UserGames (UserID, GameID, PlayTimeHours) VALUES
(1, 1, 350),
(1, 3, 80),
(2, 2, 1200),
(3, 4, 150),
(4, 3, 210),
(5, 5, 25);

-- 8. Achievements
INSERT INTO Achievements (GameID, Title, Description) VALUES
(1, N'Первая кровь', N'Сделайте первое убийство в CS2'),
(2, N'Победа в турнире', N'Выиграйте матч в Dota 2'),
(3, N'Добро пожаловать в Найт-Сити', N'Завершите пролог'),
(4, N'Дикая Охота', N'Пройдите игру на любой сложности'),
(5, N'Выживший', N'Завершите 1 главу в RE4');

-- 9. UserAchievements 
INSERT INTO UserAchievements (UserID, AchievementID) VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 4),
(4, 3),
(4, 4);

-- 10. Reviews
INSERT INTO Reviews (UserID, GameID, ReviewText, IsRecommended) VALUES
(1, 1, N'Отличный обновленный шутер!', 1),
(1, 3, N'Шедевральный сюжет и визуал.', 1),
(2, 2, N'Сложная игра, но затягивает.', 1),
(3, 4, N'Лучшая RPG всех времен!', 1),
(5, 5, N'Очень страшная и атмосферная.', 1);
GO

-- Проверки

SELECT G.GameID, G.Title, G.Price, P.PublisherName 
FROM Games G
JOIN Publishers P ON G.PublisherID = P.PublisherID;

SELECT U.Username, U.Email, P.RealName, P.Level 
FROM Users U
JOIN UserProfiles P ON U.UserID = P.UserID;

SELECT U.Username, G.Title, UG.PlayTimeHours, UG.PurchaseDate
FROM UserGames UG
JOIN Users U ON UG.UserID = U.UserID
JOIN Games G ON UG.GameID = G.GameID;
GO
