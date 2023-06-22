-- dla zadanego numeru VIN wypisuje na konsoli listę możliwych napraw w serwisach wraz z numerami telefonów do nich
CREATE OR REPLACE PROCEDURE LISTA_NAPRAW_DLA_POJAZDU(v_vin CHAR)
AS
    v_count   NUMBER;
    CURSOR c_naprawa IS SELECT R.Nazwa, AS1.Nazwa Serwis, DK.Telefon
                        FROM RodzajNaprawy R
                                 INNER JOIN AutoryzowanySerwisRodzajNaprawy ASRN
                                            ON R.Id = ASRN.RodzajNaprawyId
                                 INNER JOIN AutoryzowanySerwis AS1
                                            ON AS1.Id = ASRN.AutoryzowanySerwisId
                                 INNER JOIN AutoryzowanySerwisMarka ASM ON AS1.Id = ASM.AutoryzowanySerwisId
                                 INNER JOIN Marka M ON M.Id = ASM.MarkaId
                                 INNER JOIN Samochod S ON M.Id = S.MarkaId
                                 INNER JOIN Adres A ON A.Id = AS1.AdresId
                                 INNER JOIN DaneKontaktowe DK ON DK.Id = AS1.DaneKontaktoweId
                        WHERE S.VIN = v_vin;
    r_naprawa C_NAPRAWA%ROWTYPE;
BEGIN
    SELECT COUNT(1) INTO v_count FROM Samochod WHERE VIN = v_vin;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20500, 'Nie ma takiego samochodu!');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Dostępne naprawy dla samochodu o numerze VIN ' || v_vin);
    OPEN c_naprawa;
    LOOP
        FETCH c_naprawa INTO r_naprawa;
        EXIT WHEN c_naprawa%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Usługa ' || r_naprawa.NAZWA || ' możliwa w ' || r_naprawa.Serwis || ' tel:' ||
                             r_naprawa.TELEFON);
    END LOOP;
    CLOSE c_naprawa;
END;


CALL LISTA_NAPRAW_DLA_POJAZDU('15GCD0911K1031583');
CALL LISTA_NAPRAW_DLA_POJAZDU('aaa');


-- wprowadza do bazy nowego klienta i powiąne z nim rekordy (Osoba, Adres, DaneKontaktowe)
CREATE OR REPLACE PROCEDURE WPROWADZ_KLIENTA(v_imie VARCHAR,
                                             v_nazwisko VARCHAR,
                                             v_telefon NUMERIC,
                                             v_ulica VARCHAR,
                                             v_nrDomu NUMERIC,
                                             v_kodPocztowy CHAR,
                                             v_miasto VARCHAR,
                                             v_nazwaFirmy VARCHAR DEFAULT NULL,
                                             v_nip NUMERIC DEFAULT NULL,
                                             v_email VARCHAR DEFAULT NULL,
                                             v_nrLokalu NUMERIC DEFAULT NULL,
                                             v_poczta VARCHAR DEFAULT NULL)
AS
BEGIN
    INSERT INTO DaneKontaktowe (ID, Telefon, Email)
    VALUES (NVL((SELECT MAX(ID) + 1 FROM DaneKontaktowe), 1), v_telefon, v_email);
    INSERT INTO Adres (Id, Ulica, NrDomu, NrLokalu, KodPocztowy, Miasto, Poczta)
    VALUES (NVL((SELECT MAX(Id) + 1 FROM Adres), 1), v_ulica, v_nrDomu, v_nrLokalu, v_kodPocztowy, v_miasto,
            v_poczta);
    INSERT INTO Osoba (Id, Imie, Nazwisko, AdresId, DaneKontaktoweId)
    VALUES (NVL((SELECT MAX(Id) + 1 FROM Osoba), 1), v_imie, v_nazwisko, (SELECT MAX(Id) FROM Adres),
            (SELECT MAX(Id) FROM DaneKontaktowe));
    INSERT INTO Klient (OsobaId, NazwaFirmy, NIP)
    VALUES ((SELECT MAX(Id) FROM Osoba), v_nazwaFirmy, v_nip);
    DBMS_OUTPUT.PUT_LINE('Wprowadzono dane dla klienta ' || v_imie || ' ' || v_nazwisko);
END;

CALL WPROWADZ_KLIENTA('Adas',
                      'Niezgodka',
                      700600500,
                      'Kwiatowa',
                      5,
                      '02-123',
                      'Pacanowo',
                      'Akademia Pana Kleksa',
                      1234567890,
                      'adas@akademia.pl',
                      23,
                      'Szczeboszyce');

SELECT *
FROM Osoba O
         INNER JOIN Klient K ON O.Id = K.OsobaId
         INNER JOIN DaneKontaktowe DK ON DK.Id = O.DaneKontaktoweId
         INNER JOIN Adres A ON A.Id = O.AdresId
WHERE O.Imie = 'Adas'
  AND O.Nazwisko = 'Niezgodka';

CALL WPROWADZ_KLIENTA('Hans',
                      'Kloss',
                      700600500,
                      'Polonische Strasse',
                      5,
                      '02-137',
                      'Hamburg');

SELECT *
FROM Osoba O
         INNER JOIN Klient K ON O.Id = K.OsobaId
         INNER JOIN DaneKontaktowe DK ON DK.Id = O.DaneKontaktoweId
         INNER JOIN Adres A ON A.Id = O.AdresId
WHERE O.Imie = 'Hans'
  AND O.Nazwisko = 'Kloss';

-- usuwa klienta o zadanym id, dbając, by usunąć powiązane rekordy, jeśli nie są w relacji z innymi rekordami
CREATE OR REPLACE PROCEDURE USUN_KLIENTA(v_id NUMERIC)
AS
    v_adresId             NUMERIC;
    v_daneKontaktoweId    NUMERIC;
    v_countPracownik      NUMERIC;
    v_countDaneKontaktowe NUMERIC;
    v_countAdres          NUMERIC;
BEGIN
    SELECT DaneKontaktoweId INTO v_daneKontaktoweId FROM Osoba WHERE Id = v_id;
    SELECT AdresId INTO v_adresId FROM Osoba WHERE Id = v_id;
    DELETE FROM Klient WHERE OsobaId = v_id;
    SELECT COUNT(1) INTO v_countPracownik FROM Pracownik WHERE OsobaId = v_id;
    IF v_countPracownik > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Usunieto dane klienta o numerze ' || v_id);
        RETURN;
    END IF;
    DELETE FROM Osoba WHERE Id = v_id;
    SELECT COUNT(1) INTO v_countDaneKontaktowe FROM DaneKontaktowe WHERE Id = v_daneKontaktoweId;
    IF v_countDaneKontaktowe = 1 THEN
        DELETE FROM DaneKontaktowe WHERE Id = v_daneKontaktoweId;
    END IF;
    SELECT COUNT(1) INTO v_countAdres FROM Adres WHERE Id = v_adresId;
    IF v_countAdres = 1 THEN
        DELETE FROM Adres WHERE Id = v_adresId;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Usunieto dane klienta o numerze ' || v_id);
END;

CALL USUN_KLIENTA(401);

-- dla klienta, który dokonał więcej niż 3 transakcje, nadaje kolejnym 5% rabat
CREATE OR REPLACE TRIGGER UPUST_STALEGO_KLIENTA
    BEFORE INSERT
    ON KupnoSprzedaz
    FOR EACH ROW
DECLARE
    v_countKlientId NUMERIC;
BEGIN
    SELECT COUNT(1) INTO v_countKlientId FROM KUPNOSPRZEDAZ WHERE KLIENTID = :NEW.KlientId;
    IF v_countKlientId > 3 THEN
        :NEW.WartoscTransakcji := :NEW.WartoscTransakcji * 0.95;
    END IF;
END;

SELECT COUNT(*), KlientId
FROM KupnoSprzedaz
GROUP BY KlientId;

INSERT INTO KupnoSprzedaz
VALUES (1609, '1G6DP1E38C0114115', 217, 124, 10000, NULL, SYSDATE, 3);

SELECT *
FROM KupnoSprzedaz
WHERE Id = 1609;

-- w przypadku usunięcia serwisu usuwa również informacje o obsłuiwanych przez niego markach i rodzajach naprawy
CREATE OR REPLACE TRIGGER USUWANIE_SERWISU
    BEFORE DELETE
    ON AutoryzowanySerwis
    FOR EACH ROW
BEGIN
    DELETE FROM AutoryzowanySerwisMarka WHERE AutoryzowanySerwisId = :OLD.Id;
    DELETE FROM AutoryzowanySerwisRodzajNaprawy WHERE AutoryzowanySerwisId = :OLD.Id;
END;

SELECT COUNT(1)
FROM AutoryzowanySerwis
WHERE Id = 100
UNION
SELECT COUNT(1)
FROM AutoryzowanySerwisMarka
WHERE AutoryzowanySerwisId = 100
UNION
SELECT COUNT(1)
FROM AutoryzowanySerwisRodzajNaprawy
WHERE AutoryzowanySerwisId = 100;

DELETE
FROM AutoryzowanySerwis
WHERE Id = 100;

-- nie pozwala wprowadzić/edytować pensji pracownika, jeśli wykracza poza zakres 1000-25000
CREATE OR REPLACE TRIGGER LIMIT_PENSJI
    BEFORE INSERT OR UPDATE
    ON Pracownik
    FOR EACH ROW
DECLARE
    v_minPensja NUMERIC := 1000;
    v_maxPensja NUMERIC := 25000;
BEGIN
    IF :NEW.Pensja > v_maxPensja THEN
        DBMS_OUTPUT.PUT_LINE('Pensja pracownika ' || :NEW.OsobaId || ' przekracza maksymalną pensję');
    ELSIF :NEW.Pensja < v_minPensja THEN
        DBMS_OUTPUT.PUT_LINE('Pensja pracownika ' || :NEW.OsobaId || ' jest mniejsza od minimalnej pensji');
    ELSE
        RETURN;
    END IF;
    IF INSERTING THEN
        raise_application_error(-20500, 'Pensja poza zakresem');
    ELSIF UPDATING THEN
        :NEW.Pensja := :OLD.Pensja;
    END IF;
END;

SELECT P1.OsobaId, P1.Pensja
FROM Pracownik P1
WHERE P1.OSOBAID = 31;

UPDATE Pracownik
SET Pensja = 500.00
WHERE OsobaId = 31;
