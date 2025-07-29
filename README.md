# General information
This branch contains documentation for the 'mnp' and 'inm' Excel reports, along with the supporting database I developed during my tenure as a PMO Specialist. These reports are the most comprehensive I have created to date.
## Issue description
   - The source data was originally distributed across dozens of Excel files, each representing a separate month of employee time registration, starting from April 2022 up to the present. This decentralised structure made data consolidation time-consuming and prone to errors.
   - The 'mnp' Excel report contains approximately 150,000 rows, with around 3,000 new rows added each month. The 'inm' report includes approximately 15,000 rows, with an addition of roughly 2,000 rows each month. Both reports include key data such as employee name, SAP ID, approved and rejected hours, and project identifiers (WBS name and number). **Using Excel alone to retrieve or analyse this data had become increasingly slow and inflexible.**
## Issue resolution
To address these challenges, I used Power Query in Excel to retrieve data directly from SharePoint and then loaded it into a PostgreSQL database for structured processing and analysis. This approach enabled:
   - Efficient consolidation of monthly data into unified reports.
   - Significant improvements in reporting speed, data accuracy, and overall productivity.
<br><br> 
The 'SQL' folder contains scripts used to create the database structure, including main tables, staging tables, and data transformation logic. It also includes several daily-use SQL queries that support ongoing operations.

## High-Level Overview of Excel-Based Data Integration, Database Staging and Update Process
**Data Compilation via PowerShell & Power Query**
- A PowerShell script automates the compilation of data into the mnp and inm Excel files. These files use Power Query to extract data from all available Time Management reports stored on SharePoint — one report per month. These reports are structured exports from SAP and are uploaded to SharePoint at the beginning of each month.

**Export to CSV Format**
- Once the data is refreshed, the script saves the updated Excel files as mnp.csv and inm.csv on the desktop.

**Import into PostgreSQL Staging Tables**
- The CSV files are then imported into the corresponding PostgreSQL staging tables (mnp_staging and inm_staging) for further processing.

**Data Validation and Main Table Update**
- After passing data quality checks, validated data is used to update the main database tables.

# I. Excel file and PowerQuery
## Data clean up and transformation steps in PowerQuery
The imported data undergoes several transformation steps:
   - Blank rows are removed to ensure data cleanliness.
   - Column names are standardised across both reports to maintain consistency.
   - Date formats are converted to the default PostgreSQL format (YYYY-MM-DD).
   - Currency fields are converted to decimal format, using a period (.) as the decimal separator.
## Important information
Any Excel and .csv files cannot be uploaded to GitHub due to the inclusion of sensitive employee information.

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
```
## Create staging tables
The staging tables inm_staging and mnp_staging are used during database updates to validate data integrity before applying changes to the main tables.
```sql
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
1. Run the PowerShell script below to refresh the data in the INM and SharePoint_site2 reports and export them as .csv files.<br>
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

3. Due to an error, 'Permission denied', tables are updated manually. Open PSQL Tool in pgAdmin4 and update the mnp_staging and inm_staging tables. Tables will be updated with the latest data.<br>
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

6. Refresh the combined table 'ess' and partitioned tables. Run SQL scripts (below) or open the file named '3 Refresh production tables', and run it.
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




## ⚠️ If the PowerShell script didn’t work, follow the steps below
1. Save Files as UTF-8 CSV. Export the mnp and inm files in .csv format with UTF-8 encoding.

2. Adjust Date Format. Open both .csv files and change the date format to YYYY-MM-DD (or RRRR-MM-DD, depending on your system settings).

3. Clean Database Tables. Use the TRUNCATE command to clear the mnp and inm tables before loading new data (as described in step 3 above).

4. Update Tables via pgAdmin4. Open the PSQL tool in pgAdmin4. Load the updated mnp.csv and inm.csv files into the corresponding tables.
   If you encounter an error like "more columns than expected", open the .csv files and remove any blank columns (especially those on the far right).

5. Execute the scripts mentioned in steps 3 and 5 above to complete the process.


## Stack
- Microsoft Excel  
- PowerQuery  
- DAX  
- PostgreSQL, pgAdmin4  
- Visual Studio Code  
- PowerShell  
- Copilot
- GitHub





