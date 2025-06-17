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
--w 1997 roku.CREATE VIEW vw_Pracownik_Zam�wienia_1997ASSELECT IDpracownika, COUNT(*) AS LICZBAFROM Zam�wienia AS ZWHERE YEAR(DataZam�wienia)=1997GROUP BY IDpracownika--29. U�ytkownikowi Magazynier nadaj prawa do czytania widoku viewProduktyMin.GRANT SELECT ON viewProduktyMin TO Magazynier;CREATE FUNCTION fn_war_zam_klienta (@IDKlienta nvarchar(5))RETURNS MONEYASBEGINDECLARE @WYNIK MONEYSELECT @WYNIK = SUM(CenaJednostkowa * Ilo��)FROM Zam�wienia Z INNER JOIN PozycjeZam�wienia AS PZ ON Z.IDzam�wienia = PZ.IDzam�wieniaWHERE Z.IDklienta = @IDKlientaRETURN @WYNIKEND