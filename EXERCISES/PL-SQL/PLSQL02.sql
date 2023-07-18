DECLARE
    CURSOR c_emp IS SELECT EMPNO, ENAME, SAL
                    FROM EMP;
    r_emp C_EMP%ROWTYPE;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO r_emp;
        EXIT WHEN c_emp%NOTFOUND;
        IF r_emp.SAL < 1000 THEN
            UPDATE EMP SET SAL = r_emp.SAL * 1.1 WHERE EMPNO = r_emp.EMPNO;
            DBMS_OUTPUT.PUT_LINE(r_emp.ENAME || ' zarabia teraz wiecej - ' || r_emp.SAL);
        ELSIF r_emp.SAL > 1500 THEN
            UPDATE EMP SET SAL = r_emp.SAL * 0.9 WHERE EMPNO = r_emp.EMPNO;
            DBMS_OUTPUT.PUT_LINE(r_emp.ENAME || ' zarabia teraz mniej - ' || r_emp.SAL);
        END IF;
    END LOOP;
    CLOSE c_emp;
END;

CREATE OR REPLACE PROCEDURE PL02ZAD02(losal NUMBER, hisal NUMBER) AS
    CURSOR c_emp IS SELECT EMPNO, ENAME, SAL
                    FROM EMP;
    r_emp C_EMP%ROWTYPE;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO r_emp;
        EXIT WHEN c_emp%NOTFOUND;
        IF r_emp.SAL < losal THEN
            UPDATE EMP SET SAL = r_emp.SAL * 1.1 WHERE EMPNO = r_emp.EMPNO;
            DBMS_OUTPUT.PUT_LINE(r_emp.ENAME || ' zarabia teraz wiecej - ' || r_emp.SAL);
        ELSIF r_emp.SAL > hisal THEN
            UPDATE EMP SET SAL = r_emp.SAL * 0.9 WHERE EMPNO = r_emp.EMPNO;
            DBMS_OUTPUT.PUT_LINE(r_emp.ENAME || ' zarabia teraz mniej - ' || r_emp.SAL);
        END IF;
    END LOOP;
    CLOSE c_emp;
END;

CALL PL02ZAD02(900, 1600);

CREATE OR REPLACE PROCEDURE PL02ZAD03(v_deptno NUMBER) AS
    CURSOR c_emp IS SELECT EMPNO, SAL, COMM
                    FROM EMP
                    WHERE DEPTNO = v_deptno;
    r_emp     C_EMP%ROWTYPE;
    v_avg_sal NUMBER;
BEGIN
    SELECT AVG(SAL) INTO v_avg_sal FROM EMP WHERE DEPTNO = v_deptno;
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO r_emp;
        EXIT WHEN c_emp%NOTFOUND;
        IF r_emp.SAL < v_avg_sal THEN
            UPDATE EMP SET COMM = NVL(COMM, 0) + r_emp.SAL * 0.05 WHERE EMPNO = r_emp.EMPNO;
        END IF;
    END LOOP;
    CLOSE c_emp;
END;

CALL PL02ZAD03(10);

CREATE TABLE Magazyn
(
    IdPozycji INT,
    Nazwa     VARCHAR(20),
    Ilosc     INT
);

INSERT INTO Magazyn
VALUES (1, 'Banany', 10);
INSERT INTO Magazyn
VALUES (2, 'Ananasy', 4);
INSERT INTO Magazyn
VALUES (3, 'Arbuzy', 23);
INSERT INTO Magazyn
VALUES (4, 'Gruszki', 12);
INSERT INTO Magazyn
VALUES (5, 'Pomelo', 7);

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

CREATE OR REPLACE PROCEDURE PL02ZAD05(v_subtract NUMBER) AS
    v_max_ilosc NUMBER(3);
BEGIN
    SELECT MAX(Ilosc) INTO v_max_ilosc FROM Magazyn;
    IF v_max_ilosc >= 5 THEN
        UPDATE Magazyn SET Ilosc = Ilosc - v_subtract WHERE Ilosc = v_max_ilosc;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Za malo towarow w magazynie!');
    END IF;
END;