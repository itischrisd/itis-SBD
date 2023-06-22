CREATE TABLE Stanowisko
(
    Id       NUMERIC(10),
    Nazwa    VARCHAR(35),
    Prowizja DECIMAL(5, 2),
    CONSTRAINT PK_Stanowisko PRIMARY KEY (Id)
);

CREATE TABLE MetodaPlatnosci
(
    Id    NUMERIC(10),
    Nazwa VARCHAR(15) NOT NULL,
    CONSTRAINT PK_MetodaPlatnosci PRIMARY KEY (Id)
);

CREATE TABLE RodzajNaprawy
(
    Id    NUMERIC(10),
    Nazwa VARCHAR(60) NOT NULL,
    CONSTRAINT PK_RodzajNaprawy PRIMARY KEY (Id)
);

CREATE TABLE Marka
(
    Id    NUMERIC(10),
    Nazwa VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Marka PRIMARY KEY (Id)
);

CREATE TABLE Kraj
(
    Id    NUMERIC(10),
    Nazwa VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Kraj PRIMARY KEY (Id)
);

CREATE TABLE Adres
(
    Id          NUMERIC(10),
    Ulica       VARCHAR(100) NOT NULL,
    NrDomu      NUMERIC(4)     NOT NULL,
    NrLokalu    NUMERIC(4),
    KodPocztowy CHAR(6)       NOT NULL,
    Miasto      VARCHAR(30)  NOT NULL,
    Poczta      VARCHAR(30),
    CONSTRAINT PK_Adres PRIMARY KEY (Id)
);

CREATE TABLE DaneKontaktowe
(
    Id      NUMERIC(10),
    Telefon NUMERIC(10) NOT NULL,
    Email   VARCHAR(50),
    CONSTRAINT PK_DaneKontaktowe PRIMARY KEY (Id)
);

CREATE TABLE Osoba
(
    Id               NUMERIC(10),
    Imie             VARCHAR(20) NOT NULL,
    Nazwisko         VARCHAR(50) NOT NULL,
    AdresId          NUMERIC(10)   NOT NULL,
    DaneKontaktoweId NUMERIC(10)   NOT NULL,
    CONSTRAINT PK_Osoba PRIMARY KEY (Id),
    CONSTRAINT FK_Osoba_Adres FOREIGN KEY (AdresId) REFERENCES Adres,
    CONSTRAINT FK_Osoba_DaneKontaktowe FOREIGN KEY (DaneKontaktoweId) REFERENCES DaneKontaktowe
);

CREATE TABLE Klient
(
    OsobaId    NUMERIC(10),
    NazwaFirmy VARCHAR(100),
    NIP        NUMERIC(10),
    CONSTRAINT PK_Klient PRIMARY KEY (OsobaId),
    CONSTRAINT FK_Klient_Osoba FOREIGN KEY (OsobaId) REFERENCES Osoba
);

CREATE TABLE Pracownik
(
    OsobaId           NUMERIC(10),
    PrzelozonyId      NUMERIC(10),
    StanowiskoId      NUMERIC(10)   NOT NULL,
    DataZatrudnienia  DATE         NOT NULL,
    DataWypowiedzenia DATE,
    Pensja            DECIMAL(7, 2) NOT NULL,
    CONSTRAINT PK_Pracownik PRIMARY KEY (OsobaId),
    CONSTRAINT FK_Pracownik_Osoba FOREIGN KEY (OsobaId) REFERENCES Osoba,
    CONSTRAINT FK_Pracownik_Pracownik FOREIGN KEY (OsobaId) REFERENCES Pracownik,
    CONSTRAINT FK_Pracownik_Stanowisko FOREIGN KEY (StanowiskoId) REFERENCES Stanowisko
);

CREATE TABLE Samochod
(
    VIN             CHAR(17),
    MarkaId         NUMERIC(10)   NOT NULL,
    Model           VARCHAR(20) NOT NULL,
    KrajProdukcjiId NUMERIC(10)   NOT NULL,
    RokProdukcji    NUMERIC(4)    NOT NULL,
    Przebieg        NUMERIC(7)    NOT NULL,
    MocSilnika      NUMERIC(4)    NOT NULL,
    Kolor           VARCHAR(15) NOT NULL,
    Wycena          NUMERIC(6)    NOT NULL,
    CONSTRAINT PK_Samochod PRIMARY KEY (VIN),
    CONSTRAINT FK_Samochod_Marka FOREIGN KEY (MarkaId) REFERENCES Marka,
    CONSTRAINT FK_Samochod_Kraj FOREIGN KEY (KrajProdukcjiId) REFERENCES Kraj
);

CREATE TABLE KupnoSprzedaz
(
    Id                NUMERIC(10),
    SamochodVIN       CHAR(17)   NOT NULL,
    KlientId          NUMERIC(10) NOT NULL,
    PracownikId       NUMERIC(10) NOT NULL,
    WartoscTransakcji NUMERIC(6)  NOT NULL,
    DataKupna         DATE,
    DataSprzedazy     DATE,
    MetodaPlatnosciId NUMERIC(10) NOT NULL,
    CONSTRAINT PK_KupnoSprzedaz PRIMARY KEY (Id),
    CONSTRAINT FK_KupnoSprzedaz_Samochod FOREIGN KEY (SamochodVIN) REFERENCES Samochod,
    CONSTRAINT FK_KupnoSprzedaz_Klient FOREIGN KEY (KlientId) REFERENCES Klient,
    CONSTRAINT FK_KupnoSprzedaz_Pracownik FOREIGN KEY (PracownikId) REFERENCES Pracownik,
    CONSTRAINT FK_KupnoSprzedaz_MetodaPlatnosci FOREIGN KEY (MetodaPlatnosciId) REFERENCES MetodaPlatnosci
);

CREATE TABLE AutoryzowanySerwis
(
    Id               NUMERIC(10),
    AdresId          NUMERIC(10)   NOT NULL,
    Nazwa            VARCHAR(30) NOT NULL,
    DaneKontaktoweId NUMERIC(10)   NOT NULL,
    CONSTRAINT PK_AutoryzowanySerwis PRIMARY KEY (Id),
    CONSTRAINT FK_AutoryzowanySerwis_Adres FOREIGN KEY (AdresId) REFERENCES Adres,
    CONSTRAINT FK_AutoryzowanySerwis_DaneKontaktowe FOREIGN KEY (DaneKontaktoweId) REFERENCES DaneKontaktowe
);

CREATE TABLE AutoryzowanySerwisRodzajNaprawy
(
    AutoryzowanySerwisId NUMERIC(10) NOT NULL,
    RodzajNaprawyId      NUMERIC(10) NOT NULL,
    CONSTRAINT PK_AutoryzowanySerwisRodzajNaprawy PRIMARY KEY (AutoryzowanySerwisId, RodzajNaprawyId),
    CONSTRAINT FK_AutoryzowanySerwisRodzajNaprawy_AutoryzowanySerwis FOREIGN KEY (AutoryzowanySerwisId) REFERENCES AutoryzowanySerwis,
    CONSTRAINT FK_AutoryzowanySerwisRodzajNaprawy_RodzajNaprawy FOREIGN KEY (RodzajNaprawyId) REFERENCES RodzajNaprawy
);

CREATE TABLE AutoryzowanySerwisMarka
(
    AutoryzowanySerwisId NUMERIC(10) NOT NULL,
    MarkaId              NUMERIC(10) NOT NULL,
    CONSTRAINT PK_AutoryzowanySerwisMarka PRIMARY KEY (AutoryzowanySerwisId, MarkaId),
    CONSTRAINT FK_AutoryzowanySerwisMarka_AutoryzowanySerwis FOREIGN KEY (AutoryzowanySerwisId) REFERENCES AutoryzowanySerwis,
    CONSTRAINT FK_AutoryzowanySerwisMarka_MarkaId FOREIGN KEY (MarkaId) REFERENCES Marka
);