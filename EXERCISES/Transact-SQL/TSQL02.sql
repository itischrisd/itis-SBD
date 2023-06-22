-- 1. Przy pomocy kursora przejrzyj wszystkich pracowników i zmodyfikuj wynagrodzenia tak, aby osoby zarabiające mniej
-- niż 1000 miały zwiększone wynagrodzenie o 10%, natomiast osoby zarabiające powyżej 1500 miały zmniejszone
-- wynagrodzenie o 10%. Wypisz na ekran każdą wprowadzoną zmianę.

DECLARE
    SalMod CURSOR FOR SELECT EMPNO, SAL
                      FROM EMP;
DECLARE @empno INT, @salary INT;
OPEN SalMod;
FETCH NEXT FROM SalMod INTO @empno, @salary;
WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @salary < 1000
            BEGIN
                UPDATE EMP SET SAL = @salary * 1.1 WHERE EMPNO = @empno;
                PRINT 'Dla pracownika o numerze ' + CONVERT(VARCHAR, @empno) + ' podniesiono pensje do ' +
                      CONVERT(VARCHAR, (@salary * 1.1));
            END
        IF @salary > 1500
            BEGIN
                UPDATE EMP SET SAL = @salary * 0.9 WHERE EMPNO = @empno;
                PRINT 'Dla pracownika o numerze ' + CONVERT(VARCHAR, @empno) + ' obnizono pensje do ' +
                      CONVERT(VARCHAR, (@salary * 0.9));
            END
        FETCH NEXT FROM SalMod INTO @empno, @salary;
    END
CLOSE SalMod;
DEALLOCATE SalMod;
GO


-- 2. Przerób kod z zadania 1 na procedurę tak, aby wartości zarobków (1000 i 1500) nie były stałe, tylko były parametrami procedury.

ALTER PROCEDURE MODIFY_SALARY @to_rise INT, @to_lower INT
AS
BEGIN
    DECLARE
        SalMod CURSOR FOR SELECT EMPNO, SAL
                          FROM EMP;
    DECLARE @empno INT, @salary INT;
    OPEN SalMod;
    FETCH NEXT FROM SalMod INTO @empno, @salary;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            IF @salary < @to_rise
                BEGIN
                    UPDATE EMP SET SAL = @salary * 1.1 WHERE EMPNO = @empno;
                    PRINT 'Dla pracownika o numerze ' + CONVERT(VARCHAR, @empno) + ' podniesiono pensje do ' +
                          CONVERT(VARCHAR, (@salary * 1.1));
                END
            IF @salary > @to_lower
                BEGIN
                    UPDATE EMP SET SAL = @salary * 0.9 WHERE EMPNO = @empno;
                    PRINT 'Dla pracownika o numerze ' + CONVERT(VARCHAR, @empno) + ' obnizono pensje do ' +
                          CONVERT(VARCHAR, (@salary * 0.9));
                END
            FETCH NEXT FROM SalMod INTO @empno, @salary;
        END
    CLOSE SalMod;
    DEALLOCATE SalMod;
END
GO

EXECUTE MODIFY_SALARY 900, 4000
GO


-- 3. W procedurze sprawdź średnią wartość zarobków z tabeli EMP z działu określonego parametrem procedury. Następnie
-- należy dać prowizję (comm) tym pracownikom tego działu, którzy zarabiają poniżej średniej. Prowizja powinna wynosić
-- 5% ich miesięcznego wynagrodzenia.

ALTER PROCEDURE GIVE_COMMISION @deptno INT
AS
BEGIN
    DECLARE @empno INT, @sal INT, @comm INT, @avg INT;
    SELECT @avg = AVG(SAL) FROM EMP WHERE DEPTNO = @deptno;
    DECLARE EmpCursor CURSOR FOR SELECT EMPNO, SAL, COMM FROM EMP WHERE DEPTNO = @deptno AND SAL < @avg;
    OPEN EmpCursor;
    FETCH NEXT FROM EmpCursor INTO @empno, @sal, @comm;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE EMP SET COMM = ISNULL(@comm, 0) + @sal * 0.05 WHERE EMPNO = @empno;
            FETCH NEXT FROM EmpCursor INTO @empno, @sal;
        END
    CLOSE EmpCursor;
    DEALLOCATE EmpCursor;
END
    EXECUTE GIVE_COMMISION 10
GO


-- 4. (bez kursora) Utwórz tabelę Magazyn (IdPozycji, Nazwa, Ilosc) zawierającą ilości poszczególnych towarów w
-- magazynie i wstaw do niej kilka przykładowych rekordów. W bloku Transact-SQL sprawdź, którego artykułu jest najwięcej
-- w magazynie i zmniejsz ilość tego artykułu o 5 (jeśli stan jest większy lub równy 5, w przeciwnym wypadku zgłoś błąd).

CREATE TABLE Magazyn
(
    IdPozycji INT,
    Nazwa     VARCHAR(20),
    Ilosc     INT
)
GO

INSERT INTO Magazyn
VALUES (1, 'Banany', 10),
       (2, 'Ananasy', 4),
       (3, 'Arbuzy', 23),
       (4, 'Gruszki', 12),
       (5, 'Pomelo', 7);
GO

DECLARE @max_ilosc INT;
SELECT @max_ilosc = MAX(Ilosc)
FROM Magazyn;
IF (@max_ilosc < 5)
    BEGIN
        PRINT 'ERROR: W magazynie jest za malo towarow'
    END
ELSE
    BEGIN
        UPDATE Magazyn SET Ilosc = @max_ilosc - 5 WHERE Ilosc = @max_ilosc;
    END
GO


-- 5. Przerób kod z zadania 4 na procedurę, której będziemy mogli podać wartość, o którą zmniejszamy stan (zamiast wpisanego „na sztywno” 5).

CREATE PROCEDURE DECREASE_STOCK @decreas_by INT
AS
BEGIN
    DECLARE @max_ilosc INT;
    SELECT @max_ilosc = MAX(Ilosc) FROM Magazyn;
    IF (@max_ilosc < 5)
        BEGIN
            PRINT 'ERROR: W magazynie jest za malo towarow'
        END
    ELSE
        BEGIN
            UPDATE Magazyn SET Ilosc = @max_ilosc - @decreas_by WHERE Ilosc = @max_ilosc;
        END
END
GO

EXECUTE DECREASE_STOCK 3
GO