Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

Select *
From PortfolioProject..CovidVaccinations
Order by 3,4

--Select data that we are going to be using.

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

--Looking at total cases vs total deaths
--Shows likelihood of dying if you contract COVID in your country 

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentages
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Looking at total cases vs population
--Shows that percentage of population contracted COVID

Select Location, date, total_cases,population, (total_cases/population)*100 as DeathPercentages
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Countries with highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/NULLIF (population,0)))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected desc

--Showing countries with highest death count per population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc

--Breaking things down by continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Showing continents with highest death count per population

Select continent, SUM(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
and location not in ('World', 'European Union', 'International') 
Group by continent
Order by TotalDeathCount desc

--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3