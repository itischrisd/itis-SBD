DECLARE @zmienna VARCHAR(3)
SELECT @zmienna = COUNT(*)
FROM EMP
PRINT 'W tabeli jest ' + @zmienna + ' osob'
GO

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

CREATE PROCEDURE GREATER_SAL @salary INT
AS
BEGIN
    SELECT * FROM EMP WHERE SAL > @salary
END
GO

EXECUTE GREATER_SAL 1500
GO

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