-- 1. Wyœwietl posortowan¹ listê najpopularniejszych rodzajów ubezpieczeñ wed³ug liczby klientów. 
-- Mo¿e byæ przydatne do celów statystycznych oraz w podejmowaniu decyzji dotycz¹cych regulacji cen ubezpieczeñ.
SELECT 
    Typy_polis.Typ AS 'Typ ubezpieczenia',
    COUNT(Polisy.ID_Polisy) AS 'Liczba klientów'
FROM Polisy
JOIN Typy_polis ON Polisy.typ_polisy = Typy_polis.Typ
GROUP BY Typy_polis.Typ
ORDER BY 'Liczba klientów' DESC;


-- 2. Wyœwietl listê w³aœcicieli pojazdów, których polisy maj¹ status "Oczekuje". 
-- Mo¿e byæ wykorzystane do przypomnienia klientom o koniecznoœci uregulowania p³atnoœci.
SELECT
	Wlasciciele.Imie AS 'Imiê',
	Wlasciciele.Nazwisko AS 'Nazwisko',
	Wlasciciele.Numer_telefonu AS 'Numer telefonu',
    Polisy.ID_Polisy AS 'ID Polisy',
    Polisy.StatusPolisy AS 'Status polisy'
FROM Polisy
JOIN Samochody ON Polisy.samochod_VIN = Samochody.VIN
JOIN Wlasciciele ON Samochody.wlasciciel_PESEL = Wlasciciele.PESEL
WHERE Polisy.StatusPolisy = 'Oczekuje';


-- 3. Utwórz posortowan¹ listê klientów wraz z ich ³¹cznymi wydatkami na ubezpieczenia. 
-- Mo¿e byæ u¿yteczne do celów statystycznych oraz jako narzêdzie do przyznawania zni¿ek lojalnym klientom.
SELECT 
    Wlasciciele.Imie AS 'Imiê',
    Wlasciciele.Nazwisko AS 'Nazwisko',
    SUM(Platnosci.Kwota) AS 'Suma wydatków na ubezpieczenie'
FROM Wlasciciele 
JOIN Samochody ON Wlasciciele.PESEL = Samochody.wlasciciel_PESEL
JOIN Polisy ON Samochody.VIN = Polisy.samochod_VIN
JOIN Platnosci ON Polisy.ID_Polisy = Platnosci.polisa_ID
GROUP BY 
    Wlasciciele.Imie,
    Wlasciciele.Nazwisko
ORDER BY 'Suma wydatków na ubezpieczenie' DESC;


-- 4. Oblicz œredni¹ liczbê wypadków przypadaj¹c¹ na klientów w poprzednim roku. 
-- Mo¿e byæ u¿yteczne do celów statystycznych, lepszego zrozumienia, ile œrednio wypadków maj¹ klienci, oraz do analizy trendów dotycz¹cych liczby wypadków.
SELECT 
    AVG(TotalAccidents) AS 'Œrednia liczba wypadków w poprzednim roku'
FROM (
    SELECT 
        COUNT(Wypadki.ID_Wypadku) AS TotalAccidents
    FROM Samochody 
    JOIN Wlasciciele ON Samochody.wlasciciel_PESEL = Wlasciciele.PESEL 
    JOIN Polisy ON Samochody.VIN = Polisy.samochod_VIN 
    JOIN Wypadki ON Polisy.ID_Polisy = Wypadki.polisa_ID 
    WHERE Wypadki.Data_wypadku >= CAST(GETDATE() - 730 AS DATE)
	  AND Wypadki.Data_wypadku < CAST(GETDATE() - 365 AS DATE)
    GROUP BY 
        Wlasciciele.Imie, 
        Wlasciciele.Numer_telefonu, 
        Samochody.VIN
) AS AccidentCounts;


-- 5. Poka¿ posortowan¹ listê w³aœcicieli pojazdów, numerów telefonów oraz liczby wypadków dotycz¹cych ich pojazdów w poprzednim roku. 
-- Mo¿e byæ u¿yte do analizy statystycznej i oceny ryzyka ubezpieczeniowego.
SELECT
    Wlasciciele.Imie AS 'Imiê',
    Wlasciciele.Numer_telefonu AS 'Numer telefonu',
    Samochody.VIN AS 'VIN',
    (SELECT COUNT(Wypadki.ID_Wypadku)
     FROM Wypadki
     JOIN Polisy ON Polisy.ID_Polisy = Wypadki.polisa_ID
     WHERE Wypadki.Data_wypadku >= CAST(GETDATE() - 730 AS DATE)
	  AND Wypadki.Data_wypadku < CAST(GETDATE() - 365 AS DATE)
      AND Polisy.samochod_VIN = Samochody.VIN) AS 'Liczba wypadków w poprzednim roku'
FROM Samochody
JOIN Wlasciciele ON Samochody.wlasciciel_PESEL = Wlasciciele.PESEL
JOIN Polisy ON Samochody.VIN = Polisy.samochod_VIN
ORDER BY 'Liczba wypadków w poprzednim roku' DESC;


-- 6. Poka¿ listê w³aœcicieli pojazdów oraz liczbê wypadków ich pojazdów w ci¹gu ostatnich 30 dni. 
-- Mo¿e to byæ wykorzystane do oceny ryzyka zwi¹zanego z potencjalnie niebezpiecznymi klientami i analizy ryzykownych zachowañ kierowców.
SELECT
    Wlasciciele.Imie AS 'Imiê',
	Wlasciciele.Nazwisko AS 'Nazwisko',
    Wlasciciele.Numer_telefonu AS 'Numer telefonu',
    Samochody.VIN AS 'VIN',
    COUNT(Wypadki.ID_Wypadku) AS 'Liczba wypadków w ci¹gu ostatnich 30 dni'
FROM Samochody
JOIN Wlasciciele ON Samochody.wlasciciel_PESEL = Wlasciciele.PESEL
JOIN Polisy ON Samochody.VIN = Polisy.samochod_VIN
JOIN Wypadki ON Polisy.ID_Polisy = Wypadki.polisa_ID
WHERE Wypadki.Data_wypadku >= CAST(GETDATE() - 30 AS DATE)
GROUP BY Wlasciciele.Imie, Wlasciciele.Nazwisko, Wlasciciele.Numer_telefonu, Samochody.VIN
HAVING COUNT(Wypadki.ID_Wypadku) >= 2;


-- 7. Utwórz widok zawieraj¹cy szczegó³owe informacje o polisach, pojazdach i w³aœcicielach (VIEW)
-- Widok umo¿liwia szybki dostêp do kompleksowych informacji o polisach, bez potrzeby sk³adania z³o¿onych zapytañ.
GO
CREATE VIEW SzczegolyPolis AS
SELECT 
    Wlasciciele.Imie AS 'Imiê', 
    Wlasciciele.Nazwisko AS 'Nazwisko', 
    Samochody.Numer_rejestracyjny AS 'Numer rejestracyjny', 
    Polisy.ID_Polisy AS 'ID Polisy', 
    Polisy.StatusPolisy AS 'Status', 
    Polisy.Data_rozpoczecia AS 'Data rozpoczêcia'
FROM Polisy
JOIN Samochody ON Polisy.samochod_VIN = Samochody.VIN
JOIN Wlasciciele ON Samochody.wlasciciel_PESEL = Wlasciciele.PESEL;
GO
-- Wyœwietlenie danych z widoku SzczegolyPolis
SELECT * FROM SzczegolyPolis;
-- Usuniêcie widoku SzczegolyPolis po zakoñczeniu analizy
DROP VIEW SzczegolyPolis;