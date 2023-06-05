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

SELECT date, SUM(new_cases), SUM(new_deaths), SUM(cast(new_deaths as float))/Sum(CAST(new_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by date 
Order by 1,2