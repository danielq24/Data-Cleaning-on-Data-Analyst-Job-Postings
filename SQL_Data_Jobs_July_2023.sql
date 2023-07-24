/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [F1]
--      ,[Job Title]
--      ,[Salary Estimate]
--      ,[Job Description]
--      ,[Rating]
--      ,[Company Name]
--      ,[Location]
--      ,[Headquarters]
--      ,[Size]
--      ,[Founded]
--      ,[Type of ownership]
--      ,[Industry]
--      ,[Sector]
--      ,[Revenue]
--      ,[Competitors]
--      ,[Easy Apply]
--  FROM [datajobs].[dbo].[DataAnalyst$]


-- SELECT ALL ROWS 
SELECT *
FROM [datajobs].[dbo].[DataAnalyst$]

-- REmove unnecessary fields
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
DROP COLUMN [rating],
			[revenue],
			[competitors],
			[easy apply],
			[type of ownership]



-- Create duplicate of salary for practice
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Setter] Nvarchar(255);

--to get rid of (glassdoor est.) in [salary estimate]
UPDATE [datajobs].[dbo].[DataAnalyst$]
SET [Salary Estimate] = REPLACE([Salary Estimate], ' (Glassdoor est.)', '');

-- Separate the salary into min and max salary as nvarchar
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
DROP COLUMN [Min Salary],
			[Max Salary]

ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Min Salary] Nvarchar(255),
    [Max Salary] Nvarchar(255);

UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Min Salary] = SUBSTRING([Salary Estimate], 1,  CHARINDEX('-', [Salary Estimate]) -1),
    [Max Salary] = SUBSTRING([Salary Estimate], CHARINDEX('-', [Salary Estimate]) +1, LEN([Salary Estimate]))

-- Separate the salary into min and max salary as int using cast
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Min Salary (in thousands)] int,
    [Max Salary (in thousands)] int;

UPDATE datajobs.dbo.[DataAnalyst$]
SET [Min Salary (in thousands)] = CAST(REPLACE(REPLACE(LEFT([Salary Estimate], CHARINDEX('-', [Salary Estimate]) - 1), '$', ''), 'K', '') AS INT),
    [Max Salary (in thousands)] = CAST(REPLACE(REPLACE(RIGHT([Salary Estimate], LEN([Salary Estimate]) - CHARINDEX('-', [Salary Estimate])), 'K', ''), '$', '') AS INT)


-- Separate the company city and state from the location field into two columns 
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Company City] Nvarchar(255);

ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Company State] Nvarchar(255);

UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Company City] = SUBSTRING(Location, 1,  CHARINDEX(',', Location) -1) 

UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Company State] = SUBSTRING(Location, CHARINDEX(',', Location) + 1, LEN(Location))

UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Company State] = TRIM([Company State])


-- Add location
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Location] Nvarchar(255);

UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Location] = CONCAT(CONCAT([Company City], ',' )  ,  CONCAT(' ',[Company State] ));

-- drop original location 
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
DROP COLUMN location

-- Discovering common keywords 
SELECT 
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%sql%' )) AS 'sql mentions',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%excel%' )) AS 'excel',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%python%' )) AS 'python mentions',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%power bi%' )) AS 'power BI mentions',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%Tableau%' )) AS 'Tableau',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%SAS%' )) AS 'SAS',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%Java%' )) AS 'Java',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '% R %' )) AS 'R mentions',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%Azure%' )) AS 'Azure',
	(SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%power point%' )) AS 'power point mentions'


-- discovering benefits and work life preferences
SELECT 
 (SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%401K%' )) AS '401K',
 (SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%hybrid%' )) AS 'hybrid',
 (SELECT count([Job Description]) FROM [datajobs].[dbo].[DataAnalyst$] WHERE ([job description] LIKE '%remote%' )) AS 'remote'


-- finding the average min and max salaries
SELECT AVG([Min Salary (in thousands)]) as 'Avg Min Salary', AVG([Max Salary (in thousands)]) as 'Avg Max Salary'
FROM [datajobs].[dbo].[DataAnalyst$]

SELECT *
FROM [datajobs].[dbo].[DataAnalyst$]
WHERE [Company State] = 'WA'