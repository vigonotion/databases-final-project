from flask import Flask, render_template
from dotenv import load_dotenv

import db

load_dotenv(verbose=True)
app = Flask(__name__)
cursor = db.connect().cursor()

@app.route('/')
def hello_world():
    #Sample select query
    cursor.execute("SELECT @@version;") 
    row = cursor.fetchone() 
    while row: 
        print(row[0])
        row = cursor.fetchone()
    return render_template('index.html', name='Otto')

@app.route('/search/<query>')
def search(query):
    print("Searching for {}".format(query))
    return render_template('search.html', query=query)

@app.route('/checkout')
def checkout():
    return render_template('checkout.html', name='Otto')


@app.route('/db_check')
def db_check():
    #Sample select query
    cursor.execute("SELECT @@version;")
    version = []
    row = cursor.fetchone() 
    while row: 
        version.append(row[0])
        row = cursor.fetchone()
    return render_template('db_check.html', version='\n'.join(version))