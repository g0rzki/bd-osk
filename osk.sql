CREATE SCHEMA instruktor_management;
CREATE SCHEMA kursant_management;
CREATE SCHEMA szkolenie_management;
CREATE SCHEMA pojazd_management;
CREATE SCHEMA plac_management;
CREATE SCHEMA uprawnienie_management;
CREATE SCHEMA jazda_management;
CREATE SCHEMA kursantSzkolenie_management;




CREATE TABLE instruktor_management.instruktorzy (
    id_instruktora SERIAL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(40) NOT NULL,
    telefon VARCHAR(9) NOT NULL,
    email VARCHAR(50) NOT NULL
);



CREATE TABLE kursant_management.kursanci (
    id_kursanta SERIAL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(40) NOT NULL,
    data_urodzenia DATE NOT NULL,
    telefon VARCHAR(9) NOT NULL,
    email VARCHAR(50) NOT NULL
);



CREATE TABLE szkolenie_management.szkolenia (
    id_kursu SERIAL PRIMARY KEY,
    nazwa VARCHAR(40) NOT NULL,
    cena DECIMAL NOT NULL,
    godziny INT NOT NULL
);



CREATE TABLE pojazd_management.pojazdy (
    id_pojazdu SERIAL PRIMARY KEY,
    nr_rejestracyjny VARCHAR(8) NOT NULL,
    kategoria VARCHAR(5) NOT NULL,
    rok_produkcji VARCHAR(4) NOT NULL,
    marka VARCHAR(20) NOT NULL,
    model VARCHAR(40) NOT NULL
);



CREATE TABLE plac_management.plac (
    nr_toru INT PRIMARY KEY,
    kategoria VARCHAR(5) NOT NULL,
    otwarcie TIME NOT NULL,
    zamkniecie TIME NOT NULL
);



CREATE TABLE uprawnienie_management.uprawnienia (
    id_uprawnienia SERIAL PRIMARY KEY,
    id_instruktora INT NOT NULL,
    kategoria VARCHAR(5) NOT NULL,
    FOREIGN KEY (id_instruktora) REFERENCES instruktor_management.instruktorzy(id_instruktora) ON DELETE CASCADE
);



CREATE TABLE kursantSzkolenie_management.kursanci_szkolenia (
    id_postepu SERIAL PRIMARY KEY,
    id_kursu INT NOT NULL,
    id_kursanta INT NOT NULL,
    id_instruktora INT NOT NULL,
    godziny_pozostale INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    oplacony BOOLEAN NOT NULL,
    FOREIGN KEY (id_kursu) REFERENCES szkolenie_management.szkolenia(id_kursu) ON DELETE CASCADE,
    FOREIGN KEY (id_kursanta) REFERENCES kursant_management.kursanci(id_kursanta) ON DELETE CASCADE,
    FOREIGN KEY (id_instruktora) REFERENCES instruktor_management.instruktorzy(id_instruktora) ON DELETE CASCADE
);



CREATE TABLE plac_management.rezerwacje_plac (
    id_rezerwacji SERIAL PRIMARY KEY,
    nr_toru INT NOT NULL,
    data_rezerwacji DATE NOT NULL,
    godzina_start TIME NOT NULL,
    godzina_koniec TIME NOT NULL,
    FOREIGN KEY (nr_toru) REFERENCES plac_management.plac(nr_toru) ON DELETE CASCADE
);



CREATE TABLE jazda_management.jazdy (
    id_jazdy SERIAL PRIMARY KEY,
    id_instruktora INT NOT NULL,
    id_pojazdu INT NOT NULL,
    id_kursanta INT NOT NULL,
    id_rezerwacji INT NULL,
    godzina_rozpoczecia TIMESTAMP NOT NULL,
    godzina_zakonczenia TIMESTAMP NOT NULL,
    FOREIGN KEY (id_instruktora) REFERENCES instruktor_management.instruktorzy(id_instruktora) ON DELETE CASCADE,
    FOREIGN KEY (id_pojazdu) REFERENCES pojazd_management.pojazdy(id_pojazdu) ON DELETE CASCADE,
    FOREIGN KEY (id_kursanta) REFERENCES kursant_management.kursanci(id_kursanta) ON DELETE CASCADE,
    FOREIGN KEY (id_rezerwacji) REFERENCES plac_management.rezerwacje_Plac(id_rezerwacji) ON DELETE CASCADE
);



INSERT INTO instruktor_management.instruktorzy (imie, nazwisko, telefon, email) VALUES
('Jan', 'Kowalski', '500123456', 'jan.kowalski@example.com'),
('Katarzyna', 'Nowak', '500234567', 'katarzyna.nowak@example.com'),
('Piotr', 'Wiśniewski', '500345678', 'piotr.wisniewski@example.com'),
('Anna', 'Zielińska', '500456789', 'anna.zielinska@example.com'),
('Grzegorz', 'Mazur', '500567890', 'grzegorz.mazur@example.com'),
('Sylwia', 'Dąbrowska', '500678901', 'sylwia.dabrowska@example.com'),
('Michał', 'Kamiński', '500789012', 'michal.kaminski@example.com'),
('Barbara', 'Lewandowska', '500890123', 'barbara.lewandowska@example.com'),
('Tomasz', 'Pawlak', '500901234', 'tomasz.pawlak@example.com'),
('Ewa', 'Szymańska', '500012345', 'ewa.szymanska@example.com');



INSERT INTO uprawnienie_management.uprawnienia (id_instruktora, kategoria) VALUES 
(1, 'B'),
(2, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'B'),
(5, 'B'),
(5, 'C'),
(6, 'B'),
(7, 'C'),
(7, 'D'),
(8, 'A'),
(8, 'B'),
(9, 'B'),
(10, 'D');



INSERT INTO plac_management.plac (nr_toru, kategoria, otwarcie, zamkniecie) VALUES
(1, 'B', '07:00', '17:00'),
(2, 'B', '08:00', '18:00'),
(3, 'B', '09:00', '19:00'),
(4, 'A', '09:00', '16:00'),
(5, 'C', '08:00', '15:00');



INSERT INTO szkolenie_management.szkolenia (nazwa, cena, godziny) VALUES
('B', 2000.00, 30),
('A', 1700.00, 20),
('D', 3000.00, 40),
('C', 2500.00, 35);



INSERT INTO pojazd_management.pojazdy (nr_rejestracyjny, kategoria, rok_produkcji, marka, model) VALUES
('RZC1234', 'B', '2020', 'Toyota', 'Yaris'),
('RZZ5678', 'B', '2021', 'Toyota', 'Yaris'),
('KRL4321', 'B', '2019', 'Toyota', 'Yaris'),
('RZO9876', 'B', '2018', 'Toyota', 'Yaris'),
('SK98JTU', 'B', '2023', 'Toyota', 'Yaris'),
('RZ24K5J', 'A', '2021', 'Yamaha', 'MT-07'),
('KRHU765', 'A', '2020', 'Yamaha', 'MT-03'),
('RZ930OP', 'C', '2022', 'MAN', 'TGL 12.250'),
('SK378HJ', 'D', '2023', 'Scania', 'R450');



INSERT INTO kursant_management.kursanci (imie, nazwisko, data_urodzenia, telefon, email) VALUES
('Adam', 'Kowalski', '1995-03-12', '500123456', 'adam.kowalski1@example.com'),
('Ewa', 'Nowak', '1998-05-18', '500234567', 'ewa.nowak2@example.com'),
('Michał', 'Wiśniewski', '1993-09-10', '500345678', 'michal.wisniewski3@example.com'),
('Katarzyna', 'Wójcik', '2000-01-22', '500456789', 'katarzyna.wojcik4@example.com'),
('Tomasz', 'Kamiński', '1997-07-15', '500567890', 'tomasz.kaminski5@example.com'),
('Anna', 'Lewandowska', '1999-11-02', '500678901', 'anna.lewandowska6@example.com'),
('Paweł', 'Zieliński', '1995-02-08', '500789012', 'pawel.zielinski7@example.com'),
('Magdalena', 'Szymańska', '1992-12-12', '500890123', 'magdalena.szymanska8@example.com'),
('Piotr', 'Woźniak', '1996-06-20', '500901234', 'piotr.wozniak9@example.com'),
('Joanna', 'Mazur', '1994-04-04', '501012345', 'joanna.mazur10@example.com'),
('Marcin', 'Krawczyk', '1990-08-08', '501123456', 'marcin.krawczyk11@example.com'),
('Agnieszka', 'Piotrowska', '1997-09-12', '501234567', 'agnieszka.piotrowska12@example.com'),
('Krzysztof', 'Pawlak', '1995-01-30', '501345678', 'krzysztof.pawlak13@example.com'),
('Natalia', 'Zając', '1993-10-10', '501456789', 'natalia.zajac14@example.com'),
('Mateusz', 'Kowalczyk', '2001-03-05', '501567890', 'mateusz.kowalczyk15@example.com'),
('Monika', 'Dąbrowska', '2002-07-18', '501678901', 'monika.dabrowska16@example.com'),
('Adam', 'Kamiński', '1994-06-06', '501789012', 'adam.kaminski17@example.com'),
('Ewa', 'Zielińska', '1998-02-20', '501890123', 'ewa.zielinska18@example.com'),
('Michał', 'Woźniak', '1992-11-11', '501901234', 'michal.wozniak19@example.com'),
('Katarzyna', 'Mazur', '1997-12-12', '502012345', 'katarzyna.mazur20@example.com'),
('Tomasz', 'Kamiński', '1995-02-14', '502123456', 'tomasz.kaminski21@example.com'),
('Anna', 'Lewandowska', '1993-05-19', '502234567', 'anna.lewandowska22@example.com'),
('Paweł', 'Zieliński', '1997-11-07', '502345678', 'pawel.zielinski23@example.com'),
('Magdalena', 'Szymańska', '1992-04-12', '502456789', 'magdalena.szymanska24@example.com'),
('Piotr', 'Woźniak', '1996-09-30', '502567890', 'piotr.wozniak25@example.com'),
('Joanna', 'Mazur', '1999-07-21', '502678901', 'joanna.mazur26@example.com'),
('Marcin', 'Krawczyk', '1995-08-18', '502789012', 'marcin.krawczyk27@example.com'),
('Agnieszka', 'Piotrowska', '1994-12-25', '502890123', 'agnieszka.piotrowska28@example.com'),
('Krzysztof', 'Pawlak', '1990-03-09', '502901234', 'krzysztof.pawlak29@example.com'),
('Natalia', 'Zając', '1992-06-17', '503012345', 'natalia.zajac30@example.com'),
('Mateusz', 'Kowalczyk', '1994-01-26', '503123456', 'mateusz.kowalczyk31@example.com'),
('Monika', 'Dąbrowska', '1998-03-03', '503234567', 'monika.dabrowska32@example.com'),
('Adam', 'Kamiński', '1993-10-14', '503345678', 'adam.kaminski33@example.com'),
('Ewa', 'Zielińska', '1999-11-28', '503456789', 'ewa.zielinska34@example.com'),
('Michał', 'Woźniak', '1992-05-30', '503567890', 'michal.wozniak35@example.com'),
('Katarzyna', 'Mazur', '1995-06-06', '503678901', 'katarzyna.mazur36@example.com'),
('Tomasz', 'Kowalski', '1998-09-09', '503789012', 'tomasz.kowalski37@example.com'),
('Anna', 'Wiśniewska', '1997-04-16', '503890123', 'anna.wisniewska38@example.com'),
('Paweł', 'Lewandowski', '1993-02-12', '503901234', 'pawel.lewandowski39@example.com'),
('Magdalena', 'Dąbrowska', '1999-10-25', '504012345', 'magdalena.dabrowska40@example.com'),
('Tomasz', 'Nowak', '1992-07-15', '504123456', 'tomasz.nowak41@example.com'),
('Anna', 'Kowalczyk', '1990-05-23', '504234567', 'anna.kowalczyk42@example.com'),
('Paweł', 'Wiśniewski', '1998-02-11', '504345678', 'pawel.wisniewski43@example.com'),
('Magdalena', 'Pawlak', '1993-10-09', '504456789', 'magdalena.pawlak44@example.com'),
('Piotr', 'Zieliński', '1997-01-28', '504567890', 'piotr.zielinski45@example.com'),
('Joanna', 'Wójcik', '1996-06-12', '504678901', 'joanna.wojcik46@example.com'),
('Marcin', 'Zając', '1995-03-14', '504789012', 'marcin.zajac47@example.com'),
('Agnieszka', 'Mazur', '1999-12-19', '504890123', 'agnieszka.mazur48@example.com'),
('Krzysztof', 'Kamiński', '1994-09-03', '504901234', 'krzysztof.kaminski49@example.com'),
('Natalia', 'Dąbrowska', '1995-08-25', '505012345', 'natalia.dabrowska50@example.com'),
('Mateusz', 'Kowalski', '1991-04-07', '505123456', 'mateusz.kowalski51@example.com'),
('Monika', 'Zielińska', '1993-11-11', '505234567', 'monika.zielinska52@example.com'),
('Adam', 'Woźniak', '1996-07-22', '505345678', 'adam.wozniak53@example.com'),
('Ewa', 'Lewandowska', '1992-02-18', '505456789', 'ewa.lewandowska54@example.com'),
('Michał', 'Piotrowski', '1990-10-10', '505567890', 'michal.piotrowski55@example.com'),
('Katarzyna', 'Szymańska', '1997-03-01', '505678901', 'katarzyna.szymanska56@example.com'),
('Tomasz', 'Pawlak', '1993-06-06', '505789012', 'tomasz.pawlak57@example.com'),
('Anna', 'Kamińska', '1995-12-12', '505890123', 'anna.kaminska58@example.com'),
('Paweł', 'Mazur', '1998-05-20', '505901234', 'pawel.mazur59@example.com'),
('Magdalena', 'Woźniak', '1994-01-14', '506012345', 'magdalena.wozniak60@example.com'),
('Tomasz', 'Piotrowski', '1997-07-07', '506123456', 'tomasz.piotrowski61@example.com'),
('Anna', 'Nowicka', '1992-02-22', '506234567', 'anna.nowicka62@example.com'),
('Paweł', 'Kowalski', '1995-11-15', '506345678', 'pawel.kowalski63@example.com'),
('Magdalena', 'Zielińska', '1998-01-10', '506456789', 'magdalena.zielinska64@example.com'),
('Piotr', 'Mazur', '1996-09-17', '506567890', 'piotr.mazur65@example.com'),
('Joanna', 'Kamińska', '1994-04-04', '506678901', 'joanna.kaminska66@example.com'),
('Marcin', 'Woźniak', '1993-12-25', '506789012', 'marcin.wozniak67@example.com'),
('Agnieszka', 'Dąbrowska', '1999-08-08', '506890123', 'agnieszka.dabrowska68@example.com'),
('Krzysztof', 'Lewandowski', '1990-06-14', '506901234', 'krzysztof.lewandowski69@example.com'),
('Natalia', 'Wiśniewska', '1991-05-05', '507012345', 'natalia.wisniewska70@example.com'),
('Mateusz', 'Nowak', '1998-03-03', '507123456', 'mateusz.nowak71@example.com'),
('Monika', 'Pawlak', '1995-12-12', '507234567', 'monika.pawlak72@example.com'),
('Adam', 'Szymański', '1997-07-21', '507345678', 'adam.szymanski73@example.com'),
('Ewa', 'Kamińska', '1993-04-29', '507456789', 'ewa.kaminska74@example.com'),
('Michał', 'Mazur', '1996-09-01', '507567890', 'michal.mazur75@example.com'),
('Katarzyna', 'Zając', '1992-02-16', '507678901', 'katarzyna.zajac76@example.com'),
('Tomasz', 'Nowicki', '1995-08-18', '507789012', 'tomasz.nowicki77@example.com'),
('Anna', 'Kowalczyk', '1999-01-30', '507890123', 'anna.kowalczyk78@example.com'),
('Paweł', 'Zieliński', '1994-12-09', '507901234', 'pawel.zielinski79@example.com'),
('Magdalena', 'Woźniak', '1997-11-11', '508012345', 'magdalena.wozniak80@example.com'),
('Adam', 'Zieliński', '2000-03-15', '111222333', 'adam.zielinski@example.com'),
('Ewa', 'Maj', '1998-07-22', '222333444', 'ewa.maj@example.com'),
('Tomasz', 'Lis', '2001-11-11', '333444555', 'tomasz.lis@example.com');



INSERT INTO kursantSzkolenie_management.kursanci_szkolenia (id_kursu, id_kursanta, godziny_pozostale, status, oplacony, id_instruktora) VALUES
(1, 1, 30, 'aktywny', TRUE, 1),
(1, 2, 20, 'aktywny', FALSE, 2),
(4, 3, 3, 'aktywny', TRUE, 3),
(1, 4, 35, 'aktywny', FALSE, 4),
(1, 5, 15, 'aktywny', TRUE, 1),
(2, 6, 6, 'aktywny', TRUE, 2),
(3, 7, 25, 'aktywny', FALSE, 10),
(4, 8, 20, 'aktywny', TRUE, 7),
(1, 9, 18, 'aktywny', FALSE, 5),
(2, 10, 5, 'aktywny', TRUE, 8),
(1, 11, 10, 'aktywny', TRUE, 6),
(2, 12, 15, 'aktywny', FALSE, 2),
(4, 13, 4, 'aktywny', TRUE, 3),
(3, 14, 30, 'aktywny', TRUE, 10),
(1, 15, 40, 'aktywny', FALSE, 4),
(1, 16, 0, 'ukończony', TRUE, 2),
(1, 17, 20, 'aktywny', TRUE, 5),
(1, 18, 10, 'aktywny', FALSE, 6),
(1, 19, 2, 'aktywny', TRUE, 9),
(1, 20, 5, 'aktywny', TRUE, 2),
(1, 21, 35, 'aktywny', FALSE, 4),
(1, 22, 0, 'ukończony', TRUE, 9),
(1, 23, 25, 'aktywny', TRUE, 6),
(1, 24, 30, 'aktywny', TRUE, 5),
(1, 25, 5, 'aktywny', FALSE, 6),
(1, 26, 0, 'ukończony', TRUE, 5),
(1, 27, 20, 'aktywny', TRUE, 2),
(1, 28, 15, 'aktywny', TRUE, 5),
(1, 29, 0, 'ukończony', TRUE, 6),  
(3, 30, 35, 'aktywny', FALSE, 10),
(4, 31, 10, 'aktywny', TRUE, 7),
(1, 32, 25, 'aktywny', TRUE, 9),
(2, 33, 5, 'aktywny', TRUE, 8),
(4, 34, 0, 'ukończony', TRUE, 3),
(4, 35, 30, 'aktywny', TRUE, 7),
(1, 36, 20, 'aktywny', TRUE, 5),
(2, 37, 10, 'aktywny', TRUE, 8),
(2, 38, 0, 'ukończony', FALSE, 2),
(4, 39, 15, 'aktywny', TRUE, 3),
(1, 40, 40, 'aktywny', TRUE, 4),
(3, 41, 0, 'ukończony', TRUE, 7),
(3, 42, 20, 'aktywny', FALSE, 10),
(4, 43, 10, 'aktywny', TRUE, 3),
(1, 44, 35, 'aktywny', FALSE, 6),
(2, 45, 5, 'aktywny', TRUE, 8),
(3, 46, 8, 'aktywny', TRUE, 7),
(4, 47, 25, 'aktywny', TRUE, 3),
(1, 48, 15, 'aktywny', TRUE, 1),
(1, 49, 6, 'aktywny', TRUE, 2),
(1, 50, 20, 'aktywny', FALSE, 4),
(1, 51, 40, 'aktywny', TRUE, 5),
(1, 52, 10, 'aktywny', TRUE, 6),
(1, 53, 8, 'aktywny', TRUE, 9),
(1, 54, 25, 'aktywny', FALSE, 9),
(1, 55, 5, 'aktywny', TRUE, 6),
(1, 56, 15, 'aktywny', TRUE, 5),
(1, 57, 0, 'ukończony', TRUE, 4),
(3, 58, 30, 'aktywny', TRUE, 10),
(4, 59, 35, 'aktywny', TRUE, 3),
(1, 60, 10, 'aktywny', FALSE, 4),
(2, 61, 0, 'ukończony', TRUE, 2),
(3, 62, 15, 'aktywny', TRUE, 7),
(4, 63, 25, 'aktywny', TRUE, 7),
(1, 64, 20, 'aktywny', FALSE, 1),
(2, 65, 15, 'aktywny', TRUE, 8),
(1, 66, 30, 'aktywny', TRUE, 6),
(4, 67, 35, 'aktywny', TRUE, 3),
(1, 68, 5, 'aktywny', TRUE, 1),
(1, 69, 0, 'ukończony', FALSE, 2),
(3, 70, 20, 'aktywny', TRUE, 7),
(1, 71, 15, 'aktywny', TRUE, 6),
(1, 72, 40, 'aktywny', TRUE, 1),
(2, 73, 8, 'aktywny', TRUE, 2),
(3, 74, 25, 'aktywny', FALSE, 10),
(4, 75, 10, 'aktywny', TRUE, 7),
(1, 76, 30, 'aktywny', TRUE, 9),
(2, 77, 0, 'ukończony', TRUE, 8),
(1, 78, 35, 'aktywny', FALSE, 4),
(1, 79, 20, 'aktywny', TRUE, 5),
(1, 80, 25, 'aktywny', TRUE, 6),
(1, 81, 5, 'aktywny', TRUE, 9),
(3, 82, 29, 'aktywny', FALSE, 7),
(4, 83, 15, 'aktywny', TRUE, 3);



INSERT INTO plac_management.rezerwacje_plac (nr_toru, data_rezerwacji, godzina_start, godzina_koniec) VALUES
(1, '2024-12-02', '08:00:00', '09:00:00'),
(4, '2024-12-02', '10:00:00', '11:30:00'),
(5, '2024-12-02', '12:00:00', '14:00:00'),
(3, '2024-12-02', '15:00:00', '16:30:00'),
(4, '2024-12-02', '14:00:00', '15:30:00'),
(5, '2024-12-02', '08:00:00', '09:30:00'),
(2, '2024-12-02', '13:00:00', '14:30:00'),
(3, '2024-12-10', '16:00:00', '17:30:00'),
(1, '2024-12-10', '08:00:00', '09:00:00'),
(4, '2024-12-10', '10:00:00', '11:30:00'),
(5, '2024-12-10', '12:00:00', '14:00:00'),
(5, '2024-12-10', '15:00:00', '16:30:00'),
(2, '2024-12-10', '09:00:00', '10:00:00'),
(3, '2024-12-10', '14:00:00', '15:30:00'),
(1, '2024-12-18', '08:00:00', '09:30:00'),
(2, '2024-12-20', '13:00:00', '14:30:00'),
(2, '2024-12-21', '16:00:00', '17:30:00'),
(3, '2024-12-22', '09:00:00', '10:30:00'),
(1, '2024-12-23', '11:00:00', '12:30:00'),
(2, '2024-12-24', '12:00:00', '13:30:00'),
(1, '2024-12-25', '08:00:00', '09:00:00'),
(2, '2024-12-26', '10:00:00', '11:30:00'),
(3, '2024-12-27', '14:00:00', '15:30:00'),
(3, '2024-12-28', '08:00:00', '09:30:00'),
(5, '2024-12-29', '10:00:00', '11:00:00'),
(5, '2024-12-30', '13:00:00', '14:30:00'),
(1, '2024-12-31', '15:00:00', '16:30:00'), 
(4, '2024-12-01', '08:00:00', '09:00:00'),
(5, '2024-12-02', '10:00:00', '11:30:00'),
(5, '2024-12-03', '12:00:00', '13:30:00'),
(4, '2024-12-04', '14:00:00', '15:30:00'),
(5, '2024-12-05', '08:00:00', '09:30:00'),
(3, '2024-12-06', '10:00:00', '11:30:00'),
(5, '2024-12-07', '12:00:00', '13:30:00'),
(5, '2024-12-08', '14:00:00', '15:30:00'),
(5, '2024-12-09', '08:00:00', '09:30:00'),
(1, '2024-12-10', '10:00:00', '11:30:00'),
(4, '2024-12-11', '12:00:00', '13:30:00'),
(2, '2024-12-12', '14:00:00', '15:30:00'),
(3, '2024-12-13', '08:00:00', '09:30:00'),
(2, '2024-12-14', '10:00:00', '11:30:00'),
(1, '2024-12-15', '12:00:00', '13:30:00'),
(3, '2024-12-16', '14:00:00', '15:30:00'),
(3, '2024-12-17', '08:00:00', '09:30:00'),
(2, '2024-12-18', '10:00:00', '11:30:00'),
(2, '2024-12-19', '12:00:00', '13:30:00'),
(1, '2024-12-20', '14:00:00', '15:30:00'),
(1, '2024-12-21', '08:00:00', '09:30:00'),
(5, '2024-12-22', '10:00:00', '11:30:00'),
(5, '2024-12-23', '12:00:00', '13:30:00'),
(1, '2024-12-24', '14:00:00', '15:30:00'),
(3, '2024-12-25', '08:00:00', '09:30:00'),
(4, '2024-12-26', '10:00:00', '11:30:00'),
(2, '2024-12-27', '12:00:00', '13:30:00'),
(5, '2024-12-28', '14:00:00', '15:30:00'),
(1, '2024-12-29', '08:00:00', '09:30:00'),
(2, '2024-12-30', '10:00:00', '11:30:00'),
(5, '2024-12-01', '08:00:00', '09:30:00'),
(2, '2024-12-02', '10:00:00', '11:30:00'),
(3, '2024-12-03', '12:00:00', '13:30:00'),
(4, '2024-12-04', '14:00:00', '15:30:00'),
(5, '2024-12-05', '08:00:00', '09:30:00'),
(5, '2024-12-06', '10:00:00', '11:30:00'),
(3, '2024-12-07', '12:00:00', '13:30:00'),
(4, '2024-12-08', '14:00:00', '15:30:00'),
(2, '2024-12-09', '08:00:00', '09:30:00'),
(1, '2024-12-10', '10:00:00', '11:30:00'),
(2, '2024-12-11', '12:00:00', '13:30:00'),
(3, '2024-12-12', '14:00:00', '15:30:00'),
(5, '2024-12-13', '08:00:00', '09:30:00'),
(3, '2024-12-14', '10:00:00', '11:30:00'),
(4, '2024-12-15', '12:00:00', '13:30:00'),
(2, '2024-12-16', '14:00:00', '15:30:00'),
(3, '2024-12-17', '08:00:00', '09:30:00'),
(2, '2024-12-18', '10:00:00', '11:30:00'),
(1, '2024-12-19', '12:00:00', '13:30:00'),
(5, '2024-12-20', '14:00:00', '15:30:00'),
(5, '2024-12-21', '08:00:00', '09:30:00'),
(5, '2024-12-22', '10:00:00', '11:30:00'),
(1, '2024-12-23', '12:00:00', '13:30:00');



INSERT INTO jazda_management.jazdy (id_instruktora, id_pojazdu, id_kursanta, id_rezerwacji, godzina_rozpoczecia, godzina_zakonczenia) VALUES
(1, 1, 1, 1, '2024-12-02 08:00:00', '2024-12-02 09:00:00'),
(2, 5, 2, 2, '2024-12-02 10:00:00', '2024-12-02 11:30:00'),
(3, 8, 3, 3, '2024-12-02 12:00:00', '2024-12-02 14:00:00'),
(4, 3, 4, 4, '2024-12-02 15:00:00', '2024-12-02 16:30:00'),
(1, 2, 5, NULL, '2024-12-02 09:00:00', '2024-12-02 10:00:00'),
(2, 7, 6, 5, '2024-12-02 14:00:00', '2024-12-02 15:30:00'),
(10, 9, 7, 6, '2024-12-02 08:00:00', '2024-12-02 09:30:00'),
(7, 8, 8, NULL, '2024-12-02 11:00:00', '2024-12-02 12:00:00'),
(5, 1, 9, 7, '2024-12-02 13:00:00', '2024-12-02 14:30:00'),
(8, 3, 10, 8, '2024-12-10 16:00:00', '2024-12-10 17:30:00'),
(6, 1, 11, 9, '2024-12-10 08:00:00', '2024-12-10 09:00:00'),
(2, 6, 12, 10, '2024-12-10 10:00:00', '2024-12-10 11:30:00'),
(3, 8, 13, 11, '2024-12-10 12:00:00', '2024-12-10 14:00:00'),
(10, 9, 14, 12, '2024-12-10 15:00:00', '2024-12-10 16:30:00'),
(4, 2, 15, 13, '2024-12-10 09:00:00', '2024-12-10 10:00:00'),
(2, 3, 16, 14, '2024-12-10 14:00:00', '2024-12-10 15:30:00'),
(5, 4, 17, 15, '2024-12-18 08:00:00', '2024-12-18 09:30:00'),
(6, 5, 18, NULL, '2024-12-10 11:00:00', '2024-12-10 12:00:00'),
(9, 1, 19, 16, '2024-12-20 13:00:00', '2024-12-20 14:30:00'),
(2, 3, 20, 17, '2024-12-21 16:00:00', '2024-12-21 17:30:00'),
(4, 3, 21, 18, '2024-12-22 09:00:00', '2024-12-22 10:30:00'),
(9, 2, 22, NULL, '2024-12-23 11:00:00', '2024-12-23 12:30:00'),
(6, 3, 23, 19, '2024-12-24 12:00:00', '2024-12-24 13:30:00'),
(5, 5, 24, 20, '2024-12-25 08:00:00', '2024-12-25 09:00:00'),
(6, 1, 25, 21, '2024-12-26 10:00:00', '2024-12-26 11:30:00'),
(5, 4, 26, 22, '2024-12-27 14:00:00', '2024-12-27 15:30:00'),
(2, 4, 27, 23, '2024-12-28 08:00:00', '2024-12-28 09:30:00'),
(5, 3, 28, NULL, '2024-12-29 10:00:00', '2024-12-29 11:00:00'),
(6, 1, 29, 24, '2024-12-30 13:00:00', '2024-12-30 14:30:00'),
(10, 9, 30, 25, '2024-12-31 15:00:00', '2024-12-31 16:30:00'),
(7, 8, 31, 26, '2024-12-01 08:00:00', '2024-12-01 09:00:00'),
(9, 5, 32, 27, '2024-12-02 10:00:00', '2024-12-02 11:30:00'),
(8, 6, 33, 28, '2024-12-03 12:00:00', '2024-12-03 13:30:00'),
(3, 8, 34, 29, '2024-12-04 14:00:00', '2024-12-04 15:30:00'),
(7, 8, 35, 30, '2024-12-05 08:00:00', '2024-12-05 09:30:00'), 
(5, 1, 36, NULL, '2024-12-06 12:00:00', '2024-12-06 14:00:00'),
(8, 6, 37, NULL, '2024-12-11 09:00:00', '2024-12-11 10:00:00'),
(2, 7, 38, 31, '2024-12-06 10:00:00', '2024-12-06 11:30:00'),
(3, 8, 39, 32, '2024-12-07 12:00:00', '2024-12-07 13:30:00'),
(4, 5, 40, 33, '2024-12-08 14:00:00', '2024-12-08 15:00:00'),
(7, 9, 41, 34, '2024-12-09 08:00:00', '2024-12-09 09:30:00'),
(10, 9, 42, 35, '2024-12-10 10:00:00', '2024-12-10 11:30:00'),
(3, 8, 43, 36, '2024-12-11 12:00:00', '2024-12-11 13:30:00'),
(6, 4, 44, 37, '2024-12-12 14:00:00', '2024-12-12 15:30:00'),
(8, 7, 45, 38, '2024-12-13 08:00:00', '2024-12-13 09:30:00'),
(7, 9, 46, NULL, '2024-12-26 10:00:00', '2024-12-26 11:30:00'),
(3, 8, 47, NULL, '2024-12-03 12:00:00', '2024-12-03 13:30:00'),
(1, 3, 48, 39, '2024-12-14 10:00:00', '2024-12-14 11:30:00'),
(2, 4, 49, 40, '2024-12-15 12:00:00', '2024-12-15 13:30:00'),
(4, 3, 50, 41, '2024-12-16 14:00:00', '2024-12-16 15:30:00'),
(5, 2, 51, 42, '2024-12-17 08:00:00', '2024-12-17 09:30:00'),
(6, 5, 52, 43, '2024-12-18 10:00:00', '2024-12-18 11:30:00'),
(9, 1, 53, 44, '2024-12-19 12:00:00', '2024-12-19 13:30:00'),
(9, 4, 54, 45, '2024-12-20 14:00:00', '2024-12-20 15:30:00'),
(6, 3, 55, 46, '2024-12-21 08:00:00', '2024-12-21 09:30:00'),
(5, 2, 56, 47, '2024-12-22 10:00:00', '2024-12-22 11:30:00'),
(4, 1, 57, 48, '2024-12-23 12:00:00', '2024-12-23 13:30:00'),
(10, 9, 58, 49, '2024-12-24 14:00:00', '2024-12-24 15:30:00'),
(3, 8, 59, 50, '2024-12-25 08:00:00', '2024-12-25 09:30:00'),
(4, 3, 60, 51, '2024-12-26 10:00:00', '2024-12-26 11:30:00'),
(2, 7, 61, NULL, '2024-12-06 10:00:00', '2024-12-06 11:30:00'),
(7, 9, 62, NULL, '2024-12-07 12:00:00', '2024-12-07 13:30:00'),
(7, 8, 63, NULL, '2024-12-11 12:00:00', '2024-12-11 13:30:00'),
(1, 3, 64, 52, '2024-12-27 12:00:00', '2024-12-27 13:30:00'),
(8, 7, 65, 53, '2024-12-28 14:00:00', '2024-12-28 15:00:00'),
(6, 1, 66, 54, '2024-12-29 08:00:00', '2024-12-29 09:30:00'),
(3, 8, 67, 55, '2024-12-30 10:00:00', '2024-12-30 11:30:00'),
(1, 2, 68, 56, '2024-12-01 08:00:00', '2024-12-01 09:30:00'),
(2, 3, 69, 57, '2024-12-02 10:00:00', '2024-12-02 11:30:00'),
(7, 9, 70, 58, '2024-12-03 12:00:00', '2024-12-03 13:30:00'),
(6, 2, 71, 59, '2024-12-04 14:00:00', '2024-12-04 15:30:00'),
(1, 4, 72, 60, '2024-12-05 08:00:00', '2024-12-05 09:30:00'),
(2, 6, 73, 61, '2024-12-06 10:00:00', '2024-12-06 11:30:00'),
(10, 9, 74, 62, '2024-12-07 12:00:00', '2024-12-07 13:30:00'),
(7, 8, 75, 63, '2024-12-08 14:00:00', '2024-12-08 15:30:00'),
(9, 2, 76, 64, '2024-12-09 08:00:00', '2024-12-09 09:30:00'),
(8, 7, 77, 65, '2024-12-10 10:00:00', '2024-12-10 11:30:00'),
(4, 1, 78, 66, '2024-12-11 12:00:00', '2024-12-11 13:30:00'),
(5, 2, 79, 67, '2024-12-12 14:00:00', '2024-12-12 15:30:00'),
(6, 3, 80, 68, '2024-12-13 08:00:00', '2024-12-13 09:30:00'),
(9, 4, 81, 69, '2024-12-14 10:00:00', '2024-12-14 11:30:00'),
(7, 9, 82, NULL, '2024-12-21 16:00:00', '2024-12-21 17:30:00'),
(3, 8, 83, NULL, '2024-12-22 09:00:00', '2024-12-22 10:30:00'),
(7, 8, 41, NULL, '2024-12-13 08:00:00', '2024-12-13 09:30:00'),
(10, 8, 42, NULL, '2024-12-13 10:00:00', '2024-12-13 11:30:00'),
(3, 9, 43, NULL, '2024-12-13 12:00:00', '2024-12-13 13:30:00'),
(6, 4, 44, NULL, '2024-12-13 14:00:00', '2024-12-13 15:30:00'),
(7, 8, 75, 70, '2024-12-15 12:00:00', '2024-12-15 13:30:00'),
(9, 2, 76, 71, '2024-12-16 14:00:00', '2024-12-16 15:30:00'),
(8, 7, 77, 72, '2024-12-17 08:00:00', '2024-12-17 09:30:00'),
(4, 1, 78, 73, '2024-12-18 10:00:00', '2024-12-18 11:30:00'),
(5, 2, 79, 74, '2024-12-19 12:00:00', '2024-12-19 13:30:00'),
(6, 3, 80, 75, '2024-12-20 14:00:00', '2024-12-20 15:30:00'),
(9, 4, 81, 76, '2024-12-21 08:00:00', '2024-12-21 09:30:00'),
(7, 9, 82, 77, '2024-12-22 10:00:00', '2024-12-22 11:30:00'),
(3, 8, 83, 78, '2024-12-23 12:00:00', '2024-12-23 13:30:00'),
(1, 2, 68, NULL, '2024-12-23 08:00:00', '2024-12-23 09:30:00'),
(2, 3, 69, NULL, '2024-12-23 10:00:00', '2024-12-23 11:30:00'),
(7, 8, 75, NULL, '2024-12-07 14:00:00', '2024-12-07 15:30:00'),
(9, 4, 81, NULL, '2024-12-16 10:00:00', '2024-12-16 11:30:00'),
(4, 1, 57, NULL, '2024-12-27 12:00:00', '2024-12-27 13:30:00'),
(10, 9, 58, 79, '2024-12-27 14:00:00', '2024-12-27 15:30:00'),
(3, 8, 59, NULL, '2024-12-27 08:00:00', '2024-12-27 09:30:00'),
(4, 3, 60, 80, '2024-12-29 15:00:00', '2024-12-29 16:30:00'),
(1, 3, 64, NULL, '2024-12-29 12:00:00', '2024-12-29 13:30:00'),
(8, 7, 65, NULL, '2024-12-29 11:00:00', '2024-12-29 12:00:00'),
(6, 1, 66, NULL, '2024-12-29 08:00:00', '2024-12-29 09:30:00'),
(3, 8, 67, NULL, '2024-12-30 12:00:00', '2024-12-30 14:30:00'),
(1, 2, 68, NULL, '2024-12-30 08:00:00', '2024-12-30 09:30:00'),
(2, 5, 2, NULL, '2024-12-04 09:00:00', '2024-12-04 10:30:00'),
(3, 8, 3, NULL, '2024-12-04 13:00:00', '2024-12-04 16:00:00'),
(4, 3, 4, NULL, '2024-12-04 15:00:00', '2024-12-04 16:30:00'),
(1, 2, 5, NULL, '2024-12-04 09:00:00', '2024-12-04 11:00:00'),
(2, 7, 6, NULL, '2024-12-05 14:00:00', '2024-12-05 15:30:00'),
(10, 9, 7, NULL, '2024-12-05 08:00:00', '2024-12-05 09:30:00'),
(7, 8, 8, NULL, '2024-12-05 11:00:00', '2024-12-05 12:00:00');



CREATE OR REPLACE FUNCTION instruktor_management.insert_into_instruktorzy(IN p_imie VARCHAR(20), IN p_nazwisko VARCHAR(40), IN p_telefon VARCHAR(9), IN p_email VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    INSERT INTO instruktor_management.instruktorzy (imie, nazwisko, telefon, email) VALUES (p_imie, p_nazwisko, p_telefon, p_email);
END;
$$ LANGUAGE plpgsql;
    


CREATE OR REPLACE FUNCTION instruktor_management.update_instruktorzy(IN p_id_instruktora INT, IN p_imie VARCHAR(20), IN p_nazwisko VARCHAR(40), IN p_telefon VARCHAR(9), IN p_email VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    UPDATE instruktor_management.instruktorzy SET imie = p_imie, nazwisko = p_nazwisko, telefon = p_telefon, email = p_email WHERE id_instruktora = p_id_instruktora;
    IF NOT FOUND THEN
	RAISE EXCEPTION 'Rekord o id_instruktora = % nie istnieje', p_id_instruktora;
    END IF;
END;
$$ LANGUAGE plpgsql;
    


CREATE OR REPLACE FUNCTION instruktor_management.delete_from_instruktorzy(IN p_id_instruktora INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM instruktor_management.instruktorzy WHERE id_instruktora = p_id_instruktora;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Rekord o id_instruktora = % nie istnieje', p_id_instruktora;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kursant_management.insert_into_kursanci(IN p_imie VARCHAR(20), IN p_nazwisko VARCHAR(40), IN p_data_urodzenia DATE, IN p_telefon VARCHAR(9), IN p_email VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    INSERT INTO kursant_management.kursanci (imie, nazwisko, data_urodzenia, telefon, email) VALUES (p_imie, p_nazwisko, p_data_urodzenia, p_telefon, p_email);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kursant_management.update_kursanci(IN p_id_kursanta INT, IN p_imie VARCHAR(20), IN p_nazwisko VARCHAR(40), IN p_data_urodzenia DATE, IN p_telefon VARCHAR(9), IN p_email VARCHAR(50))
RETURNS VOID AS $$
BEGIN
    UPDATE kursant_management.kursanci SET imie = p_imie, nazwisko = p_nazwisko, data_urodzenia = p_data_urodzenia, telefon = p_telefon, email = p_email WHERE id_kursanta = p_id_kursanta;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Kursant o id_kursanta = % nie istnieje', p_id_kursanta;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kursant_management.delete_from_kursanci(IN p_id_kursanta INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM kursant_management.kursanci WHERE id_kursanta = p_id_kursanta;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Kursant o id_kursanta = % nie istnieje', p_id_kursanta;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION szkolenie_management.insert_into_szkolenia(IN p_nazwa VARCHAR(40), IN p_cena DECIMAL, IN p_godziny INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO szkolenie_management.szkolenia (nazwa, cena, godziny) VALUES (p_nazwa, p_cena, p_godziny);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION szkolenie_management.update_szkolenia(IN p_id_kursu INT, IN p_nazwa VARCHAR(40), IN p_cena DECIMAL, IN p_godziny INT)
RETURNS VOID AS $$
BEGIN
    UPDATE szkolenie_management.szkolenia SET nazwa = p_nazwa, cena = p_cena, godziny = p_godziny WHERE id_kursu = p_id_kursu;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Szkolenie o id_kursu = % nie istnieje', p_id_kursu;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION szkolenie_management.delete_from_szkolenia(IN p_id_kursu INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM szkolenie_management.szkolenia WHERE id_kursu = p_id_kursu;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Szkolenie o id_kursu = % nie istnieje', p_id_kursu;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION pojazd_management.insert_into_pojazdy(IN p_nr_rejestracyjny VARCHAR(8), IN p_kategoria VARCHAR(5), IN p_rok_produkcji VARCHAR(4), IN p_marka VARCHAR(20), IN p_model VARCHAR(40))
RETURNS VOID AS $$
BEGIN
    INSERT INTO pojazd_management.pojazdy (nr_rejestracyjny, kategoria, rok_produkcji, marka, model) VALUES (p_nr_rejestracyjny, p_kategoria, p_rok_produkcji, p_marka, p_model);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION pojazd_management.update_pojazdy(IN p_id_pojazdu INT, IN p_nr_rejestracyjny VARCHAR(8), IN p_kategoria VARCHAR(5), IN p_rok_produkcji VARCHAR(4), IN p_marka VARCHAR(20), IN p_model VARCHAR(40))
RETURNS VOID AS $$
BEGIN
    UPDATE pojazd_management.pojazdy SET nr_rejestracyjny = p_nr_rejestracyjny, kategoria = p_kategoria, 
        rok_produkcji = p_rok_produkcji, marka = p_marka, model = p_model WHERE id_pojazdu = p_id_pojazdu;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Pojazd o id_pojazdu = % nie istnieje', p_id_pojazdu;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION pojazd_management.delete_from_pojazdy(IN p_id_pojazdu INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM pojazd_management.pojazdy WHERE id_pojazdu = p_id_pojazdu;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Pojazd o id_pojazdu = % nie istnieje', p_id_pojazdu;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plac_management.insert_into_plac(IN p_nr_toru INT, IN p_kategoria VARCHAR(5), IN p_otwarcie TIME, IN p_zamkniecie TIME)
RETURNS VOID AS $$
BEGIN
    INSERT INTO plac_management.plac (nr_toru, kategoria, otwarcie, zamkniecie) VALUES (p_nr_toru, p_kategoria, p_otwarcie, p_zamkniecie);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plac_management.update_plac(IN p_nr_toru INT, IN p_kategoria VARCHAR(5), IN p_otwarcie TIME, IN p_zamkniecie TIME)
RETURNS VOID AS $$
BEGIN
    UPDATE plac_management.plac SET kategoria = p_kategoria, otwarcie = p_otwarcie, zamkniecie = p_zamkniecie WHERE nr_toru = p_nr_toru;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tor o nr_toru = % nie istnieje', p_nr_toru;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plac_management.delete_from_plac(IN p_nr_toru INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM plac_management.plac WHERE nr_toru = p_nr_toru;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tor o nr_toru = % nie istnieje', p_nr_toru;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION uprawnienie_management.insert_into_uprawnienia(IN p_id_instruktora INT, IN p_kategoria VARCHAR(5))
RETURNS VOID AS $$
BEGIN
    INSERT INTO uprawnienie_management.uprawnienia (id_instruktora, kategoria) VALUES (p_id_instruktora, p_kategoria);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION uprawnienie_management.update_uprawnienia(IN p_id_uprawnienia INT, IN p_id_instruktora INT, IN p_kategoria VARCHAR(5))
RETURNS VOID AS $$
BEGIN
    UPDATE uprawnienie_management.uprawnienia SET id_instruktora = p_id_instruktora, kategoria = p_kategoria WHERE id_uprawnienia = p_id_uprawnienia;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Uprawnienie o id_uprawnienia = % nie istnieje', p_id_uprawnienia;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION uprawnienie_management.delete_from_uprawnienia(IN p_id_uprawnienia INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM uprawnienie_management.uprawnienia WHERE id_uprawnienia = p_id_uprawnienia;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Uprawnienie o id_uprawnienia = % nie istnieje', p_id_uprawnienia;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kursantSzkolenie_management.insert_into_kursanci_szkolenia(IN p_id_kursu INT, IN p_id_kursanta INT, IN p_id_instruktora INT, IN p_godziny_pozostale INT, IN p_status VARCHAR(20), IN p_oplacony BOOLEAN)
RETURNS VOID AS $$
BEGIN
    INSERT INTO kursantSzkolenia_management.kursanci_szkolenia (id_kursu, id_kursanta, id_instruktora, godziny_pozostale, status, oplacony) VALUES (p_id_kursu, p_id_kursanta, p_id_instruktora, p_godziny_pozostale, p_status, p_oplacony);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kursantSzkolenie_management.update_kursanci_szkolenia(IN p_id_postepu INT, IN p_id_kursu INT, IN p_id_kursanta INT, IN p_id_instruktora INT, IN p_godziny_pozostale INT, IN p_status VARCHAR(20), IN p_oplacony BOOLEAN)
RETURNS VOID AS $$
BEGIN
    UPDATE kursantSzkolenie_management.kursanci_szkolenia SET id_kursu = p_id_kursu, id_kursanta = p_id_kursanta, id_instruktora = p_id_instruktora, godziny_pozostale = p_godziny_pozostale, status = p_status, oplacony = p_oplacony WHERE id_postepu = p_id_postepu;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Postęp kursanta o id_postepu = % nie istnieje', p_id_postepu;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kursantSzkolenie_management.delete_from_kursanci_szkolenia(IN p_id_postepu INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM kursantSzkolenie_management.kursanci_szkolenia WHERE id_postepu = p_id_postepu;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Postęp kursanta o id_postepu = % nie istnieje', p_id_postepu;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plac_management.insert_into_rezerwacje_plac(IN p_nr_toru INT, IN p_data_rezerwacji DATE, IN p_godzina_start TIME, IN p_godzina_koniec TIME)
RETURNS VOID AS $$
BEGIN
    INSERT INTO plac_management.rezerwacje_plac (nr_toru, data_rezerwacji, godzina_start, godzina_koniec) VALUES (p_nr_toru, p_data_rezerwacji, p_godzina_start, p_godzina_koniec);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plac_management.update_rezerwacje_plac(IN p_id_rezerwacji INT, IN p_nr_toru INT, IN p_data_rezerwacji DATE, IN p_godzina_start TIME, IN p_godzina_koniec TIME)
RETURNS VOID AS $$
BEGIN
    UPDATE plac_management.rezerwacje_plac SET nr_toru = p_nr_toru, data_rezerwacji = p_data_rezerwacji, godzina_start = p_godzina_start, godzina_koniec = p_godzina_koniec WHERE id_rezerwacji = p_id_rezerwacji;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Rezerwacja o id_rezerwacji = % nie istnieje', p_id_rezerwacji;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plac_management.delete_from_rezerwacje_plac(IN p_id_rezerwacji INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM plac_management.rezerwacje_plac WHERE id_rezerwacji = p_id_rezerwacji;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Rezerwacja o id_rezerwacji = % nie istnieje', p_id_rezerwacji;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION jazda_management.insert_into_jazdy(IN p_id_instruktora INT, IN p_id_pojazdu INT, IN p_id_kursanta INT, IN p_id_rezerwacji INT, IN p_godzina_rozpoczecia TIMESTAMP, IN p_godzina_zakonczenia TIMESTAMP)
RETURNS VOID AS $$
BEGIN
    INSERT INTO jazda_management.jazdy (id_instruktora, id_pojazdu, id_kursanta, id_rezerwacji, godzina_rozpoczecia, godzina_zakonczenia) VALUES (p_id_instruktora, p_id_pojazdu, p_id_kursanta, p_id_rezerwacji, p_godzina_rozpoczecia, p_godzina_zakonczenia);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION jazda_management.update_jazdy(IN p_id_jazdy INT, IN p_id_instruktora INT, IN p_id_pojazdu INT, IN p_id_kursanta INT, IN p_id_rezerwacji INT, IN p_godzina_rozpoczecia TIMESTAMP, IN p_godzina_zakonczenia TIMESTAMP)
RETURNS VOID AS $$
BEGIN
    UPDATE jazda_management.jazdy SET id_instruktora = p_id_instruktora, id_pojazdu = p_id_pojazdu, id_kursanta = p_id_kursanta, id_rezerwacji = p_id_rezerwacji, godzina_rozpoczecia = p_godzina_rozpoczecia, godzina_zakonczenia = p_godzina_zakonczenia WHERE id_jazdy = p_id_jazdy;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Jazda o id_jazdy = % nie istnieje', p_id_jazdy;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION jazda_management.delete_from_jazdy(IN p_id_jazdy INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM jazda_management.jazdy WHERE id_jazdy = p_id_jazdy;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Jazda o id_jazdy = % nie istnieje', p_id_jazdy;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION plac_management.check_plac_availability(IN p_nr_toru INT, IN p_data_rezerwacji DATE, IN p_godzina_start TIME, IN p_godzina_koniec TIME)
RETURNS BOOLEAN AS $$
DECLARE
    conflict_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM plac_management.rezerwacje_plac WHERE nr_toru = p_nr_toru AND data_rezerwacji = p_data_rezerwacji AND ((godzina_start < p_godzina_koniec AND godzina_koniec > p_godzina_start))
    ) INTO conflict_exists;
    RETURN NOT conflict_exists;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION kursantSzkolenie_management.update_status_on_complete() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.godziny_pozostale = 0 THEN 
        UPDATE kursantSzkolenie_management.kursanci_szkolenia SET status = 'Zakończony' WHERE id_postepu = NEW.id_postepu;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trg_update_status_on_complete AFTER UPDATE ON kursantSzkolenie_management.kursanci_szkolenia
FOR EACH ROW WHEN (NEW.godziny_pozostale = 0)
EXECUTE FUNCTION kursantSzkolenie_management.update_status_on_complete();



CREATE OR REPLACE FUNCTION szkolenie_management.report_remaining_hours()
RETURNS TABLE (kurs_name VARCHAR(40), kursant_name VARCHAR(60), godziny_pozostale INT) AS $$
BEGIN
    RETURN QUERY
    SELECT s.nazwa, k.imie || ' ' || k.nazwisko, ks.godziny_pozostale FROM kursanci_szkolenia ks JOIN kursanci k ON ks.id_kursanta = k.id_kursanta JOIN szkolenia s ON ks.id_kursu = s.id_kursu;
END;
$$ LANGUAGE plpgsql;





-- zapisywanie na kurs 
CREATE OR REPLACE FUNCTION zapisz_na_kurs(
    p_imie_kursanta VARCHAR(20),
    p_nazwisko_kursanta VARCHAR(40),
    p_data_urodzenia DATE,
    p_telefon VARCHAR(9),
    p_email VARCHAR(50),
    p_kategoria VARCHAR(40),
    p_imie_instruktora VARCHAR(20),
    p_nazwisko_instruktora VARCHAR(40),
    p_oplacony BOOLEAN
)
RETURNS VOID AS $$
DECLARE
    v_id_kursanta INT;
    v_id_instruktora INT;
    v_id_kategorii VARCHAR(5);
    v_instruktor_ma_uprawnienia BOOLEAN;
    v_instruktorzy_z_uprawnieniami TEXT[];
BEGIN
    
    SELECT id_kursanta INTO v_id_kursanta
    FROM kursant_management.kursanci
    WHERE imie = p_imie_kursanta AND nazwisko = p_nazwisko_kursanta;

    IF v_id_kursanta IS NULL THEN
        INSERT INTO kursant_management.kursanci (imie, nazwisko, data_urodzenia, telefon, email)
        VALUES (p_imie_kursanta, p_nazwisko_kursanta, p_data_urodzenia, p_telefon, p_email)
        RETURNING id_kursanta INTO v_id_kursanta;
    END IF;



    IF NOT EXISTS (SELECT 1 FROM szkolenie_management.szkolenia WHERE nazwa = p_kategoria) THEN
        RAISE EXCEPTION 'Kategoria % nie istnieje', p_kategoria;
    END IF;
    v_id_kategorii := p_kategoria;



    SELECT id_instruktora INTO v_id_instruktora
    FROM instruktor_management.instruktorzy
    WHERE imie = p_imie_instruktora AND nazwisko = p_nazwisko_instruktora;

    IF v_id_instruktora IS NULL THEN
        RAISE EXCEPTION 'Instruktor % % nie istnieje', p_imie_instruktora, p_nazwisko_instruktora;
    END IF;



    SELECT EXISTS (
        SELECT 1 FROM uprawnienie_management.uprawnienia
        WHERE id_instruktora = v_id_instruktora AND kategoria = v_id_kategorii
    ) INTO v_instruktor_ma_uprawnienia;

    IF NOT v_instruktor_ma_uprawnienia THEN
        SELECT ARRAY_AGG(i.imie || ' ' || i.nazwisko)
        INTO v_instruktorzy_z_uprawnieniami
        FROM instruktor_management.instruktorzy i
        JOIN uprawnienie_management.uprawnienia u ON i.id_instruktora = u.id_instruktora
        WHERE u.kategoria = v_id_kategorii;

        RAISE EXCEPTION 'Instruktor % % nie ma uprawnień na kategorię %. Dostępni instruktorzy: %',
            p_imie_instruktora, p_nazwisko_instruktora, v_id_kategorii, v_instruktorzy_z_uprawnieniami;
    END IF;



    INSERT INTO kursantSzkolenie_management.kursanci_szkolenia (
        id_kursu,
        id_kursanta,
        id_instruktora,
        godziny_pozostale,
        status,
        oplacony
    )
    VALUES (
        (SELECT id_kursu FROM szkolenie_management.szkolenia WHERE nazwa = v_id_kategorii LIMIT 1),
        v_id_kursanta,
        v_id_instruktora,
        (SELECT godziny FROM szkolenie_management.szkolenia WHERE nazwa = v_id_kategorii LIMIT 1),
        'aktywny',
        p_oplacony
    );
END;
$$ LANGUAGE plpgsql;





-- dostepnosc torow na placu
CREATE OR REPLACE FUNCTION sprawdz_dostepnosc_torow(
    p_kategoria VARCHAR(5),
    p_data DATE,
    p_godzina TIME
)
RETURNS TABLE (
    nr_toru INT,
    status TEXT
) AS $$
DECLARE
    dostepne_tory RECORD;
BEGIN
    
    FOR dostepne_tory IN
        SELECT p.nr_toru
        FROM plac_management.plac p
        WHERE p.kategoria = p_kategoria
          AND p.otwarcie <= p_godzina
          AND p.zamkniecie > p_godzina
          AND NOT EXISTS (
              SELECT 1
              FROM plac_management.rezerwacje_plac r
              WHERE r.nr_toru = p.nr_toru
                AND r.data_rezerwacji = p_data
                AND r.godzina_start <= p_godzina
                AND r.godzina_koniec > p_godzina
          )
    LOOP
        RETURN QUERY SELECT dostepne_tory.nr_toru, 'Dostępny' AS status;
    END LOOP;

    
    IF NOT FOUND THEN
        FOR dostepne_tory IN
            SELECT DISTINCT r.data_rezerwacji, r.nr_toru
            FROM plac_management.rezerwacje_plac r
            JOIN plac p ON r.nr_toru = p.nr_toru
            WHERE p.kategoria = p_kategoria
            ORDER BY r.data_rezerwacji ASC
        LOOP
            RETURN QUERY SELECT dostepne_tory.nr_toru, 'Dostępny w innym terminie' AS status;
        END LOOP;
    END IF;
END;
$$ LANGUAGE plpgsql;



-- raport o zdajacym
CREATE OR REPLACE FUNCTION kursant_management.raport_kursanta(IN p_id_kursanta INT)
RETURNS TABLE (
    kursant_imie VARCHAR(20),
    kursant_nazwisko VARCHAR(40),
    kursant_telefon VARCHAR(9),
    kursant_email VARCHAR(50),
    godziny_pozostale INT,
    jazda_data TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        k.imie AS kursant_imie,
        k.nazwisko AS kursant_nazwisko,
        k.telefon AS kursant_telefon,
        k.email AS kursant_email,
        ks.godziny_pozostale,
        j.godzina_rozpoczecia AS jazda_data
    FROM 
        kursant_management.kursanci k
    INNER JOIN 
        kursantSzkolenie_management.kursanci_szkolenia ks 
        ON k.id_kursanta = ks.id_kursanta
    LEFT JOIN 
        jazda_management.jazdy j 
        ON k.id_kursanta = j.id_kursanta
    WHERE 
        k.id_kursanta = p_id_kursanta;
END;
$$ LANGUAGE plpgsql;



-- sprawdza dostępność pojazdu zwraca false/true
CREATE OR REPLACE FUNCTION dostepnosc_pojazdu(
    IN p_id_pojazdu INT,
    IN p_start_time TIMESTAMP,
    IN p_end_time TIMESTAMP
) RETURNS BOOLEAN AS $$
DECLARE
    conflict_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM jazda_management.jazdy 
        WHERE id_pojazdu = p_id_pojazdu 
        AND ((p_start_time < godzina_zakonczenia AND p_end_time > godzina_rozpoczecia))
    ) INTO conflict_exists;
    RETURN NOT conflict_exists;
END;
$$ LANGUAGE plpgsql;



-- po jeździe odejmuje godziny pozostałe
CREATE OR REPLACE FUNCTION kursantSzkolenie_management.update_godziny_pozostale()
RETURNS VOID AS $$
BEGIN
    UPDATE kursantSzkolenie_management.kursanci_szkolenia ks
    SET godziny_pozostale = ks.godziny_pozostale - subquery.godziny_przejechane
    FROM (
        SELECT 
            j.id_kursanta,
            SUM(EXTRACT(EPOCH FROM (j.godzina_zakonczenia - j.godzina_rozpoczecia)) / 3600) AS godziny_przejechane
        FROM jazda_management.jazdy j
        GROUP BY j.id_kursanta
    ) subquery
    WHERE ks.id_kursanta = subquery.id_kursanta
      AND ks.godziny_pozostale > 0; 
END;
$$ LANGUAGE plpgsql;



-- ilość godzin przepracowanych w miesiacu przez instruktora
CREATE OR REPLACE FUNCTION instruktor_management.suma_godzin_instruktora_w_miesiacu(
    p_id_instruktora INT,
    p_rok INT,
    p_miesiac INT
)
RETURNS DECIMAL AS $$
DECLARE
    v_suma_godzin DECIMAL;
BEGIN
    miesiącu
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (godzina_zakonczenia - godzina_rozpoczecia)) / 3600), 0)
    INTO v_suma_godzin
    FROM jazda_management.jazdy
    WHERE id_instruktora = p_id_instruktora
      AND EXTRACT(YEAR FROM godzina_rozpoczecia) = p_rok
      AND EXTRACT(MONTH FROM godzina_rozpoczecia) = p_miesiac;

      RETURN v_suma_godzin;
END;
$$ LANGUAGE plpgsql;


-- przez ile godzin był uzywany dany tor na placu w miesiącu
CREATE OR REPLACE FUNCTION plac_management.licz_godziny_uzycia_toru_w_miesiacu(
    p_nr_toru INT, 
    p_miesiac INT, 
    p_rok INT
)
RETURNS INT AS $$
DECLARE
    v_godziny_uzycia INT := 0;
BEGIN

    SELECT SUM(EXTRACT(EPOCH FROM (j.godzina_zakonczenia - j.godzina_rozpoczecia)) / 3600) 
    INTO v_godziny_uzycia
    FROM jazda_management.jazdy j
    JOIN plac_management.rezerwacje_plac r ON j.id_rezerwacji = r.id_rezerwacji
    WHERE r.nr_toru = p_nr_toru
      AND EXTRACT(MONTH FROM r.data_rezerwacji) = p_miesiac
      AND EXTRACT(YEAR FROM r.data_rezerwacji) = p_rok;
    
    RETURN COALESCE(v_godziny_uzycia, 0);
END;
$$ LANGUAGE plpgsql;



-- KURSORY
DECLARE instr_cursor CURSOR FOR
SELECT * FROM instruktor_management.instruktorzy;


DECLARE kursant_cursor CURSOR FOR
SELECT * FROM kursant_management.kursanci;

DECLARE jazdy_cursor CURSOR FOR
SELECT * FROM jazda_management.jazdy;

DECLARE kurs_szkol_cursor CURSOR FOR
SELECT * FROM kursantSzkolenie_management.kursanci_szkolenia;

DECLARE plac_cursor CURSOR FOR
SELECT * FROM plac_management.plac;


DECLARE rezerwacje_plac_cursor CURSOR FOR
SELECT * FROM plac_management.rezerwacje_plac;


DECLARE pojazdy_cursor CURSOR FOR
SELECT * FROM pojazd_management.pojazdy;

DECLARE szkolenia_cursor CURSOR FOR
SELECT * FROM szkolenie_management.szkolenia;

DECLARE uprawnienia_cursor CURSOR FOR
SELECT * FROM uprawnienie_management.uprawnienia;


DECLARE kursant_cursor_kurs CURSOR FOR
SELECT k.id_kursanta, k.imie, k.nazwisko 
FROM kursant_management.kursanci k
JOIN kursantSzkolenie_management.kursanci_szkolenia ks ON k.id_kursanta = ks.id_kursanta
WHERE ks.id_kursu = 1;


DECLARE completed_cursor CURSOR FOR
SELECT ks.id_kursanta, ks.status 
FROM kursantSzkolenie_management.kursanci_szkolenia ks 
WHERE ks.status = 'Ukończono';


