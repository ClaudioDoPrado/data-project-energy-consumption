-- Apresentation,  https://docs.google.com/presentation/d/1arC_jUv39PDcYOUJvnvfGIjmFNGcMwCdSXuWBpGpwjs/edit#slide=id.g346215e72f0_0_5

-- Trello, https://trello.com/b/Hcj2fgQp/durmstrang

use energy_stats;

-- Total Population and Area by Region:
-- This query provides the total population and total area of countries grouped by region for the last 10 years.

SELECT region, 
       ROUND(SUM(population), 2) AS total_population, 
       ROUND(SUM(area), 2) AS total_area
FROM clean_countries
GROUP BY region;

-- Top 10 Countries with the Largest Renewable Energy Consumption:
-- Top 10 countries that consume the most renewable energy over the last 10 years:

WITH RenewableEnergyTotals AS (
    SELECT country, 
           SUM(`Renewable_Energy_Share__%`) AS total_renewable_energy
    FROM energy_type
    WHERE year >= YEAR(CURRENT_DATE) - 10
    GROUP BY country
)
SELECT country, 
       ROUND(total_renewable_energy, 2) AS total_renewable_energy
FROM RenewableEnergyTotals
ORDER BY total_renewable_energy DESC;
-- LIMIT 10;

SELECT * 
FROM energy_type;

-- Average Total Energy Consumption by Country:
-- Compare the average total energy consumption (both renewable and fossil fuel) over the last 10 years:

SELECT country, 
       ROUND(AVG(Total_Energy_Consumption__TWh), 2) AS average_consumption_twh
FROM energy_type
WHERE year >= YEAR(CURDATE()) - 10
GROUP BY country
ORDER BY average_consumption_twh DESC;

-- Total Renewable vs. Fossil Fuel Consumption for Each Country:
-- Calculate total renewable and fossil fuel consumption for each country over the last 10 years:

SELECT country, 
       ROUND(SUM(`Renewable_Energy_Share__%`), 2) AS total_renewable, 
       ROUND(SUM(`Fossil_Fuel_Dependency__%`), 2) AS total_fossil_fuel
FROM energy_type
WHERE year >= YEAR(CURDATE()) - 10
GROUP BY country;

-- Correlation Between Population and Total Energy Consumption:
-- Analyze the relationship between population size and total energy consumption for each country over the last 10 years:

SELECT c.name, 
       c.population, 
       ROUND(SUM(e.`Total Energy Consumption (TWh)`), 2) AS total_energy_consumption
FROM clean_countries AS c
JOIN total_energy AS e ON c.name = e.country
WHERE e.year >= YEAR(CURRENT_DATE) - 10
GROUP BY c.name, c.population
ORDER BY total_energy_consumption DESC;

-- Average Energy Consumption per Person:
-- Calculate the average energy consumption per capita for each country over the last 10 years:

SELECT c.name, 
       AVG(e.`Total Energy Consumption (TWh)` / c.population) AS consumption_per_capita 
FROM clean_countries AS c
JOIN total_energy AS e ON c.name = e.country
WHERE e.year >= YEAR(CURDATE()) - 10
GROUP BY c.name
ORDER BY consumption_per_capita DESC;

-- Countries with Highest Total Energy Consumption:
-- Find countries with the highest total energy consumption for the latest year available in the last 10 years:

SELECT country, `Total Energy Consumption (TWh)`
FROM total_energy
WHERE year = (SELECT MAX(year) FROM total_energy WHERE year >= YEAR(CURDATE()) - 10)
ORDER BY `Total Energy Consumption (TWh)` DESC
LIMIT 10;

-- analyze the claim that renewable energy has been the most consumed energy type over the last 10 years,

SELECT 
    country, 
    ROUND(SUM(`Renewable_Energy_Share__%`), 2) AS total_renewable_energy,
    ROUND(SUM(`Fossil_Fuel_Dependency__%`), 2) AS total_fossil_fuel,
    ROUND(SUM(Total_Energy_Consumption__TWh), 2) AS total_energy_consumption
FROM 
    energy_type AS e
WHERE 
    year >= YEAR(CURRENT_DATE) - 10
GROUP BY 
    country
ORDER BY 
    total_energy_consumption DESC;
    
    
SELECT 
    year, 
    country,
    ROUND(SUM(`Renewable_Energy_Share__%`), 2) AS total_renewable_energy_generated
FROM 
    energy_type
WHERE 
    year >= YEAR(CURRENT_DATE) - 10
GROUP BY 
    year, country
ORDER BY 
    year ASC, country ASC;
    
SELECT
    country,
    ROUND(SUM(`Renewable_Energy_Share__%`), 2) AS total_renewable_energy,
    ROUND(SUM(`Fossil_Fuel_Dependency__%`), 2) AS total_fossil_fuel,
    ROUND(SUM(Total_Energy_Consumption__TWh), 2) AS total_energy_consumption
FROM
    energy_type AS e
WHERE
    year >= YEAR(CURRENT_DATE) - 10
GROUP BY
    country
ORDER BY
    total_energy_consumption DESC;
    
SELECT 
    et.Country, 
    et.Year, 
    ROUND(SUM(`Renewable_Energy_Share__%`), 2) AS Total_Renewable_Share,
    ROUND(SUM(`Fossil_Fuel_Dependency__%`), 2) AS Total_Fossil_Share,
    ROUND(SUM(`Total_Energy_Consumption__TWh`), 2) AS Total_Energy_Consumption
FROM energy_type et
WHERE et.Country IN ('USA', 'Canada')
GROUP BY et.Country, et.Year
ORDER BY et.Country, et.Year;
