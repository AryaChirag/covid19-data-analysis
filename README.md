# COVID-19 Data Analysis and Visualisation

![SQL](https://img.shields.io/badge/SQL-Server-red)
![Tableau](https://img.shields.io/badge/Tableau-Public-blue)
![Excel](https://img.shields.io/badge/Excel-Data%20Preparation-green)

An end-to-end COVID-19 data analytics project using SQL Server, Tableau, and Excel to analyse global infection trends, mortality rates, and vaccination progress from January 2020 to May 2023.

-----

## Project Overview

This project analyses global COVID-19 data to uncover trends in:
- Infection rates  
- Mortality rates  
- Vaccination progress across countries and continents

### Tools & Technologies

- SQL Server Management Studio (SSMS) → data cleaning & analysis  
- Tableau Public → interactive dashboards  
- Microsoft Excel → initial data preparation
- Git & GitHub

-----

## Tableau Dashboard
The dashboard visualises COVID-19 data collected between **01 January 2020 to 23 May 2023**.

### Dashboard Preview
![Dashboard](Media/Dashboard.png)

🔗 **Live Dashboard:**
👉 [View Interactive Tableau Dashboard](https://public.tableau.com/app/profile/chirag.arya4385/viz/Coviddata_17809148631170/Dashboard1?publish=yes) 

-----

## Key Insights

- Countries with highest infection rates relative to population  
- Mortality comparison across continents and countries  
- Global COVID-19 trends over time  
- Rolling vaccination trends using SQL window functions  
- Vaccination progress visualised in Tableau

-----

## Objectives

- Analyse global COVID-19 infection trends  
- Compare death rates across regions  
- Track vaccination progress over time  
- Build interactive dashboards  
- Perform end-to-end data analytics workflow

-----

## Data Processing

Dataset split into:

- CovidDeaths  
- CovidVaccinations

Location and date fields were preserved to enable joins and time-based analysis.

-----

## Data Cleaning (SQL)

Data cleaning was performed in SQL Server and included:

- Date standardisation
- Duplicate removal
- Null handling
- Column optimisation

Complete SQL scripts are available in:

**[Covid_Analysis.sql](SQL/Covid_Analysis.sql)**

-----

## Analysis Performed

### Country-Level
- Infection rate (Cases %)
- Death rate (Death %)
- Highest infection countries
- Highest death countries

### Continent-Level
- Infection comparison
- Death comparison

### Global Analysis
- Global death rate over time

### Vaccination Analysis
- Daily vaccination counts
- Rolling vaccination totals
- Percentage of population vaccinated

-----

## SQL Concepts Demonstrated

- Data Cleaning
- Data Transformation
- Aggregate Functions
- Window Functions
- Common Table Expressions (CTEs)
- Joins
- Running Totals
- Percentage Calculations
- Data Exploration

-----

## Sample Query (Rolling Vaccinations)

```SQL
SELECT dea.continent, dea.location, dea.dateconverted, dea.population,
       vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS BIGINT))
       OVER (PARTITION BY dea.location ORDER BY dea.dateconverted)
       AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.dateconverted = vac.dateconverted;
```

-----

## Repository Structure

```text
Covid-19-Data-Analysis/
│
├── Data_files/
│   ├── CovidDeaths.xlsx
│   └── CovidVaccinations.xlsx
│
├── Media/
│   └── Dashboard.png
│
├── SQL/
│   └── Covid_Analysis.sql
│
└── README.md
```

-----

## Data Source

Dataset: [Our World in Data - COVID-19 Dataset](https://ourworldindata.org/covid-deaths)

Project file:
- [Covid Deaths.xlsx](Data_files/CovidDeaths.xlsx)
- [Covid Vaccination.xlsx](Data_files/CovidVaccinations.xlsx)

## Project Outcome
This project demonstrates practical experience in:

- SQL data cleaning and transformation
- Exploratory data analysis
- Window functions and CTEs
- Data visualization using Tableau
- Storytelling through data

This project highlights the complete analytics lifecycle—from raw data preparation and SQL analysis to dashboard development and business insight generation.

## Future Improvements

- Automate data refresh using SQL pipelines
- Expand dashboard with regional drill-down analysis
- Incorporate additional healthcare indicators
- Deploy dashboard using Tableau Server or Power BI

-----

## Author

**Chirag Arya**

GitHub: https://github.com/AryaChirag

LinkedIn: https://www.linkedin.com/in/chiragarya/

-----

⭐ If you found this project interesting, feel free to explore the repository and connect with me on LinkedIn.
