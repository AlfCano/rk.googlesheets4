# rk.googlesheets4: Google Sheets Tools for RKWard

![Version](https://img.shields.io/badge/Version-0.0.1-blue.svg)
![License](https://img.shields.io/badge/License-GPL--3-green.svg)
![R Version](https://img.shields.io/badge/R-%3E%3D%203.0.0-lightgrey.svg)

This package provides a suite of RKWard plugins that create a graphical user interface for the popular `googlesheets4` R package. It is designed to bridge the gap between desktop RKWard sessions and cloud-based Google Sheets, allowing for authentication, reading, writing, and management of sheets without needing to memorize API functions.

## Features / Included Plugins

This package installs a new submenu in RKWard: **Data > Google Sheets (googlesheets4)**, which contains the following plugins:

*   **Authenticate:** The entry point for the package. It loads the necessary libraries and triggers the browser-based authentication flow to connect R to your Google Drive/Sheets account.
    *   `drive_auth()`
    *   `gs4_auth()`

*   **Find Sheet by Name:** specific search tool to locate sheet metadata by its name in your Drive.
    *   `gs4_find()`

*   **Get Metadata from URL:** Retrieves metadata (ID, name, permissions) using a direct URL or ID string.
    *   `gs4_get()`

*   **Read Google Sheet:** A comprehensive tool to import data into R. It supports reading specific tabs or ranges and includes a **"Smart Fix"** feature to convert list-columns (caused by mixed data types in Sheets) into clean text vectors.
    *   `read_sheet()`
    *   `range_read()`

*   **Write Data to Sheet:** Writes an R data frame into a specific tab of an existing Google Sheet.
    *   `write_sheet()`

*   **Create New Sheet:** Creates a brand new spreadsheet file in your Google Drive.
    *   `gs4_create()`

*   **Advanced Operations:** Tools for granular control over data manipulation.
    *   `sheet_append()`: Add rows to the end of a sheet.
    *   `range_write()`: Write data to a specific cell range.
    *   `range_flood()`: Fill a range with a single value.
    *   `range_clear()`: Clear data from a specific range.

## Requirements

1.  A working installation of **RKWard**.
2.  The R packages **`googlesheets4`** and **`googledrive`**. If you do not have them, install them from the R console:
    ```R
    install.packages(c("googlesheets4", "googledrive"))
    ```
3.  The R package **`devtools`** is required for installation from the source code.
    ```R
    install.packages("devtools")
    ```

## Installation

To install the `rk.googlesheets4` plugin package, you need the source code (e.g., by downloading it from GitHub).

1.  Open R in RKWard.
2.  Run the following commands in the R console:

```R
local({
## Preparar
require(devtools)
## Computar
  install_github(
    repo="AlfCano/rk.googlesheets4"
  )
## Imprimir el resultado
rk.header ("Resultados de Instalar desde git")
})
```
    
3.  Restart RKWard to ensure the new menu items appear correctly.

## Usage

Once installed, all plugins can be found under the **Data > Google Sheets (googlesheets4)** menu in RKWard.

### Example: Reading a Sheet

1.  Navigate to **Data > Google Sheets (googlesheets4) > Authenticate**. Click **Submit** and follow the instructions in your web browser to log in.
2.  Once authenticated, go to **Data > Google Sheets (googlesheets4) > Read Google Sheet**.
3.  In the "Source Type" section, select **"URL or ID (String)"**.
4.  Paste the URL of the Google Sheet you wish to read into the text field.
5.  (Optional) If you know the sheet contains mixed data types (numbers and text in the same column), check the box **"Convert mixed 'List' columns to Text"** to ensure a clean import.
6.  Click **Submit**.

A new dataframe (default name `my_sheet_data`) will be created in your workspace containing the data from the cloud.

## Author

Alfonso Cano Robles (alfonso.cano@correo.buap.mx)

Assisted by Gemini, a large language model from Google.
