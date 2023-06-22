-- 1. Napisz prosty program w PL/SQL. Zadeklaruj zmienną, przypisz na tą zmienną liczbę rekordów w tabeli EMP i wypisz
-- uzyskany wynik w postaci np. "W tabeli jest 10 osób".

DECLARE
    v_emp_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_emp_count
    FROM EMP;
    DBMS_OUTPUT.PUT_LINE('W tabeli jest ' || v_emp_count || ' osób');
END;

-- 2. Sprawdź w bloku PL/SQL liczbę pracowników z tabeli EMP. Jeśli liczba jest mniejsza niż 16, wstaw pracownika
-- Kowalskiego i wypisz odpowiedni komunikat. W przeciwnym przypadku wypisz komunikat informujący o tym,
-- że nie wstawiono danych.

DECLARE
    v_emp_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_emp_count
    FROM EMP;
    IF v_emp_count < 16 THEN
        INSERT INTO EMP
        VALUES ((SELECT NVL(MAX(EMPNO) + 1, 1) FROM EMP), 'Kowalski', NULL, NULL, SYSDATE, 1000, NULL, 10);
        DBMS_OUTPUT.PUT_LINE('Mniej niz 16 pracownikow - wstawiono Kowalskiego!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nie wstawiono zadnych danych.');
    END IF;
END;

-- 3. Napisz procedurę służącą do wstawiania działów do tabeli Dept. Procedura będzie pobierać jako parametry:
-- nr_działu, nazwę i lokalizację. Należy sprawdzić, czy dział o takiej nazwie lub lokalizacji już istnieje.
-- Jeżeli istnieje, to nie wstawiamy nowego rekordu.

CREATE OR REPLACE PROCEDURE pl01zad03(v_new_deptno NUMBER, v_new_dname VARCHAR, v_new_loc VARCHAR) AS
    v_curr_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_curr_count FROM DEPT WHERE DNAME = v_new_dname OR LOC = v_new_loc;
    IF v_curr_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Taki dzial juz istnieje!');
    ELSE
        INSERT INTO DEPT VALUES (v_new_deptno, v_new_dname, v_new_loc);
    END IF;
END;

CALL PL01ZAD03(50, 'HQ', 'WARSAW');

-- 4. Napisz procedurę służącą do wstawiania pracowników. Jako parametry podamy: nr działu i nazwisko. Procedura powinna
-- sprawdzić, czy podany dział istnieje (w przeciwnym przypadku zgłaszamy błąd) i wyliczyć pracownikowi pensję równą
-- minimalnemu wynagrodzeniu w jego dziale. Procedura powinna również nadać EMPNO nowemu pracownikowi obliczone jako
-- maksymalne EMPNO w tabeli + 1.

CREATE OR REPLACE PROCEDURE pl01zad04(v_new_deptno NUMBER, v_new_ename VARCHAR) AS
    v_curr_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_curr_count FROM DEPT WHERE DEPTNO = v_new_deptno;
    IF v_curr_count > 0 THEN
        INSERT INTO EMP
        VALUES ((SELECT NVL(MAX(EMPNO) + 1, 1) FROM EMP), v_new_ename, NULL, NULL, SYSDATE, (SELECT MIN(SAL) FROM EMP WHERE DEPTNO = v_new_deptno), NULL,
                v_new_deptno);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nie ma takiego dzialu!');
    END IF;
END;

CALL PL01ZAD04(10, 'Testerski');

-- 5. Utwórz tabelę Magazyn (IdPozycji, Nazwa, Ilosc) zawierającą ilości poszczególnych towarów w magazynie i wstaw do
-- niej kilka przykładowych rekordów. W bloku PL/SQL sprawdź, którego artykułu jest najwięcej w magazynie i zmniejsz
-- ilość tego artykułu o 5 (jeśli stan jest większy lub równy 5, w przeciwnym wypadku zgłoś błąd).

CREATE TABLE Magazyn
(
    IdPozycji NUMBER(2) NOT NULL
        CONSTRAINT Magazyn_PK PRIMARY KEY,
    Nazwa     VARCHAR(20),
    Ilosc     NUMBER(3)
);

INSERT INTO Magazyn
VALUES (1, 'Chleb', 10);
INSERT INTO Magazyn
VALUES (2, 'Cukier', 3);
INSERT INTO Magazyn
VALUES (3, 'Mleko', 7);
INSERT INTO Magazyn
VALUES (4, 'Woda', 2);
INSERT INTO Magazyn
VALUES (5, 'Maslo', 4);

DECLARE
    v_max_ilosc NUMBER(3);
BEGIN
    SELECT MAX(Ilosc) INTO v_max_ilosc FROM Magazyn;
    IF v_max_ilosc >= 5 THEN
        UPDATE Magazyn SET Ilosc = Ilosc - 5 WHERE Ilosc = v_max_ilosc;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Za malo towarow w magazynie!');
    END IF;
END;