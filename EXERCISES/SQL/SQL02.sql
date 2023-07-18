SELECT imie, nazwisko
FROM gosc
ORDER BY nazwisko, imie;

SELECT DISTINCT procent_rabatu
FROM gosc
WHERE procent_rabatu IS NOT NULL
ORDER BY procent_rabatu DESC;

SELECT *
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE imie = 'Ferdynand'
  AND nazwisko = 'Kiepski';

SELECT *
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE EXTRACT(YEAR FROM dataod) = 2008
  AND (nazwisko LIKE 'K%' OR nazwisko LIKE 'L%');

SELECT DISTINCT nrpokoju
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE imie = 'Andrzej'
  AND nazwisko = 'Nowak';

SELECT nazwa, COUNT(*)
FROM kategoria
         INNER JOIN pokoj ON kategoria.idkategoria = pokoj.idkategoria
GROUP BY nazwa;

SELECT *
FROM gosc
         LEFT JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc;

SELECT imie, nazwisko
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE nrpokoju = 101
  AND zaplacona = 1;

SELECT nazwisko || ' ' || imie, dataod, datado, pokoj.nrpokoju, nazwa
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
         INNER JOIN pokoj ON rezerwacja.nrpokoju = pokoj.nrpokoju
         INNER JOIN kategoria ON pokoj.idkategoria = kategoria.idkategoria;

SELECT DISTINCT imie, nazwisko
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE (nrpokoju = 101 AND nazwisko LIKE 'K%')
   OR (nrpokoju = 201 AND nazwisko LIKE 'P%');

SELECT DISTINCT imie, nazwisko
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE procent_rabatu IS NULL;

SELECT imie, nazwisko, dataod, datado
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE nrpokoju IN (101, 102, 103, 104);

SELECT nazwa
FROM kategoria
WHERE cena BETWEEN 10 AND 100;

SELECT DISTINCT imie || ' ' || nazwisko AS "Dluznik"
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE zaplacona = 0
ORDER BY nazwisko, imie;

SELECT COUNT(*)
FROM rezerwacja
WHERE zaplacona = 1;

SELECT COUNT(*)
FROM rezerwacja
WHERE EXTRACT(YEAR FROM dataod) = 2009;

INSERT INTO gosc
VALUES (1111, 'Test', 'Testowy', NULL);
INSERT INTO rezerwacja
VALUES (1111, TO_DATE('01-04-2023', 'DD-MM-YYYY'), TO_DATE('07-04-2023', 'DD-MM-YYYY'), 1111, 101, 1);

UPDATE rezerwacja
SET datado = TO_DATE('08-04-2023', 'DD-MM-YYYY')
WHERE idrezerwacja = 1111;

DELETE
FROM rezerwacja
WHERE idrezerwacja = 1111;