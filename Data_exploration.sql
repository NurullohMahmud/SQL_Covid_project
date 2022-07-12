-- Let's see the data we are working with

select *
from sql_project.coviddeaths;

-- Let's select data we'll be using

select location, date, total_cases, new_cases, total_deaths, population
from sql_project.coviddeaths
order by 1,2;

-- Calculating deaths percentage in countries
-- Shows likelihood of dying if you contract virus in your country

select location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as deaths_percentage
from sql_project.coviddeaths
order by 1;

-- Total cases vs population in United States
-- Shows percentage of population infected by covid

select location, date, total_cases,  population, (total_cases/population)*100 as infection_percentage
from sql_project.coviddeaths
where location like '%%states'
order by 1,2 ;

-- Countries with Highest Infection Rate compared to Population

select location, max(total_cases) as HighestInfectionCount,  population, max((total_cases/population))*100 as InfectionRate
from sql_project.coviddeaths
group by location, population
order by InfectionRate desc;

-- Countries with Highest Death Count per Population

select location, max(convert(total_deaths, unsigned integer)) as DeathCount
from sql_project.coviddeaths
group by location
order by DeathCount desc;


-- Global death percentage

select sum(new_cases) as total_cases, sum(convert(new_deaths, unsigned integer)) as total_deaths, 
sum(convert(new_deaths, unsigned integer))/sum(new_cases)*100 as death_percentage
from sql_project.coviddeaths
where continent is not null
order by 1,2;

-- Total population vs Vaccination
-- We need to join 2nd table to show what percentage of population received at least one vaccination


SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
sum(convert(vacs.new_vaccinations, unsigned integer)) over (partition by deaths.location order by deaths.location, deaths.date) as PeopleVaccinated
FROM sql_project.coviddeaths as deaths
join sql_project.covidvaccinationts as vacs
on deaths.location = vacs.location
and deaths.date = vacs.date
where deaths.continent is not null 
order by 2, 3;


-- Perform Calculation on Partition By in previous query using CTE


with Pop_vs_Vac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations
, SUM(CONVERT(vacs.new_vaccinations, unsigned integer)) OVER (Partition by deaths.Location Order by deaths.location, deaths.Date) as RollingPeopleVaccinated
From sql_project.coviddeaths as deaths
Join sql_project.covidvaccinationts as vacs
On deaths.location = vacs.location
and deaths.date = vacs.date
where deaths.continent is not null)
select *, (RollingPeopleVaccinated/population)*100 as PercentagePeopleVaccinated
from Pop_vs_Vac;

