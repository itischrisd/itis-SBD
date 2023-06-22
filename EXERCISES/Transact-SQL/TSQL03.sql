-- 1. Utwórz wyzwalacz, który nie pozwoli usunąć rekordu z tabeli Emp.

CREATE TRIGGER BLOCK_DEL_EMP
    ON EMP
    FOR DELETE
    AS
BEGIN
    ROLLBACK;
END
GO

-- 2. Utwórz wyzwalacz, który przy wstawianiu pracownika do tabeli Emp, wstawi prowizję równą 0, jeśli prowizja była
-- pusta. Uwaga: Zadanie da się wykonać bez użycia wyzwalaczy przy pomocy DEFAULT. Użyjmy jednak wyzwalacza w celach treningowych.

CREATE TRIGGER EMP_SET_COMM_0
    ON EMP
    FOR INSERT
    AS
BEGIN
    UPDATE EMP SET COMM = 0 WHERE EMPNO IN (SELECT EMPNO FROM inserted WHERE inserted.COMM IS NULL);
END
GO


-- 3. Utwórz wyzwalacz, który przy wstawianiu lub modyfikowaniu danych w tabeli Emp sprawdzi czy nowe zarobki
-- (wstawiane lub modyfikowane) są większe niż 1000. W przeciwnym przypadku wyzwalacz powinien zgłosić błąd i nie
-- dopuścić do wstawienia rekordu. Uwaga: Ten sam efekt można uzyskać łatwiej przy pomocy więzów spójności typu CHECK.
-- Użyjmy wyzwalacza w celach treningowych.

CREATE TRIGGER EMP_SAL_1000
    ON EMP
    FOR INSERT, UPDATE
    AS
BEGIN
    IF EXISTS(SELECT 1 FROM inserted WHERE inserted.SAL <= 1000)
        BEGIN
            RAISERROR ('Pensja musi byc wieksza niz 1000!', 10, 1);
            ROLLBACK;
        END
END
GO
-- 4. Utwórz tabelę budzet: CREATE TABLE budzet (wartosc INT NOT NULL) W tabeli tej będzie przechowywana łączna wartość
-- wynagrodzenia wszystkich pracowników. Tabela będzie zawsze zawierała jeden wiersz. Należy najpierw obliczyć początkową
-- wartość zarobków: INSERT INTO budzet (wartosc) SELECT SUM(sal) FROM emp Utwórz wyzwalacz, który będzie pilnował, aby
-- wartość w tabeli budzet była zawsze aktualna, a więc przy wszystkich operacjach aktualizujących tabelę emp
-- (INSERT, UPDATE, DELETE), wyzwalacz będzie aktualizował wpis w tabeli budżet

CREATE TABLE budzet
(
    wartosc INT NOT NULL
);

INSERT INTO budzet (wartosc)
SELECT SUM(sal)
FROM emp;

CREATE TRIGGER SUM_SAL
    ON EMP
    FOR INSERT, UPDATE, DELETE
    AS
BEGIN
    UPDATE budzet SET wartosc = (SELECT SUM(SAL) FROM EMP);
END
GO

-- 5. Napisz wyzwalacz, który nie pozwoli modyfikować nazw działów w tabeli dept.
-- Powinno być jednak możliwe wstawianie nowych działów.

CREATE TRIGGER DEPT_NAME
    ON DEPT
    FOR UPDATE
    AS
BEGIN
    IF EXISTS(SELECT d.DEPTNO
              FROM deleted d
                       INNER JOIN inserted i ON d.DEPTNO = i.DEPTNO
              WHERE i.DNAME != d.DNAME)
        ROLLBACK
END
GO

-- 6. Napisz jeden wyzwalacz, który:
-- · Nie pozwoli usunąć pracownika, którego pensja jest większa od 0.
-- · Nie pozwoli zmienić nazwiska pracownika.
-- · Nie pozwoli wstawić pracownika, który już istnieje (sprawdzając po nazwisku).

CREATE TRIGGER MULTI_EMP
    ON EMP
    FOR INSERT, UPDATE, DELETE
    AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) = 0
        BEGIN
            IF EXISTS(SELECT empno FROM deleted WHERE SAL > 0)
                BEGIN
                    ROLLBACK;
                END
        END
    ELSE
        IF (SELECT COUNT(*) FROM deleted) = 0
            BEGIN
                IF EXISTS(SELECT empno
                          FROM inserted i
                          WHERE ename IN (SELECT ename FROM emp e WHERE e.empno != i.empno))
                    BEGIN
                        ROLLBACK;
                    END
            END
        ELSE
            BEGIN
                IF EXISTS(SELECT i.ENAME
                          FROM inserted i
                                   INNER JOIN deleted d ON i.EMPNO = d.EMPNO
                          WHERE i.ENAME != d.ENAME)
                    BEGIN
                        ROLLBACK;
                    END
            END
END
GO

-- 7. Napisz wyzwalacz, który:
-- · Nie pozwoli zmniejszać pensji.
-- · Nie pozwoli usuwać pracowników.

CREATE TRIGGER MULTI_EMP_2
    ON EMP
    FOR UPDATE, DELETE AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) = 0
        ROLLBACK;
    ELSE
        IF EXISTS(SELECT d.EMPNO
                  FROM inserted i
                           INNER JOIN deleted d ON i.EMPNO = d.EMPNO
                  WHERE i.sal < d.SAL)
            ROLLBACK;
END
GO
