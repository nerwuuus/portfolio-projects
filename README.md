This branch contains a description of 'mnp' and 'inm' Excel files, and database to retrieve data from these files, that I created during my tenure as a PMO Specialist. 
Folder 'SQL' contains SQL scripts used to create main tables, staging tables, and combine them. It contains some scripts used on daily basis.

## Issue description
The mnp Excel report contains approximately 150,000 rows, with around 3,000 new rows added each month. The inm report includes about 15,000 rows, growing by roughly 2,000 rows monthly.
Using Excel to retrieve or analyze data from these files has become increasingly slow and inflexible.
<br>
<br>
Since I started learning SQL in April 2025, I decided this would be a great opportunity to set up a local PostgreSQL database on my work laptop.
To support this setup, I used a LLM (Copilot) to help generate a PowerShell script and debug the necessary SQL scripts.

## General information
There are two Excel files:
- MNP: PowerQuery pulls data from several dozen smaller historical reports (each covering one month), transform it, and generates a consolidated report spanning from April 2022 to the present day.
- iNM: PowerQuery pulls data from several dozen smaller historical reports (each covering one month), transform it, and generates a consolidated report spanning from January 2025 to the present day.<br>
The mnp and inm files are refreshed using a PowerShell script, which also saves these reports as .csv files on the desktop.
Afterward, the mnp.csv and inm.csv files are loaded into a PostgreSQL database. <br>
To avoid duplicates, the mnp and inm tables must be cleared before loading data for the most recent month.

# I. Power BI steps performed
   - Clean up the data (e.g., remove blank rows).
   - Refine and update column names.
   - Remove columns unused, e.g., realted to the Standby activities.
   - Change data formatting to the default PostgreSQL formatting: YYYY-MM-DD.
   - Keep only 'Approved' hours in the 'Status' column (remove any other values).
   - Replace currency data type with decimals.



**Any Excel and .csv files cannot be uploaded to GitHub due to the inclusion of sensitive employee information. Please refer to the screenshots below for details on the Excel file structure and technical details.**
**This Excel report is the biggest that I have ever created. It takes data from different SharePoint repositories and combines them. The result is two Excel reports, mnp (over 140 000 rows) and inm (over 20 000 rows), that contains data such as: employee name, SAP ID, number of hours approved and rejected, project name (WBS name and number).**

This file solved the problem with distributed data regarding the registration of working hours in individual months (one month, one separate Excel report). 

The 'mnp' and 'inm' files compile data, using PowerQuery, from all 'Time Management' reports, available on SharePoint. The 'Time Management' report is designed to collect and maintain data from SAP in an organized manner. At the beginning of each month, a 'Time Management' report is prepared and uploaded to SharePoint repository. 

# II. Database set-up
## Create tables inm and mnp
```sql
-- Create table inm
CREATE TABLE inm (
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)
);

-- Create table mnp
CREATE TABLE mnp (
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)
);

-- Create staging tables
CREATE TABLE mnp_staging AS
TABLE mnp;

CREATE TABLE inm_staging AS
TABLE inm;

```
## Create table ess
The ess table serves as a unified dataset, containing all records from both the inm and mnp tables.
```sql
CREATE TABLE IF NOT EXISTS ess AS (
    SELECT *
    FROM inm
    UNION ALL
    SELECT *
    FROM mnp
);
```
## First data insert
```sql
-- Insert data into table 'inm'
COPY inm 
FROM 'C:\Users\(...)\(...)\Desktop\inm.csv'
WITH (
    FORMAT csv, 
    HEADER true, 
    DELIMITER ';', 
    ENCODING 'UTF8'
);

-- Insert data into table 'mnp'
COPY mnp 
FROM 'C:\Users\(...)\(...)\Desktop\mnp.csv'
WITH (
    FORMAT csv, 
    HEADER true, 
    DELIMITER ';', 
    ENCODING 'UTF8'
);

/* 

Error 'Permission denied' while uploading data. Paste the below code in pgAdmin4, PSQL Tool to load data manually:
\copy inm FROM 'C:\Users\(...)\(...)\Desktop\inm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

Error 'Permission denied' while uploading data. Paste the below code in pgAdmin4, PSQL Tool to load data manually:
\copy mnp FROM 'C:\Users\(...)\(...)\Desktop\mnp.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

*/

```

# III. Database update
1. Run the PowerShell script below to refresh the data in the INM and SharePoint_site2 reports and export them as .CSV files.<br>
The data refresh duration can be adjusted as needed. The script includes an additional 1-minute buffer time for each file refresh to ensure completion (total runtime: 6 minutes — 3 minutes per file).
For comparison, manually refreshing both files takes approximately 4 minutes (2 minutes per file).
```PowerShell

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

\# --- SharePoint_site2 File ---
$mnpSource = "C:\\Users\\(...)\\(...)\\SharePoint_site\\SharePoint_site2\\mnp.xlsx"
$mnpCSV = "C:\\Users\\(...)\\(...)\\Desktop\\mnp.csv"

$mnpWorkbook = $excel.Workbooks.Open($mnpSource)
$mnpWorkbook.RefreshAll()
Start-Sleep -Seconds 180
$mnpSheet = $mnpWorkbook.Worksheets.Item(1)
$mnpSheet.SaveAs($mnpCSV, 6)
$mnpWorkbook.Close($false)

\# --- INM File ---
$inmSource = "C:\\Users\\(...)\\(...)\\SharePoint_site\\SharePoint_site2\\inm.xlsx"
$inmCSV = "C:\\Users\\(...)\\(...)\\Desktop\\inm.csv"

$inmWorkbook = $excel.Workbooks.Open($inmSource)
$inmWorkbook.RefreshAll()
Start-Sleep -Seconds 180 # Refresh time can be changed here
$inmSheet = $inmWorkbook.Worksheets.Item(1)
$inmSheet.SaveAs($inmCSV, 6)
$inmWorkbook.Close($false)

\# --- Cleanup ---
$excel.Quit()
\[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

Write-Host "✅ Both files refreshed and saved as CSV on your desktop."

```

2. Open the mnp and inm .csv files, and update date format to YYYY-MM-DD (or RRRR-MM-DD, depending on your system data settings). Excel often auto-formats dates incorrectly, so this manual adjustment is the most reliable (and easiest!) workaround. <br><br>

3. Due to an error 'Permission denied', tables are updated manually. Open PSQL Tool in pgAdmin4 and update the mnp_staging and inm_staging tables. Tables will be updated with the latest data.<br>
```sql
\copy inm_staging FROM 'C:\Users\(...)\(...)\Desktop\inm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

\copy mnp_staging FROM 'C:\Users\(...)\(...)\Desktop\mnp.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
```
4. Update the mnp and inm production tables with data from the previous month, using the corresponding records from the mnp_staging and inm_staging tables.
```sql
-- inm
INSERT INTO inm
SELECT *
FROM inm_staging
WHERE EXTRACT(MONTH FROM date_column) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
  AND EXTRACT(YEAR FROM date_column) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 month');

-- mnp
INSERT INTO mnp
SELECT *
FROM mnp_staging
WHERE EXTRACT(MONTH FROM date_column) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
  AND EXTRACT(YEAR FROM date_column) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 month');

```

5. Run these scripts to ensure there are no duplicates:
```sql
-- Check if duplicates were inserted mnp
SELECT 
    *, 
    COUNT(*) 
FROM mnp
GROUP BY 
    name,
    nessie,
    date,
    status,
    wbs,
    wbs_description,
    hours
HAVING COUNT(*) > 1;

-- Check if duplicates were inserted inm
SELECT 
    *, 
    COUNT(*) 
FROM inm
GROUP BY 
    name,
    nessie,
    date,
    status,
    wbs,
    wbs_description,
    hours
HAVING COUNT(*) > 1;
```

6. Refresh combined table 'ess' and partitioned tables. Run SQL scripts (below) or open file named '3 Refresh production tables', and run it.
```sql
-- Refresh data for ess table (main table)
TRUNCATE TABLE ess;

INSERT INTO ess (name, nessie, date, status, wbs, wbs_description, hours)
SELECT name, nessie, date, status, wbs, wbs_description, hours FROM mnp
UNION
SELECT name, nessie, date, status, wbs, wbs_description, hours FROM inm;

-- Create (partition) tables if they don't exist
CREATE TABLE IF NOT EXISTS ess_2022 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2022
LIMIT 0;

CREATE TABLE IF NOT EXISTS ess_2023 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2023
LIMIT 0;

CREATE TABLE IF NOT EXISTS ess_2024 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2024
LIMIT 0;

CREATE TABLE IF NOT EXISTS ess_2025 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2025
LIMIT 0;

-- Refresh data for partition table
TRUNCATE TABLE ess_2022;
INSERT INTO ess_2022
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2022;

TRUNCATE TABLE ess_2023;
INSERT INTO ess_2023
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2023;

TRUNCATE TABLE ess_2024;
INSERT INTO ess_2024
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2024;

TRUNCATE TABLE ess_2025;
INSERT INTO ess_2025
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2025;
```




## ⚠️ If the PowerShell script didn’t work, follow the steps below manually
1. Save Files as UTF-8 CSV. Export the mnp and inm files in .csv format with UTF-8 encoding.

2. Adjust Date Format. Open both .csv files and change the date format to YYYY-MM-DD (or RRRR-MM-DD, depending on your system settings).

3. Clean Database Tables. Use the TRUNCATE command to clear the mnp and inm tables before loading new data (as described in step 3 above).

4. Update Tables via pgAdmin4. Open the PSQL tool in pgAdmin4. Load the updated mnp.csv and inm.csv files into the corresponding tables.
⚠️ If you encounter an error like "more columns than expected", open the .csv files and remove any blank columns (especially those on the far right).

5. Execute the scripts mentioned in steps 3 and 5 above to complete the process.


## Stack
- Microsoft Excel  
- PowerQuery  
- DAX  
- PostgreSQL, pgAdmin4  
- Visual Studio Code  
- PowerShell  
- Copilot





