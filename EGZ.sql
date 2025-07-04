--1.Wy�wietl klient�w maj�cych siedzib� w miastach zaczynaj�cych si� na liter� �L� a na
--trzeciej pozycji maj�ce liter� �o�.
SELECT *
FROM Klienci
WHERE Miasto Like 'L_o%'

--2. Wy�wietl klient�w, kt�rzy nie posiadaj� faksu.
SELECT *
FROM Klienci
WHERE Faks is  null

--3. Wy�wietl klient�w, kt�rzy mieszkaj� w Londynie, Pary�u, Madrycie lub Mediolanie. Zadanie wykonaj wszystkimi mo�liwymi metodami.
SELECT *
FROM Klienci
WHERE Miasto = 'LondYn' OR Miasto =  'Pary�' OR MIASTO='MADRYT' OR Miasto =  'Mediolan'

SELECT * FROM Klienci
WHERE Miasto IN ('Pary�','Madryt','Mediolan','Londyn')
--4. Wy�wietl warto�� wszystkich pozycji zam�wie�.
SELECT SUM(CenaJednostkowa*Ilo��) AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
--5. Wy�wietl wszystkich klient�w, kt�rzy mieszkaj� mie�cie o nazwie wi�kszej od Londynu.
SELECT *
FROM KLIENCI
WHERE LEN(MIASTO) > LEN('Londyn')
--6. Wy�wietl klient�w, kt�rzy mieszkaj� w Londynie, nie maj� faksu a nazwa firmy zaczyna
--si� od liter A, B, C lub K.
SELECT *
FROM Klienci
WHERE Miasto = 'Londyn' AND Faks IS NULL AND (NazwaFirmy LIKE 'A%' OR NazwaFirmy LIKE 'B%' OR NazwaFirmy LIKE 'C%' OR NazwaFirmy LIKE 'K%')
--7. Wy�wietl ranking pracownik�w wed�ug ilo�ci przyj�tych zam�wie�.
SELECT P.IDpracownika, P.Imi�, P.Nazwisko, COUNT(Z.IDZAM�WIENIA) AS ILE
FROM Pracownicy AS P INNER JOIN Zam�wienia AS Z ON P.IDpracownika = Z.IDpracownika
GROUP BY P.IDpracownika, P.Imi�, P.Nazwisko
ORDER BY ILE DESC
--8. Podaj warto�� zam�wie� wzgl�dem kraj�w, wynik ma zosta� pouk�adany od warto�ci
--najwi�kszej do najmniejszej.
SELECT Kraj, SUM(Ilo��*CenaJednostkowa) AS WARTO��
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Kraj
ORDER BY WARTO�� DESC
--9. Wy�wietl warto�� z�o�onych przez klient�w zam�wie�.
SELECT K.IDklienta, K.NazwaFirmy, SUM(CenaJednostkowa*ILO��) AS WARTO��
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY K.IDklienta, K.NazwaFirmy
ORDER BY WARTO�� DESC

--10. Wy�wietl klient�w, kt�rzy sumarycznie z�o�yli zam�wienia na warto�� wi�ksz� ni�
--50 000 PLN.
SELECT K.IDklienta, K.NazwaFirmy, SUM(CenaJednostkowa*ILO��) AS WARTO��
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY K.IDklienta, K.NazwaFirmy
HAVING SUM(CenaJednostkowa * Ilo��) > 50000
--11. Nale�y wy�wietli� rozk�ad pracownik�w w ka�dym dziale ze wzgl�du na p�e�.
SELECT DISTINCT STANOWISKO,
(SELECT COUNT(IDPRACOWNIKA)
FROM Pracownicy AS M WHERE (M.ZwrotGrzeczno�ciowy = 'Mr.' or M.ZwrotGrzeczno�ciowy ='Dr.') and m.Stanowisko = p.Stanowisko) as ilo��_m�czyzn,
(SELECT COUNT(IDPRACOWNIKA)
FROM Pracownicy AS M WHERE (M.ZwrotGrzeczno�ciowy = 'Ms.' or M.ZwrotGrzeczno�ciowy ='Mrs.') and m.Stanowisko = p.Stanowisko) as ilo��_kobiet
FROM Pracownicy AS P
--12. Podaj najcz�ciej i najrzadziej zamawiany towar w 1997 roku.
SELECT  P.IDproduktu,NazwaProduktu, COUNT(PZ.IDproduktu) AS ILE
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
WHERE DataWysy�ki BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY P.IDproduktu, NazwaProduktu
ORDER BY ILE DESC

--13. Wy�wietl rozk�ad ilo�ci urodze� pracownik�w w zale�no�ci od dnia tygodnia.
SELECT DATENAME(WEEKDAY, DataUrodzenia) AS DzienTygodnia, COUNT(*) AS Liczba
FROM Pracownicy
GROUP BY DATENAME(WEEKDAY, DataUrodzenia)
--14. Wy�wietl warto�� zam�wie� za 1997 rok. Zadanie wykonaj wszystkimi mo�liwymi
--sposobami.
SELECT SUM(CenaJednostkowa*Ilo��) AS WAR
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE DataZam�wienia BETWEEN '1997-01-01' AND '1997-12-31'

--15. Sprawd�, czy na li�cie produkt�w jest taki, kt�rego ani jedna sztuka nie zosta�a
--zam�wiona.
SELECT * 
FROM mg.Produkty P
LEFT JOIN PozycjeZam�wienia PZ ON P.IDproduktu = PZ.IDproduktu
WHERE PZ.IDproduktu IS NULL

--15a. Poka� wszystkich klient�w kt�rzy nie z�o�yli zam�wienia
SELECT *
FROM Klienci AS K LEFT JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
WHERE Z.IDklienta IS NULL
--16. Policz, ile pozycji zawiera ka�de zam�wienie, wy�wietli� nale�y ID zam�wienia i ilo�� jej
--pozycji.
SELECT IDzam�wienia, COUNT(*) AS ILO��
FROM PozycjeZam�wienia
GROUP BY IDzam�wienia
--17. Podaj, kt�re miasto wyst�puje najcz�ciej w danych adresowych.
SELECT TOP 1 MIASTO, COUNT(*) AS ILE
FROM Klienci
GROUP BY Miasto
ORDER BY ILE DESC

--18. Podaj nazwisko i imi� najstarszego i najm�odszego pracownika.
SELECT TOP 1 Imi�, Nazwisko
FROM Pracownicy
ORDER BY DataUrodzenia DESC

SELECT TOP 1 Imi�, Nazwisko
FROM Pracownicy
ORDER BY DataUrodzenia 
--19. Poda� nazwisko, imi� i wiek w latach wszystkich pracownik�w, kt�rzy s� starsi o co
--najmniej 10 lat od najm�odszego pracownika.
SELECT Nazwisko, Imi�, DATEDIFF(YEAR,DataUrodzenia,GETDATE()) AS WIEK
FROM Pracownicy
WHERE DATEDIFF(
YEAR,DataUrodzenia,GETDATE()) >=
(SELECT DATEDIFF(YEAR, MAX(DataUrodzenia), GETDATE()) + 10
FROM Pracownicy)
--20. Oblicz �redni� warto�� zam�wie�.
SELECT AVG(CenaJednostkowa*Ilo��)
FROM PozycjeZam�wienia AS PZ
--21. Zam�wienia po ostatnim zam�wieniu na "Tofu"
SELECT IDzam�wienia,IDklienta,DataZam�wienia
FROM Zam�wienia
WHERE DataZam�wienia >(
SELECT MAX(DataZam�wienia)
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
WHERE P.NazwaProduktu = 'Tofu' 
)
--Poda� nazw� kategorii, ID produktu, nazw� produktu i jego cen�, dla wszystkich
--produkt�w, kt�rych cena jednostkowa jest wi�ksza od �redniej ceny produkt�w
--kategorii, do kt�rej produkt nale�y.


SELECT 
    K.NazwaKategorii, 
    P.IDProduktu, 
    P.NazwaProduktu, 
    P.CenaJednostkowa
FROM 
    mg.Produkty AS P
JOIN mg.Kategorie AS K ON P.IDKategorii = K.IDKategorii
WHERE 
    P.CenaJednostkowa > (
        SELECT AVG(P2.CenaJednostkowa)
        FROM mg.Produkty AS P2
        WHERE P2.IDKategorii = P.IDKategorii
    );

--23. Rozk�ad p�ci wg stanowiska 
SELECT 
    Stanowisko,
    COUNT(*) AS LiczbaPracownik�w
FROM 
    Pracownicy
GROUP BY 
    Stanowisko;


--25. Nale�y dokona� rankingu kraj�w wed�ug warto�ci z�o�onych zam�wie�
SELECT KrajOdbiorcy, SUM(CenaJednostkowa*Ilo��) AS WAR
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY KrajOdbiorcy
ORDER BY WAR DESC

--26.Poka� klient�w, kt�rzy nie z�o�yli �adnego zam�wienia, bez u�ycia klauzuli OUTER JOIN
SELECT *
FROM Klienci
WHERE IDklienta NOT IN ( SELECT DISTINCT IDklienta FROM Zam�wienia)

-- 28.Zdefiniuj widok wy�wietlaj�cy ID pracownika i ilo�� przyj�tych przez niego zam�wie�
--w 1997 roku.
CREATE VIEW vw_Pracownik_Zam�wienia_1997
AS
SELECT IDpracownika, COUNT(*) AS LICZBA
FROM Zam�wienia AS Z
WHERE YEAR(DataZam�wienia)=1997
GROUP BY IDpracownika

--29. U�ytkownikowi Magazynier nadaj prawa do czytania widoku viewProduktyMin.
GRANT SELECT ON viewProduktyMin TO Magazynier;

CREATE FUNCTION fn_war_zam_klienta (@IDKlienta nvarchar(5))
RETURNS MONEY
AS
BEGIN
DECLARE @WYNIK MONEY
SELECT @WYNIK = SUM(CenaJednostkowa * Ilo��)
FROM Zam�wienia Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE Z.IDklienta = @IDKlienta

RETURN @WYNIK


--Wy�wietl klient�w i zam�wienia, kt�re z�o�yli
SELECT *
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta


--Wy�wietl klient�w i zam�wienia, kt�re z�o�yli mi�dzy 1997-01-01 a 1997-01-14 w��cznie.
SELECT *
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
WHERE DataZam�wienia BETWEEN '1997-01-01' AND '1997-01-14'

--Wy�wietl tych klient�w, kt�rzy nie z�o�yli �adnego zam�wienia.
SELECT *
FROM Klienci AS K LEFT OUTER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
WHERE Z.IDklienta IS NULL

--Wy�wietl klient�w i kategorie towar�w, kt�re zam�wili.
SELECT DISTINCT NazwaFirmy, KA.NazwaKategorii
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZam�wienia AS PZ ON PZ.IDzam�wienia = Z.IDzam�wienia INNER JOIN MG.Produkty
AS P ON P.IDproduktu = PZ.IDproduktu INNER JOIN MG.Kategorie AS KA ON P.IDkategorii = KA.IDkategorii

--Poka� tych pracownik�w, kt�rzy przyj�li przynajmniej jedno zam�wienie.
SELECT DISTINCT P.Imi�, P.Nazwisko
FROM Pracownicy AS P
INNER JOIN Zam�wienia AS Z ON P.IDpracownika = Z.IDpracownika

--Poka� klient�w, kt�rzy nigdy nie zam�wili s�odyczy.
SELECT IDKLIENTA
FROM KLIENCI 
WHERE IDklienta NOT IN(
SELECT IDklienta
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = pz.IDzam�wienia
INNER JOIN mg.Produkty AS PR ON PZ.IDproduktu = PR.IDproduktu
INNER JOIN mg.Kategorie AS KA ON PR.IDkategorii = KA.IDkategorii
WHERE KA.NazwaKategorii ='S�odycze')

--Poka� klient�w mieszkaj�cych w Londynie, kt�rzy z�o�yli zam�wienie 2 lipca 1997 roku
SELECT *
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
WHERE K.Miasto = 'Londyn' and z.DataZam�wienia = '1997-07-02'

--Wy�wietl wszystkie produkty, kt�re zakupi� klient o ID r�wnym �MACKI�
SELECT DISTINCT PR.NazwaProduktu
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
INNER JOIN mg.Produkty AS PR ON PZ.IDproduktu = PR.IDproduktu
WHERE Z.IDklienta = 'MACKI'

--Wy�wietl nazw� i kod tych produkt�w, kt�re zosta�y wycofane	
SELECT IDproduktu, NazwaProduktu
FROM MG.Produkty
WHERE Wycofany = 1

--Wy�wietl produkty o cenie wi�kszej od 25 z�.
SELECT *
FROM MG.Produkty
WHERE CenaJednostkowa > 25

--Wy�wietl klient�w maj�cych siedzib� w miastach zaczynaj�cych si� na liter� �L�.
SELECT IDklienta, NazwaFirmy
FROM Klienci 
WHERE Miasto LIKE 'L%'

--Wy�wietl warto�� wszystkich pozycji zam�wie� wi�kszych od 100 z�
SELECT	CenaJednostkowa* Ilo��
FROM PozycjeZam�wienia
WHERE CenaJednostkowa* Ilo�� > 100

--Wy�wietl klient�w, kt�rzy nie posiadaj� faksu.
SELECT *
FROM Klienci
WHERE FAKS IS NULL

--Nale�y wy�wietli� wszystkie miasta wyst�puj�ce bazie danych
SELECT MIASTO
FROM Klienci
UNION 
SELECT MIASTO
FROM mg.Dostawcy
UNION 
SELECT MIASTO
FROM Pracownicy

--Sprawd�, czy na li�cie produkt�w jest taki, z kt�rego ani jedna sztuka nie zosta�a sprzedana
SELECT IDproduktu, NazwaProduktu
FROM MG.Produkty
EXCEPT
SELECT PR.IDproduktu, NazwaProduktu
FROM mg.Produkty AS PR INNER JOIN PozycjeZam�wienia AS PZ ON PR.IDproduktu = PZ.IDproduktu

--Wy�wietl ranking klient�w wed�ug ilo�ci z�o�onych zam�wie�. 
SELECT Z.IDklienta, COUNT(*) AS ILO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.IDklienta
ORDER BY ILO�� DESC

--Wy�wietl ranking pracownik�w wed�ug ilo�ci przyj�tych zam�wie�.
SELECT P.IDpracownika, COUNT(*) AS ILO��
FROM Pracownicy AS P INNER JOIN Zam�wienia AS Z ON P.IDpracownika = Z.IDpracownika
GROUP BY P.IDpracownika
ORDER BY ILO�� DESC

--Podaj warto�� zam�wie� wzgl�dem kraj�w, wynik ma zosta� pouk�adany od warto�ci najwi�kszej
--wielko�ci do najmniejszej.
SELECT KrajOdbiorcy, SUM(CenaJednostkowa*Ilo��)AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY KrajOdbiorcy
ORDER BY WARTO�� DESC

--Wy�wietl warto�� z�o�onych przez klient�w zam�wie�.
SELECT Z.IDklienta, SUM(CenaJednostkowa*Ilo��) AS WARTOSC
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.IDklienta

--Wy�wietl klient�w, kt�rzy sumarycznie z�o�yli zam�wienia na warto�� wi�ksz� ni� 50 000 PLN.
SELECT Z.IDklienta, SUM(CenaJednostkowa*Ilo��) AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.IDklienta
HAVING SUM(CenaJednostkowa*Ilo��) > 50000

--Nale�y wy�wietli� ilo�� pracownik�w na ka�dym stanowisku ze wzgl�du na p�e�.
SELECT DISTINCT STANOWISKO,
(SELECT COUNT(*) FROM Pracownicy WHERE ZwrotGrzeczno�ciowy in ('Dr.','mr.') and p.Stanowisko = Stanowisko) as ilo��_m�czyzn,
(SELECT COUNT(*) FROM Pracownicy WHERE ZwrotGrzeczno�ciowy in ('ms.','mrs.') and p.Stanowisko = Stanowisko) as ilo��_kobiet
from Pracownicy as p

--Podaj najcz�ciej i najrzadziej zamawiany towar w 1997 roku.
SELECT TOP 1 PZ.IDproduktu,COUNT(*) AS ILE
FROM PozycjeZam�wienia AS PZ INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
GROUP BY PZ.IDproduktu
ORDER BY ILE DESC

SELECT TOP 1 PZ.IDproduktu,COUNT(*) AS ILE
FROM PozycjeZam�wienia AS PZ INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
GROUP BY PZ.IDproduktu
ORDER BY ILE 

--Wy�wietl warto�� zam�wie� za 1997 rok. Zadanie wykonaj wszystkimi mo�liwymi sposobami.
SELECT SUM(CenaJednostkowa*Ilo��)AS WAR
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE YEAR(Z.DataZam�wienia) = 1997

--Sprawd�, czy na li�cie produkt�w jest taki, z kt�rego ani jedna sztuka nie zosta�a zam�wiona.
SELECT *
FROM mg.Produkty
WHERE IDproduktu NOT IN (

SELECT PZ.IDproduktu
FROM PozycjeZam�wienia AS PZ
GROUP BY PZ.IDproduktu)

SELECT IDproduktu
FROM mg.Produkty
EXCEPT
SELECT PZ.IDproduktu
FROM PozycjeZam�wienia AS PZ
GROUP BY PZ.IDproduktu
-- Policz, ile pozycji zawiera ka�de zam�wienie, wy�wietli� nale�y ID zam�wienia i ilo�� jego pozycji
SELECT IDzam�wienia, COUNT(*) AS ILE_POZYCJI
FROM PozycjeZam�wienia AS PZ
GROUP BY PZ.IDzam�wienia


--Podaj, kt�re miasto wyst�puje najcz�ciej w danych adresowych
SELECT TOP 1 Miasto, ilo��
FROM(
SELECT Miasto, count(Miasto) as ilo�� 
FROM (
SELECT MIASTO
FROM Pracownicy
UNION ALL
SELECT MIASTO
FROM Klienci
UNION ALL
SELECT MIASTO
FROM mg.Dostawcy
) AS TM
 GROUP BY Miasto) AS M
 ORDER BY ilo�� DESC

 --Podaj nazwisko i imi� najstarszego i najm�odszego pracownika.
 SELECT Imi�, Nazwisko
 FROM 
 ( SELECT TOP 1 Imi�, Nazwisko
	FROM Pracownicy
	ORDER BY DataUrodzenia DESC
	UNION
	SELECT TOP 1 Imi�, Nazwisko
	FROM Pracownicy
	ORDER BY DataUrodzenia 
 ) AS prac

 --Poda� nazwisko, imi� i wiek w latach wszystkich pracownik�w, kt�rzy s� starsi o co najmniej 10 lat od
--najm�odszego pracownika.
SELECT Nazwisko, Imi�, YEAR(GETDATE()) - YEAR(DataUrodzenia) AS WIEK
FROM Pracownicy
WHERE YEAR(GETDATE()) - YEAR(DataUrodzenia) >
(
SELECT TOP 1 YEAR(GETDATE()) - YEAR(DataUrodzenia) + 10 AS WIEK
FROM Pracownicy
ORDER BY WIEK 
)

--Oblicz �redni� warto�� zam�wie�.
SELECT AVG(WAR)
FROM
(
SELECT SUM(CenaJednostkowa*Ilo��) AS WAR
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON PZ.IDzam�wienia = Z.IDzam�wienia
GROUP BY Z.IDzam�wienia) AS WARTO��_ZAM�WIE�


--Podaj ID zam�wienia, ID klienta i dat� zam�wienia dla wszystkich zam�wie� z�o�onych p�niej ni� data
--ostatniego zam�wienia towaru o nazwie �Tofu�.
SELECT Z.IDzam�wienia, Z.IDklienta, Z.DataZam�wienia
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE DataZam�wienia > (
SELECT TOP 1 DataZam�wienia
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
WHERE P.NazwaProduktu = 'Tofu'
ORDER BY DataZam�wienia DESC
)

--Poda� nazw� kategorii, ID produktu, nazw� produktu i jego cen�, dla wszystkich produkt�w, kt�rych
--cena jednostkowa jest wi�ksza od �redniej ceny produkt�w kategorii, do kt�rej produkt nale�y.
SELECT KA.NazwaKategorii, PR.IDproduktu, PR.NazwaProduktu, PR.CenaJednostkowa
FROM mg.Produkty AS PR INNER JOIN mg.Kategorie AS KA ON PR.IDkategorii = KA.IDkategorii
WHERE CenaJednostkowa > (
SELECT AVG(CenaJednostkowa) AS �REDNIA
FROM mg.Produkty AS P INNER JOIN mg.Kategorie AS K ON P.IDkategorii = K.IDkategorii
WHERE KA.IDkategorii = k.IDkategorii)

--Nale�y dokona� rankingu kraj�w wed�ug warto�ci z�o�onych zam�wie�
SELECT KrajOdbiorcy, SUM(CenaJednostkowa*Ilo��) AS WAR
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY KrajOdbiorcy
ORDER BY WAR DESC
--Poka� produkty, kt�rych cena jest wi�ksza od ceny �redniej produkt�w w kategorii do kt�rej nale��. 
SELECT K.IDklienta, K.NazwaFirmy, K.Miasto, K.Kraj
FROM Klienci AS K
INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
GROUP BY K.IDklienta, K.NazwaFirmy, K.Miasto, K.Kraj
HAVING SUM((SELECT SUM(PZ.CenaJednostkowa * PZ.Ilo��) 
             FROM PozycjeZam�wienia AS PZ 
             WHERE PZ.IDzam�wienia = Z.IDzam�wienia)) >
       (
         SELECT AVG(WAR)
         FROM (
            SELECT K2.Miasto, SUM(PZ2.CenaJednostkowa * PZ2.Ilo��) AS WAR
            FROM Klienci AS K2
            INNER JOIN Zam�wienia AS Z2 ON K2.IDklienta = Z2.IDklienta
            INNER JOIN PozycjeZam�wienia AS PZ2 ON Z2.IDzam�wienia = PZ2.IDzam�wienia
            WHERE K2.Miasto = K.Miasto
            GROUP BY K2.IDklienta
         ) AS MiastoSrednie
       )
--Podaj IDKlienta, Nazw�Firmy, Miasto i Kraj, tych klient�w, kt�rych warto�� zam�wie� by� wi�ksza od
--�redniej warto�ci zam�wie� w mie�cie w kt�rym maj� siedzib�

--1. Zdefiniuj widok obliczaj�cy warto�ci poszczeg�lnych zam�wie�.
CREATE VIEW vw_War_Posz_Zam
AS
SELECT Z.IDzam�wienia, SUM(CenaJednostkowa*Ilo��) AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.IDzam�wienia

SELECT *
FROM vw_War_Posz_Zam
--2. Zastosuj zdefiniowany widok do obliczenia �redniej warto�ci zam�wie�.
SELECT AVG(WARTO��)
FROM vw_War_Posz_Zam
--3. Zdefiniuj widok wy�wietlaj�cy ID pracownika i ilo�� przyj�tych przez niego zam�wie� w 1997 roku
CREATE VIEW vw_Pracownicy_Zam�wienia_1997
AS
SELECT Z.IDpracownika, COUNT(*) AS PRZYJ�TE
FROM Pracownicy AS P INNER JOIN Zam�wienia AS Z ON Z.IDpracownika = P.IDpracownika
WHERE YEAR(DATAZAM�WIENIA) = 1997
GROUP BY Z.IDpracownika
--Zdefiniuj funkcj� zwracaj�c� warto�� zam�wie� klienta, parametrem wej�ciowym funkcji jest identyfikator
--klienta.
	CREATE FUNCTION fn_War_Zam_Klient (@IDKLIENTA CHAR(5))
RETURNS MONEY
AS
BEGIN
DECLARE @WAR MONEY 
	SELECT @WAR = SUM(CenaJednostkowa*Ilo��)
	FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
	WHERE Z.IDklienta = @IDKLIENTA
	RETURN @WAR
END
GO
SELECT dbo.fn_War_Zam_Klient('ALFKI');
--Zdefiniuj funkcj� zwracaj�c� inicja�y. Parametrami wej�ciowymi s� nazwisko i imi�
CREATE FUNCTION fn_Inicjaly (@Imie NVARCHAR(50), @Nazwisko NVARCHAR(50))
RETURNS CHAR(2)
AS
BEGIN
    RETURN LEFT(@Imie, 1) + LEFT(@Nazwisko, 1)
END
GO
--Napisz funkcj� sprawdzaj�c� istnienie tabeli. Parametrem wej�ciowym jest nazwa tabeli (CHAR(128)).
--Funkcja zwraca 0 je�eli tabela istnieje, 1 je�eli tabela nie istnieje, NULL w przypadku b��dnych
--parametr�w.
CREATE FUNCTION fn_CzyIstniejeTabela (@NazwaTabeli CHAR(128))
RETURNS INT
AS
BEGIN
    IF @NazwaTabeli IS NULL OR LEN(@NazwaTabeli) = 0 RETURN NULL
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @NazwaTabeli)
        RETURN 0
    ELSE
        RETURN 1
END
GO
--Zdefiniuj funkcj� obliczaj�c� silni� liczby podanej jako parametr wej�ciowy
CREATE FUNCTION SILNIA (@LICZBA INT)
RETURNS BIGINT
AS
BEGIN
DECLARE @WYNIK BIGINT = 1
IF @LICZBA < 0 RETURN NULL
WHILE @LICZBA > 1
BEGIN
SET @WYNIK = @WYNIK * @LICZBA
SET @LICZBA = @LICZBA -1
END
RETURN @WYNIK
END
GO
SELECT dbo.SILNIA(5);
--Zdefiniuj funkcj� zwacaj�c� tabel� zawieraj�c�: ID, nazw� i miasto klienta, ID zam�wienia i jego warto��.
--Kluczem podstawowym jest ID klienta i ID zam�wienia.
CREATE FUNCTION TABELA_KLIENCI()
RETURNS TABLE
AS
RETURN
SELECT K.IDklienta, K.NazwaFirmy, K.Miasto, Z.IDzam�wienia, SUM(CenaJednostkowa*Ilo��) AS WARTOSC
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON Z.IDklienta = K.IDklienta 
INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY K.IDklienta, K.NazwaFirmy, K.Miasto,Z.IDzam�wienia

SELECT *
from dbo.TABELA_KLIENCI();
--Zdefiniuj procedur� sk�adowan� zwracaj�c� zam�wienia klienta. Pokaza� nale�y: ID klienta, jego nazw�,
--ID zam�wienia i dat� zam�wienia. Parametrem wej�ciowym jest identyfikator klienta. 
CREATE PROCEDURE pr_Zam�wienia_klienta(@IDKlienta nvarchar(5))
AS
BEGIN
SELECT K.IDklienta, K.NazwaFirmy, Z.IDzam�wienia, Z.DataZam�wienia
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
INNER JOIN PozycjeZam�wienia AS PZ ON PZ.IDzam�wienia = Z.IDzam�wienia
WHERE K.IDklienta = @IDKlienta

END
GO

exec pr_Zam�wienia_Klienta 'ALFKI'
--Zdefiniuj procedur� wy�wietlaj�c� przeterminowane zam�wienia
--Napisz funkcj� sprawdzaj�c� istnienie tabeli. Parametrem wej�ciowym jest nazwa
--tabeli (CHAR(128)). Funkcja zwraca 0 je�eli tabela istnieje, 1 je�eli tabela nie istnieje,
--NULL w przypadku b��dnych parametr�w.

CREATE FUNCTION fn_czy_istnieje (@Nazwa char(128))
returns bit
as
BEGIN
if LEN(@Nazwa)=0 or @Nazwa is null
return null
if EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @Nazwa)
RETURN 1
ELSE
RETURN 0
END
GO

--Zdefiniuj funkcj� obliczaj�c� silni� liczby podanej jako parametr wej�ciowy.
CREATE FUNCTION fn_factorian (@liczba int)
RETURNS BIGINT
AS
BEGIN
DECLARE @WYNIK BIGINT = 1
IF @liczba < 0 RETURN NULL
WHILE @liczba > 1
BEGIN
	SET @Wynik = @Wynik* @Liczba
	SET @Liczba = @Liczba -1
	END
	return @Wynik
END

--Zdefiniuj procedur� sk�adowan� zwracaj�c� zam�wienia klienta. Pokaza� nale�y: ID
--klienta, jego nazw�, ID zam�wienia i dat� zam�wienia. Parametrem wej�ciowym jest
--identyfikator klienta.

CREATE OR ALTER PROCEDURE pr_Zam_Klienta(@IDKlienta varchar(5))
AS
BEGIN
SELECT K.IDklienta,K.NazwaFirmy,Z.IDzam�wienia,Z.DataZam�wienia
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
WHERE Z.IDklienta = @IDKlienta
END
GO
EXEC pr_Zam_Klienta 'ALFKI'

--Zdefiniuj procedur� wy�wietlaj�c� warto�� zam�wienia o identyfikatorze podanym
--parametrem. Gdy warto�ci parametru nie podano nale�y wy�wietli� warto��
--wszystkich zam�wie�. Wy�wietli� nale�y id zam�wienia, id klienta i warto��.
--W przypadku wy�wietlenia warto�ci wszystkich zam�wie� w miejsce identyfikatora
--klienta nale�y poda� warto�� �ALL�.

CREATE OR ALTER PROCEDURE pr_Ja_jebie_nie_zdam(@ID int)
AS
BEGIN
IF @ID IS NULL
BEGIN
SELECT 'ALL', SUM(CenaJednostkowa*Ilo��) AS Warto��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
END
ELSE
SELECT Z.IDzam�wienia,Z.IDklienta, SUM(CenaJednostkowa*Ilo��) AS Warto��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE Z.IDzam�wienia = @ID
GROUP BY Z.IDzam�wienia,Z.IDklienta
END
GO

EXEC pr_Ja_jebie_nie_zdam null

--Zdefiniuj procedur� sk�adowan� zawracaj�c� id zam�wienia, dat� zam�wienia
--i warto�� zam�wienia dla zdefiniowanego parametrami wej�ciowymi okresu
--czasowego. Nale�y uwzgl�dni� obs�ug� poprawno�ci warto�ci parametr�w
--wej�ciowych

CREATE OR ALTER PROCEDURE pr_Przedzia�_czasowy
@Data_Start datetime, @Data_Stop datetime
AS
BEGIN
IF @Data_Start > @Data_Stop 
BEGIN
RAISERROR ('Data start jest z przysz�o�ci',16,1);
RETURN;
END
IF @Data_Start IS NULL OR @Data_Stop IS NULL
BEGIN
RAISERROR ('PODANO NIEPOPRAWNE DANE',16,1);
RETURN;
END
SELECT Z.IDzam�wienia, Z.DataZam�wienia, SUM(CenaJednostkowa*Ilo��)AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE Z.DataZam�wienia BETWEEN @Data_Start AND @Data_Stop
GROUP BY Z.IDzam�wienia, Z.DataZam�wienia
END
GO

EXEC pr_Przedzia�_czasowy @Data_Start = '1997-01-01', @Data_Stop = '1997-12-31';


--Zdefiniuj kursor zwracaj�cy ID produktu, nazw� produktu i cen� jednostkow�,
--a nast�pnie kod przegl�daj�cy kursor z zatrzymaniem na 10 wierszu i potwierdzaj�cym
--to komunikatem 'jeste�my na 10 wierszu'.
DECLARE @IDproduktu INT, 
        @NazwaProduktu NVARCHAR(100), 
        @CenaJednostkowa MONEY,
        @Licznik INT = 0;

-- Definicja kursora
DECLARE KursorProdukty CURSOR FOR
SELECT IDproduktu, NazwaProduktu, CenaJednostkowa
FROM mg.Produkty;

-- Otwarcie kursora
OPEN KursorProdukty;

-- Pobranie pierwszego rekordu
FETCH NEXT FROM KursorProdukty INTO @IDproduktu, @NazwaProduktu, @CenaJednostkowa;

-- Przegl�danie danych
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Licznik = @Licznik + 1;

    -- Wy�wietlenie danych (opcjonalne � pomocne w testach)
    PRINT CAST(@Licznik AS VARCHAR) + '. ' + @NazwaProduktu + ' (' + CAST(@CenaJednostkowa AS VARCHAR) + ' z�)';

    -- Sprawdzenie, czy to 10. wiersz
    IF @Licznik = 10
    BEGIN
        PRINT 'Jeste�my na 10 wierszu';
        BREAK; -- zako�czenie przegl�dania po 10 wierszu
    END

    FETCH NEXT FROM KursorProdukty INTO @IDproduktu, @NazwaProduktu, @CenaJednostkowa;
END

-- Zamkni�cie i usuni�cie kursora
CLOSE KursorProdukty;
DEALLOCATE KursorProdukty;

--Dla ka�dego klienta ze Stan�w Zjednoczonych A.P. nale�y poda� jego zam�wienia z ich
--warto�ciami, obs�uguj�cych go pracownik�w i list� kategorii produkt�w, kt�re
--zamawia�. Dane nale�y zapisa� w tabeli tymczasowej o postaci [id klienta],
--[id zam�wienia], [id pracownika], [id kategorii].

DROP TABLE IF EXISTS dbo.#DaneKlient�wUSA
CREATE TABLE #DaneKlient�wUSA(
IDKlienta varchar(5),
IDZam�wienia int,
IDPracownika int,
IDKategorii int
)
INSERT INTO #DaneKlient�wUSA
SELECT Z.IDklienta, Z.IDzam�wienia, P.IDpracownika, PR.IDkategorii
FROM Pracownicy AS P INNER JOIN Zam�wienia AS Z ON P.IDpracownika = Z.IDpracownika
INNER JOIN PozycjeZam�wienia AS PZ ON PZ.IDzam�wienia = Z.IDzam�wienia
INNER JOIN mg.Produkty AS PR ON PZ.IDproduktu = PR.IDproduktu
WHERE Z.KrajOdbiorcy = 'USA'

--Wy�wietl kolejnych 10 klient�w rozpoczynaj�c od 10, poda� nale�y ich id, nazw� i kraj.
SELECT IDklienta, NazwaFirmy, Kraj
FROM Klienci
ORDER BY IDklienta
OFFSET 9 ROWS FETCH NEXT 10 ROWS ONLY;

--Wy�wietl wszystkie miasta wyst�puj�ce w danych bazy [Northwind].
SELECT Miasto
FROM Pracownicy
UNION
SELECT Miasto
FROM Klienci
UNION
SELECT Miasto
FROM MG.Dostawcy

--Wy�wietl miasta, w kt�rych mieszkaj� i klienci i pracownicy.
SELECT MIASTO
FROM Pracownicy
INTERSECT
SELECT Miasto
FROM Klienci

--Wy�wietl miasta, w kt�rych maj� siedzib� dostawcy a nie mieszkaj� pracownicy.
SELECT Miasto
FROM mg.Dostawcy
EXCEPT
SELECT Miasto
FROM Pracownicy

--Nale�y wy�wietli� ilo�� zam�wie� z�o�onych w ka�dym roku.
SELECT YEAR(Z.DataZam�wienia), COUNT(*) AS ILE
FROM Zam�wienia AS Z
GROUP BY YEAR(Z.DataZam�wienia)

--Dla tabeli Produkty nale�y wprowadzi� ograniczenie nie pozwalaj�ce na przyj�cie
--warto�ci ujemnych przez kolumn� [CenaJednostkowa].
ALTER TABLE Produkty
ADD CONSTRAINT CHK_CenaJednostkowa_NieUjemna CHECK (CenaJednostkowa >= 0);
--Zdefiniuj wyzwalacz, kt�ry operacj� usuni�cia produktu zamienia na zmian� warto�ci
--kolumny [Wycofano] na 1.
CREATE TRIGGER tr_ZamienUsuniecieNaWycofanie
ON mg.Produkty
INSTEAD OF DELETE
AS
BEGIN
    -- Aktualizujemy kolumn� Wycofano na 1 zamiast usuwa� rekord
    UPDATE P
    SET P.Wycofano = 1
    FROM Produkty AS P
    INNER JOIN deleted AS D ON P.IDproduktu = D.IDproduktu
END

--Zdefiniuj wyzwalacz, kt�ry nie pozwoli na zatrudnienie pracownika, kt�ry nie uko�czy�
--18 lat. 
CREATE TRIGGER tr_pe�noletno��_pracownik�w
ON PRACOWNICY
AFTER INSERT
AS
BEGIN
	IF Exists (
	SELECT 1
	FROM inserted
	WHERE DATEDIFF(YEAR, DataUrodzenia,GetDate())<18
	)
	BEGIN
	RAISERROR('Pracownik musi by� pe�noletni',16,1)
	Rollback TRANSACTION
	END
END
GO;

/*
b) Bezpo�rednio do pliku na dysku:
                                        BACKUP DATABASE nazwa_bazy
                                        TO DISK = 'D:\backup\plik.bak';
                                        GO

c) Backup r�nicowy:
                                        BACKUP DATABASE nazwa_bazy
                                        TO DISK = 'D:\backup\plik_diff.bak'
                                        WITH DIFFERENTIAL;
                                        GO

d) Backup dziennika transakcji:
                                       BACKUP LOG nazwa_bazy
                                       TO DISK = 'D:\backup\plik.trn';
                                       GO

a) w celu nadpisania istniej�cych danych:
                                       BACKUP DATABASE nazwa_bazy
                                       TO nazwa_backup_device WITH INIT;
                                       GO

b) aby dopisa� do no�nika now� kopi� zapasow� (opcja domy�lna):
                                       BACKUP DATABASE nazwa_bazy
                                       TO nazwa_backup_device WITH NOINIT;
                                       GO

Aby odtworzy� baz� z poziomu SQL, nale�y napisa�:
                             USE master
                             GO                   
                             RESTORE DATABASE nazwa_bazy
                             FROM DISK = '�cie�ka'
                             [WITH REPLACE];
                             GO
I dalej, w celu odtworzenia dziennika transakcji, z poziomu SQL nale�y napisa�:
                                RESTORE LOG nazwa_bazy
                                FROM DISK = '�cie�ka'
                                   WITH FILE = 1,
                                   WITH NORECOVERY;
                                GO
i przywr�cenia bazy do u�ytkowania:
                                RESTORE DATABASE nazwa_bazy
                                WITH RECOVERY;
                                GO
*/

--Wy�wietl klient�w, kt�rzy z�o�yli zam�wienia w 1997 roku i mieszkaj� w Niemczech.
SELECT k.idklienta, NazwaFirmy
FROM Klienci as k INNER JOIN Zam�wienia AS Z on K.IdKlienta = Z.idklienta
WHERE K.kraj =	'Niemcy' AND Year(DataZam�wienia)=1997


--Poka� produkty, kt�rych cena jednostkowa jest wy�sza ni� �rednia cena w ich kategorii.
SELECT *
FROM mg.Produkty as P iNNER JOIN POZYCJEZAM�WIENIA AS PZ ON p.idproduktu = pz.idproduktu
WHERE P.CENAJEDNOSTKOWA >
(
SELECT AVG(CENAJEDNOSTKOWA)
FROM mg.Produkty AS PR INNER JOIN MG.Kategorie AS KA ON PR.IDkategorii = KA.IDkategorii
WHERE P.IDkategorii = PR.IDkategorii
)
--Dla ka�dego klienta podaj liczb� jego zam�wie� oraz ��czn� warto�� wszystkich zam�wie�.
SELECT Z.IDklienta, COUNT(*) AS ILE_ZAM�WIE�, SUM(CenaJednostkowa*Ilo��) AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.IDklienta
--Znajd� pracownik�w, kt�rzy nigdy nie obs�u�yli �adnego zam�wienia.
SELECT *
FROM Pracownicy AS PR
WHERE PR.IDpracownika NOT IN (
SELECT P.IDpracownika
FROM Pracownicy AS P INNER JOIN Zam�wienia AS Z ON P.IDpracownika = Z.IDpracownika
GROUP BY P.IDpracownika
)
--Wy�wietl ranking kraj�w wed�ug warto�ci zam�wie� (od najwy�szego)
SELECT Z.KrajOdbiorcy, SUM(CenaJednostkowa*Ilo��)AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.KrajOdbiorcy
ORDER BY WARTO�� DESC
--Utw�rz widok pokazuj�cy IDzam�wienia, dat� i warto�� zam�wienia.
CREATE OR ALTER VIEW vw_1
AS
SELECT Z.IDzam�wienia, DataZam�wienia, SUM(CenaJednostkowa*Ilo��)AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.IDzam�wienia, DataZam�wienia

SELECT *
FROM vw_1
--Utw�rz widok zwracaj�cy pracownik�w oraz liczb� ich zam�wie� z roku 1997.
CREATE OR ALTER VIEW vw_2
AS
SELECT Z.IDpracownika, COUNT(*) AS ILE
FROM Pracownicy AS P INNER JOIN Zam�wienia AS Z ON P.IDpracownika = Z.IDpracownika
GROUP BY Z.IDpracownika

SELECT *
FROM vw_2
--Utw�rz widok pokazuj�cy klient�w, kt�rzy z�o�yli wi�cej ni� 5 zam�wie�.
CREATE OR ALTER VIEW vw_3
AS
SELECT Z.IDklienta,COUNT(*) AS ILE
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
GROUP BY Z.IDklienta
HAVING COUNT(*) > 5

SELECT *
FROM vw_3
--Utw�rz widok pokazuj�cy produkty, kt�re zosta�y wycofane (Wycofano = 1).
CREATE OR ALTER VIEW vw_4	
AS
SELECT *
FROM mg.Produkty
WHERE Wycofany = 1
--Utw�rz widok zwracaj�cy klient�w, kt�rzy zam�wili przynajmniej jeden produkt z kategorii �S�odycze�.
SELECT *
FROM KLIENCI AS K INNER JOIN Zam�wienia AS ZA ON K.IDklienta = ZA.IDklienta
WHERE K.IDklienta NOT IN (
SELECT Z.IDklienta
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
INNER JOIN mg.Produkty AS PR ON PZ.IDproduktu = PR.IDproduktu
INNER JOIN mg.Kategorie AS KA ON PR.IDkategorii = KA.IDkategorii
WHERE KA.NazwaKategorii = 'S�odycze'
)
--Zdefiniuj procedur� przyjmuj�c� dat� pocz�tkow� i ko�cow� i zwracaj�c� zam�wienia w tym przedziale (z obs�ug� b��d�w daty).
CREATE OR ALTER PROCEDURE PR_1
@OD DATETIME, @DO DATETIME
AS
BEGIN
	IF @OD IS NULL OR @DO IS NULL
	BEGIN
	RAISERROR('Podaj daty',16,1)
	RETURN
	END
	IF @OD > @DO
	BEGIN
	RAISERROR('Podano daty w z�ej kolejno�ci!',16,1)
	RETURN
	END
	SELECT *
	FROM Zam�wienia
	WHERE DataZam�wienia BETWEEN @OD AND @DO
END
EXEC PR_1 '1997-01-01', '1997-12-31';
--Zdefiniuj procedur�, kt�ra przyjmie ID klienta i wypisze wszystkie jego zam�wienia z dat� i warto�ci�.
CREATE OR ALTER PROCEDURE pr_2 @IDKlienta varchar(5)
AS
BEGIN
SELECT Z.IDzam�wienia, SUM(CenaJednostkowa*Ilo��)AS ILE
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE Z.IDklienta = @IDKlienta
GROUP BY Z.IDzam�wienia
END

EXEC pr_2 'ALFKI'
--Zdefiniuj procedur�, kt�ra przyjmie nazw� kraju i wypisze wszystkich klient�w z tego kraju oraz ich liczb� zam�wie�.
CREATE OR ALTER PROCEDURE pr_3 @KRAJ VARCHAR(100)
AS
BEGIN
SELECT K.IDklienta, COUNT(*) AS ILE
FROM Klienci AS K INNER JOIN Zam�wienia AS Z ON K.IDklienta = Z.IDklienta
WHERE K.Kraj = @KRAJ
GROUP BY K.IDklienta
END

EXEC pr_3 'Niemcy'
--Zdefiniuj procedur�, kt�ra doda nowy produkt do tabeli Produkty (z podstawowymi walidacjami np. cena > 0).
CREATE OR ALTER PROCEDURE pr_4
    @Nazwa NVARCHAR(100),
    @Cena MONEY,
    @IDkategorii INT,
    @IDdostawcy INT
AS
BEGIN
    IF @Cena <= 0
    BEGIN
        RAISERROR('Cena musi by� wi�ksza od zera.', 16, 1);
        RETURN;
    END

    INSERT INTO mg.Produkty (NazwaProduktu, CenaJednostkowa, IDkategorii, IDdostawcy, Wycofany)
    VALUES (@Nazwa, @Cena, @IDkategorii, @IDdostawcy, 0)
END
GO
--Zdefiniuj procedur� tworz�c� kopi� tabeli Klienci do tymczasowej tabeli #BackupKlienci
CREATE OR ALTER PROCEDURE pr_5
AS
BEGIN
    SELECT * INTO #BackupKlienci
    FROM Klienci
END
GO
--Zdefiniuj funkcj� skalarn�, kt�ra przyjmuje ID klienta i zwraca ��czn� warto�� jego zam�wie�.
CREATE OR ALTER FUNCTION fn_1 (@IDKlienta varchar(5))
RETURNS MONEY
AS
BEGIN
DECLARE @WAR MONEY = 0
SELECT @WAR = SUM(CenaJednostkowa*Ilo��)
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE Z.IDklienta = @IDKlienta
RETURN @WAR
END
GO
SELECT DBO.fn_1('ALFKI')
--Zdefiniuj funkcj� tabelaryczn�, kt�ra dla danego kraju zwraca list� klient�w z tego kraju.
CREATE OR ALTER FUNCTION fn_2 (@Kraj varchar(100))
RETURNS TABLE
AS
RETURN
SELECT *
FROM Klienci AS K
WHERE K.Kraj = @Kraj

SELECT *
FROM fn_2('USA')
--Zdefiniuj funkcj� skalarn�, kt�ra oblicza �redni� warto�� zam�wienia klienta.
CREATE OR ALTER FUNCTION fn_3 (@IDKlienta varchar(5))
RETURNS MONEY
AS
BEGIN
DECLARE @WAR MONEY = 0
SELECT @WAR = AVG(WARTO��) FROM (
SELECT SUM(CenaJednostkowa*Ilo��) AS WARTO��
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
WHERE Z.IDklienta = @IDKlienta) AS SUMA
RETURN @WAR
END

SELECT dbo.fn_3('Alfki')
--Zdefiniuj funkcj� tabelaryczn�, kt�ra dla danego ID produktu zwraca wszystkie zam�wienia, w kt�rych si� pojawi�.
CREATE OR ALTER FUNCTION fn_4 (@IDPRODUKTU INT)
RETURNS TABLE
AS
RETURN
SELECT Z.IDzam�wienia
FROM Zam�wienia AS Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wienia
INNER JOIN mg.Produkty AS PR ON PZ.IDproduktu = PR.IDproduktu
WHERE PR.IDproduktu = @IDPRODUKTU

SELECT *
FROM fn_4(1)
--Zdefiniuj funkcj� skalarn�, kt�ra przyjmuje rok i zwraca liczb� zam�wie� z tego roku.
CREATE OR ALTER FUNCTION fn_5 (@ROK INT)
RETURNS INT
AS
BEGIN
DECLARE @WYNIK INT = 0
SELECT @WYNIK= COUNT(*)
FROM Zam�wienia AS Z
WHERE YEAR(Z.DataZam�wienia) = @ROK
RETURN @WYNIK
END
SELECT DBO.fn_5(1997)
