# OSK - Ośrodek Szkolenia Kierowców

Projekt wykonany w ramach zajęć uczelnianych.

System wspierający zarządzanie ośrodkiem szkolenia kierowców. Umożliwia rejestrację kursantów, przypisywanie ich do kursów oraz przeglądanie danych administracyjnych.

## 🛠 Stack technologiczny

- **Język**: PHP (czysty, bez frameworków)
- **Baza danych**: PostgreSQL
- **Serwer lokalny**: XAMPP (Apache)
- **Frontend**: HTML + CSS

## 🧩 Funkcje aplikacji

- Rejestracja nowych kursantów
- Tworzenie i zarządzanie kursami
- Harmonogram zajęć (przydzielanie instruktorów)
- Przeglądanie danych i raportów
- Automatyczne zapisywanie powiązań w bazie (np. kursant ↔ kurs)

## 🚀 Uruchamianie lokalne (Windows)

1. **Sklonuj repozytorium:**
   - Pobierz ZIP z GitHuba lub użyj Git GUI, np. GitHub Desktop.

2. **Wgraj projekt do XAMPP:**
   - Rozpakuj folder projektu i umieść go w katalogu `htdocs`, np. `C:\xampp\htdocs\external_access`.

3. **Utwórz bazę danych:**
   - Uruchom pgAdmin lub inny interfejs PostgreSQL.
   - Stwórz nową bazę danych o nazwie `osk`.
   - Zaimportuj plik `osk.sql` znajdujący się w folderze:
     - W pgAdmin: kliknij prawym na bazę → **Restore** lub **Query Tool**, wklej zawartość `osk.sql` i uruchom.

4. **Skonfiguruj połączenie z bazą w `config.php`:**
   ```php
   $host = 'localhost';
   $port = '5432';
   $dbname = 'osk';
   $user = 'postgres';
   $password = 'twoje_haslo';

5. **Uruchom XAMPP:**
   Włącz Apache i upewnij się, że PostgreSQL działa.

6. **Otwórz przeglądarkę i wpisz:**
   http://localhost/external_access

## 👥 Autorzy
   - [Piotrek] (https://github.com/g0rzki) – logika aplikacji, backend, połączenia z bazą, operacje CRUD, automatyzacja powiązań
     
   - [Julia] (https://github.com/julchm) – analiza wymagań, modelowanie danych, projekt diagramów ERD i przypadków użycia, przygotowanie dokumentacji technicznej oraz współtworzenie struktury bazy danych
    
## 📜 Licencja
   Projekt dostępny na licencji MIT – możesz go swobodnie modyfikować i rozwijać.
