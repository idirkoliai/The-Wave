
# The Wave music streaming platform
This projet runs locally a web side , the main aim is to practice on databases using PostgresSQL.
# Table of Contents
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [general structure](#general-structure)
- [installation](#installation)

# Getting Started
This project is a simple web side that allows to have customized music streaming platform.The main aim is to practice on databases using PostgresSQL and Python(Flask).

# Prerequisites
Postgres and the Flask library are required to run this project

# General Structure
- __static__ : contains the css and js files
- **templates** : contains the html files
- **db.py** : contains the database connection
- **main.py** : contains the main code of the project

# Installation

To load the database, you will to import the dump file into your database using this command:
```bash
psql -U your_user_name -d your_db_name -f dump.sql
```
Then you can run the project using this command:
```bash
python main.py
```
you will also have to change the database connection in the db.py file

