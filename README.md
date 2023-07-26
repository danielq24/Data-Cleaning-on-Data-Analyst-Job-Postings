# Data-Cleaning-on-Data-Analyst-Job-Postings
### Overview
Context: Data analysts require many skills to be a competitive applicant on the job market. It can be difficutl to prioritize which skills one should learn before becoming a data analyst. 
The purpose of this project is use an Excel file containing over 2,000 data analyst job applications to filter out useful information such as what skills are necessary, average pay, and other information
applicants are interested in. In addition, other queries will be used to better sort and clean the data. 


### Queries
The project included many SQL queries necessary for data cleaning.

Formatting:
- The company name in the original file had unnecessary numbers at the end of the string such as "J.P. Morgan 3.6" or "NYSTEC
3.8". Using the following query, it updates the database to only remove the last 3 characters in the string for only those strings that had the number values.

UPDATE[datajobs].[dbo].[DataAnalyst$]
SET [Company Name] = LEFT([Company Name], (LEN([Company Name]) - 3)) 
WHERE [Company Name] LIKE '%.%'; 

