# Databases Final Project

![databases @ kea](https://img.shields.io/badge/software%20testing-kea-%23ea5045)
![docker](https://img.shields.io/badge/docker-yes-blue)

Source Code for the final project for databases at KEA Copenhagen.

## Prerequisites

- Python 3
- SQL Server
- Microsoft ODBC Driver 17
  - [Download for Windows](https://www.microsoft.com/en-us/download/details.aspx?id=56567)
  - [Guide for OS X and Linux](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15)
-Setting up the database should be done before accessing web app:

##Setup (for database)

###1. Run scripts in "security" folder following the numbering 000_Schema, 001_Procedure,002_Triggers, 003_Temporal_table, 004_Audit, 005_Indexes
###2. Import test data in "data" folder: Testdata v3.sql
*** Procedure for Neo4j is included in Cypher Script

## Setup (for development)

Follow these steps to install the virtual environment.

### 1. Create a virtual environment (optional)

Open a command line (Powershell or CMD, Windows) or a console (OS X / Linux), navigate to the source code directory and create a new virtual environment:

```sh
python -m venv venv
```

A new folder called `venv` should have been created.

Whenever you want to use this newly created venv (everytime you open a new terminal), use

**Windows**:
```sh
# cmd.exe:
.\venv\Scripts\activate.bat

# PowerShell
.\venv\Scripts\Activate.ps1
```

**OS X / Linux**:
```sh
source ./venv/bin/activate
```

### 2. Install requirements

Navigate to the outer `app/` folder and enter:

```sh
pip install -r requirements.txt
```

### 3. Copy .env.example to .env
```sh
cp .env.example .env
```

Now open this file and edit the variables to reflect your SQL Server authentication data.

### 4. Setup database

Run all the SQL scripts in the `database/` folder ordered by number.

### 5. Run app

```sh
flask run --host=0.0.0.0
```

Then, navigate to http://localhost:5000.
