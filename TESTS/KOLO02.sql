-- 1. Stwórz procedurę, która przyjmuje jako parametr nazwę produktu. Procedura ta powinna wyliczać ile razy dany produkt
-- został sprzedany. Liczba sprzedaży powinna zostać zwrócona jako parametr typu OUTPUT (Pojedyncza sprzedaż liczy się raz,
-- niezależnie w jakiej ilości został produkt sprzedany). (2p)

CREATE PROCEDURE zad1 @nazwa VARCHAR(20),
                      @ilosc INT = 0 OUTPUT
AS
BEGIN
    SELECT @ilosc = COUNT(*)
    FROM PRODUKT p
             INNER JOIN SPRZEDAZ s ON p.ID_PRODUKT = s.ID_PRODUKT
    WHERE p.NAZWA = @nazwa;
END
GO

-- 2. Stwórz wyzwalacz, który nie pozwoli wykonać operacji UPDATE, jeśli modyfikowany jest jakiś klient, który coś kupował. (2p)

CREATE TRIGGER zad2
    ON KLIENT
    FOR UPDATE
    AS
BEGIN
    IF EXISTS(SELECT i.ID_KLIENT
              FROM inserted i
                       INNER JOIN SPRZEDAZ s ON i.ID_KLIENT = s.ID_KLIENT)
        BEGIN
            ROLLBACK;
        END
END
GO


-- 3. Stwórz procedurę, która jako parametr przyjmuje nazwę miasta. Wszyscy pracownicy, którzy są do niego przypisani powinni
-- otrzymać jako swoje miasto wartość NULL. Następnie należy usunąć podane miasto. Jeśli podane miasto nie istnieje, należy wypisać komunikat. (2p)

CREATE PROCEDURE zad3 @miasto VARCHAR(20)
AS
BEGIN
    DECLARE @id_miasto INT;
    SELECT @id_miasto = ID_MIASTO FROM MIASTO WHERE MIASTO = @miasto;
    IF @id_miasto IS NULL
        BEGIN
            PRINT 'Nie ma takiego miasta!';
        END
    ELSE
        BEGIN
            UPDATE PRACOWNIK SET ID_MIASTO = NULL WHERE ID_MIASTO = @id_miasto;
            DELETE FROM MIASTO WHERE ID_MIASTO = @id_miasto;
        END
END
GO

-- 4. Stwórz wyzwalacz, który nie pozwoli na wpisanie produktów o nazwach już istniejących. Wyzwalacz powinien zablokować
-- jedynie niepoprawnie wpisywane produkty. (2p)

CREATE TRIGGER zad4
    ON PRODUKT
    FOR INSERT
    AS
BEGIN
    DECLARE kursor CURSOR FOR SELECT NAZWA, ID_PRODUKT FROM inserted;
    DECLARE @nazwa VARCHAR(20), @id INT;
    OPEN kursor;
    FETCH NEXT FROM kursor INTO @nazwa, @id;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            IF (SELECT COUNT(NAZWA) FROM PRODUKT WHERE NAZWA = @nazwa) > 1
                BEGIN
                    DELETE FROM PRODUKT WHERE ID_PRODUKT = @id;
                END
            FETCH NEXT FROM kursor INTO @nazwa, @id;
        END
    CLOSE kursor;
    DEALLOCATE kursor;
END
GO

-- 5. Stwórz procedurę, która przyjmie jako parametry nazwę produktu oraz nazwę kategorii. Następnie podany produkt powinien
-- zostać przypisany do danej kategorii. Jeśli nie istnieje jeszcze taki produkt i/lub kategoria to zostaną wcześniej utworzone.
-- W przypadku konieczności utworzenia produktu, jego cena powinna być równa średniej cenie wszystkich produktów. (2p)

CREATE PROCEDURE zad5 @produkt VARCHAR(20), @kategoria VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS(SELECT ID_KATEGORIA FROM KATEGORIA WHERE KATEGORIA = @kategoria)
        BEGIN
            INSERT INTO KATEGORIA
            VALUES ((SELECT MAX(ID_KATEGORIA) + 1 FROM KATEGORIA), @kategoria);
        END
    IF NOT EXISTS(SELECT ID_PRODUKT FROM PRODUKT WHERE NAZWA = @produkt)
        BEGIN
            INSERT INTO PRODUKT
            VALUES ((SELECT MAX(ID_PRODUKT) + 1 FROM PRODUKT), @produkt, (SELECT AVG(CENA) FROM PRODUKT),
                    (SELECT ID_KATEGORIA FROM KATEGORIA WHERE KATEGORIA = @kategoria));
        END
    ELSE
        BEGIN
            UPDATE PRODUKT
            SET ID_KATEGORIA = (SELECT ID_KATEGORIA FROM KATEGORIA WHERE KATEGORIA = @kategoria)
            WHERE NAZWA = @produkt;
        END
END
GO