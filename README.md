**This Excel file cannot be uploaded to GitHub due to the inclusion of sensitive employee information. Please refer to the screenshots below for details on the file structure and technical details.**

This branch contains a description of 'All activity reports' Excel file, that I created during my tenure as a PMO Specialist. 
This file solved the problem with distributed data regarding the registration of working hours in individual months (one month, one separate Excel report). 
Additionally, this report calculates the cost of each employee from the moment of signing the contract with the client (since 2022) until the present day.

The 'All Activity Reports' file compiles data, using PowerQuery, from all 'Time Management' reports, available on SharePoint. The 'Time Management' report is designed to collect and maintain 
data from SAP in an organized manner. At the beginning of each month, a 'Time Management' report is prepared and uploaded to SharePoint repository. 


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



PowerQuery applied steps:

![image](https://github.com/user-attachments/assets/ce2f7155-e9aa-484b-b881-3c42e9ede700)


PowerQuery list of all queries:

![image](https://github.com/user-attachments/assets/ed6f6a64-6087-4f9c-a8e4-8c09f97b120a)


