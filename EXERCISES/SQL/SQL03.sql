-- 1. Utwórz wyzwalacz, który nie pozwoli usunąć rekordu z tabeli Emp.

CREATE OR REPLACE TRIGGER PL03ZAD01
    BEFORE DELETE
    ON EMP
BEGIN
    RAISE_APPLICATION_ERROR(-20500, 'Usuwanie zablokowane');
END;

-- 2. Utwórz wyzwalacz, który przy wstawianiu lub modyfikowaniu danych w tabeli Emp sprawdzi czy nowe zarobki (wstawiane
-- lub modyfikowane) są większe niż 1000. W przeciwnym przypadku wyzwalacz powinien zgłosić błąd i nie dopuścić do
-- wstawienia rekordu. Uwaga: Ten sam efekt można uzyskać łatwiej przy pomocy więzów spójności typu CHECK. Użyjmy
-- wyzwalacza w celach treningowych.

CREATE OR REPLACE TRIGGER PL03ZAD02
    BEFORE INSERT OR UPDATE
    ON EMP
    FOR EACH ROW
BEGIN
    IF :NEW.sal < 1000 THEN
        RAISE_APPLICATION_ERROR(-20500, 'Zarobki nie moga byc ponizej 1000!');
    END IF;
END;

INSERT INTO EMP
VALUES ((SELECT NVL(MAX(EMPNO) + 1, 1) FROM EMP), 'Kowalski', NULL, NULL, CURRENT_DATE, 1000, NULL, 10);

-- 3. Utwórz tabelę budzet: CREATE TABLE budzet (wartosc INT NOT NULL) W tabeli tej będzie przechowywana łączna wartość
-- wynagrodzenia wszystkich pracowników. Tabela będzie zawsze zawierała jeden wiersz. Należy najpierw obliczyć
-- początkową wartość zarobków: INSERT INTO budzet (wartosc) SELECT SUM(sal) FROM emp Utwórz wyzwalacz, który będzie
-- pilnował, aby wartość w tabeli budzet była zawsze aktualna, a więc przy wszystkich operacjach aktualizujących tabelę
-- emp (INSERT, UPDATE, DELETE), wyzwalacz będzie aktualizował wpis w tabeli budżet.

CREATE TABLE Budzet
(
    wartos INT NOT NULL
);

INSERT INTO Budzet
VALUES ((SELECT SUM(sal) FROM EMP));

CREATE OR REPLACE TRIGGER PL03ZAD03
    BEFORE INSERT OR UPDATE OR DELETE
    ON EMP
BEGIN
    UPDATE Budzet SET wartos = (SELECT SUM(sal) FROM EMP);
END;

-- 4. Napisz jeden wyzwalacz, który:
-- · Nie pozwoli usunąć pracownika, którego pensja jest większa od 0.
-- · Nie pozwoli zmienić nazwiska pracownika.
-- · Nie pozwoli wstawić pracownika, który już istnieje (sprawdzając po nazwisku).

CREATE OR REPLACE TRIGGER PL03ZAD04
    BEFORE INSERT OR UPDATE OR DELETE
    ON EMP
    FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO v_count FROM EMP WHERE ENAME = :NEW.ENAME;
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20500, 'Pracownik o tym nazwisku juz istnieje!');
        END IF;
    ELSIF UPDATING AND :NEW.ename != :OLD.ename THEN
        :NEW.SAL := :OLD.SAL;
    ELSIF :OLD.sal > 0 THEN
        RAISE_APPLICATION_ERROR(-20500, 'Nie wolno usuwac pracownika z niezerowa pensja!');
    END IF;
END;

INSERT INTO EMP
VALUES ((SELECT NVL(MAX(EMPNO) + 1, 1) FROM EMP), 'Kowalski', NULL, NULL, CURRENT_DATE, 1000, NULL, 10);

UPDATE EMP
SET ENAME = 'Malinowsi'
WHERE EMPNO = 7938;

DELETE
FROM EMP
WHERE EMPNO = 7938;

-- 5. Napisz wyzwalacz, który:
-- · Nie pozwoli zmniejszać pensji.
-- · Nie pozwoli usuwać pracowników.

CREATE OR REPLACE TRIGGER PL03ZAD05
    BEFORE UPDATE OR DELETE
    ON EMP
    FOR EACH ROW
BEGIN
    IF UPDATING AND :NEW.SAL < :OLD.SAL THEN
        :NEW.SAL := :OLD.SAL;
    ELSIF DELETING THEN
        RAISE_APPLICATION_ERROR(-20500, 'Nie wolno usuwać pracowników');
    END IF;
END;