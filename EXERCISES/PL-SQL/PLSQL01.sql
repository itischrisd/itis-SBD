DECLARE
    v_emp_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_emp_count
    FROM EMP;
    DBMS_OUTPUT.PUT_LINE('W tabeli jest ' || v_emp_count || ' osób');
END;

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

CREATE OR REPLACE PROCEDURE pl01zad04(v_new_deptno NUMBER, v_new_ename VARCHAR) AS
    v_curr_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_curr_count FROM DEPT WHERE DEPTNO = v_new_deptno;
    IF v_curr_count > 0 THEN
        INSERT INTO EMP
        VALUES ((SELECT NVL(MAX(EMPNO) + 1, 1) FROM EMP), v_new_ename, NULL, NULL, SYSDATE,
                (SELECT MIN(SAL) FROM EMP WHERE DEPTNO = v_new_deptno), NULL,
                v_new_deptno);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nie ma takiego dzialu!');
    END IF;
END;

CALL PL01ZAD04(10, 'Testerski');

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