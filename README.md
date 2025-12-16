# yetgim-gamevault-db
"Dijital Oyun Platformu Veritabanı Tasarımı (SQL)."

# 🎮 GameVault Veritabanı Projesi (SQL Ödevi)

Bu depo, Yetgim Data-Bootcamp dersi kapsamında hazırlanan **"GameVault"** adlı dijital oyun platformu için tasarlanmış veritabanı projesini içerir.

## 🌟 Proje Amacı

Bu çalışma, geliştirici firmalar, oyunlar ve oyun türleri arasındaki ilişkileri modelleyen bir veritabanının sıfırdan oluşturulmasını, veri eklenip güncellenmesini ve bu veriler üzerinden anlamlı raporlar çekilmesini (SELECT ve JOIN) amaçlamaktadır.

## 📂 İçerik Dosyaları

| Dosya Adı | Açıklama |
| :--- | :--- |
| **`gamevault_yetgim.sql`** | Projenin ana dosyasıdır. Tüm DDL (Tablo Oluşturma), DML (Veri Ekleme/Güncelleme/Silme) ve Raporlama (SELECT/JOIN) sorgularını sırasıyla içerir. |
| **`veri tabanı diyagramı ss.png`** | Tasarlanan `GameVault` veritabanının görsel şemasını (ilişkiler, anahtarlar, tablolar) gösterir. |
| **`_Veritabanı İşlemleri.docx`** | Ödevin orijinal gereksinimlerini ve adımlarını içeren belgedir. |

## ⚙️ Uygulanan SQL Adımları

Proje, [PostgreSQL] veritabanı sistemi üzerinde uygulanmış olup, adımlar aşağıdaki sırayı takip etmektedir:

### 1. Tablo Yapısının Kurulması (DDL)

-   **4 Temel Tablo:** `developers`, `games`, `genres`, `games_genres` tabloları oluşturulmuştur.
-   **İlişkiler:**
    -   `developers` ve `games` arasında **1-to-Many** (Bire Çok) ilişki kurulmuştur.
    -   `games` ve `genres` arasında **Many-to-Many** (Çoka Çok) ilişki, `games_genres` ara tablosu kullanılarak kurulmuştur.
-   **Tutarlılık:** Tüm tablolar için `Primary Key` (Birincil Anahtar) ve ilişki sağlayan `Foreign Key` (Yabancı Anahtar) tanımlamaları yapılmıştır.
-   **Veri Bütünlüğü:** `ON DELETE CASCADE` yapısı kullanılarak, bir kayıt silindiğinde (Örn: Bir oyun), ilişkili ara tablolardaki kayıtların da otomatik silinmesi sağlanmıştır.

### 2. Veri Ekleme, Güncelleme ve Silme (DML)

-   Gereksinimlere uygun sayıda kayıt eklenmiştir (5 Geliştirici, 5 Tür, 10 Oyun).
-   Tüm oyun fiyatları **%10 indirim** uygulanarak güncellenmiştir.
-   Belirli bir oyunun puanı (rating) güncellenmiştir.
-   Bir oyun kaydı (ve ilişkili tür eşleşmeleri) veritabanından silinmiştir.

### 3. Raporlama (SELECT & JOIN)

Aşağıdaki kompleks sorgularla veritabanından bilgi çekilmiştir:

1.  Oyun adı, fiyatı ve geliştirici firmasının adını birleştiren rapor (`INNER JOIN`).
2.  Sadece belirli bir türe ait oyunları listeleyen rapor (`Many-to-Many JOIN` - 3 tablo birleşimi).
3.  Fiyat aralığına göre filtreleme ve sıralama (`WHERE` ve `ORDER BY`).
4.  Oyun adında belirli bir kelimeyi arama (`LIKE` operatörü).
