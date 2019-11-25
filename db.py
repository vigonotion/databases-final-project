import pyodbc 
import os

def connect():
    server = os.environ["DATABASE_SERVER"]
    database = os.environ["DATABASE_NAME"]
    username = os.environ["DATABASE_USER"]
    password = os.environ["DATABASE_PASSWORD"]
    return pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)