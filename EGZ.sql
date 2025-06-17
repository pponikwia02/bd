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
--w 1997 roku.CREATE VIEW vw_Pracownik_Zamówienia_1997ASSELECT IDpracownika, COUNT(*) AS LICZBAFROM Zamówienia AS ZWHERE YEAR(DataZamówienia)=1997GROUP BY IDpracownika--29. U¿ytkownikowi Magazynier nadaj prawa do czytania widoku viewProduktyMin.GRANT SELECT ON viewProduktyMin TO Magazynier;CREATE FUNCTION fn_war_zam_klienta (@IDKlienta nvarchar(5))RETURNS MONEYASBEGINDECLARE @WYNIK MONEYSELECT @WYNIK = SUM(CenaJednostkowa * Iloœæ)FROM Zamówienia Z INNER JOIN PozycjeZamówienia AS PZ ON Z.IDzamówienia = PZ.IDzamówieniaWHERE Z.IDklienta = @IDKlientaRETURN @WYNIKEND