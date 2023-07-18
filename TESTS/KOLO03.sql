DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(1)
    INTO v_count
    FROM PRODUKT
             INNER JOIN KATEGORIA K ON PRODUKT.ID_KATEGORIA = K.ID_KATEGORIA
    WHERE KATEGORIA = 'NABIAL';
    DBMS_OUTPUT
        .
        PUT_LINE
        ('W kategorii NABIAL jest ' || v_count || ' produktów.');
END;

CREATE
    OR REPLACE TRIGGER KOLO02ZAD02
    BEFORE INSERT
    ON KATEGORIA
BEGIN
    RAISE_APPLICATION_ERROR
        (-20500, 'Wstawianie zablokowane');
END;

CREATE OR REPLACE PROCEDURE KOLO02ZAD03(v_nazwa VARCHAR2) AS
    v_id NUMBER;
    v_count
         NUMBER;
BEGIN
    SELECT COUNT(1)
    INTO v_count
    FROM KATEGORIA
    WHERE KATEGORIA = v_nazwa;
    IF
        v_count = 0 THEN
        SELECT NVL(MAX(ID_KATEGORIA) + 1, 1)
        INTO v_id
        FROM KATEGORIA;
        INSERT INTO KATEGORIA
        VALUES (v_id, v_nazwa);
    ELSE
        SELECT ID_KATEGORIA
        INTO v_id
        FROM KATEGORIA
        WHERE KATEGORIA = v_nazwa;
    END IF;
    UPDATE PRODUKT
    SET ID_KATEGORIA = v_id
    WHERE ID_KATEGORIA IS NULL;
END;

CREATE
    OR REPLACE TRIGGER KOLO02ZAD04
    BEFORE INSERT OR
        UPDATE OR
        DELETE
    ON PRODUKT
    FOR EACH ROW
BEGIN
    IF
        DELETING THEN
        RAISE_APPLICATION_ERROR(-20500, 'Usuwanie zablokowane.');
    ELSIF
        INSERTING AND :NEW.CENA <= 0 THEN
        RAISE_APPLICATION_ERROR(-20500, 'Cena poza zakresem');
    ELSIF
        :NEW.ID_KATEGORIA != :OLD.ID_KATEGORIA THEN
        :NEW.ID_KATEGORIA := :OLD.ID_KATEGORIA;
    END IF;
END;

CREATE OR REPLACE PROCEDURE KOLO02ZAD05(v_imie VARCHAR2, v_nazwisko VARCHAR2) AS
    v_id_miasto NUMBER;
    v_count
                NUMBER;
    CURSOR c_klient IS
        SELECT IMIE, NAZWISKO
        FROM KLIENT
        WHERE ID_MIASTO = v_id_miasto
          AND (IMIE != v_imie OR NAZWISKO != v_nazwisko);
    r_klient
                C_KLIENT%ROWTYPE;

BEGIN
    SELECT COUNT(1)
    INTO v_count
    FROM KLIENT
    WHERE IMIE = v_imie
      AND NAZWISKO = v_nazwisko;
    IF
        v_count > 0 THEN
        SELECT ID_MIASTO
        INTO v_id_miasto
        FROM KLIENT
        WHERE IMIE = v_imie
          AND NAZWISKO = v_nazwisko;
        OPEN c_klient;
        LOOP
            FETCH c_klient INTO r_klient;
            EXIT
                WHEN c_klient%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE
                (r_klient.IMIE || ' ' || r_klient.NAZWISKO ||
                 ' mieszka w tym samym mieście co ' || v_imie || ' ' || v_nazwisko);
        END LOOP;
        CLOSE c_klient;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Klient ' || v_imie || ' ' || v_nazwisko || ' nie wsytępuje w systemie.');
    END IF;
END;