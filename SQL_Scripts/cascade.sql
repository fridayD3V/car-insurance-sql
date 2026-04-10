ALTER TABLE Wypadki
ADD CONSTRAINT FK_Wypadki_Polisy
FOREIGN KEY (polisa_ID) REFERENCES Polisy(ID_Polisy)
ON DELETE CASCADE;

ALTER TABLE Znizki
ADD CONSTRAINT FK_Znizki_Polisy
FOREIGN KEY (polisa_ID) REFERENCES Polisy(ID_Polisy)
ON DELETE CASCADE;

ALTER TABLE Platnosci
ADD CONSTRAINT FK_Platnosci_Polisy
FOREIGN KEY (polisa_ID) REFERENCES Polisy(ID_Polisy)
ON DELETE CASCADE;

ALTER TABLE Polisy
ADD CONSTRAINT FK_Polisy_Samochody
FOREIGN KEY (samochod_VIN) REFERENCES Samochody(VIN)
ON DELETE CASCADE;

ALTER TABLE Samochody
ADD CONSTRAINT FK_Wlasciciel 
FOREIGN KEY (wlasciciel_PESEL) REFERENCES Wlasciciele(PESEL) 
ON DELETE CASCADE;

DELETE FROM Wlasciciele WHERE PESEL = '12345678901';
DELETE FROM Polisy WHERE ID_Polisy = 5;

SELECT * FROM Wlasciciele;
SELECT * FROM Samochody;
SELECT * FROM Polisy;
SELECT * FROM Platnosci;
SELECT * FROM Znizki;
SELECT * FROM Wypadki;



ALTER TABLE Polisy
ADD CONSTRAINT FK_Polisa_Typ 
FOREIGN KEY (typ_polisy) REFERENCES Typy_polis(Typ) 
ON UPDATE CASCADE;

UPDATE Typy_polis SET Typ = 'Super_OC' WHERE Typ = 'OC';

SELECT * FROM Typy_polis;
SELECT * FROM Polisy;


ALTER TABLE Samochody
ADD CONSTRAINT FK_Samochody_Typ 
FOREIGN KEY (marka_ID) REFERENCES Marki_samochodow(ID_MarkiModeli) 
ON UPDATE CASCADE;

UPDATE Marki_samochodow SET ID_MarkiModeli = 'Toyota' WHERE ID_MarkiModeli = 'Toyota_Corolla';

SELECT * FROM Marki_samochodow;
SELECT * FROM Samochody;