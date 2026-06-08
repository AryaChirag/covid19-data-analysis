/* =========================================================
   COVID-19 DATA ANALYSIS PROJECT
   Author: Chirag Arya
   Source: Our World in Data
   Tool: SQL Server Management Studio
========================================================= */


/* =========================
   1. DATA PREVIEW
========================= */

SELECT *
FROM CovidDeaths
ORDER BY location, date;

SELECT *
FROM CovidVaccinations
ORDER BY location, date;


/* =========================
   2. DATE STANDARDISATION
========================= */

ALTER TABLE CovidDeaths
ADD DateConverted DATE;

UPDATE CovidDeaths
SET DateConverted = CONVERT(DATE, date);

ALTER TABLE CovidVaccinations
ADD DateConverted DATE;

UPDATE CovidVaccinations
SET DateConverted = CONVERT(DATE, date);


/* =========================
   3. DATA CLEANING - DUPLICATES CHECK
========================= */

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY location, DateConverted
               ORDER BY location, DateConverted
           ) AS row_num
    FROM CovidDeaths
)
SELECT *
FROM CTE
WHERE row_num > 1;


/* =========================
   4. CASES & DEATH ANALYSIS (COUNTRY LEVEL)
========================= */

-- Infection Rate
SELECT Location,
       DateConverted,
       total_cases,
       (total_cases / population) * 100 AS CasesPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, DateConverted;

-- Death Rate
SELECT Location,
       DateConverted,
       total_cases,
       total_deaths,
       (total_deaths / total_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, DateConverted;

-- Highest Infection Countries
SELECT Location,
       Population,
       MAX(total_cases) AS HighestInfectionCount,
       MAX(total_cases / population) * 100 AS PercentagePopulationCases
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentagePopulationCases DESC;

-- Highest Death Countries
SELECT Location,
       Population,
       MAX(total_deaths) AS HighestDeathCount,
       MAX(total_deaths / population) * 100 AS PercentagePopulationDeath
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentagePopulationDeath DESC;


/* =========================
   5. CONTINENT ANALYSIS
========================= */

-- Highest Infection by Continent
SELECT continent,
       MAX(total_cases / population) * 100 AS ContinentCasesPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY ContinentCasesPercentage DESC;

-- Highest Death by Continent
SELECT continent,
       MAX(total_deaths) AS HighestDeathCount,
       MAX(total_deaths / population) * 100 AS ContinentDeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY ContinentDeathPercentage DESC;


/* =========================
   6. GLOBAL ANALYSIS
========================= */

SELECT DateConverted,
       SUM(new_cases) AS TotalCases,
       SUM(new_deaths) AS TotalDeaths,
       SUM(new_deaths) / NULLIF(SUM(new_cases), 0) * 100 AS DeathRateGlobally
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY DateConverted
ORDER BY DateConverted;


/* =========================
   7. VACCINATION ANALYSIS
========================= */

-- Join deaths + vaccinations
SELECT dea.continent,
       dea.location,
       dea.DateConverted,
       dea.population,
       vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.DateConverted = vac.DateConverted
WHERE dea.continent IS NOT NULL;


/* Rolling Vaccinations */
SELECT dea.continent,
       dea.location,
       dea.DateConverted,
       dea.population,
       vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS BIGINT))
       OVER (PARTITION BY dea.location ORDER BY dea.DateConverted) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.DateConverted = vac.DateConverted
WHERE dea.continent IS NOT NULL;


/* Vaccination Percentage */
WITH PopvsVac AS (
    SELECT dea.continent,
           dea.location,
           dea.DateConverted,
           dea.population,
           vac.new_vaccinations,
           SUM(CAST(vac.new_vaccinations AS BIGINT))
           OVER (PARTITION BY dea.location ORDER BY dea.DateConverted) AS RollingPeopleVaccinated
    FROM CovidDeaths dea
    JOIN CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.DateConverted = vac.DateConverted
    WHERE dea.continent IS NOT NULL
)
SELECT *,
       (RollingPeopleVaccinated / population) * 100 AS PercentageRollingPeopleVaccinated
FROM PopvsVac;
