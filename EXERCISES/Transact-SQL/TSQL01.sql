-- 1. Napisz prosty program w Transact-SQL. Zadeklaruj zmienną, przypisz na tą zmienną liczbę rekordów w tabeli Emp (lub
-- jakiejkolwiek innej) i wypisz uzyskany wynik używając instrukcji PRINT, w postaci napisu np. "W tabeli jest 10 osób".

DECLARE @zmienna VARCHAR(3)
SELECT @zmienna = COUNT(*)
FROM EMP
PRINT 'W tabeli jest ' + @zmienna + ' osob'
GO


-- 2. Używając Transact-SQL, policz liczbę pracowników z tabeli EMP. Jeśli liczba jest mniejsza niż 16, wstaw pracownika
-- Kowalskiego i wypisz komunikat. W przeciwnym przypadku wypisz komunikat informujący o tym, że nie wstawiono danych.


IF (SELECT COUNT(*)
    FROM EMP) < 16
    BEGIN
        INSERT INTO EMP VALUES (1255, 'Kowalski', 'SALESMAN', NULL, CONVERT(DATETIME, '17-DEC-1980'), 1000, NULL, 1)
        PRINT 'Wstawiono Kowalskiego'
    END
ELSE
    BEGIN
        PRINT 'Nie wstawiono danych'
    END
GO


-- 3. Napisz procedurę zwracającą pracowników, którzy zarabiają więcej niż wartość zadana parametrem procedury.

CREATE PROCEDURE GREATER_SAL @salary INT
AS
BEGIN
    SELECT * FROM EMP WHERE SAL > @salary
END
GO

EXECUTE GREATER_SAL 1500
GO


-- 4. Napisz procedurę służącą do wstawiania działów do tabeli Dept. Procedura będzie pobierać jako parametry:
-- nr_działu, nazwę i lokalizację. Należy sprawdzić, czy dział o takiej nazwie lub lokalizacji już istnieje. Jeżeli
-- istnieje, to nie wstawiamy nowego rekordu.

ALTER PROCEDURE INSERT_DEPT @nr_dzialu INT, @nazwa VARCHAR(20), @lokalizacja VARCHAR(20)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DEPT WHERE DNAME = @nazwa OR LOC = @lokalizacja)
        BEGIN
            PRINT 'Taki dzial juz istnieje'
        END
    ELSE
        BEGIN
            INSERT INTO DEPT VALUES (@nr_dzialu, @nazwa, @lokalizacja)
        END
END
GO

EXECUTE INSERT_DEPT 5, 'TESTIN', 'LUBLIN'
GO


-- 5. Napisz procedurę umożliwiającą użytkownikowi wprowadzanie nowych pracowników do tabeli EMP. Jako parametry
-- będziemy podawać nazwisko i nr działu zatrudnianego pracownika. Procedura powinna wprowadzając nowy rekord sprawdzić,
-- czy wprowadzany dział istnieje (jeżeli nie, to należy zgłosić błąd) oraz obliczyć mu pensję równą minimalnemu
-- zarobkowi w tym dziale. EMPNO nowego pracownika powinno zostać wyliczone jako najwyższa istniejąca wartość w tabeli + 1.

ALTER PROCEDURE INSERT_EMP @nazwisko VARCHAR(20), @nr_dzialu INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM DEPT WHERE DEPTNO = @nr_dzialu)
        BEGIN
            PRINT 'Nie ma takiego dzialu'
        END
    ELSE
        BEGIN
            INSERT INTO EMP
            VALUES ((SELECT MAX(EMPNO) + 1 FROM EMP), @nazwisko, NULL, NULL, GETDATE(),
                    (SELECT MIN(SAL) FROM EMP WHERE DEPTNO = @nr_dzialu), NULL, @nr_dzialu)
            PRINT 'Wprowadzono nowego pracownika'
        END
END
GO

EXECUTE INSERT_EMP 'MICHAIL', 35
GO