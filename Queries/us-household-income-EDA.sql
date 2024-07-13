SELECT *
FROM us_household_income
;


SELECT *
FROM us_household_income_statistics
;


#Top 10 land areas by state
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

/*
There is a lot of data from the us_household_income table
that is not populated compared to the us_household_income_statistics table.

I could go back and fix the missing data, or I could delete the statistics records.
For now I am not going to use the records where half the data is missing.
*/
SELECT *
FROM us_household_income u
RIGHT JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE u.id IS NULL
;

#Many areas are not reporting any income data, so those areas will be filtered out.
SELECT *
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

#Overall state averages of mean and median household incomes
SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
;

/*
Overall place type averages of mean and median household incomes

A lot of these types have such a low count that I would not want to
use them as they are considered to be outliers, so they will be filtered out.
*/
SELECT Type, COUNT(Type), ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 3 DESC
;

#Community type places have very low averages, and now I can see that all the communities are located in Puerto Rico
SELECT *
FROM us_household_income
WHERE Type = 'Community'
;

#Now I am looking at the average household incomes on a city level.
#The median seems to cap out at 300k, which makes me wonder.
#Some cities have huge average incomes.
SELECT u.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
RIGHT JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name, City
ORDER BY 3 DESC
;