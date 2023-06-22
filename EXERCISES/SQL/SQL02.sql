-- 1. Wypisz wszystkich klientów hotelu w kolejności alfabetycznej (sortując po nazwisku i imieniu).

SELECT imie, nazwisko
FROM gosc
ORDER BY nazwisko, imie;

-- 2. Podaj bez powtórzeń wszystkie występujące w tabeli wartości rabatu posortowane malejąco.

SELECT DISTINCT procent_rabatu
FROM gosc
WHERE procent_rabatu IS NOT NULL
ORDER BY procent_rabatu DESC;

-- 3. Wypisz wszystkie rezerwacje Ferdynanda Kiepskiego.

SELECT *
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE imie = 'Ferdynand'
  AND nazwisko = 'Kiepski';

-- 4. Wypisz rezerwacje z 2008 roku klientów, których nazwisko zaczyna się na literę „K” lub „L”. Podaj imię, nazwisko
-- oraz numer pokoju.

SELECT *
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE EXTRACT(YEAR FROM dataod) = 2008
  AND (nazwisko LIKE 'K%' OR nazwisko LIKE 'L%');

-- 5. Wypisz numery pokoi wynajmowanych przez Andrzeja Nowaka.

SELECT DISTINCT nrpokoju
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE imie = 'Andrzej'
  AND nazwisko = 'Nowak';

-- 6. Podaj liczbę pokoi w każdej kategorii.

SELECT nazwa, COUNT(*)
FROM kategoria
         INNER JOIN pokoj ON kategoria.idkategoria = pokoj.idkategoria
GROUP BY nazwa;

-- 7. Podaj dane klientów oraz ich rezerwacji tak, aby klient został wypisany nawet, jeśli nigdy nie rezerwował pokoju.

SELECT *
FROM gosc
         LEFT JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc;

-- 8. Wypisz klientów, którzy spali w pokoju 101 i zapłacili.

SELECT imie, nazwisko
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE nrpokoju = 101
  AND zaplacona = 1;

-- 9. Wypisz dane w postaci: Nazwisko i imię (w jednej kolumnie), DataOd, DataDo, NrPokoju, nazwa kategorii.

SELECT nazwisko || ' ' || imie, dataod, datado, pokoj.nrpokoju, nazwa
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
         INNER JOIN pokoj ON rezerwacja.nrpokoju = pokoj.nrpokoju
         INNER JOIN kategoria ON pokoj.idkategoria = kategoria.idkategoria;

-- 10. Wypisz w jednym zapytaniu gości, którzy zarezerwowali pokój 101, mających nazwisko na literę „K” oraz tych,
-- którzy zarezerwowali pokój 201, ale mających nazwisko na literę „P”.

SELECT DISTINCT imie, nazwisko
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE (nrpokoju = 101 AND nazwisko LIKE 'K%')
   OR (nrpokoju = 201 AND nazwisko LIKE 'P%');

-- 11. Wypisz dane klientów, którzy nie mają rabatu (NULL) i wynajęli jakikolwiek pokój.

SELECT DISTINCT imie, nazwisko
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE procent_rabatu IS NULL;

-- 12. Wypisz dane wszystkich rezerwacji pokoi: 101, 102, 103, 104. Podaj imię, nazwisko i datę.

SELECT imie, nazwisko, dataod, datado
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE nrpokoju IN (101, 102, 103, 104);

-- 13. Podaj kategorie z przedziału cenowego <10,100>.

SELECT nazwa
FROM kategoria
WHERE cena BETWEEN 10 AND 100;

-- 14. Wypisz imiona i nazwiska (w jednej kolumnie) klientów, którzy zalegają z płatnościami (pole „zaplacona” = 0).
-- Kolumnie z danymi klienta nadaj etykietę „dłużnik”. Posortuj w pierwszej kolejności po nazwiskach, a w drugiej po
-- imionach.

SELECT DISTINCT imie || ' ' || nazwisko AS "Dluznik"
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE zaplacona = 0
ORDER BY nazwisko, imie;

-- 15. Podaj, ile jest łącznie rezerwacji zapłaconych.

SELECT COUNT(*)
FROM rezerwacja
WHERE zaplacona = 1;

-- 16. Wypisz, ile rezerwacji zostało złożonych w 2009 roku.

SELECT COUNT(*)
FROM rezerwacja
WHERE EXTRACT(YEAR FROM dataod) = 2009;

-- 17. Wstaw do bazy danych nowego gościa (wymyśl dowolne dane) oraz rezerwację dla niego.

INSERT INTO gosc
VALUES (1111, 'Test', 'Testowy', NULL);
INSERT INTO rezerwacja
VALUES (1111, TO_DATE('01-04-2023', 'DD-MM-YYYY'), TO_DATE('07-04-2023', 'DD-MM-YYYY'), 1111, 101, 1);

-- 18. Zmień dowolnie datę zakończenia wybranej rezerwacji.

UPDATE rezerwacja
SET datado = TO_DATE('08-04-2023', 'DD-MM-YYYY')
WHERE idrezerwacja = 1111;

-- 19. Usuń wybraną rezerwację.

DELETE
FROM rezerwacja
WHERE idrezerwacja = 1111;