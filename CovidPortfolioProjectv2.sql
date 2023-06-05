SELECT *
FROM PortfolioProjectv2..CovidDeathsv2
Where continent is not null 
Order by 3,4

SELECT *
From PortfolioProjectv2..CovidVaccinationsv2
Order by 3,4

-- Select data to be used

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjectv2..CovidDeathsv2
ORDER by 1,2

-- Look at total cases vs total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectv2..CovidDeathsv2
Where location = 'New Zealand'
AND continent is not NULL
Order by 1,2

-- Look at total cases vs population

Select location, date, total_cases, population, (total_cases/population)*100 As PercentPopulationInfected
From PortfolioProjectv2..CovidDeathsv2
Where location = 'New Zealand'
Order BY 1,2

-- Looking at countries with highest infection rate compared to population

SELECT location, population, Max(total_cases) as HighestInfectionCount, (MAX(total_cases)/population)*100 as PercentagePopulationInfected
From PortfolioProjectv2..CovidDeathsv2
Where continent is not NULL
Group by location, population
Order by PercentagePopulationInfected DESC

-- Looking at countries with highest death count compared to population

SELECT location, population, MAX(total_deaths) as TotalDeathCount, (Max(total_deaths)/population)*100 AS PercentageDeaths
From PortfolioProjectv2..CovidDeathsv2
WHERE continent is not NULL
Group by location, population
Order by PercentageDeaths DESC

-- Looking at total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjectv2..CovidDeathsv2 dea 
Join PortfolioProjectv2..CovidVaccinationsv2 vac 
    ON dea.location = vac.location  
    and dea.date = vac.date 
Where dea.continent is not NULL
Order by 2,3

-- With CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjectv2..CovidDeathsv2 dea 
Join PortfolioProjectv2..CovidVaccinationsv2 vac 
    ON dea.location = vac.location  
    and dea.date = vac.date 
Where dea.continent is not NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100
From PopvsVac
ORDER by 7 DESC

