-- Stanowisko
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (1, 'Młodszy sprzedawca', 0.05);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (2, 'Sprzedawca', 0.10);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (3, 'Starszy sprzedawca', 0.15);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (4, 'Księgowy', null);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (5, 'Manager', 0.20);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (6, 'Stażysta', null);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (7, 'Ochroniarz', null);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (8, 'Inspektor BHP', null);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (9, 'Specjalista ds. kadr', null);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (10, 'Zaopatrzeniowiec', null);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (11, 'Specjalista ds. obsługi klienta', null);
INSERT INTO STANOWISKO (ID, NAZWA, PROWIZJA) VALUES (12, 'Specjalista ds. marketingu', null);

-- MetodaPlatnosci
INSERT INTO METODAPLATNOSCI (ID, NAZWA) VALUES (1, 'Gotówka');
INSERT INTO METODAPLATNOSCI (ID, NAZWA) VALUES (2, 'Karta');
INSERT INTO METODAPLATNOSCI (ID, NAZWA) VALUES (3, 'Raty');
INSERT INTO METODAPLATNOSCI (ID, NAZWA) VALUES (4, 'Leasing');

-- RodzajNaprawy
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (1, 'Diagnostyka samochodowa');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (2, 'Wymiana akumulatora');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (3, 'Analiza spalin');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (4, 'Test amortyzatorów');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (5, 'Test hamulców na płytach rolkowych');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (6, 'Test akumulatora');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (7, 'Ustawienie zbieżności / geometrii kół');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (8, 'Ustawienie świateł');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (9, 'Diagnostyka komputerowa');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (10, 'Kasowanie inspekcji olejowej');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (11, 'Pomiar zadymienia silnika „ZS”');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (12, 'Wymiana klocków hamulcowych przód komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (13, 'Wymiana klocków hamulcowych tył komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (14, 'Wymiana tarcz hamulcowych 2 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (15, 'Wymiana szczęk hamulcowych komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (16, 'Wymiana cylinderka hamulcowego 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (17, 'Wymiana przewodów hamulcowych komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (18, 'Wymiana pompy hamulcowej');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (19, 'Wymiana linki hamulca ręcznego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (20, 'Regulacja hamulca ręcznego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (21, 'Uruchomienie zacisku hamulcowego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (22, 'Wymiana płynu hamulcowego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (23, 'Regulacja zaworów silnikowych');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (24, 'Wymiana cewki zapłonowej');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (25, 'Wymiana przewodów zapłonowych');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (26, 'Wymiana świec zapłonowych komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (27, 'Wymiana świec żarowych 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (28, 'Wymiana oleju z filtrem');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (29, 'Wymiana filtra powietrza');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (30, 'Wymiana filtra paliwa');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (31, 'Wymiana filtra kabinowego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (32, 'Wymiana płynu hamulcowego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (33, 'Wymiana płynu chłodzącego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (34, 'Wymiana oleju w manualnej skrzyni biegów');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (35, 'Wymiana oleju w automatycznej skrzyni biegów');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (36, 'Wymiana oleju w układzie wspomagania');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (37, 'Przegląd okresowy mały (15-45-75 tys.)');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (38, 'Przegląd okresowy średni (30 -90 tys.)');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (39, 'Przegląd okresowy duży (60-120 tys.)');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (40, 'Wymiana reflektora');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (41, 'Uzupełnienie czynnika klimatyzacji');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (42, 'Dezynfekcja');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (43, 'Ozonowanie układu');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (44, 'Naprawa układu napędowego i osprzętu silnika');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (45, 'Wymiana sprzęgła');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (46, 'Wymiana rozrządu');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (47, 'Wymiana pompy wody');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (48, 'Wymiana paska klinowego 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (49, 'Wymiana uszczelki pod głowicą');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (50, 'Demontaż silnika – weryfikacja – naprawa');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (51, 'Wymiana turbosprężarki');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (52, 'Uszczelnienie miski olejowej');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (53, 'Wymiana termostatu');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (54, 'Naprawa układu kierowniczego i układu zawieszenia');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (55, 'Wymiana amortyzatorów przód 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (56, 'Wymiana amortyzatorów tył 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (57, 'Wymiana sprężyn przód 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (58, 'Wymiana sprężyn tył 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (59, 'Wymiana drążka kierowniczego 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (60, 'Wymiana końcówki drążka kierowniczego 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (61, 'Wymiana łącznika stabilizatora 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (62, 'Wymiana gumy drążka stabilizatora 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (63, 'Wymiana wahacza 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (64, 'Wymiana sworznia wahacza 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (65, 'Wymiana pompy wspomagania');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (66, 'Wymiana tulei metalowo-gumowych 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (67, 'Wymiana łożyska przód 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (68, 'Wymiana łożyska tył 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (69, 'Wymiana przegubu wewnętrznego 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (70, 'Wymiana przegubu zewnętrznego 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (71, 'Wymiana osłon przegubów wewnętrznych 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (72, 'Wymiana osłon przegubów zewnętrznych 1 szt.');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (73, 'Wymiana przekładni kierowniczej');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (74, 'Wymiana kolumny kierowniczej');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (75, 'Wymiana poduszki silnika');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (76, 'Wymiana kompletnego układu wydechowego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (77, 'Wymiana środkowego tłumika');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (78, 'Wymiana końcowego tłumika');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (79, 'Wymiana złącza elastycznego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (80, 'Wymiana zaworu EGR');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (81, 'Wymiana sondy lambda');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (82, 'Naprawa (spawanie) układu wydechowego');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (83, 'Wypalanie filtra cząstek stałych');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (84, 'Wymiana łącznika elastycznego tłumika/spawanie');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (85, 'Kodowanie czujników ciśnienia');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (86, 'Wymiana opon felga aluminowa 12”-14” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (87, 'Wymiana opon felga aluminowa 15” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (88, 'Wymiana opon felga aluminowa 16” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (89, 'Wymiana opon felga aluminowa 17” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (90, 'Wymiana opon felga aluminowa 18” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (91, 'Wymiana opon felga aluminowa 19” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (92, 'Wymiana opon felga aluminowa 20” i więcej – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (93, 'Wymiana opon felga aluminiowa SUV/BUS');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (94, 'Wymiana opon felga stal 12”-14” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (95, 'Wymiana opon felga stal 15” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (96, 'Wymiana opon felga stal 16”-17” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (97, 'Wymiana opon felga stal 18”-19” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (98, 'Wymiana opon felga stalowa 20” i więcej – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (99, 'Wymiana opon felga stalowa SUV/BUS');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (100, 'Wyważanie bez zdejmowania');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (101, 'Wyważanie ze zdjęciem');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (102, 'Wymiana kół bez wyważania');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (103, 'Wymiana kół z wyważaniem 12”-17” – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (104, 'Wymiana kół z wyważaniem 18” i więcej – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (105, 'Naprawa opony (łata)');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (106, 'Naprawa opony (kołek)');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (107, 'Pompowanie azotem – komplet');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (108, 'Przechowywanie opon 12”-17” – komplet / 1 sezon');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (109, 'Przechowywanie opon 18” i więcej – komplet / 1 sezon');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (110, 'Koła wyposażone w czujniki');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (111, 'Mycie i sprzątanie samochodu – Koszt');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (112, 'Mycie podstawowe – mały samochód');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (113, 'Mycie podstawowe – średni samochód');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (114, 'Mycie podstawowe – duży samochód');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (115, 'Mycie podstawowe – VAN, terenowy, BUS');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (116, 'Sprzątanie – mały samochód');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (117, 'Sprzątanie – średni samochód');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (118, 'Sprzątanie – duży samochód');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (119, 'Sprzątanie – VAN, terenowy');
INSERT INTO RODZAJNAPRAWY (ID, NAZWA) VALUES (120, 'Sprzątanie – BUS');

-- Marka
INSERT INTO MARKA (ID, NAZWA) VALUES (1, 'Audi');
INSERT INTO MARKA (ID, NAZWA) VALUES (2, 'BMW');
INSERT INTO MARKA (ID, NAZWA) VALUES (3, 'Citroen');
INSERT INTO MARKA (ID, NAZWA) VALUES (4, 'Dacia');
INSERT INTO MARKA (ID, NAZWA) VALUES (5, 'Fiat');
INSERT INTO MARKA (ID, NAZWA) VALUES (6, 'Ford');
INSERT INTO MARKA (ID, NAZWA) VALUES (7, 'Hyundai');
INSERT INTO MARKA (ID, NAZWA) VALUES (8, 'Kia');
INSERT INTO MARKA (ID, NAZWA) VALUES (9, 'Mercedes');
INSERT INTO MARKA (ID, NAZWA) VALUES (10, 'Nissan');
INSERT INTO MARKA (ID, NAZWA) VALUES (11, 'Opel');
INSERT INTO MARKA (ID, NAZWA) VALUES (12, 'Peugeot');
INSERT INTO MARKA (ID, NAZWA) VALUES (13, 'Renault');
INSERT INTO MARKA (ID, NAZWA) VALUES (14, 'SEAT');
INSERT INTO MARKA (ID, NAZWA) VALUES (15, 'Skoda');
INSERT INTO MARKA (ID, NAZWA) VALUES (16, 'Toyota');
INSERT INTO MARKA (ID, NAZWA) VALUES (17, 'Volkswagen');
INSERT INTO MARKA (ID, NAZWA) VALUES (18, 'Volvo');

-- Kraj
INSERT INTO KRAJ (ID, NAZWA) VALUES (1, 'Chiny');
INSERT INTO KRAJ (ID, NAZWA) VALUES (2, 'USA');
INSERT INTO KRAJ (ID, NAZWA) VALUES (3, 'Japonia');
INSERT INTO KRAJ (ID, NAZWA) VALUES (4, 'Indie');
INSERT INTO KRAJ (ID, NAZWA) VALUES (5, 'Niemcy');
INSERT INTO KRAJ (ID, NAZWA) VALUES (6, 'Meksyk');
INSERT INTO KRAJ (ID, NAZWA) VALUES (7, 'Korea Południowa');
INSERT INTO KRAJ (ID, NAZWA) VALUES (8, 'Brazylia');
INSERT INTO KRAJ (ID, NAZWA) VALUES (9, 'Hiszpania');
INSERT INTO KRAJ (ID, NAZWA) VALUES (10, 'Francja');