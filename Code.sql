-- COVID DEATHS

select * from coviddeaths;

-- Overview of the table and the relevant columns

select location, STR_TO_DATE(date,'%d-%m-%y') as date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2;

-- Death rate

select location, STR_TO_DATE(date,'%d-%m-%y') as date, total_cases, total_deaths,(total_deaths/total_cases)*100 as death_rate
from coviddeaths
where location like 'India'
order by 1,2;

-- Total cases vs Population

select location, STR_TO_DATE(date,'%d-%m-%y') as date, population, total_cases,(total_cases/population)*100 as percent_of_population_covid
from coviddeaths
where location like 'India'
order by 1,2;

-- Total cases by Population

select location,population, STR_TO_DATE(date,'%d-%m-%y') as date,MAX(total_cases) as HighestCount,MAX((total_cases/population))*100 as max_percent
from coviddeaths
where continent is not null
group by location
order by 5 desc;

-- Deaths across countries

select location,population, STR_TO_DATE(date,'%d-%m-%y') as date,MAX(total_deaths) as HighestCount,MAX((total_deaths/population))*100 as max_percent
from coviddeaths
where continent is not null
group by location
order by 5 desc;

-- Cases across Countries

select location,population, STR_TO_DATE(date,'%d-%m-%y') as date,MAX(total_cases) as HighestCount,MAX((total_cases/population))*100 as max_percent
from coviddeaths
where continent is not null
group by location
order by 5 desc;

-- Deaths across the continent

select continent,population, STR_TO_DATE(date,'%d-%m-%y') as date,MAX(total_deaths) as HighestCount,MAX((total_deaths/population))*100 as max_percent
from coviddeaths
where continent = location or continent is not null
group by continent
order by 5 desc;

-- Cases across the continent

select continent,population, STR_TO_DATE(date,'%d-%m-%y') as date,MAX(total_cases) as HighestCount,MAX((total_cases/population))*100 as max_percent
from coviddeaths
where continent = location or continent is not null
group by continent
order by 5 desc;

-- Cases and deaths that gradually increased over time

select date,sum(new_cases) as newCases,sum(new_deaths) as newDeaths,(sum(new_deaths)/sum(new_cases))*100 as Deathpercentage
from coviddeaths
where new_cases is not null
group by date
order by 2;

-- Total Number of cases around the globe

select 'world' as global,SUM(new_cases) as totalCases,SUM(new_deaths) as totalDeaths,(SUM(new_cases)/SUM(new_deaths))*100 as Death_percent
from coviddeaths;
-- COVID VACCINATIONS

select * from covidvaccinations;

-- Joining the 2 tables

select *
from coviddeaths as dea
join covidvaccinations as vac
    on dea.location = vac.location
    and dea.date = vac.date
order by 3,4;

-- Overview

select dea.continent, dea.location, STR_TO_DATE(dea.date,'%d-%m-%y') as date, total_cases, new_cases ,total_deaths, new_deaths, population,
       vac.new_tests as newTests, vac.total_tests as totalTests, vac.total_vaccinations, vac.people_vaccinated
from coviddeaths as dea
join covidvaccinations as vac
    on dea.location = vac.location
    and dea.date = vac.date
order by 2,3;

-- Number of people taking vaccination on day to day basis

select dea.location,STR_TO_DATE(dea.date,'%d-%m-%y') as date, vac.new_vaccinations, (vac.new_vaccinations/population)*100 as percentVaccinated
from coviddeaths as dea
join covidvaccinations as vac
    on dea.location = vac.location
    and dea.date = vac.date
where vac.new_vaccinations is not null
and dea.continent is not null
order by 1,2;

-- Total Vaccination based on country

with PopVsVacc (location, Population, date, newVaccination, Vaccinated) as (

    select dea.location,dea.population, STR_TO_DATE(dea.date,'%d-%m-%y') as date, vac.new_vaccinations,
           SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,STR_TO_DATE(dea.date,'%d-%m-%y')) as Vaccinated
    from coviddeaths as dea
    join covidvaccinations as vac
        on dea.location = vac.location
        and dea.date = vac.date
    where dea.continent is not null
    and vac.new_vaccinations is not null
    order by 1,2

        )

select *, round((Vaccinated/Population)*100,2)as PercentVaccinated from PopVsVacc

-- Creating view

create view VIEWPopVsVacc as

    select dea.location,dea.population, STR_TO_DATE(dea.date,'%d-%m-%y') as date, vac.new_vaccinations,
           SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,STR_TO_DATE(dea.date,'%d-%m-%y')) as Vaccinated
    from coviddeaths as dea
    join covidvaccinations as vac
        on dea.location = vac.location
        and dea.date = vac.date
    where dea.continent is not null
    and vac.new_vaccinations is not null
    order by 1,2

select * from VIEWPopVsVacc









