**I. Program Board Meeting file description (created in March 2024 and still in use)**

This report includes various reports from ServiceNow such as Project Status, Project RAG (Red, Amber, Green) ratings, Milestones, Risks, Issues, and Project Change Requests (PCR). 
These six reports are downloaded from ServiceNow and uploaded to a dedicated folder on SharePoint. Using PowerQuery, the latest data is integrated into Excel (applied main steps: filter out Excel file names, show the latest uploaded files, keep only the first row).

Report structure:

Visible Sheets:
1. Governance Dashboard: Contains 12 charts (e.g., project RAG status, milestone status) and 2 tables (milestones completed and upcoming).
2. Projects Dashboard: Features a table with project details (e.g., project manager, status, priority, project name).
3. Milestones: Displays a table with all milestones.
4. Risk: Lists registered risks.
5. Issues: Contains a table with registered issues.
6. PCR: Shows a table with registered project change requests.

Hidden Sheets:
1. VBA: Includes a short work instruction and 7 macros assigned to separate buttons. These macros perform tasks such as removing HTML tags from ServiceNow reports, replacing text in columns with RAG status shortcuts (R, A, G), and refreshing charts.
2. Projects: Contains data collected and manipulated using PowerQuery.
3. RAG: Holds data collected and manipulated using PowerQuery.
