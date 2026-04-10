CREATE TABLE Wlasciciele (
    PESEL VARCHAR(11) PRIMARY KEY,      
    Nazwisko VARCHAR(50) NOT NULL CHECK (LEN(Nazwisko) BETWEEN 3 AND 50 AND Nazwisko LIKE '%[A-Za-z]'),        
    Imie VARCHAR(50) NOT NULL CHECK (LEN(Imie) BETWEEN 3 AND 50 AND Imie LIKE '%[A-Za-z]'),
    Numer_telefonu VARCHAR(9) UNIQUE NOT NULL CHECK (LEN(Numer_telefonu) = 9 AND ISNUMERIC(Numer_telefonu) = 1)
);

CREATE TABLE Typy_polis (
    Typ VARCHAR(50) PRIMARY KEY,         
    Koszt_okresu DECIMAL(10, 2) NOT NULL,          
    Okres_platnosci INT NOT NULL CHECK (Okres_platnosci >= 1)
);

CREATE TABLE Marki_samochodow (
    ID_MarkiModeli VARCHAR(100) PRIMARY KEY,  
    Marka VARCHAR(50) NOT NULL CHECK (LEN(Marka) BETWEEN 3 AND 50 AND Marka LIKE '%[A-Za-z]'),                  
    Model VARCHAR(50) NOT NULL CHECK (LEN(Model) BETWEEN 2 AND 50)
);

CREATE TABLE Typy_wypadkow (
    ID_TypuWypadku INT IDENTITY(1,1) PRIMARY KEY,      
    Kategoria_wypadku VARCHAR(50) NOT NULL CHECK (LEN(Kategoria_wypadku) BETWEEN 3 AND 50 AND Kategoria_wypadku LIKE '%[A-Za-z ]'),        
    Stopien_powagi INT NOT NULL CHECK (Stopien_powagi BETWEEN 1 AND 10)
);

CREATE TABLE Samochody (
    VIN VARCHAR(17) PRIMARY KEY,          
    Numer_rejestracyjny VARCHAR(10) UNIQUE NOT NULL CHECK (LEN(Numer_rejestracyjny) BETWEEN 3 AND 10),    
    Kolor VARCHAR(25) NOT NULL CHECK (LEN(Kolor) BETWEEN 3 AND 25 AND Kolor LIKE '%[A-Za-z]'),
	wlasciciel_PESEL VARCHAR(11) NOT NULL,
    marka_ID VARCHAR(100) NOT NULL,
    FOREIGN KEY (wlasciciel_PESEL) REFERENCES Wlasciciele(PESEL),
    FOREIGN KEY (marka_ID) REFERENCES Marki_samochodow(ID_MarkiModeli)
);

CREATE TABLE Polisy (
    ID_Polisy INT IDENTITY(1,1) PRIMARY KEY, 
    StatusPolisy VARCHAR(20) NOT NULL CHECK (LEN(StatusPolisy) BETWEEN 3 AND 20 AND StatusPolisy LIKE '%[A-Za-z]'),           
    Data_rozpoczecia DATE NOT NULL CHECK (Data_rozpoczecia >= '2000-01-01'),  
    Data_zakoncznie_okresu DATE NOT NULL CHECK (Data_zakoncznie_okresu >= '2000-01-01'),
    samochod_VIN VARCHAR(17) NOT NULL,
	typ_polisy VARCHAR(50) NOT NULL,
    FOREIGN KEY (samochod_VIN) REFERENCES Samochody(VIN),
	FOREIGN KEY (typ_polisy) REFERENCES Typy_polis(Typ)
);

CREATE TABLE Platnosci (
    ID_Platnosci INT IDENTITY(1,1) PRIMARY KEY, 
    Kwota DECIMAL(10, 2) NOT NULL,   
    Data_platnosci DATE NOT NULL CHECK (Data_platnosci >= '2000-01-01'),
	polisa_ID INT NOT NULL,
	FOREIGN KEY (polisa_ID) REFERENCES Polisy(ID_Polisy)
);

CREATE TABLE Znizki (
    ID_Znizki INT IDENTITY(1,1) PRIMARY KEY,            
    Procent_znizki DECIMAL(4, 1) NOT NULL CHECK (Procent_znizki >= 0 AND Procent_znizki <= 100),        
    Liczba_objetych_okresow INT NOT NULL CHECK (Liczba_objetych_okresow >= 1),
	polisa_ID INT NOT NULL,
	FOREIGN KEY (polisa_ID) REFERENCES Polisy(ID_Polisy)
);

CREATE TABLE Wypadki (
    ID_Wypadku INT IDENTITY(1,1) PRIMARY KEY,          
    Data_wypadku DATE NOT NULL CHECK (Data_wypadku >= '2000-01-01'),
	polisa_ID INT NOT NULL,
    typ_ID INT NOT NULL,
    FOREIGN KEY (polisa_ID) REFERENCES Polisy(ID_Polisy),
    FOREIGN KEY (typ_ID) REFERENCES Typy_wypadkow(ID_TypuWypadku)
);
