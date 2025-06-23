DROP TABLE IF EXISTS DBO.Wydzia³y
CREATE TABLE Wydzia³y(
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
IDWydzia³u char(5) not null
)

DROP TABLE IF EXISTS DBO.Specjalnoœci_Pracowników
CREATE TABLE Specjalnoœci_Pracowników(
ID INT PRIMARY KEY,
PracID int not null,
SpecID char(5) not null
)

DROP TABLE IF EXISTS dbo.Specjalnoœci
CREATE TABLE Specjalnoœci(
SpecID char(5) Primary KEY,
SpecNazwa varchar(100) not null,
SpecIloœæPrac int null
)

ALTER TABLE Wydzia³y
ADD FOREIGN KEY (IDSzefa) REFERENCES Pracownicy(PracID)

ALTER TABLE Pracownicy
ADD FOREIGN KEY (IDWydzia³u) REFERENCES Wydzia³y(WydzID)

ALTER TABLE Specjalnoœci_Pracowników
ADD FOREIGN KEY (PracID) REFERENCES Pracownicy(PracID)

ALTER TABLE Specjalnoœci_Pracowników
ADD FOREIGN KEY (SpecID) REFERENCES Specjalnoœci(SpecID)


ALTER TABLE Specjalnoœci
ADD CONSTRAINT CHK_SpecIloœæPrac_Pos CHECK(SpecIloœæPrac >=0)

ALTER TABLE Wydzia³y
ADD DataPowstania DATE

CREATE INDEX ID_Pracownicy_Miasto
ON Pracownicy(PracMiasto)


--Polecenie: Zabezpiecz, aby PracNrBudynku w Pracownicy nie móg³ zawieraæ pustego tekstu ('').
ALTER TABLE Pracownicy
ADD CONSTRAINT CHK_NoEmptyString_PracNrBudynku check(PracNrBudynku is null or PracNrBudynku <> '')

--Polecenie: Dodaj kolumnê EmailSzefa typu VARCHAR(100) do tabeli Wydzia³y z domyœln¹ wartoœci¹ NULL.
ALTER TABLE Wydzia³y
ADD EmailSzefa VARCHAR(100) NULL

--Polecenie: Stwórz indeks na PracNazwisko, aby przyspieszyæ zapytania wyszukuj¹ce po nazwisku.
CREATE INDEX ind_PracNazwisko
ON Pracownicy(PracNazwisko)
--Polecenie: Zapisz pe³ny backup bazy TRENING do pliku TRENING_FULL.bak.
BACKUP DATABASE EGZ
TO DISK = 
WITH FORMAT, INIT;

RESTORE DATABASE EGZ
FROM DISK
WITH REPLACE

--Polecenie: Przywróæ bazê TRENING z pliku, nadpisuj¹c istniej¹c¹ bazê.

--Polecenie: Po dodaniu nowego wpisu do Specjalnoœci_Pracowników, zwiêksz SpecIloœæPrac o 1 w tabeli Specjalnoœci.
CREATE OR ALTER TRIGGER TR_SpecIloœæO1
ON SpecjalnoœæI_Pracowników
AFTER INSERT
AS
BEGIN
	UPDATE Specjalnoœci
	SET SpecIloœæPrac = SpecIloœæPrac + 1
	WHERE SpecID IN (SELECT SpecID FROM INSERTED)
END

--Polecenie: Nie pozwalaj na usuniêcie pracownika, jeœli jest on szefem jakiegokolwiek wydzia³u.
CREATE TRIGGER TRG_NieUsuwajSzefa
ON Pracownicy
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM deleted d
        JOIN Wydzia³y w ON w.IDSzefa = d.PracID
    )
    BEGIN
        RAISERROR('Nie mo¿na usun¹æ pracownika, który jest szefem wydzia³u.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DELETE FROM Pracownicy
    WHERE PracID IN (SELECT PracID FROM deleted);
END;
--Polecenie: Dodaj specjalnoœæ, przypisz j¹ pracownikowi, zaktualizuj dane, a nastêpnie usuñ wpis z tabeli poœrednicz¹cej.
INSERT INTO Specjalnoœci (SpecID, SpecNazwa) VALUES ('DEV', 'Development');
INSERT INTO Specjalnoœci_Pracowników (ID, PracID, SpecID) VALUES (10, 1, 'DEV');

-- UPDATE
UPDATE Pracownicy
SET PracMiasto = 'Kraków'
WHERE PracID = 1;

-- DELETE
DELETE FROM Specjalnoœci_Pracowników WHERE ID = 10;
--Polecenie: Utwórz login i u¿ytkownika, który ma dostêp tylko do przegl¹dania tabeli Wydzia³y.
CREATE LOGIN Czytelnik WITH Password = 'Czytelnik123'
CREATE USER Czytelnik FOR LOGIN Czytelnik

GRANT SELECT ON Wydzia³y to Czytelnik
--Polecenie: Dodaj kolumnê typu VARCHAR(20) do Wydzia³y z domyœln¹ wartoœci¹ 'etatyczny'.
ALTER TABLE WYDZIA£Y
ADD Nowa VARCHAR(20) DEFAULT 'Etatyczny'

DROP dbo.Specjalnoœci