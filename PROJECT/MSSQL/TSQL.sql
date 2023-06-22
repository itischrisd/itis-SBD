-- dla zadanego numeru VIN wypisuje na konsoli listę możliwych napraw w serwisach wraz z numerami telefonów do nich
ALTER PROCEDURE LISTA_NAPRAW_DLA_POJAZDU @vin CHAR(17)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Samochod WHERE VIN = @vin)
        BEGIN
            RAISERROR ('Nie ma takiego samochodu!', 10, 1);
            RETURN;
        END
    DECLARE c_Naprawa CURSOR FOR SELECT R.Nazwa, "[AS]".Nazwa, DK.Telefon
                                 FROM RodzajNaprawy R
                                          INNER JOIN AutoryzowanySerwisRodzajNaprawy ASRN
                                                     ON R.Id = ASRN.RodzajNaprawyId
                                          INNER JOIN AutoryzowanySerwis "[AS]"
                                                     ON "[AS]".Id = ASRN.AutoryzowanySerwisId
                                          INNER JOIN AutoryzowanySerwisMarka ASM ON "[AS]".Id = ASM.AutoryzowanySerwisId
                                          INNER JOIN Marka M ON M.Id = ASM.MarkaId
                                          INNER JOIN Samochod S ON M.Id = S.MarkaId
                                          INNER JOIN Adres A ON A.Id = "[AS]".AdresId
                                          INNER JOIN DaneKontaktowe DK ON DK.Id = "[AS]".DaneKontaktoweId
                                 WHERE S.VIN = @vin;
    DECLARE @nazwaNaprawy VARCHAR(60), @nazwaSerwisu VARCHAR(30), @telefon NUMERIC(10);
    OPEN c_Naprawa;
    FETCH NEXT FROM c_Naprawa INTO @nazwaNaprawy, @nazwaSerwisu, @telefon;
    PRINT N'Dostępne naprawy dla samochodu o numerze VIN ' + @vin;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT N'Usługa ' + @nazwaNaprawy + N' możliwa w ' + @nazwaSerwisu + ' tel:' + CONVERT(VARCHAR, @telefon);
            FETCH NEXT FROM c_Naprawa INTO @nazwaNaprawy, @nazwaSerwisu, @telefon;
        END
    CLOSE c_Naprawa;
    DEALLOCATE c_Naprawa;
END
GO

-- wprowadza do bazy nowego klienta i powiąne z nim rekordy (Osoba, Adres, DaneKontaktowe)
ALTER PROCEDURE WPROWADZ_KLIENTA @imie VARCHAR(20), @nazwisko VARCHAR(50), @nazwaFirmy VARCHAR(100) = NULL,
                                 @nip NUMERIC(10) = NULL, @telefon NUMERIC(10), @email VARCHAR(50) = NULL,
                                 @ulica VARCHAR(100), @nrDomu NUMERIC(4), @nrLokalu NUMERIC(4) = NULL,
                                 @kodPocztowy CHAR(6),
                                 @miasto VARCHAR(30), @poczta VARCHAR(30) = NULL
AS
BEGIN
    INSERT INTO DaneKontaktowe (Id, Telefon, Email)
    VALUES (ISNULL((SELECT MAX(Id) + 1 FROM DaneKontaktowe), 1), @telefon, @email);
    INSERT INTO Adres (Id, Ulica, NrDomu, NrLokalu, KodPocztowy, Miasto, Poczta)
    VALUES (ISNULL((SELECT MAX(Id) + 1 FROM Adres), 1), @ulica, @nrDomu, @nrLokalu, @kodPocztowy, @miasto, @poczta);
    INSERT INTO Osoba (Id, Imie, Nazwisko, AdresId, DaneKontaktoweId)
    VALUES (ISNULL((SELECT MAX(Id) + 1 FROM Osoba), 1), @imie, @nazwisko, (SELECT MAX(Id) FROM Adres),
            (SELECT MAX(Id) FROM DaneKontaktowe));
    INSERT INTO Klient (OsobaId, NazwaFirmy, NIP)
    VALUES ((SELECT MAX(Id) FROM Osoba), @nazwaFirmy, @nip);
    PRINT 'Wprowadzono dane dla klienta ' + @imie + ' ' + @nazwisko
END
GO

-- usuwa klienta o zadanym id, dbając, by usunąć powiązane rekordy, jeśli nie są w relacji z innymi rekordami
ALTER PROCEDURE USUN_KLIENTA @id NUMERIC(10)
AS
BEGIN
    DECLARE @adresId NUMERIC(10), @daneKontaktoweId NUMERIC(10);
    SELECT @adresId = AdresId, @daneKontaktoweId = DaneKontaktoweId FROM Osoba WHERE Id = @id;
    DELETE FROM Klient WHERE OsobaId = @id;
    IF EXISTS(SELECT 1 FROM Pracownik WHERE OsobaId = @id)
        BEGIN
            PRINT 'Usunieto dane klienta o numerze ' + CONVERT(VARCHAR, @id);
            RETURN;
        END
    DELETE FROM Osoba WHERE Id = @id;
    IF (SELECT COUNT(*) FROM DaneKontaktowe WHERE Id = @daneKontaktoweId) = 1
        BEGIN
            DELETE FROM DaneKontaktowe WHERE Id = @daneKontaktoweId
        END
    IF (SELECT COUNT(*) FROM Adres WHERE Id = @adresId) = 1
        BEGIN
            DELETE FROM Adres WHERE Id = @adresId
        END
    PRINT 'Usunieto dane klienta o numerze ' + CONVERT(VARCHAR, @id);
END
GO


-- dla klienta, który dokonał więcej niż 3 transakcje, nadaje kolejnym 5% rabat
ALTER TRIGGER UPUST_STALEGO_KLIENTA
    ON KupnoSprzedaz
    FOR INSERT
    AS
    BEGIN
        DECLARE c_inserted CURSOR FOR SELECT Id, KlientId FROM inserted;
        DECLARE @id NUMERIC(10), @klientId NUMERIC(10);
        OPEN c_inserted;
        FETCH NEXT FROM c_inserted INTO @id, @klientId;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                IF (SELECT COUNT(1) FROM KupnoSprzedaz KS WHERE KS.KlientId = @klientId) > 3
                    BEGIN
                        UPDATE KupnoSprzedaz
                        SET WartoscTransakcji = WartoscTransakcji * 0.95
                        WHERE KupnoSprzedaz.Id = @id;
                    END
                FETCH NEXT FROM c_inserted INTO @id, @klientId;
            END
        CLOSE c_inserted;
        DEALLOCATE c_inserted;
    END
GO

-- w przypadku usunięcia serwisu usuwa również informacje o obsłuiwanych przez niego markach i rodzajach naprawy
ALTER TRIGGER USUWANIE_SERWISU
    ON AutoryzowanySerwis
    INSTEAD OF DELETE
    AS
    BEGIN
        DECLARE c_deleted CURSOR FOR SELECT Id FROM deleted;
        DECLARE @delId NUMERIC(10);
        OPEN c_deleted;
        FETCH NEXT FROM c_deleted INTO @delId;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                DELETE FROM AutoryzowanySerwisMarka WHERE AutoryzowanySerwisId = @delId;
                DELETE FROM AutoryzowanySerwisRodzajNaprawy WHERE AutoryzowanySerwisId = @delId;
                DELETE FROM AutoryzowanySerwis WHERE Id = @delId;
                FETCH NEXT FROM c_deleted INTO @delId;
            END
        CLOSE c_deleted;
        DEALLOCATE c_deleted;
    END
GO

-- nie pozwala wprowadzić/edytować pensji pracownika, jeśli jej wartość przekroczy pensję jego szefa
ALTER TRIGGER LIMIT_PENSJI
    ON Pracownik
    FOR INSERT, UPDATE
    AS
    BEGIN
        DECLARE c_pracownik CURSOR FOR SELECT OsobaId, PrzelozonyId FROM inserted;
        DECLARE @id NUMERIC(10), @szefId NUMERIC(10);
        OPEN c_pracownik;
        FETCH NEXT FROM c_pracownik INTO @id, @szefId;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                IF (SELECT Pensja FROM inserted WHERE OsobaId = @id) >
                   (SELECT Pensja FROM Pracownik WHERE OsobaId = @szefId)
                    BEGIN
                        RAISERROR ('Pensja pracownika przekracza pensje szefa', 10, 2);
                        IF EXISTS(SELECT 1 FROM deleted WHERE OsobaId = @id)
                            BEGIN
                                UPDATE Pracownik
                                SET Pensja = (SELECT Pensja FROM deleted WHERE OsobaId = @id)
                                WHERE OsobaId = @id;
                            END
                        ELSE
                            BEGIN
                                DELETE FROM Pracownik WHERE OsobaId = @id;
                            END
                    END
                FETCH NEXT FROM c_pracownik INTO @id, @szefId;
            END
        CLOSE c_pracownik;
        DEALLOCATE c_pracownik;
    END
GO