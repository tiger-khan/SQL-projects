-- Insights from the covid-19 data using two datasets

-- selecting data
select *from [My Portfolio]..CovidDeaths;
select *from [My Portfolio]..CovidVaccinations;

-- covid cases ordered by location and date
select location, date, total_cases, new_cases, population
from [My Portfolio]..CovidDeaths
order by 1,2;

-- deaths percentage in each country by each day
select location, date, total_cases, (total_deaths/total_cases)*100 as total_death_percentage from [My Portfolio]..CovidDeaths
where total_deaths is not null;

-- Chance of death by covid 19 in India each day
select location, date, total_cases, (total_deaths/total_cases)*100 as total_death_percentage, population from [My Portfolio]..CovidDeaths
where location like 'india'
order by 1,2;

-- Percentage of cases as per population
select location, date, total_cases, (total_cases/population)*100 as total_cases_percentage, population from [My Portfolio]..CovidDeaths
where location like 'india'
order by 1,2;


-- Total cases per country and total percentage of population that was affected
select location, MAX(total_cases) as Total_cases, MAX((total_cases/population)*100) as Totalpercentageaffected, population from [My Portfolio]..CovidDeaths
where continent is not null
group by location, population
order by total_cases desc;

-- Total cases on each continent
select continent, MAX(total_cases) as Total_cases from [My Portfolio]..CovidDeaths
where continent is not null
group by continent
order by total_cases desc;

-- Countries by Highest death rates and total death percentage
select location, MAX(cast(total_deaths as int)) as Total_deaths, MAX((total_deaths/population)*100) as Totalpercentagedeath, population from [My Portfolio]..CovidDeaths
where continent is not null
group by location, population
order by total_deaths desc;

-- Total covid cases and deaths globally each day
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Totalpercentageofdeaths
from [My Portfolio]..CovidDeaths
where continent is not null
group by date
order by date;


-- combining vacinations and covid cases tables with join
select * from [My Portfolio]..CovidDeaths d
join [My Portfolio]..CovidVaccinations v
on d.location = v.location and
d.date = v.date;

-- New vaccinations each country per day
select d.continent, d.location, d.date, d.population, v.new_vaccinations
from [My Portfolio]..CovidDeaths d
join [My Portfolio]..CovidVaccinations v
on d.location = v.location and
d.date = v.date
where d.continent is not null
order by 1,2,3;


-- Total vaccinations per day ordering by country location
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date) as total_vaccinations
from [My Portfolio]..CovidDeaths d
join [My Portfolio]..CovidVaccinations v
on d.location = v.location and
d.date = v.date
where d.continent is not null
order by 1,2,3;





