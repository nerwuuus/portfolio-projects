**I. Program Board Meeting Excel file description (created in March 2024 and still in use)**

The main reasons for creating this file were:
- lack of access to ServiceNow by some internal stakeholders.
- Lack of a solution enabling the review of project statuses without obtaining data from multiple reports.
- The need to create a file that would be presented during status meetings held every two weeks.
 
This report includes various reports from ServiceNow such as Project Status, Project RAG (Red, Amber, Green) ratings, Milestones, Risks, Issues, and Project Change Requests (PCR). 
These six reports are downloaded from ServiceNow and uploaded to a dedicated folder on SharePoint. Using PowerQuery, the latest data is integrated into Excel (applied main steps: filter out Excel file names, show the latest uploaded files, keep only the first row).
![image](https://github.com/user-attachments/assets/10a25461-c3b5-499c-831f-45584834de74)



PowerQuery applied steps (repeated for every ServiceNow Excel report):

![image](https://github.com/user-attachments/assets/740ec96e-0300-4da8-b2ca-e0e5502223c1)


PowerQuery queries:

![image](https://github.com/user-attachments/assets/a176e688-2a38-42ab-a990-2cdb7717043d)


**Report structure**
Visible Sheets:
1. Governance Dashboard: Contains 12 charts (e.g., project RAG status, milestone status) and 2 tables (milestones completed and upcoming).
2. Projects Dashboard: Features a table with project details (e.g., project manager, status, priority, project name).
3. Milestones: Displays a table with all milestones (collected and manipulated using PowerQuery).
4. Risk: Lists registered risks.
5. Issues: Contains a table with registered issues.
6. PCR: Shows a table with registered project change requests.

Hidden Sheets:
1. VBA: Includes a short work instruction and 7 macros assigned to separate buttons. These macros perform tasks such as removing HTML tags from ServiceNow reports, replacing text in columns with RAG status shortcuts (R, A, G), and refreshing charts.
2. Projects: Contains data collected and manipulated using PowerQuery.
3. RAG: Holds data collected and manipulated using PowerQuery.



**II. Program Board Meeting Power BI file description (created in March 2024 and still in use)**

![image](https://github.com/user-attachments/assets/90e7e4aa-8331-4217-92d0-56b0637b6c0f)


Power BI file takes data from Program Board Meeting Excel file. Data is transformed in PowerQuery and visualised.
