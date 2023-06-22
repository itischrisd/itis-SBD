-- 1. Wypisz gości wraz z liczbą dokonanych przez nich rezerwacji. Nie wypisuj informacji o gościach, którzy złożyli tylko jedną rezerwację.

SELECT imie, nazwisko, COUNT(*)
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
GROUP BY gosc.idgosc, imie, nazwisko
HAVING COUNT(*) > 1;

-- 2. Wypisz pokoje o największej liczbie miejsc.

SELECT nrpokoju
FROM pokoj
WHERE liczba_miejsc = (SELECT MAX(liczba_miejsc) FROM pokoj);

-- 3. Dla każdego pokoju wypisz, kiedy był ostatnio wynajmowany.

SELECT nrpokoju, MAX(dataod)
FROM rezerwacja
GROUP BY nrpokoju;

-- 4. Wypisz liczbę rezerwacji dla każdego pokoju. Nie wypisuj pokoi, które były rezerwowane tylko raz oraz pokoi z kategorii „luksusowy”.

SELECT pokoj.nrpokoju, COUNT(*)
FROM rezerwacja
         INNER JOIN pokoj ON rezerwacja.nrpokoju = pokoj.nrpokoju
WHERE idkategoria != (SELECT idkategoria FROM kategoria WHERE nazwa = 'Luksusowy')
GROUP BY pokoj.nrpokoju
HAVING COUNT(*) > 1;

-- 5. Podaj dane (imię, nazwisko, numer pokoju) najnowszej rezerwacji.

SELECT imie, nazwisko, nrpokoju
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE dataod = (SELECT MAX(dataod) FROM rezerwacja);

-- 6. Wypisz dane pokoju, który nie był nigdy wynajmowany.

SELECT *
FROM pokoj
WHERE nrpokoju NOT IN (SELECT nrpokoju FROM rezerwacja);

-- 7. Używając operatora NOT EXISTS wypisz gości, którzy nigdy nie wynajmowali pokoju luksusowego.

SELECT *
FROM gosc
WHERE NOT EXISTS (SELECT 1
                  FROM rezerwacja
                           INNER JOIN pokoj ON rezerwacja.nrpokoju = pokoj.nrpokoju
                           INNER JOIN kategoria ON pokoj.idkategoria = kategoria.idkategoria
                  WHERE nazwa = 'Luksusowy'
                    AND rezerwacja.idgosc = gosc.idgosc);

-- 8. W jednym zapytaniu wypisz gości, którzy wynajmowali pokój 101 (imię, nazwisko, data rezerwacji) oraz gości, którzy nigdy nie wynajmowali żadnego pokoju (imię, nazwisko, ‘brak’).

SELECT imie, nazwisko, NVL(TO_CHAR(dataod), 'brak') AS "Data"
FROM gosc
         LEFT JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE idrezerwacja IS NULL
   OR nrpokoju = 101;

-- 9. Znajdź kategorię, w której liczba pokoi jest największa.

SELECT nazwa
FROM kategoria
         INNER JOIN pokoj ON kategoria.idkategoria = pokoj.idkategoria
GROUP BY nazwa
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM pokoj GROUP BY idkategoria);

-- 10. Dla każdej kategorii podaj pokój o największej liczbie miejsc.

SELECT nazwa, nrpokoju
FROM kategoria
         INNER JOIN pokoj ON kategoria.idkategoria = pokoj.idkategoria
WHERE liczba_miejsc = (SELECT MAX(liczba_miejsc) FROM pokoj WHERE idkategoria = kategoria.idkategoria);