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
        return render_template('index.html', logged_in=True, name=escape(session['name']), email=escape(session['email']))
    return render_template('index.html')

@app.route('/search/')
def search_empty():
    return render_template('partials/products.html')

@app.route('/search/<query>')
def search(query):
    print("Searching for {}".format(query))
    return render_template('partials/search.html', query=query)

@app.route('/checkout')
def checkout():
    return render_template('checkout.html', name='Otto')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']

        # get users from database with this email
        cursor.execute("SELECT email, first_name, sur_name FROM TUser WHERE email = '{}';".format(email))
        users = cursor.fetchall()

        if len(users) < 1:
            flash(u'A user with this email could not be found.', 'danger')
            return render_template('login.html')
        user = users[0]
        session['email'] = user.email
        session['name'] = "{} {}".format(user.first_name, user.sur_name)
        return redirect(url_for('index'))

    cursor.execute("SELECT email FROM TUser;");
    emails = [x.email for x in cursor.fetchall()]

    return render_template('login.html', emails=emails)

@app.route('/logout')
def logout():
    session.pop('email', None)
    session.pop('name', None)
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

@app.route('/RateAndComment', methods=['GET','POST'])
def RateAndComment():
    if request.method == 'POST':
        product_id = request.form['product_id']
        email = session['email']
        rating = request.form['rating']
        comment = request.form['comment']
	    #try save changes to DB or send user back to page with the users inputs
        try:
            cursor.execute(""" insert into TRating (iProduct_id,cEmail,iRating,cComment) 
          	values( ? , ? , ? , ? ) """, 
           	product_id,email,rating,comment)
            cursor.commit()
            return render_template('RateAndComment.html')
        except:
            cursor.rollback()
            return render_template('RateAndComment.html', rating=rating, comment=comment)
    else:
        return render_template('RateAndComment.html')
