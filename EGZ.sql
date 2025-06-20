--1.Wyœwietl klientów maj¹cych siedzibê w miastach zaczynaj¹cych siê na literê ‘L’ a na
--trzeciej pozycji maj¹ce literê ‘o’.
SELECT *
FROM Klienci
WHERE Miasto Like 'L_o%'

--2. Wyœwietl klientów, którzy nie posiadaj¹ faksu.
SELECT *
FROM Klienci
WHERE Faks is  null

--3. Wyœwietl klientów, którzy mieszkaj¹ w Londynie, Pary¿u, Madrycie lub Mediolanie. Zadanie wykonaj wszystkimi mo¿liwymi metodami.
SELECT *
FROM Klienci
WHERE Miasto = 'LondYn' OR Miasto =  'Pary¿' OR MIASTO='MADRYT' OR Miasto =  'Mediolan'

SELECT * FROM Klienci
WHERE Miasto IN ('Pary¿','Madryt','Mediolan','Londyn')
--4. Wyœwietl wartoœæ wszystkich pozycji zamówieñ.
SELECT SUM(CenaJednostkowa*Iloœæ) AS WARTOŒÆ
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
--5. Wyœwietl wszystkich klientów, którzy mieszkaj¹ mieœcie o nazwie wiêkszej od Londynu.
SELECT *
FROM KLIENCI
WHERE LEN(MIASTO) > LEN('Londyn')
--6. Wyœwietl klientów, którzy mieszkaj¹ w Londynie, nie maj¹ faksu a nazwa firmy zaczyna
--siê od liter A, B, C lub K.
SELECT *
FROM Klienci
WHERE Miasto = 'Londyn' AND Faks IS NULL AND (NazwaFirmy LIKE 'A%' OR NazwaFirmy LIKE 'B%' OR NazwaFirmy LIKE 'C%' OR NazwaFirmy LIKE 'K%')
--7. Wyœwietl ranking pracowników wed³ug iloœci przyjêtych zamówieñ.
SELECT P.IDpracownika, P.Imiê, P.Nazwisko, COUNT(Z.IDZAMÓWIENIA) AS ILE
FROM Pracownicy AS P INNER JOIN Zamówienia AS Z ON P.IDpracownika = Z.IDpracownika
GROUP BY P.IDpracownika, P.Imiê, P.Nazwisko
ORDER BY ILE DESC
--8. Podaj wartoœæ zamówieñ wzglêdem krajów, wynik ma zostaæ pouk³adany od wartoœci
--najwiêkszej do najmniejszej.
SELECT Kraj, SUM(Iloœæ*CenaJednostkowa) AS WARTOŒÆ
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY Kraj
ORDER BY WARTOŒÆ DESC
--9. Wyœwietl wartoœæ z³o¿onych przez klientów zamówieñ.
SELECT K.IDklienta, K.NazwaFirmy, SUM(CenaJednostkowa*ILOŒÆ) AS WARTOŒÆ
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY K.IDklienta, K.NazwaFirmy
ORDER BY WARTOŒÆ DESC

--10. Wyœwietl klientów, którzy sumarycznie z³o¿yli zamówienia na wartoœæ wiêksz¹ ni¿
--50 000 PLN.
SELECT K.IDklienta, K.NazwaFirmy, SUM(CenaJednostkowa*ILOŒÆ) AS WARTOŒÆ
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY K.IDklienta, K.NazwaFirmy
HAVING SUM(CenaJednostkowa * Iloœæ) > 50000
--11. Nale¿y wyœwietliæ rozk³ad pracowników w ka¿dym dziale ze wzglêdu na p³eæ.
SELECT DISTINCT STANOWISKO,
(SELECT COUNT(IDPRACOWNIKA)
FROM Pracownicy AS M WHERE (M.ZwrotGrzecznoœciowy = 'Mr.' or M.ZwrotGrzecznoœciowy ='Dr.') and m.Stanowisko = p.Stanowisko) as iloœæ_mê¿czyzn,
(SELECT COUNT(IDPRACOWNIKA)
FROM Pracownicy AS M WHERE (M.ZwrotGrzecznoœciowy = 'Ms.' or M.ZwrotGrzecznoœciowy ='Mrs.') and m.Stanowisko = p.Stanowisko) as iloœæ_kobiet
FROM Pracownicy AS P
--12. Podaj najczêœciej i najrzadziej zamawiany towar w 1997 roku.
SELECT  P.IDproduktu,NazwaProduktu, COUNT(PZ.IDproduktu) AS ILE
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
WHERE DataWysy³ki BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY P.IDproduktu, NazwaProduktu
ORDER BY ILE DESC

--13. Wyœwietl rozk³ad iloœci urodzeñ pracowników w zale¿noœci od dnia tygodnia.
SELECT DATENAME(WEEKDAY, DataUrodzenia) AS DzienTygodnia, COUNT(*) AS Liczba
FROM Pracownicy
GROUP BY DATENAME(WEEKDAY, DataUrodzenia)
--14. Wyœwietl wartoœæ zamówieñ za 1997 rok. Zadanie wykonaj wszystkimi mo¿liwymi
--sposobami.
SELECT SUM(CenaJednostkowa*Iloœæ) AS WAR
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
WHERE DataZamówienia BETWEEN '1997-01-01' AND '1997-12-31'

--15. SprawdŸ, czy na liœcie produktów jest taki, którego ani jedna sztuka nie zosta³a
--zamówiona.
SELECT * 
FROM mg.Produkty P
LEFT JOIN PozycjeZamówienia PZ ON P.IDproduktu = PZ.IDproduktu
WHERE PZ.IDproduktu IS NULL

--15a. Poka¿ wszystkich klientów którzy nie z³o¿yli zamówienia
SELECT *
FROM Klienci AS K LEFT JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta
WHERE Z.IDklienta IS NULL
--16. Policz, ile pozycji zawiera ka¿de zamówienie, wyœwietliæ nale¿y ID zamówienia i iloœæ jej
--pozycji.
SELECT IDzamówienia, COUNT(*) AS ILOŒÆ
FROM PozycjeZamówienia
GROUP BY IDzamówienia
--17. Podaj, które miasto wystêpuje najczêœciej w danych adresowych.
SELECT TOP 1 MIASTO, COUNT(*) AS ILE
FROM Klienci
GROUP BY Miasto
ORDER BY ILE DESC

--18. Podaj nazwisko i imiê najstarszego i najm³odszego pracownika.
SELECT TOP 1 Imiê, Nazwisko
FROM Pracownicy
ORDER BY DataUrodzenia DESC

SELECT TOP 1 Imiê, Nazwisko
FROM Pracownicy
ORDER BY DataUrodzenia 
--19. Podaæ nazwisko, imiê i wiek w latach wszystkich pracowników, którzy s¹ starsi o co
--najmniej 10 lat od najm³odszego pracownika.
SELECT Nazwisko, Imiê, DATEDIFF(YEAR,DataUrodzenia,GETDATE()) AS WIEK
FROM Pracownicy
WHERE DATEDIFF(
YEAR,DataUrodzenia,GETDATE()) >=
(SELECT DATEDIFF(YEAR, MAX(DataUrodzenia), GETDATE()) + 10
FROM Pracownicy)
--20. Oblicz œredni¹ wartoœæ zamówieñ.
SELECT AVG(CenaJednostkowa*Iloœæ)
FROM PozycjeZamówienia AS PZ
--21. Zamówienia po ostatnim zamówieniu na "Tofu"
SELECT IDzamówienia,IDklienta,DataZamówienia
FROM Zamówienia
WHERE DataZamówienia >(
SELECT MAX(DataZamówienia)
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
WHERE P.NazwaProduktu = 'Tofu' 
)
--Podaæ nazwê kategorii, ID produktu, nazwê produktu i jego cenê, dla wszystkich
--produktów, których cena jednostkowa jest wiêksza od œredniej ceny produktów
--kategorii, do której produkt nale¿y.


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

--23. Rozk³ad p³ci wg stanowiska 
SELECT 
    Stanowisko,
    COUNT(*) AS LiczbaPracowników
FROM 
    Pracownicy
GROUP BY 
    Stanowisko;


--25. Nale¿y dokonaæ rankingu krajów wed³ug wartoœci z³o¿onych zamówieñ
SELECT KrajOdbiorcy, SUM(CenaJednostkowa*Iloœæ) AS WAR
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY KrajOdbiorcy
ORDER BY WAR DESC

--26.Poka¿ klientów, którzy nie z³o¿yli ¿adnego zamówienia, bez u¿ycia klauzuli OUTER JOIN
SELECT *
FROM Klienci
WHERE IDklienta NOT IN ( SELECT DISTINCT IDklienta FROM Zamówienia)

-- 28.Zdefiniuj widok wyœwietlaj¹cy ID pracownika i iloœæ przyjêtych przez niego zamówieñ
--w 1997 roku.
CREATE VIEW vw_Pracownik_Zamówienia_1997
AS
SELECT IDpracownika, COUNT(*) AS LICZBA
FROM Zamówienia AS Z
WHERE YEAR(DataZamówienia)=1997
GROUP BY IDpracownika

--29. U¿ytkownikowi Magazynier nadaj prawa do czytania widoku viewProduktyMin.
GRANT SELECT ON viewProduktyMin TO Magazynier;

CREATE FUNCTION fn_war_zam_klienta (@IDKlienta nvarchar(5))
RETURNS MONEY
AS
BEGIN
DECLARE @WYNIK MONEY
SELECT @WYNIK = SUM(CenaJednostkowa * Iloœæ)
FROM Zamówienia Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
WHERE Z.IDklienta = @IDKlienta

RETURN @WYNIK


--Wyœwietl klientów i zamówienia, które z³o¿yli
SELECT *
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta


--Wyœwietl klientów i zamówienia, które z³o¿yli miêdzy 1997-01-01 a 1997-01-14 w³¹cznie.
SELECT *
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta
WHERE DataZamówienia BETWEEN '1997-01-01' AND '1997-01-14'

--Wyœwietl tych klientów, którzy nie z³o¿yli ¿adnego zamówienia.
SELECT *
FROM Klienci AS K LEFT OUTER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta
WHERE Z.IDklienta IS NULL

--Wyœwietl klientów i kategorie towarów, które zamówili.
SELECT DISTINCT NazwaFirmy, KA.NazwaKategorii
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta INNER JOIN PozycjeZamówienia AS PZ ON PZ.IDzamówienia = Z.IDzamówienia INNER JOIN MG.Produkty
AS P ON P.IDproduktu = PZ.IDproduktu INNER JOIN MG.Kategorie AS KA ON P.IDkategorii = KA.IDkategorii

--Poka¿ tych pracowników, którzy przyjêli przynajmniej jedno zamówienie.
SELECT DISTINCT P.Imiê, P.Nazwisko
FROM Pracownicy AS P
INNER JOIN Zamówienia AS Z ON P.IDpracownika = Z.IDpracownika

--Poka¿ klientów, którzy nigdy nie zamówili s³odyczy.
SELECT IDKLIENTA
FROM KLIENCI 
WHERE IDklienta NOT IN(
SELECT IDklienta
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = pz.IDzamówienia
INNER JOIN mg.Produkty AS PR ON PZ.IDproduktu = PR.IDproduktu
INNER JOIN mg.Kategorie AS KA ON PR.IDkategorii = KA.IDkategorii
WHERE KA.NazwaKategorii ='S³odycze')

--Poka¿ klientów mieszkaj¹cych w Londynie, którzy z³o¿yli zamówienie 2 lipca 1997 roku
SELECT *
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta
WHERE K.Miasto = 'Londyn' and z.DataZamówienia = '1997-07-02'

--Wyœwietl wszystkie produkty, które zakupi³ klient o ID równym ‘MACKI’
SELECT DISTINCT PR.NazwaProduktu
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
INNER JOIN mg.Produkty AS PR ON PZ.IDproduktu = PR.IDproduktu
WHERE Z.IDklienta = 'MACKI'

--Wyœwietl nazwê i kod tych produktów, które zosta³y wycofane	
SELECT IDproduktu, NazwaProduktu
FROM MG.Produkty
WHERE Wycofany = 1

--Wyœwietl produkty o cenie wiêkszej od 25 z³.
SELECT *
FROM MG.Produkty
WHERE CenaJednostkowa > 25

--Wyœwietl klientów maj¹cych siedzibê w miastach zaczynaj¹cych siê na literê ‘L’.
SELECT IDklienta, NazwaFirmy
FROM Klienci 
WHERE Miasto LIKE 'L%'

--Wyœwietl wartoœæ wszystkich pozycji zamówieñ wiêkszych od 100 z³
SELECT	CenaJednostkowa* Iloœæ
FROM PozycjeZamówienia
WHERE CenaJednostkowa* Iloœæ > 100

--Wyœwietl klientów, którzy nie posiadaj¹ faksu.
SELECT *
FROM Klienci
WHERE FAKS IS NULL

--Nale¿y wyœwietliæ wszystkie miasta wystêpuj¹ce bazie danych
SELECT MIASTO
FROM Klienci
UNION 
SELECT MIASTO
FROM mg.Dostawcy
UNION 
SELECT MIASTO
FROM Pracownicy

--SprawdŸ, czy na liœcie produktów jest taki, z którego ani jedna sztuka nie zosta³a sprzedana
SELECT IDproduktu, NazwaProduktu
FROM MG.Produkty
EXCEPT
SELECT PR.IDproduktu, NazwaProduktu
FROM mg.Produkty AS PR INNER JOIN PozycjeZamówienia AS PZ ON PR.IDproduktu = PZ.IDproduktu

--Wyœwietl ranking klientów wed³ug iloœci z³o¿onych zamówieñ. 
SELECT Z.IDklienta, COUNT(*) AS ILOŒÆ
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY Z.IDklienta
ORDER BY ILOŒÆ DESC

--Wyœwietl ranking pracowników wed³ug iloœci przyjêtych zamówieñ.
SELECT P.IDpracownika, COUNT(*) AS ILOŒÆ
FROM Pracownicy AS P INNER JOIN Zamówienia AS Z ON P.IDpracownika = Z.IDpracownika
GROUP BY P.IDpracownika
ORDER BY ILOŒÆ DESC

--Podaj wartoœæ zamówieñ wzglêdem krajów, wynik ma zostaæ pouk³adany od wartoœci najwiêkszej
--wielkoœci do najmniejszej.
SELECT KrajOdbiorcy, SUM(CenaJednostkowa*Iloœæ)AS WARTOŒÆ
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY KrajOdbiorcy
ORDER BY WARTOŒÆ DESC

--Wyœwietl wartoœæ z³o¿onych przez klientów zamówieñ.
SELECT Z.IDklienta, SUM(CenaJednostkowa*Iloœæ) AS WARTOSC
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY Z.IDklienta

--Wyœwietl klientów, którzy sumarycznie z³o¿yli zamówienia na wartoœæ wiêksz¹ ni¿ 50 000 PLN.
SELECT Z.IDklienta, SUM(CenaJednostkowa*Iloœæ) AS WARTOŒÆ
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY Z.IDklienta
HAVING SUM(CenaJednostkowa*Iloœæ) > 50000

--Nale¿y wyœwietliæ iloœæ pracowników na ka¿dym stanowisku ze wzglêdu na p³eæ.
SELECT DISTINCT STANOWISKO,
(SELECT COUNT(*) FROM Pracownicy WHERE ZwrotGrzecznoœciowy in ('Dr.','mr.') and p.Stanowisko = Stanowisko) as iloœæ_mê¿czyzn,
(SELECT COUNT(*) FROM Pracownicy WHERE ZwrotGrzecznoœciowy in ('ms.','mrs.') and p.Stanowisko = Stanowisko) as iloœæ_kobiet
from Pracownicy as p

--Podaj najczêœciej i najrzadziej zamawiany towar w 1997 roku.
SELECT TOP 1 PZ.IDproduktu,COUNT(*) AS ILE
FROM PozycjeZamówienia AS PZ INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
GROUP BY PZ.IDproduktu
ORDER BY ILE DESC

SELECT TOP 1 PZ.IDproduktu,COUNT(*) AS ILE
FROM PozycjeZamówienia AS PZ INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
GROUP BY PZ.IDproduktu
ORDER BY ILE 

--Wyœwietl wartoœæ zamówieñ za 1997 rok. Zadanie wykonaj wszystkimi mo¿liwymi sposobami.
SELECT SUM(CenaJednostkowa*Iloœæ)AS WAR
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
WHERE YEAR(Z.DataZamówienia) = 1997

--SprawdŸ, czy na liœcie produktów jest taki, z którego ani jedna sztuka nie zosta³a zamówiona.
SELECT *
FROM mg.Produkty
WHERE IDproduktu NOT IN (

SELECT PZ.IDproduktu
FROM PozycjeZamówienia AS PZ
GROUP BY PZ.IDproduktu)

SELECT IDproduktu
FROM mg.Produkty
EXCEPT
SELECT PZ.IDproduktu
FROM PozycjeZamówienia AS PZ
GROUP BY PZ.IDproduktu
-- Policz, ile pozycji zawiera ka¿de zamówienie, wyœwietliæ nale¿y ID zamówienia i iloœæ jego pozycji
SELECT IDzamówienia, COUNT(*) AS ILE_POZYCJI
FROM PozycjeZamówienia AS PZ
GROUP BY PZ.IDzamówienia


--Podaj, które miasto wystêpuje najczêœciej w danych adresowych
SELECT TOP 1 Miasto, iloœæ
FROM(
SELECT Miasto, count(Miasto) as iloœæ 
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
 ORDER BY iloœæ DESC

 --Podaj nazwisko i imiê najstarszego i najm³odszego pracownika.
 SELECT Imiê, Nazwisko
 FROM 
 ( SELECT TOP 1 Imiê, Nazwisko
	FROM Pracownicy
	ORDER BY DataUrodzenia DESC
	UNION
	SELECT TOP 1 Imiê, Nazwisko
	FROM Pracownicy
	ORDER BY DataUrodzenia 
 ) AS prac

 --Podaæ nazwisko, imiê i wiek w latach wszystkich pracowników, którzy s¹ starsi o co najmniej 10 lat od
--najm³odszego pracownika.
SELECT Nazwisko, Imiê, YEAR(GETDATE()) - YEAR(DataUrodzenia) AS WIEK
FROM Pracownicy
WHERE YEAR(GETDATE()) - YEAR(DataUrodzenia) >
(
SELECT TOP 1 YEAR(GETDATE()) - YEAR(DataUrodzenia) + 10 AS WIEK
FROM Pracownicy
ORDER BY WIEK 
)

--Oblicz œredni¹ wartoœæ zamówieñ.
SELECT AVG(WAR)
FROM
(
SELECT SUM(CenaJednostkowa*Iloœæ) AS WAR
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON PZ.IDzamówienia = Z.IDzamówienia
GROUP BY Z.IDzamówienia) AS WARTOŒÆ_ZAMÓWIEÑ


--Podaj ID zamówienia, ID klienta i datê zamówienia dla wszystkich zamówieñ z³o¿onych póŸniej ni¿ data
--ostatniego zamówienia towaru o nazwie ‘Tofu’.
SELECT Z.IDzamówienia, Z.IDklienta, Z.DataZamówienia
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
WHERE DataZamówienia > (
SELECT TOP 1 DataZamówienia
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia INNER JOIN mg.Produkty AS P ON PZ.IDproduktu = P.IDproduktu
WHERE P.NazwaProduktu = 'Tofu'
ORDER BY DataZamówienia DESC
)

--Podaæ nazwê kategorii, ID produktu, nazwê produktu i jego cenê, dla wszystkich produktów, których
--cena jednostkowa jest wiêksza od œredniej ceny produktów kategorii, do której produkt nale¿y.
SELECT KA.NazwaKategorii, PR.IDproduktu, PR.NazwaProduktu, PR.CenaJednostkowa
FROM mg.Produkty AS PR INNER JOIN mg.Kategorie AS KA ON PR.IDkategorii = KA.IDkategorii
WHERE CenaJednostkowa > (
SELECT AVG(CenaJednostkowa) AS ŒREDNIA
FROM mg.Produkty AS P INNER JOIN mg.Kategorie AS K ON P.IDkategorii = K.IDkategorii
WHERE KA.IDkategorii = k.IDkategorii)

--Nale¿y dokonaæ rankingu krajów wed³ug wartoœci z³o¿onych zamówieñ
SELECT KrajOdbiorcy, SUM(CenaJednostkowa*Iloœæ) AS WAR
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY KrajOdbiorcy
ORDER BY WAR DESC
--Poka¿ produkty, których cena jest wiêksza od ceny œredniej produktów w kategorii do której nale¿¹. 
SELECT K.IDklienta, K.NazwaFirmy, K.Miasto, K.Kraj
FROM Klienci AS K
INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta
GROUP BY K.IDklienta, K.NazwaFirmy, K.Miasto, K.Kraj
HAVING SUM((SELECT SUM(PZ.CenaJednostkowa * PZ.Iloœæ) 
             FROM PozycjeZamówienia AS PZ 
             WHERE PZ.IDzamówienia = Z.IDzamówienia)) >
       (
         SELECT AVG(WAR)
         FROM (
            SELECT K2.Miasto, SUM(PZ2.CenaJednostkowa * PZ2.Iloœæ) AS WAR
            FROM Klienci AS K2
            INNER JOIN Zamówienia AS Z2 ON K2.IDklienta = Z2.IDklienta
            INNER JOIN PozycjeZamówienia AS PZ2 ON Z2.IDzamówienia = PZ2.IDzamówienia
            WHERE K2.Miasto = K.Miasto
            GROUP BY K2.IDklienta
         ) AS MiastoSrednie
       )
--Podaj IDKlienta, NazwêFirmy, Miasto i Kraj, tych klientów, których wartoœæ zamówieñ by³ wiêksza od
--œredniej wartoœci zamówieñ w mieœcie w którym maj¹ siedzibê

--1. Zdefiniuj widok obliczaj¹cy wartoœci poszczególnych zamówieñ.
CREATE VIEW vw_War_Posz_Zam
AS
SELECT Z.IDzamówienia, SUM(CenaJednostkowa*Iloœæ) AS WARTOŒÆ
FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY Z.IDzamówienia

SELECT *
FROM vw_War_Posz_Zam
--2. Zastosuj zdefiniowany widok do obliczenia œredniej wartoœci zamówieñ.
SELECT AVG(WARTOŒÆ)
FROM vw_War_Posz_Zam
--3. Zdefiniuj widok wyœwietlaj¹cy ID pracownika i iloœæ przyjêtych przez niego zamówieñ w 1997 roku
CREATE VIEW vw_Pracownicy_Zamówienia_1997
AS
SELECT Z.IDpracownika, COUNT(*) AS PRZYJÊTE
FROM Pracownicy AS P INNER JOIN Zamówienia AS Z ON Z.IDpracownika = P.IDpracownika
WHERE YEAR(DATAZAMÓWIENIA) = 1997
GROUP BY Z.IDpracownika
--Zdefiniuj funkcjê zwracaj¹c¹ wartoœæ zamówieñ klienta, parametrem wejœciowym funkcji jest identyfikator
--klienta.
	CREATE FUNCTION fn_War_Zam_Klient (@IDKLIENTA CHAR(5))
RETURNS MONEY
AS
BEGIN
DECLARE @WAR MONEY 
	SELECT @WAR = SUM(CenaJednostkowa*Iloœæ)
	FROM Zamówienia AS Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
	WHERE Z.IDklienta = @IDKLIENTA
	RETURN @WAR
END
GO
SELECT dbo.fn_War_Zam_Klient('ALFKI');
--Zdefiniuj funkcjê zwracaj¹c¹ inicja³y. Parametrami wejœciowymi s¹ nazwisko i imiê
CREATE FUNCTION fn_Inicjaly (@Imie NVARCHAR(50), @Nazwisko NVARCHAR(50))
RETURNS CHAR(2)
AS
BEGIN
    RETURN LEFT(@Imie, 1) + LEFT(@Nazwisko, 1)
END
GO
--Napisz funkcjê sprawdzaj¹c¹ istnienie tabeli. Parametrem wejœciowym jest nazwa tabeli (CHAR(128)).
--Funkcja zwraca 0 je¿eli tabela istnieje, 1 je¿eli tabela nie istnieje, NULL w przypadku b³êdnych
--parametrów.
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
--Zdefiniuj funkcjê obliczaj¹c¹ silniê liczby podanej jako parametr wejœciowy
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
--Zdefiniuj funkcjê zwacaj¹c¹ tabelê zawieraj¹c¹: ID, nazwê i miasto klienta, ID zamówienia i jego wartoœæ.
--Kluczem podstawowym jest ID klienta i ID zamówienia.
CREATE FUNCTION TABELA_KLIENCI()
RETURNS TABLE
AS
RETURN
SELECT K.IDklienta, K.NazwaFirmy, K.Miasto, Z.IDzamówienia, SUM(CenaJednostkowa*Iloœæ) AS WARTOSC
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON Z.IDklienta = K.IDklienta 
INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówienia
GROUP BY K.IDklienta, K.NazwaFirmy, K.Miasto,Z.IDzamówienia

SELECT *
from dbo.TABELA_KLIENCI();
--Zdefiniuj procedurê sk³adowan¹ zwracaj¹c¹ zamówienia klienta. Pokazaæ nale¿y: ID klienta, jego nazwê,
--ID zamówienia i datê zamówienia. Parametrem wejœciowym jest identyfikator klienta. 
CREATE PROCEDURE pr_Zamówienia_klienta(@IDKlienta nvarchar(5))
AS
BEGIN
SELECT K.IDklienta, K.NazwaFirmy, Z.IDzamówienia, Z.DataZamówienia
FROM Klienci AS K INNER JOIN Zamówienia AS Z ON K.IDklienta = Z.IDklienta
INNER JOIN PozycjeZamówienia AS PZ ON PZ.IDzamówienia = Z.IDzamówienia
WHERE K.IDklienta = @IDKlienta

END
GO

exec pr_Zamówienia_Klienta 'ALFKI'
--Zdefiniuj procedurê wyœwietlaj¹c¹ przeterminowane zamówienia
