/* Covid 19 Data Exporation 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select * 
From [PortfolioProject]..CovidDeaths
Where Continent is not null
Order by 3, 4

-- Select data to start with 

Select Location, date, total_cases, total_deaths
From [PortfolioProject]..CovidDeaths
Where Continent is not null
Order by 1, 2


-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths,
(total_deaths/NullIf(total_cases,0)) * 100 AS DeathPercentage
From [PortfolioProject]..CovidDeaths
Where continent is not null
Where Location = 'United States'
Order by 1,2

--Looking at total cases vs population in the US
--Shows what percentage of population infected with covid

Select location, date, Population, total_cases,
(total_cases/NullIf(Population,0)) * 100 as PercentPopulationInfected
From [PortfolioProject]..CovidDeaths
Where continent is not null
--Where Location = 'United States' 
Order by 1, 2

-- Looking at countries with highest infection rate compared to population

Select location, Population, MAX(total_cases) as HighestInfectionCount, 
(MAX(total_cases/NullIf(Population,0))) * 100 as PercentPopulationInfected
From [PortfolioProject]..CovidDeaths
Where continent is not null
Group By Location, Population
Order by PercentPopulationInfected Desc

-- Showing countries with highest death count per population

Select location, Max(total_deaths) as TotalDeathCount
From [PortfolioProject]..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount Desc

-- Showing continents with the highest death count per population

Select continent, Max(total_deaths) as TotalDeathCount
From [PortfolioProject]..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount Desc


-- Global Numbers 

Select Sum(new_cases) as total_cases, Sum(new_deaths) as total_deaths, Sum(cast(new_deaths as float))/ Sum(cast(new_cases as float))*100 as DeathPercentage
From [PortfolioProject]..CovidDeaths
Where continent is not null
--Group by date
Order by 1, 2

-- Total population vs vaccinations
-- Shows percentage of population that has received at least one covid vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) Over(Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/Population) * 100 as PercentageVaccinatedPopulation
From [PortfolioProject]..CovidDeaths dea
Join [PortfolioProject]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date 
Where dea.continent is not null
Order by 2, 3

-- Using CTE to perform calculation on Partition By in previous query

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(numeric,vac.new_vaccinations)) Over(Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) * 100 as PercentageVaccinatedPopulation
From [PortfolioProject]..CovidDeaths dea
Join [PortfolioProject]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date 
Where dea.continent is not null
)

Select *, Convert(numeric,(RollingPeopleVaccinated/Population))*100
From PopvsVac

-- Using Temp Table to perform calculation on Partition By in previosu query

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(numeric,vac.new_vaccinations)) Over(Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) * 100 as PercentageVaccinatedPopulation
From [PortfolioProject]..CovidDeaths dea
Join [PortfolioProject]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date 
Where dea.continent is not null

Select *, Convert(numeric,(RollingPeopleVaccinated/Population))*100
From #PercentPopulationVaccinated

-- Creating view to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) Over(Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [PortfolioProject]..CovidDeaths dea
Join [PortfolioProject]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date 
Where dea.continent is not null

Create View TotalDeathsByCountry as
Select location, Max(total_deaths) as TotalDeathCount
From [PortfolioProject]..CovidDeaths
Where continent is not null
Group by location

Create View TotalDeathsByContinent as 
Select continent, Max(total_deaths) as TotalDeathCount
From [PortfolioProject]..CovidDeaths
Where continent is not null
Group by continent
