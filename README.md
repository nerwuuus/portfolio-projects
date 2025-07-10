This branch contains a description of 'mnp' and 'inm' Excel files, that I created during my tenure as a PMO Specialist. 


Folder 'SQL' contains SQL scripts used to create main tables, staging tables, and combine them. It contains some scripts used on daily basis.

# Power BI steps performed
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
**This Excel report is the biggest that I have ever created. It takes data from different SharePoint repositories and combines them. The result is two Excel reports, mnp (over 140 000 rows) and inm (over 20 000 rows), that contains data such as: employee name, SAP ID, number of hours approved and rejected, project name (WBS name and number).**

This file solved the problem with distributed data regarding the registration of working hours in individual months (one month, one separate Excel report). 

The 'mnp' and 'inm' files compile data, using PowerQuery, from all 'Time Management' reports, available on SharePoint. The 'Time Management' report is designed to collect and maintain data from SAP in an organized manner. At the beginning of each month, a 'Time Management' report is prepared and uploaded to SharePoint repository. 


'PowerQuery Data' sheet columns structure:

![image](https://github.com/user-attachments/assets/5bfaa7fc-2a3e-40a7-98d3-9b375c17bf05)
PowerQuery transforms data and extracts month and year from date. Mandays are calculated using simply Excel formula.

****More advanced Excel formulas are available in the 'Excel formulas snippet' file.****



PowerQuery applied steps:

![image](https://github.com/user-attachments/assets/ce2f7155-e9aa-484b-b881-3c42e9ede700)


PowerQuery list of all queries:

![image](https://github.com/user-attachments/assets/ed6f6a64-6087-4f9c-a8e4-8c09f97b120a)


