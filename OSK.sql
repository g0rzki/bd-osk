CREATE TABLE Instruktorzy (
    id_instruktora SERIAL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(40) NOT NULL,
    telefon VARCHAR(9) NOT NULL,
    email VARCHAR(50) NOT NULL,
    uprawnienia VARCHAR(20) NOT NULL
);

CREATE TABLE Kursanci (
    id_kursanta SERIAL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(40) NOT NULL,
    data_urodzenia DATE NOT NULL,
    telefon VARCHAR(9) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE Szkolenia (
    id_kursu SERIAL PRIMARY KEY,
    nazwa VARCHAR(40) NOT NULL,
    cena DECIMAL NOT NULL,
    godziny INT NOT NULL
);

CREATE TABLE Pojazdy (
    id_pojazdu SERIAL PRIMARY KEY,
    nr_rejestracyjny VARCHAR(8) NOT NULL,
    kategoria VARCHAR(5) NOT NULL,
    rok_produkcji VARCHAR(4) NOT NULL,
    marka VARCHAR(20) NOT NULL,
    model VARCHAR(40) NOT NULL
);

CREATE TABLE Plac (
    nr_toru INT PRIMARY KEY,
    kategoria VARCHAR(5) NOT NULL,
    otwarcie TIME NOT NULL,
    zamkniecie TIME NOT NULL
);

CREATE TABLE Uprawnienia (
    id_uprawnienia SERIAL PRIMARY KEY,
    id_instruktora INT NOT NULL,
    kategoria VARCHAR(5) NOT NULL,
    FOREIGN KEY (id_instruktora) REFERENCES Instruktorzy(id_instruktora)
);

CREATE TABLE Kursanci_Szkolenia (
    id_postepu SERIAL PRIMARY KEY,
    id_kursu INT NOT NULL,
    id_kursanta INT NOT NULL,
    godziny_pozostale INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    oplacony BOOLEAN NOT NULL,
    id_instruktora INT NOT NULL,
    FOREIGN KEY (id_kursu) REFERENCES Szkolenia(id_kursu),
    FOREIGN KEY (id_kursanta) REFERENCES Kursanci(id_kursanta),
    FOREIGN KEY (id_instruktora) REFERENCES Instruktorzy(id_instruktora)
);

CREATE TABLE Rezerwacje_Plac (
    id_rezerwacji SERIAL PRIMARY KEY,
    nr_toru INT NOT NULL,
    data_rezerwacji DATE NOT NULL,
    godzina_start TIME NOT NULL,
    godzina_koniec TIME NOT NULL,
    FOREIGN KEY (nr_toru) REFERENCES Plac(nr_toru)
);

CREATE TABLE Jazdy (
    id_jazdy SERIAL PRIMARY KEY,
    id_instruktora INT NOT NULL,
    id_pojazdu INT NOT NULL,
    id_kursanta INT NOT NULL,
    id_rezerwacji INT,
    godzina_rozpoczecia TIMESTAMP NOT NULL,
    godzina_zakonczenia TIMESTAMP NOT NULL,
    FOREIGN KEY (id_instruktora) REFERENCES Instruktorzy(id_instruktora),
    FOREIGN KEY (id_pojazdu) REFERENCES Pojazdy(id_pojazdu),
    FOREIGN KEY (id_kursanta) REFERENCES Kursanci(id_kursanta),
    FOREIGN KEY (id_rezerwacji) REFERENCES Rezerwacje_Plac(id_rezerwacji)
);