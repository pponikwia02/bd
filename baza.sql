DROP TABLE IF EXISTS DBO.Wydzia�y
CREATE TABLE Wydzia�y(
WydzID char(5) primary key,
WydzNazwa varchar(100) not null,
IDSzefa int null
)

DROP TABLE IF EXISTS DBO.Pracownicy
CREATE TABLE Pracownicy(
PracID int PRIMARY KEY,
PracNazwisko varchar(50) not null,
PracImie varchar(50) not null,
PracMiasto varchar(50) null,
PracUlicna varchar(50) null,
PracNrBudynku varchar(5) null,
IDWydzia�u char(5) not null
)

DROP TABLE IF EXISTS DBO.Specjalno�ci_Pracownik�w
CREATE TABLE Specjalno�ci_Pracownik�w(
ID INT PRIMARY KEY,
PracID int not null,
SpecID char(5) not null
)

DROP TABLE IF EXISTS dbo.Specjalno�ci
CREATE TABLE Specjalno�ci(
SpecID char(5) Primary KEY,
SpecNazwa varchar(100) not null,
SpecIlo��Prac int null
)

ALTER TABLE Wydzia�y
ADD FOREIGN KEY (IDSzefa) REFERENCES Pracownicy(PracID)

ALTER TABLE Pracownicy
ADD FOREIGN KEY (IDWydzia�u) REFERENCES Wydzia�y(WydzID)

ALTER TABLE Specjalno�ci_Pracownik�w
ADD FOREIGN KEY (PracID) REFERENCES Pracownicy(PracID)

ALTER TABLE Specjalno�ci_Pracownik�w
ADD FOREIGN KEY (SpecID) REFERENCES Specjalno�ci(SpecID)


ALTER TABLE Specjalno�ci
ADD CONSTRAINT CHK_SpecIlo��Prac_Pos CHECK(SpecIlo��Prac >=0)

ALTER TABLE Wydzia�y
ADD DataPowstania DATE

CREATE INDEX ID_Pracownicy_Miasto
ON Pracownicy(PracMiasto)


--Polecenie: Zabezpiecz, aby PracNrBudynku w Pracownicy nie m�g� zawiera� pustego tekstu ('').
ALTER TABLE Pracownicy
ADD CONSTRAINT CHK_NoEmptyString_PracNrBudynku check(PracNrBudynku is null or PracNrBudynku <> '')

--Polecenie: Dodaj kolumn� EmailSzefa typu VARCHAR(100) do tabeli Wydzia�y z domy�ln� warto�ci� NULL.
ALTER TABLE Wydzia�y
ADD EmailSzefa VARCHAR(100) NULL

--Polecenie: Stw�rz indeks na PracNazwisko, aby przyspieszy� zapytania wyszukuj�ce po nazwisku.
CREATE INDEX ind_PracNazwisko
ON Pracownicy(PracNazwisko)
--Polecenie: Zapisz pe�ny backup bazy TRENING do pliku TRENING_FULL.bak.
BACKUP DATABASE EGZ
TO DISK = 
WITH FORMAT, INIT;

RESTORE DATABASE EGZ
FROM DISK
WITH REPLACE

--Polecenie: Przywr�� baz� TRENING z pliku, nadpisuj�c istniej�c� baz�.

--Polecenie: Po dodaniu nowego wpisu do Specjalno�ci_Pracownik�w, zwi�ksz SpecIlo��Prac o 1 w tabeli Specjalno�ci.
CREATE OR ALTER TRIGGER TR_SpecIlo��O1
ON Specjalno��I_Pracownik�w
AFTER INSERT
AS
BEGIN
	UPDATE Specjalno�ci
	SET SpecIlo��Prac = SpecIlo��Prac + 1
	WHERE SpecID IN (SELECT SpecID FROM INSERTED)
END

--Polecenie: Nie pozwalaj na usuni�cie pracownika, je�li jest on szefem jakiegokolwiek wydzia�u.
CREATE TRIGGER TRG_NieUsuwajSzefa
ON Pracownicy
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM deleted d
        JOIN Wydzia�y w ON w.IDSzefa = d.PracID
    )
    BEGIN
        RAISERROR('Nie mo�na usun�� pracownika, kt�ry jest szefem wydzia�u.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DELETE FROM Pracownicy
    WHERE PracID IN (SELECT PracID FROM deleted);
END;
--Polecenie: Dodaj specjalno��, przypisz j� pracownikowi, zaktualizuj dane, a nast�pnie usu� wpis z tabeli po�rednicz�cej.
INSERT INTO Specjalno�ci (SpecID, SpecNazwa) VALUES ('DEV', 'Development');
INSERT INTO Specjalno�ci_Pracownik�w (ID, PracID, SpecID) VALUES (10, 1, 'DEV');

-- UPDATE
UPDATE Pracownicy
SET PracMiasto = 'Krak�w'
WHERE PracID = 1;

-- DELETE
DELETE FROM Specjalno�ci_Pracownik�w WHERE ID = 10;
--Polecenie: Utw�rz login i u�ytkownika, kt�ry ma dost�p tylko do przegl�dania tabeli Wydzia�y.
CREATE LOGIN Czytelnik WITH Password = 'Czytelnik123'
CREATE USER Czytelnik FOR LOGIN Czytelnik

GRANT SELECT ON Wydzia�y to Czytelnik
--Polecenie: Dodaj kolumn� typu VARCHAR(20) do Wydzia�y z domy�ln� warto�ci� 'etatyczny'.
ALTER TABLE WYDZIA�Y
ADD Nowa VARCHAR(20) DEFAULT 'Etatyczny'

DROP dbo.Specjalno�ci