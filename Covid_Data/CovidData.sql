SELECT*
FROM Lizdata..CovidDeaths
WHERE continent is not NULL
order by 3,4

--SELECT*
--FROM Lizdata..CovidVaccinations
--order by 3,4

--SELECT Data that we will be using for this project

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Lizdata..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows how likely you could die if you contract Covid in your country

SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM Lizdata..CovidDeaths
WHERE location like '%states%'
order by 1,2
-- Narrowing down to look at United States

--Looking at the Total Cases vs Population and what percentage of the population got Covid

SELECT Location, date, Population, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM Lizdata..CovidDeaths
--WHERE location like '%states%'
order by 1,2

--Finding the Countries with the Highest Infection Rate compared to their Population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentofPopulationInfected
FROM Lizdata..CovidDeaths
--WHERE location like '%states%'
Group by Location, Population
order by PercentofPopulationInfected desc

--Showing Countries with the Highest Death Count based on Population 
--Turn Total_deaths from nvarchar to int using the cast function 

SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Lizdata..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not NULL
Group by Location
order by TotalDeathCount desc

--Breaking things down by continent
SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Lizdata..CovidDeaths
WHERE continent is NULL
Group by location
order by TotalDeathCount desc

--Gobal data comparing the date vs total cases, total deaths and showing the death percentage
--We can also see the toal cases, deaths and death percentage globally

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM Lizdata..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not NULL
--Group By date
order by 1,2

--Combining tables using JOIN using location and date
--Looking at Total Population vs Vaccinations 

-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingVaccinations)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingVaccinations
FROM Lizdata..CovidDeaths dea
JOIN Lizdata..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null
	--order by 2,3
)
SELECT*, (RollingVaccinations/Population)*100
FROM PopvsVac

--Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinations numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingVaccinations
FROM Lizdata..CovidDeaths dea
JOIN Lizdata..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null
	--order by 2,3

	SELECT*, (RollingVaccinations/Population)*100
FROM #PercentPopulationVaccinated


--Creating a view to store data for visualizations 

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingVaccinations
FROM Lizdata..CovidDeaths dea
JOIN Lizdata..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null
	--order by 2,3

--Checking View to make sure all info is there
	SELECT*
	FROM PercentPopulationVaccinated
	
	
--Looking at total vaccinations based on continent	

  SELECT continent, sum(cast(new_vaccinations as int)) as total_vaccinations
  FROM [Lizdata].[dbo].[PercentPopulationVaccinated]
  group by continent
  
  --total vaccinations based on location and population
  
  SELECT location, population, SUM(cast(new_vaccinations as int)) as total_vaccinations
  FROM [Lizdata].[dbo].[PercentPopulationVaccinated]
  group by location, population
