# General information
A Service Activation is a web tool used to monitor and manage the activation of services, systems, or facilities, ensuring that all necessary tasks are completed. The data used in this report was sourced from the web-based Service Activation Tracker. Data was exported into an Excel file and loaded into the Service Activation Tracker file using PowerQuery. The report was created in January 2024 and was actively used until October 2024.
## Issue description
Initially, the data was only accessible through a web-based application. However, a key challenge emerged: not all stakeholders had access to the Service Activation Tool, and many were reluctant to learn how to navigate it. Additionally, retrieving the data was difficult and time-consuming, while management primarily required high-level reports.
## Issue resolution
To address these issues, I developed a Service Activation Tracker in Excel. Upon request, I exported data from the Service Activation application and uploaded it to SharePoint. The report was then refreshed using Power Query, which automatically pulled the latest uploaded export, ensuring the data was always up to date and ready to be shared. No visualisations were required for this solution.

It was my first report created that used PowerQuery, defined variables, a FILTER formula and multiple nested IFs:
```PowerShell
Service Activation Tracker - 'SA Tracker' sheet - 'Days to complete' column formula:
=IF(F2="";"";
IF(D2="Cancelled";"Cancelled";
IF(F2=0;"Undefined";
IFERROR(
IF(M2>80%;"Completed";
ABS(
LET(varToday;$T$1;
IF(ISTEXT(F2)=TRUE;"";
IF(F2<=varToday;"";varToday-F2)))));
"Breached"))))

Service Activation Tracker - 'Search bar' sheet formula:
=IFERROR(
SORT(
CHOOSECOLS(
FILTER('SA Tracker'!A2:O300;
ISNUMBER(SEARCH('Search bar'!D3;'SA Tracker'!B2:B300))+ISNUMBER(SEARCH('Search bar'!D3;'SA Tracker'!A2:A300))
+ISNUMBER(SEARCH('Search bar'!D3;'SA Tracker'!C2:C300))+ISNUMBER(SEARCH('Search bar'!D3;'SA Tracker'!D2:D300))
+ISNUMBER(SEARCH('Search bar'!D3;'SA Tracker'!E2:E300))+ISNUMBER(SEARCH('Search bar'!D3;'SA Tracker'!F2:F300))
+ISNUMBER(SEARCH('Search bar'!D3;'SA Tracker'!M2:M300)));
1;2;3;4;5;6;12);
1;1);
"Not found")
```

## Report
SA Tracker Sheet - the main data
![image](https://github.com/user-attachments/assets/6933b04f-6a7b-42be-a7d8-f245b46db6c1)



Search bar with conditional formatting
![image](https://github.com/user-attachments/assets/d6f6318c-e4e4-45c0-80fc-579b5ed007e0)



Simple dashboard
![image](https://github.com/user-attachments/assets/3f7e197b-7303-4dc3-b70d-c348d7822e9f)


## PowerQuery steps applied

![image](https://github.com/user-attachments/assets/91549f4a-181d-43e9-af87-a24ed14aebc1)


