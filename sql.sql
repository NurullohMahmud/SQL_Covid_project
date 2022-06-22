select location, date, continent
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




