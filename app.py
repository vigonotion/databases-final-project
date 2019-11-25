from flask import Flask, render_template, session, escape, request, redirect, url_for, flash
from dotenv import load_dotenv
import os
import db

load_dotenv(verbose=True)
app = Flask(__name__)
app.secret_key = os.environ['APP_SECRET_KEY']
cursor = db.connect().cursor()

@app.route('/')
def index():
    if 'email' in session:
        return render_template('index.html', logged_in=True, name=escape(session['email']))
    return render_template('index.html')

@app.route('/search/<query>')
def search(query):
    print("Searching for {}".format(query))
    return render_template('search.html', query=query)

@app.route('/checkout')
def checkout():
    return render_template('checkout.html', name='Otto')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['email'] = request.form['email']
        return redirect(url_for('index'))
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('email', None)
    flash(u'You\'ve been logged out successfully.', 'success')
    return redirect(url_for('index'))

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