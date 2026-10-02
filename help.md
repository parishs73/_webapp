When building the zip file in linux make sure to build oit with

zip -ju <zip file name> <files to add seperated by space>

before deployemtn make sure the environmnet has do build during deploy set to true

az webapp config appsettings set --name <web-app name>> --resource-group <resource group>> --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true

when deploying the webapp use:

az webapp deploy --name <web-app name> -g <resource group> --src-path deployment.zip --type zip

This took days to sort out and ai wasn't that much help



| Type ID | Element Type | Description |
| :--- | :--- | :--- |
| **`1`** | **Text / Markdown** | Renders static documentation, titles, hints, or instructions using Markdown. |
| **`3`** | **Query / Grid** | Executes queries (KQL, Log Analytics, Azure Resource Graph, Azure Data Explorer, JSON, etc.) and visualizes data as grids, charts, or graphs. |
| **`9`** | **Parameters** | Creates interactive user inputs like dropdowns, text areas, date pickers, or resource selectors to scope downstream steps. |
| **`11`** | **Links / Tabs / Actions** | Configures navigation menus, structural tabs, action buttons, or links to external Azure blades. |
| **`12`** | **Groups** | Acts as a container component to group multiple sub-items together for layout framing, conditional visibility, or scoping load triggers. |
| **`14`** | **Metrics** | Connects to standard multi-resource Azure Monitor metrics and prints time-series performance data. |
