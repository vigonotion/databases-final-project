import db


logo = """
 ____       _        __                     _   
|  _ \ __ _(_)_ __  / _| ___  _ __ ___  ___| |_ 
| |_) / _` | | '_ \| |_ / _ \| '__/ _ \/ __| __|
|  _ < (_| | | | | |  _| (_) | | |  __/\__ \ |_ 
|_| \_\__,_|_|_| |_|_|  \___/|_|  \___||___/\__|

  ___        _ _              ____  _                 
 / _ \ _ __ | (_)_ __   ___  / ___|| |_ ___  _ __ ___ 
| | | | '_ \| | | '_ \ / _ \ \___ \| __/ _ \| '__/ _ \\
| |_| | | | | | | | | |  __/  ___) | || (_) | | |  __/
 \___/|_| |_|_|_|_| |_|\___| |____/ \__\___/|_|  \___|

"""

print(logo)
print("Setup application")
print("=====")
print()
print("What would you like to do?")
print("[1] Setup database")
print("[2] Fill database with example data")
print("[3] Clear database")
print("[0] Exit")
choice = input("Your choice: ")

if choice == 1:
    print("Checking database connection...")
    try:
        connection = db.connect()
    except Exception:
        print("""
            Failed to connect to the database. Please check:
            - your credentials inside .env file are correct
            - a database with the name in the .env file exists
            - the database server is running
        """)