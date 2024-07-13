SELECT *
FROM us_household_income
;

#At first glance I notice 200+ rows were not imported and some places have 0 income

#Checking both tables for duplicate id numbers
#us_household_income has several duplicate id numbers
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

#us_household_income_statistics has no duplicate id numbers
SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

#I am deleting the duplicates using the same method that was used for the world-life-expectancies dataset.
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_household_income
	) duplicates
	WHERE row_num > 1
)
;

/*
Checking for state names that are spelled incorrectly.

The first project taught me that this is a quick way to check every single column and row for correctness.

I will be using this method on appropriate columns to identify missing values and/or misspelled values, so I can standardize everything.
*/
SELECT DISTINCT State_Name, COUNT(State_Name)
FROM us_household_income
GROUP BY State_Name
ORDER BY State_Name
;

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

SELECT DISTINCT State_ab, COUNT(State_ab)
FROM us_household_income
GROUP BY State_ab
ORDER BY State_ab
;

SELECT *
FROM us_household_income
WHERE Place = '' OR Place IS NULL
;

SELECT * 
FROM us_household_income
WHERE County = 'Autauga County'
;

#There is 1 missing Place value, I will populate it using the same value as above and below it
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE id = 102216
;

SELECT DISTINCT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
ORDER BY Type
;

#I need to look into the CDP/CPD Type; I cant update it without being sure that they are the same thing.

#There are 128 Borough and 1 Boroughs, so I will be fixing that.
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

#I noticed some ALand and AWater values are 0, so I am taking a look at those rows
#I can see that some places are either just land or just water, so no changes are needed
SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
;

SELECT ALand, AWater
FROM us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
;