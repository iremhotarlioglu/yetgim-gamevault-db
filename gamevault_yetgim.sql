-- 1 .BÖLÜM TABLOLARIN OLUŞTURMASI
--İlişkiler (FOREIGN KEY) ve veri tipleri tanımlanmıştır.

-- 1. developers (Geliştiriciler) Tablosu
CREATE TABLE developers (
id SERIAL NOT NULL, 
company_name VARCHAR(100) NOT NULL, 
country VARCHAR(50), 
founded_year INTEGER 
);

ALTER TABLE developers
ADD PRIMARY KEY (id);

-- 2. games (Oyunlar) Tablosu
-- developer_id: developers tablosuna bağlanacak (one-to-Many ilişki). 
CREATE TABLE games (
id SERIAL NOT NULL, 
title VARCHAR(200) NOT NULL, 
price DECIMAL(10, 2) NOT NULL DEFAULT 0.00, 
release_date DATE,
rating DECIMAL(3, 1), 
developer_id INTEGER NOT NULL
);

ALTER TABLE games
ADD PRIMARY KEY (id);

ALTER TABLE games
ADD CONSTRAINT games_developer_fk
FOREIGN KEY (developer_id)
REFERENCES developers(id);

-- 3. genres (Türler) Tablosu
CREATE TABLE genres (
    id SERIAL NOT NULL,
    name VARCHAR(50) NOT NULL, 
    description TEXT 
);

ALTER TABLE genres
ADD PRIMARY KEY (id);

-- 4. games_genres (Ara Tablo - Many to Many)
-- game_id: Hangi oyun? (Foreign Key) 
-- genre_id: Hangi tür? (Foreign Key) 
-- Bir oyun birden çok türe, bir tür birden çok oyuna ait olabilir. 
CREATE TABLE games_genres (
    id SERIAL NOT NULL,
    game_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
);

ALTER TABLE games_genres
ADD PRIMARY KEY (id);

ALTER TABLE games_genres
ADD CONSTRAINT games_genres_game_fk
FOREIGN KEY (game_id) REFERENCES games(id)
ON DELETE CASCADE;

ALTER TABLE games_genres
ADD CONSTRAINT games_genres_genre_fk
FOREIGN KEY (genre_id) REFERENCES genres(id)
ON DELETE CASCADE;


-- 2. BÖLÜM: VERİ EKLEME (DML -INSERT)
-- İstenen 5 Geliştirici, 5 Tür, 10 Oyun ve Many-to-Many eşleştirmeleri eklenmiştir.

-- Geliştirici Ekleme (5 Adet) 
INSERT INTO developers (company_name, country, founded_year) VALUES
('CD Projekt Red', 'Poland', 2002),
('Rockstar Games', 'USA', 1998),
('Bethesda Game Studios', 'USA', 2001),
('FromSoftware', 'Japan', 1986),
('Ubisoft Montreal', 'Canada', 1997);

-- Tür Ekleme (5 Adet) 
INSERT INTO genres (name, description) VALUES
('RPG', 'Role-Playing Game'),
('Open World', 'Geniş keşfedilebilir dünyaya sahip oyunlar.'),
('Horror', 'Korku ve gerilim temalı oyunlar.'),
('FPS', 'First-Person Shooter'),
('Action', 'Hızlı tempolu dövüş ve aksiyon içeren oyunlar.');

-- Oyun Ekleme (10 Adet) 
INSERT INTO games (title, price, release_date, rating, developer_id) VALUES
('The Witcher 3: Wild Hunt', 699.00, '2015-05-19', 9.2, 1),
('Cyberpunk 2077', 899.00, '2020-12-10', 8.4, 1),
('Red Dead Redemption 2', 999.00, '2018-10-26', 9.7, 2),
('Grand Theft Auto V', 199.00, '2013-09-17', 9.5, 2),
('The Elder Scrolls V: Skyrim', 149.00, '2011-11-11', 9.3, 3),
('Fallout 4', 249.00, '2015-11-10', 8.7, 3),
('Elden Ring', 799.00, '2022-02-25', 9.6, 4),
('Dark Souls III', 599.00, '2016-03-24', 9.1, 4),
('Assassin''s Creed Valhalla', 349.00, '2020-11-10', 8.2, 5),
('Far Cry 6', 499.00, '2021-10-07', 7.9, 5);

-- Oyun ve Tür Eşleştirmesi (games_genres) 
INSERT INTO games_genres (game_id, genre_id) VALUES
(1, 1), (1, 2), -- The Witcher 3: RPG, Open World
(2, 1), (2, 4), -- Cyberpunk 2077: RPG, FPS
(3, 2), (3, 5), -- Red Dead Redemption 2: Open World, Action
(4, 5), (4, 2), -- Grand Theft Auto V: Action, Open World
(5, 1), (5, 2), -- Skyrim: RPG, Open World
(7, 1), (7, 2), -- Elden Ring: RPG, Open World
(8, 1), (8, 5), -- Dark Souls III: RPG, Action
(9, 5), (9, 2), -- AC Valhalla: Action, Open World
(10, 4), (10, 5), -- Far Cry 6: FPS, Action
(6, 1), (6, 5); -- Fallout 4: RPG, Action


select * from developers
select * from games
select * from genres
select * from games_genres


-- 3. BÖLÜM: GÜNCELLEME VE SİLME (UPDATE / DELETE)
-- İndirim Zamanı: Tüm oyunların fiyatını %10 düşürür.
UPDATE games
SET price = price * 0.90;
-- Sorgu sonucu: Fiyatlar başarıyla güncellendi.

-- Hata Düzeltme: Grand Theft Auto V'in rating'ini 9.8 olarak günceller. (9.5, 9.8'e değişecek.)
UPDATE games 
SET rating = 9.8 
WHERE title = 'Grand Theft Auto V';
-- Sorgu sonucu: 1 kayıt güncellendi.

-- Kaldırma: "Far Cry 6" oyununu games tablosundan siler.
-- games_genres tablosundaki ilgili kayıtlar, FOREIGN KEY'deki ON DELETE CASCADE sayesinde otomatik silinir.
DELETE FROM games 
WHERE title = 'Far Cry 6';
-- Sorgu sonucu: 1 oyun kaydı silindi ve games_genres tablosundaki 2 eşleştirme kaydı silindi.


-- 4. BÖLÜM: RAPORLAMA (SELECT & JOIN)
-- İstenen raporları çeken sorgular.

-- SORGU 1: Tüm Oyunlar Listesi (Oyun Adı, Fiyatı, Geliştirici Firmanın Adı)
SELECT
    games.title 
    games.price 
    developers.company_name 
FROM games 
INNER JOIN developers ON games.developer_id = developers.id;


-- SORGU 2: Sadece "RPG" Türündeki Oyunların adı ve puanını:
SELECT
   games.title,
    games.rating
FROM games 
INNER JOIN games_genres 
ON games.id = games_genres.game_id -- Oyunları ara tablo ile birleştir.
INNER JOIN genres
ON games_genres.genre_id = genres.id  -- Ara tabloyu türler tablosu ile birleştir
WHERE genres.name = 'RPG';


-- SORGU 3: Fiyatı 500 TL Üzerinde Olan Oyunlar (Pahalıdan Ucuza)
SELECT title, price
FROM games
WHERE price > 500.00
ORDER BY price DESC;


-- SORGU 4: İçinde "War" Kelimesi Geçen Oyunlar
SELECT title, release_date 
FROM games
WHERE title LIKE '%War%' OR title LIKE '%war%';

-- DOSYA SONU
