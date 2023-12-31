SELECT IMIE, NAZWISKO, DATAOD, DATADO, P.NRPOKOJU, NAZWA
FROM REZERWACJA
         INNER JOIN GOSC G ON G.IDGOSC = REZERWACJA.IDGOSC
         INNER JOIN POKOJ P ON P.NRPOKOJU = REZERWACJA.NRPOKOJU
         INNER JOIN KATEGORIA K ON K.IDKATEGORIA = P.IDKATEGORIA;

SELECT NRPOKOJU
FROM POKOJ
         INNER JOIN KATEGORIA K ON K.IDKATEGORIA = POKOJ.IDKATEGORIA
WHERE NAZWA = 'Luksusowy';

SELECT IMIE, NAZWISKO, COUNT(*)
FROM GOSC
         INNER JOIN REZERWACJA R ON GOSC.IDGOSC = R.IDGOSC
GROUP BY IMIE, NAZWISKO;

SELECT POKOJ.NRPOKOJU
FROM POKOJ
         INNER JOIN REZERWACJA R ON POKOJ.NRPOKOJU = R.NRPOKOJU
GROUP BY POKOJ.NRPOKOJU
HAVING COUNT(*) >= 3;

SELECT DISTINCT IMIE, NAZWISKO
FROM GOSC
         INNER JOIN REZERWACJA R ON GOSC.IDGOSC = R.IDGOSC
         INNER JOIN POKOJ P ON P.NRPOKOJU = R.NRPOKOJU
         INNER JOIN KATEGORIA K ON K.IDKATEGORIA = P.IDKATEGORIA
WHERE NAZWA = 'Turystyczny'
  AND ZAPLACONA = 1;

SELECT DISTINCT IMIE, NAZWISKO
FROM GOSC
         INNER JOIN REZERWACJA R ON GOSC.IDGOSC = R.IDGOSC
WHERE NRPOKOJU IN (SELECT NRPOKOJU
                   FROM REZERWACJA
                            INNER JOIN GOSC G ON G.IDGOSC = REZERWACJA.IDGOSC
                   WHERE G.IMIE = 'Ferdynand'
                     AND G.NAZWISKO = 'Kiepski');