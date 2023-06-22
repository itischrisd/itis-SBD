DECLARE
    CURSOR kursor IS SELECT ENAME, SAL
                     FROM EMP;
    wiersz kursor%ROWTYPE;
BEGIN
    OPEN kursor;
    LOOP
        FETCH kursor INTO wiersz;
        EXIT WHEN kursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(wiersz.ENAME || ' zarabia ' || wiersz.SAL);
    end loop;
    CLOSE kursor;
end;

BEGIN
    FOR wiersz IN (SELECT ENAME, SAL FROM EMP)
        LOOP
            DBMS_OUTPUT.PUT_LINE(wiersz.ENAME || ' zarabia ' || wiersz.SAL);
        end loop;
end;

CREATE OR REPLACE TRIGGER trigger1
    BEFORE DELETE
    ON EMP
BEGIN
    raise_application_error(-20500, 'Nie mozna usuwac');
end;

CREATE OR REPLACE TRIGGER trigger1
    BEFORE DELETE OR INSERT
    ON EMP
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.sal < 1000 THEN
            :NEW.sal := 1000;
        end if;
    ELSIF DELETING THEN
        IF :OLD.sal > 5000 THEN
            raise_application_error(-20500, 'Nie mozna usuwac');
        end if;
    end if;
end;

-- 1. Przy pomocy kursora przejrzyj wszystkich pracowników i zmodyfikuj wynagrodzenia tak, aby osoby zarabiające mniej
-- niż 1000 miały zwiększone wynagrodzenie o 10%, natomiast osoby zarabiające powyżej 1500 miały zmniejszone wynagrodzenie
-- o 10%. Wypisz na ekran każdą wprowadzoną zmianę.

DECLARE
    CURSOR c_emp IS SELECT EMPNO, ENAME, SAL
                     FROM EMP;
    r_emp c_emp%ROWTYPE;
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
        end if;   
    end loop;
    CLOSE c_emp;
end;

-- 2. Przerób kod z zadania 1 na procedurę tak, aby wartości zarobków (1000 i 1500) nie były stałe, tylko były
-- parametrami procedury.

CREATE OR REPLACE PROCEDURE PL02ZAD02(losal NUMBER, hisal NUMBER) AS
    CURSOR c_emp IS SELECT EMPNO, ENAME, SAL
                     FROM EMP;
    r_emp c_emp%ROWTYPE;
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
        end if;
    end loop;
    CLOSE c_emp;
end;

CALL PL02ZAD02(900, 1600);

-- 3. W procedurze sprawdź średnią wartość zarobków z tabeli EMP z działu określonego parametrem procedury.
-- Następnie należy dać prowizję (comm) tym pracownikom tego działu, którzy zarabiają poniżej średniej.
-- Prowizja powinna wynosić 5% ich miesięcznego wynagrodzenia.

CREATE OR REPLACE PROCEDURE PL02ZAD03(v_deptno NUMBER) AS
    CURSOR c_emp IS SELECT EMPNO, SAL, COMM
                     FROM EMP
                     WHERE DEPTNO = v_deptno;
    r_emp    c_emp%ROWTYPE;
    v_avg_sal NUMBER;
BEGIN
    SELECT AVG(SAL) INTO v_avg_sal FROM EMP WHERE DEPTNO = v_deptno;
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO r_emp;
        EXIT WHEN c_emp%NOTFOUND;
        IF r_emp.SAL < v_avg_sal THEN
            UPDATE EMP SET COMM = NVL(COMM, 0) + r_emp.SAL * 0.05 WHERE EMPNO = r_emp.EMPNO;
        end if;
    end loop;
    CLOSE c_emp;
end;

CALL PL02ZAD03(10);

-- 4. (bez kursora) Utwórz tabelę Magazyn (IdPozycji, Nazwa, Ilosc) zawierającą ilości poszczególnych towarów w magazynie
-- i wstaw do niej kilka przykładowych rekordów. W bloku PL/SQL sprawdź, którego artykułu jest najwięcej w magazynie
-- i zmniejsz ilość tego artykułu o 5 (jeśli stan jest większy lub równy 5, w przeciwnym wypadku zgłoś błąd).

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

-- 5. Przerób kod z zadania 4 na procedurę, której będziemy mogli podać wartość, o którą zmniejszamy stan (zamiast
-- wpisanego „na sztywno” 5).

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