SELECT * 
FROM PortfolioProject..CovidDeathsData$
WHERE continent IS NOT NULL
ORDER BY 3,4

--Select * FROM PortfolioProject..COVIDVaccinations$
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeathsData$
ORDER BY 1,2

--shows likelihood of dying if you contract COVID in your country
--Looking at total cases vs total deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeathsData$
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at Total cases vs population
--shows % of population that got COVID
SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeathsData$
--WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeathsData$
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc

--Countries with Highest Desath Count per Population
SELECT Location, MAX(cast(total_deaths as int)) AS HighestDeathCount, MAX((total_deaths/population))*100 AS PercentPopulationDeaths
FROM PortfolioProject..CovidDeathsData$
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY HighestDeathCount desc

--Break things down by continent
--this is the accurate one
SELECT location, MAX(cast(total_deaths as int)) AS HighestDeathCount, MAX((total_deaths/population))*100 AS PercentPopulationDeaths
FROM PortfolioProject..CovidDeathsData$
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeathCount desc
--this is not accurate
SELECT continent, MAX(cast(total_deaths AS int)) AS HighestDeathCount, MAX((total_deaths/population))*100 AS PercentPopulationDeaths
FROM PortfolioProject..CovidDeathsData$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount desc

--global numbers
SELECT SUM(new_cases) AS TotalCases, SUM(cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeathsData$
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


--Rolling people vaccinations
--USE CTE
WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS 
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
		AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathsData$ dea --alias
JOIN PortfolioProject..COVIDVaccinations$ vac --alias
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopVsVac



--TEMP TABLE
DROP table IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
		AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathsData$ dea --alias
JOIN PortfolioProject..COVIDVaccinations$ vac --alias
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
		AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeathsData$ dea --alias
JOIN PortfolioProject..COVIDVaccinations$ vac --alias
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated