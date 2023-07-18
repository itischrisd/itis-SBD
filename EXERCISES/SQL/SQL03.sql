SELECT imie, nazwisko, COUNT(*)
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
GROUP BY gosc.idgosc, imie, nazwisko
HAVING COUNT(*) > 1;

SELECT nrpokoju
FROM pokoj
WHERE liczba_miejsc = (SELECT MAX(liczba_miejsc) FROM pokoj);

SELECT nrpokoju, MAX(dataod)
FROM rezerwacja
GROUP BY nrpokoju;

SELECT pokoj.nrpokoju, COUNT(*)
FROM rezerwacja
         INNER JOIN pokoj ON rezerwacja.nrpokoju = pokoj.nrpokoju
WHERE idkategoria != (SELECT idkategoria FROM kategoria WHERE nazwa = 'Luksusowy')
GROUP BY pokoj.nrpokoju
HAVING COUNT (*) > 1;

SELECT imie, nazwisko, nrpokoju
FROM gosc
         INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE dataod = (SELECT MAX(dataod) FROM rezerwacja);

SELECT *
FROM pokoj
WHERE nrpokoju NOT IN (SELECT nrpokoju FROM rezerwacja);

SELECT *
FROM gosc
WHERE NOT EXISTS (SELECT 1
                  FROM rezerwacja
                           INNER JOIN pokoj ON rezerwacja.nrpokoju = pokoj.nrpokoju
                           INNER JOIN kategoria ON pokoj.idkategoria = kategoria.idkategoria
                  WHERE nazwa = 'Luksusowy'
                    AND rezerwacja.idgosc = gosc.idgosc);

SELECT imie, nazwisko, NVL(TO_CHAR(dataod), 'brak') AS "Data"
FROM gosc
         LEFT JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc
WHERE idrezerwacja IS NULL
   OR nrpokoju = 101;

SELECT nazwa
FROM kategoria
         INNER JOIN pokoj ON kategoria.idkategoria = pokoj.idkategoria
GROUP BY nazwa
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM pokoj GROUP BY idkategoria);

SELECT nazwa, nrpokoju
FROM kategoria
         INNER JOIN pokoj ON kategoria.idkategoria = pokoj.idkategoria
WHERE liczba_miejsc = (SELECT MAX(liczba_miejsc) FROM pokoj WHERE idkategoria = kategoria.idkategoria);