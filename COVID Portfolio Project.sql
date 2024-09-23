
select * 
from PortefolioProject..CovidDeaths
where continent is not null
order by 3,4

--select * 
--from PortefolioProject..CovidVacci
--order by 3,4;

-- Select data to be use

select location, date, total_cases, new_cases, total_deaths, population
from PortefolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking at Toatal Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortefolioProject..CovidDeaths
--where location like '%states%' and 
where continent is not null
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortefolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as 
	PercentPopulationInfected
from PortefolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortefolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

-- Breaking it by Continent


-- Showing continents with highest death count oer population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortefolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Global Numbers

select date, SUM(new_cases) as total_caases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
	(new_deaths as int))/SUM(new_cases)*100 as DeathPercent
from PortefolioProject..CovidDeaths
--where location like '%states%' and 
where continent is not null
group by date
order by 1,2


select SUM(new_cases) as total_caases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
	(new_deaths as int))/SUM(new_cases)*100 as DeathPercent
from PortefolioProject..CovidDeaths
--where location like '%states%' and 
where continent is not null
--group by date
order by 1,2


-- Looking at Total Population vs Vaccinations

With PopvsVac (continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortefolioProject..CovidDeaths dea
Join PortefolioProject..CovidVacci vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP Table

DROP Table if exists #PercentPopulationVaccinationed
Create Table #PercentPopulationVaccinationed
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinationed
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortefolioProject..CovidDeaths dea
Join PortefolioProject..CovidVacci vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinationed


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinationed as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortefolioProject..CovidDeaths dea
Join PortefolioProject..CovidVacci vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3



Select *
From PercentPopulationVaccinationed

