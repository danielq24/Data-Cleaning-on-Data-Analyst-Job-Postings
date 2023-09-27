# Data-Cleaning-on-Data-Analyst-Job-Postings
### Overview
Context: Data analysts require many skills to be a competitive applicant on the job market. It can be difficult to prioritize which skills one should learn before becoming a data analyst. 
The purpose of this project is use an Excel file containing over 2,000 data analyst job applications to filter out useful information such as what skills are necessary, average pay, and other information
applicants are interested in. In addition, other queries will be used to better sort and clean the data. 


### Queries
The project included many SQL queries necessary for data cleaning.

Removing unused fields:
- Through the exploration of the data, it was discovered that there are no duplicate values through searching the job titles and descriptions. While there are null values represented as -1, they are focused in less important fields such as industry, sector, size of company, and headquarters. There are fields that are not useful to an applicant on a job search and will be removed from the database. This includes rating, revenue, competitors, easy apply, and type of ownership fields. 

Formatting:
- Removing digits from the company name: The company name in the original file had unnecessary numbers at the end of the string such as "J.P. Morgan 3.6" or "NYSTEC
3.8". Using the following query, it updates the database to only remove the last 3 characters in the string for only those strings that had the number values.
```
UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Company Name] = LEFT([Company Name], (LEN([Company Name]) - 3)) 
WHERE [Company Name] LIKE '%.%'; 
```
- Removing parts of a string within a numeric salary value. The salary estimate field included the string "Glassdoor est." at the end which is not useful for creating statistics on this field. An example of this change is $77K-$132K(Glassdoor est.) to $77K-$132K
```
UPDATE [datajobs].[dbo].[DataAnalyst$]
SET [Salary Estimate] = REPLACE([Salary Estimate], ' (Glassdoor est.)', '');
```
- Separating the company location into two columns: The company location is a string that includes the city and state of the company separated by a comma. This field can be separted into two columns representing the city and the state using
```
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Company City] Nvarchar(255);
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Company State] Nvarchar(255);

UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Company City] = SUBSTRING(Location, 1,  CHARINDEX(',', Location) -1) 
UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Company State] = SUBSTRING(Location, CHARINDEX(',', Location) + 1, LEN(Location))
```


Field extraction & type casting:
- The salary estimate is displayed at $(min salary)-$(max salary). This field can be used to split into columns called low salary and max salary. It is also necessary type cast to convert the string into a numeric variable.
```
ALTER TABLE [datajobs].[dbo].[DataAnalyst$]
ADD [Min Salary (in thousands)] int,
    [Max Salary (in thousands)] int;

UPDATE datajobs.dbo.[DataAnalyst$]
SET [Min Salary (in thousands)] = CAST(REPLACE(REPLACE(LEFT([Salary Estimate], CHARINDEX('-', [Salary Estimate]) - 1), '$', ''), 'K', '') AS INT),
    [Max Salary (in thousands)] = CAST(REPLACE(REPLACE(RIGHT([Salary Estimate], LEN([Salary Estimate]) - CHARINDEX('-', [Salary Estimate])), 'K', ''), '$', '') AS INT)
```
### Data Findings:
Data cleaning is essential for the job applications file as it ensures the data is accurate, consistent, and free from errors or anomalies. By meticulously cleaning and organizing the data, It improves data reliability and enables me to derive meaningful insights, leading to more informed decisions. 
- Skills Keywords: Through filtering out the job descriptions, we can discover important key words such as skills to see which tools applicants should focus on:
  

![image](https://github.com/danielq24/Data-Cleaning-on-Data-Analyst-Job-Postings/assets/123119481/7854511a-7c2d-462b-935b-5d9dbaf8c5ce)


- Worklife balance & benefits:


![image](https://github.com/danielq24/Data-Cleaning-on-Data-Analyst-Job-Postings/assets/123119481/2e941fe6-d353-4c60-8d9d-0d92031111c0)



### Data Cleaning Database Images
Before:
![image](https://github.com/danielq24/Data-Cleaning-on-Data-Analyst-Job-Postings/assets/123119481/a3c894c5-5c57-45de-bf11-1df0f9736287)
After:
![image](https://github.com/danielq24/Data-Cleaning-on-Data-Analyst-Job-Postings/assets/123119481/b2b2f53d-782d-4a96-aee7-27e5ca578b7f)

![image](https://github.com/danielq24/Data-Cleaning-on-Data-Analyst-Job-Postings/assets/123119481/98b06e27-1949-4914-a9b3-9d2ba91084cb)
![image](https://github.com/danielq24/Data-Cleaning-on-Data-Analyst-Job-Postings/assets/123119481/67ce0c66-9dc7-4346-aaa2-70a8983a0d5e)
