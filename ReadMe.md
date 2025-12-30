# wrkPass Application
This demo app is built with 4D Qodly Pro and is meant to inspire you or help you kickstart your own project.

## Purpose of the Application

wrkPass is an all-in-one telecommuting solution designed to streamline the coordination of remote, hybrid, and onsite work.
The application allows employees to declare their work status, schedule meetings that match their availability mode, and maintain fluid communication between teams and managers. It simplifies workforce organization and ensures smooth collaboration across distributed environments.

![Dashboard](Project/Sources/Shared/visuals/dashboard.png)

## Main Features

- Interactive dashboard for viewing and managing work statuses
- Dedicated pages for creating, viewing, and managing meetings
![Add meeting](Project/Sources/Shared/visuals/newMeeting.png)
- Ability for users to declare their current work mode: Remote, Hybrid, or Onsite
![Status](Project/Sources/Shared/visuals/status.png)
- Meeting management with filtering by work status
- Managers can view and manage their team’s statuses and meetings
![declare status](Project/Sources/Shared/visuals/declareStatus.png)
- Employees can view their own status history and related meetings
- Real-time overview for administrators to monitor organization-wide work modes
![Teams](Project/Sources/Shared/visuals/teams.png)

- Secure, role-based access ensuring proper visibility and permissions

## How to run
 
###  Pre-requisites (4D Software):
- Download the latest Release version of 4D: [Product Download](https://us.4d.com/product-download/Feature-Release)
- Or the latest Beta version: [Beta Program](https://discuss.4d.com/)
- Follow activation steps: [Installation Guide](https://developer.4d.com/docs/GettingStarted/installation)
 
### Steps to Run the Project
- Clone or download this repository to your local machine. Need help? See Using GitHub with 4D.
- Open the project in 4D: Go to File > Open Project (More details here: Open a Project)
- Open Qodly Studio: Go to Design > Qodly Studio menu
- Run the application: Click Run to start the server and preview the app in your browser
 
## Configuration & Credentials
 
This section explains exactly how to wire credentials and test the app (what to create, where to place files, and what the app already provides).

### Do I need to create external accounts?
  - Microsoft Teams / Meetings: Yes — to enable automatic meeting creation, the application must be connected to Microsoft Azure / Microsoft Graph.

        - You need to register an application in Azure Active Directory and grant it permission to create Teams meetings on behalf of users or as an application.

    - Example (Microsoft Graph – Teams Meetings)
        - Tenant ID: `your Azure tenant ID`
        - Client ID: `your Azure application (client) ID`
        - Client Secret: `your Azure application secret`
        - Authority: https://login.microsoftonline.com/`tenant-id`
        - Scope: https://graph.microsoft.com/.default 

### Where does the app read credentials?
- Credentials are configured via the **Credentials** page located in the Settings section.
- External service keys and secrets are stored and accessed through the database.

### How to test Teams meeting locally
Provide Microsoft Graph credentials, then trigger a Teams meeting creation action to test the integration locally.
 
## Test accounts and sample data

  - The app includes a data generator `Project/Sources/Classes/data.4dm` which creates sample users with known emails and passwords as well as related demo data. You can call it from the UI (home.WebForm) or run `ds.generateData()` in the server console.

## Where to find the code for each feature

If you want to change the behavior or appearance of a specific feature, edit the files listed below.

- Authentication / Login
  - Code: `Project/Sources/Classes/DataStore.4dm` (method: `authentify`) — handles login, session privileges and landing page routing.
  - UI: `Project/Sources/WebForms/login.WebForm` 