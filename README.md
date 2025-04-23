![image](https://github.com/user-attachments/assets/410bafce-0c1b-4b2e-91d4-d6f5d9628922)**This Excel file cannot be uploaded to GitHub due to the inclusion of sensitive employee information. Please refer to the screenshots below for details on the file structure and technical details.**

This branch contains a description of 'All activity reports' Excel file, that I created during my tenure as a PMO Specialist. 
This file solved the problem with distributed data regarding the registration of working hours in individual months (one month, one separate Excel report). Additionally, this report calculates the cost of each employee from the moment of signing the contract with the client (since 2022) until the present day.

The 'All Activity Reports' file compiles data, using PowerQuery, from all 'Time Management' reports, available on SharePoint. The 'Time Management' report is designed to collect and maintain data from SAP in an organized manner. At the beginning of each month, a 'Time Management' report is prepared and uploaded to SharePoint repository. 


![image](https://github.com/user-attachments/assets/6f9a036b-d50e-4a65-a240-d34df106a696)

Report sheets explanation: 
a.	Standby WBS – list of all standby WBS used by engineers.
b.	WFM 2021-2023 – list of employees working from 2021 to 2023.
c.	WFM 2024 - list of employees working in 2024 (PowerQuery connection to the WFM 2024 file).
d.	WFM 2025 - list of employees working in 2025 (PowerQuery connection to the WFM 2025 file).
e.	PowerQuery data – all WFM and Time Management reports data combined.
f.	Cost per WBS, Cost per employee and Standby cost – self-explanatory, pivot tables.


'PowerQuery Data' sheet columns structure:

![image](https://github.com/user-attachments/assets/5bfaa7fc-2a3e-40a7-98d3-9b375c17bf05)
PowerQuery transforms data and extracts month and year from date. Mandays are calculated using Excel formula. 
For 'HourlyRate' column calculation, I used Copilot to help me generate the below formula:
=LET(
    value; B2;
    result1; XLOOKUP(value; 'WFM 2021-2024'!A:A; 'WFM 2021-2024'!C:C; "");
    result2; XLOOKUP(value; 'WFM 2024'!A:A; 'WFM 2024'!C:C; "");
    result3; XLOOKUP(value; 'WFM 2025'!A:A; 'WFM 2025'!C:C; "");
    IF(result1 <> ""; result1; IF(result2 <> ""; result2; result3))
)

'StandbyWBS' column looks for WBS numbers that are assigned as Standby WBS:
=IFNA(
INDEX('Standby WBS'!$A$1:$C$9;MATCH([@WBS];'Standby WBS'!$A$1:$A$9;0);3);
"No")

