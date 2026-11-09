--

IF OBJECT_ID('dbo.Uppdrag', 'U') IS NOT NULL DROP TABLE dbo.Uppdrag;
IF OBJECT_ID('dbo.Konsulter', 'U') IS NOT NULL DROP TABLE dbo.Konsulter;
IF OBJECT_ID('dbo.Kunder', 'U') IS NOT NULL DROP TABLE dbo.Kunder;
GO

-- Skappar Tabellerna.

CREATE TABLE Kunder (
	KundId INT IDENTITY(1,1) PRIMARY KEY,
	OrgNr VARCHAR(50) NOT NULL UNIQUE,
	Foretagsnamn NVARCHAR (100) NOT NULL,
	Epost NVARCHAR(100) NOT NULL,
	Telefonnummer VARCHAR(100) NOT NULL,
);
GO

CREATE TABLE Konsulter(
	KonsultId INT IDENTITY(1,1) PRIMARY KEY,
	PersonNr CHAR(100) NOT NULL UNIQUE,
	Namn NVARCHAR(100) NOT NULL,
	Timpris DECIMAL(10,2) NOT NULL,
	Specialitet NVARCHAR(100) NOT NULL,
);

CREATE TABLE Uppdrag(
	UppdragId INT IDENTITY(1,1) PRIMARY KEY,
	KundId INT NOT NULL,
	KonsultId INT NOT NULL,
	Startdatum DATE NOT NULL,
	Slutdatum DATE NOT NULL,
	Rollbeskrivning NVARCHAR(100) NOT NULL,
);

-- Testdata med lite humor

INSERT INTO Kunder (OrgNr, Foretagsnamn, Epost, Telefonnummer) values
	('19990101-5555', 'AlibabsLivs', 'AlibabasLivs@kebab.nu', '911'),
	('19890101-2313', 'GyrosPaBaten', 'Claeslevererar@greece.se', '070789123'),
	('19240462-2518', 'KimsKattTrim', 'Kimrakar@cut.katnaked', '112'),
	('19240312-3824', 'IngetUppdrag', 'Kimrakar2@cut.kattnaked', '073576182');

INSERT INTO Konsulter (PersonNr, Namn, Timpris, Specialitet) values
	('19400521-3526', 'Robin Fiskarsson', 10, 'FiskaPaLand'),
	('19420921-3627', 'Kim Kattsson', 0, 'KattFrisör'),
	('19891121-2314', 'Fredrik Svarvarsson', 3, 'Kebab Tekniker'),
	('19700325-0522', 'Kiwi Svensson', 1300, 'Humpster'),
	('19520513-1313', 'Donna Kissaisängensson', 3000, 'Kissa');
INSERT INTO Uppdrag (KundId,KonsultId,Startdatum,Slutdatum,Rollbeskrivning)values
	(2,1, '20260301', '20260302', 'Fiska i Fritösen'),
	(1,2, '20260503', '20260513', 'Raka frugan'),
	(1,3, '20260111', '20260114', 'Svarva Kebab'), 
	(1,1, '20260821', '20260823', 'Fiska i Akvariumet'),
	(3,5, '20261109', '20261113', 'Kissa i sängen hos kim'),
	(2,3, '20261012', '20261021', 'Svarva Gyros i hamnen');

-- FRÅGA A

SELECT Namn, Timpris
FROM Konsulter
WHERE Timpris > 1200
ORDER BY Timpris DESC;

-- FRÅGA B

SELECT
	k.Foretagsnamn,
	c.Namn,
	u.Startdatum,
	u.Slutdatum
FROM dbo.Uppdrag AS u
INNER JOIN dbo.Kunder AS k
	on u.KundId = k.KundId
INNER JOIN dbo.Konsulter AS c
	on u.KonsultId = c.KonsultId

ORDER BY k.Foretagsnamn, u.Startdatum;

-- FRÅGA C

SELECT 
	k.Foretagsnamn,
	COUNT(u.UppdragId) AS PågåendeUppdrag
FROM dbo.Kunder AS k
LEFT JOIN dbo.Uppdrag AS u
	ON k.KundId = u.KundId
	AND CAST (GETDATE() AS DATE) BETWEEN CAST(u.Startdatum AS DATE) 
	AND CAST(u.Slutdatum AS DATE)
GROUP BY 
	k.KundId,
	k.Foretagsnamn
ORDER BY 
	k.Foretagsnamn;

-- FRÅGA D

UPDATE dbo.Konsulter
SET Timpris = 1400
WHERE PersonNr = '19700325-0522';

-- FRÅGA E 

-- Har uppdrag
DELETE FROM dbo.Kunder
WHERE KundId NOT IN (SELECT DISTINCT KundId From dbo.Uppdrag)
	AND OrgNr = '19240462-2518';
GO


-- Har inte uppdrag
DELETE FROM dbo.Kunder
WHERE KundId NOT IN (SELECT DISTINCT KundId From dbo.Uppdrag)
	AND OrgNr = '19240312-3824';
GO