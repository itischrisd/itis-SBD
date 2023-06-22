-- 1. Wypisz wszystkie rezerwacje: imie, nazwisko goscia, data od, data do, nr pokoju, nazwa kategorii pokoju.
SELECT IMIE, NAZWISKO, DATAOD, DATADO, P.NRPOKOJU, NAZWA
FROM REZERWACJA
         INNER JOIN GOSC G on G.IDGOSC = REZERWACJA.IDGOSC
         INNER JOIN POKOJ P on P.NRPOKOJU = REZERWACJA.NRPOKOJU
         INNER JOIN KATEGORIA K on K.IDKATEGORIA = P.IDKATEGORIA;
-- 2. Wypisz numery pokojów z kategorii Luksusowe.
SELECT NRPOKOJU
FROM POKOJ
         INNER JOIN KATEGORIA K on K.IDKATEGORIA = POKOJ.IDKATEGORIA
WHERE NAZWA = 'Luksusowy';
-- 3. Dla każdego gościa wypisz jego imię, nazwisko i liczbę zrobionych rezerwacji.
SELECT IMIE, NAZWISKO, COUNT(*)
FROM GOSC
         INNER JOIN REZERWACJA R on GOSC.IDGOSC = R.IDGOSC
GROUP BY IMIE, NAZWISKO;
-- 4. Wypisz pokoje, które były rezerwowane przynajmniej 3 razy.
SELECT POKOJ.NRPOKOJU
FROM POKOJ
         INNER JOIN REZERWACJA R on POKOJ.NRPOKOJU = R.NRPOKOJU
GROUP BY POKOJ.NRPOKOJU
HAVING COUNT(*) >= 3;
-- 5. Wypisz wszystkich gości, którzy opłacili rezerwację z pokoju z kategorii Turystyczne.
SELECT DISTINCT IMIE, NAZWISKO
FROM GOSC
         INNER JOIN REZERWACJA R on GOSC.IDGOSC = R.IDGOSC
         INNER JOIN POKOJ P on P.NRPOKOJU = R.NRPOKOJU
         INNER JOIN KATEGORIA K on K.IDKATEGORIA = P.IDKATEGORIA
WHERE NAZWA = 'Turystyczny'
  AND ZAPLACONA = 1;
-- 6. Wypisz osoby, które rezerwowały ten sam pokój co Ferdynand Kiepski.
SELECT DISTINCT IMIE, NAZWISKO
FROM GOSC
         INNER JOIN REZERWACJA R on GOSC.IDGOSC = R.IDGOSC
WHERE NRPOKOJU IN (SELECT NRPOKOJU
                   FROM REZERWACJA
                            INNER JOIN GOSC G on G.IDGOSC = REZERWACJA.IDGOSC
                   WHERE G.IMIE = 'Ferdynand'
                     AND G.NAZWISKO = 'Kiepski');