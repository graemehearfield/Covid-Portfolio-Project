SELECT *
From PortfolioProject..CovidDeaths
Where continent is not NULL
ORDER by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order BY 3,4

-- Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2


-- Look at total cases vs total deaths

SELECT Location, date, total_cases, total_deaths, CAST(total_deaths AS float)/CAST(total_cases AS float)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Location = 'New Zealand'
and continent is not NULL
Order by 1,2

-- Looking at total cases vs population

SELECT Location, date, total_cases, population, CAST(total_deaths AS float)/CAST(population AS float)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where Location = 'New Zealand'
Order by 1,2

-- Looking at countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX(CAST(total_cases AS float))/CAST(population as float) * 100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
GROUP by Location, population
ORDER BY PercentagePopulationInfected desc

-- Looking at countries with highest death count per population

Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by Location, population
Order by TotalDeathCount desc 

-- by continent

Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is NULL
Group by Location
Order by TotalDeathCount desc 

-- Showing the continents with the hightest death counts

Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is NULL
Group by Location
Order by TotalDeathCount desc 

-- Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(cast(new_deaths as float))/Sum(CAST(new_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by date 
Order by 1,2

-- global total

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(cast(new_deaths as float))/Sum(CAST(new_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not NULL
--Group by date 
Order by 1,2

-- Looking at total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by  dea.location, dea.date) As RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
JOIN PortfolioProject..CovidVaccinations vac 
    on dea.location = vac.location 
    and dea.date = vac.date 
Where dea.continent is not null 
Order by 2,3

-- Use CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by  dea.location, dea.date) As RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
JOIN PortfolioProject..CovidVaccinations vac 
    on dea.location = vac.location 
    and dea.date = vac.date 
Where dea.continent is not null 
--Order by 2,3
)
SELECT *, (CAST(RollingPeopleVaccinated AS float)/ (CAST(Population AS float)))/100
FROM PopvsVac


-- Temp Table

Drop TABLE if EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated

(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
)

Insert INTO #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by  dea.location, dea.date) As RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
JOIN PortfolioProject..CovidVaccinations vac 
    on dea.location = vac.location 
    and dea.date = vac.date 
Where dea.continent is not null 
--Order by 2,3

SELECT *, (CAST(RollingPeopleVaccinated AS float)/ (CAST(Population AS float)))/100
FROM #PercentPopulationVaccinated


-- Creating view to store data for later visualisation

CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by  dea.location, dea.date) As RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
JOIN PortfolioProject..CovidVaccinations vac 
    on dea.location = vac.location 
    and dea.date = vac.date 
Where dea.continent is not null 
--Order by 2,3