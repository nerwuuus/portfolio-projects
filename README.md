This branch contains a description of 'All activity reports' Excel file, that I created during my tenure as a PMO Specialist. 


Folder 'SQL' contains 5 SQL files:
- 0_all_activity_report - all SQL scripts in one file
- 1_create_database_ess
- 2_create_table_ess
- 3_data_insert_and_table_modify
- 4_calculations_and_additional_tables

Due to the Excel's poor performance, I decided to use PostgreSQL (pgAdmin4) to manipulate and use 'All activity report'. It is much easier and faster to, e.g., filter out needed data and then export it to .csv.

Steps performed:

1. Clean up the data:
   - Remove blank rows.
   - Refine and update column names.
   - Remove columns unused, e.g., realted to the Standby activities.
   - Change data formatting to the default PostgreSQL formatting: YYYY-MM-DD.
   - Keep only 'Approved' hours in the 'Status' column (remove any other values).
   - Replace currency data type with decimals.
2. Save the 'All activity reports' as .csv (UTF-8).
3. Create database 'ess'.
4. Connect database 'ess' to VSCode using 'SQLTools' extension.
5. Upload data.
6. Remove bugs and resolve issues using Google, Stackoverflow and Copilot :-)
7. Write some SQL scripts. 


**Any Excel and .csv files cannot be uploaded to GitHub due to the inclusion of sensitive employee information. Please refer to the screenshots below for details on the Excel file structure and technical details.**
**This Excel report is the biggest that I have ever created. It takes data from 2 different SharePoint repositories and combines them. The result is the report with almost 140 000 rows, that contains data such as: employee name, SAP ID, hourly rate, number of hours approved and rejected, project name (WBS name and number).**

This file solved the problem with distributed data regarding the registration of working hours in individual months (one month, one separate Excel report). 
Additionally, this report calculates the cost of each employee from the moment of signing the contract with the client (since 2022) until the present day.

The 'All Activity Reports' file compiles data, using PowerQuery, from all 'Time Management' reports, available on SharePoint. The 'Time Management' report is designed to collect and maintain data from SAP in an organized manner. At the beginning of each month, a 'Time Management' report is prepared and uploaded to SharePoint repository. 


![image](https://github.com/user-attachments/assets/6f9a036b-d50e-4a65-a240-d34df106a696)

Report sheets explanation: 
- Standby WBS – list of all standby WBS used by engineers.
- WFM 2021-2023 – list of employees working from 2021 to 2023.
- WFM 2024 - list of employees working in 2024 (PowerQuery connection to the WFM 2024 file).
- WFM 2025 - list of employees working in 2025 (PowerQuery connection to the WFM 2025 file).
- PowerQuery data – all WFM and Time Management reports data combined.
- Cost per WBS, Cost per employee and Standby cost – self-explanatory, pivot tables.


'PowerQuery Data' sheet columns structure:

![image](https://github.com/user-attachments/assets/5bfaa7fc-2a3e-40a7-98d3-9b375c17bf05)
PowerQuery transforms data and extracts month and year from date. Mandays are calculated using simply Excel formula.

****More advanced Excel formulas are available in the 'Excel formulas snippet' file.****



PowerQuery applied steps:

![image](https://github.com/user-attachments/assets/ce2f7155-e9aa-484b-b881-3c42e9ede700)


PowerQuery list of all queries:

![image](https://github.com/user-attachments/assets/ed6f6a64-6087-4f9c-a8e4-8c09f97b120a)


