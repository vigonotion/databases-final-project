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

    # get all products
    cursor.execute('SELECT * FROM TProduct')
    products = cursor.fetchall()

    if 'email' in session:
        return render_template('index.html', logged_in=True, name=escape(session['name']), email=escape(session['email']), products=products)
    return render_template('index.html', products=products)

@app.route('/search/')
def search_empty():
    # get all products
    cursor.execute('SELECT * FROM TProduct')
    products = cursor.fetchall()

    if 'email' in session:
        return render_template('partials/products.html', logged_in=True, name=escape(session['name']), email=escape(session['email']), products=products)
    return render_template('partials/products.html', products=products)

@app.route('/search/<query>')
def search(query):
    sql = 'SELECT * FROM TProduct WHERE cName LIKE \'%{}%\''.format(query)
    print(sql)
    cursor.execute(sql)
    products = cursor.fetchall()

    return render_template('partials/search.html', query=query, products=products)

@app.route('/checkout')
def checkout():
    return render_template('checkout.html', name='Otto')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']

        # get users from database with this email
        cursor.execute("SELECT cEmail, cFirstName, cLastName FROM TUser WHERE cEmail = '{}';".format(email))
        users = cursor.fetchall()

        if len(users) < 1:
            flash(u'A user with this email could not be found.', 'danger')
            return render_template('login.html')
        user = users[0]
        session['email'] = user.cEmail
        session['name'] = "{} {}".format(user.cFirstName, user.cLastName)
        return redirect(url_for('index'))

    cursor.execute("SELECT cEmail FROM TUser;")
    emails = [x.cEmail for x in cursor.fetchall()]

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

@app.route("/ShoppingCart")
def ShoppingChart():
    if "cartProduct" not in session:
        session["cartProduct"] = []
    
    print(str(session["cartProduct"])+"lol")

    tempCart=session["cartProduct"]

    shoppingChart=[]
    for product_id in tempCart: 
        cursor.execute("""
            select * from TProduct
            where iProductId = ?
        """, product_id)
        product= cursor.fetchall()
        #product[0].fUnitPrice=round(product[0].fUnitPrice,2)
        shoppingChart.append(product[0])
    
    print(shoppingChart)

    return render_template('ShoppingCart.html', haspurchases=True, cartProduct=shoppingChart)


@app.route('/AddToCart', methods=['POST'])
def AddToCart():
    if "cartProduct" not in session:
        session["cartProduct"] = []
    tempCart=session["cartProduct"]
    productId = request.get_json()
    tempCart.append(productId)
    session["cartProduct"] = tempCart
    return "succes"


@app.route('/DeleteFromCart', methods=['POST'])
def DeleteFromCart():
    tempCart=session["cartProduct"]
    productId = request.get_json()
    tempCart.remove(productId)
    session["cartProduct"] = tempCart
    return "succes"


##################################################################################
# api
##################################################################################

@app.route('/api/products/<int:product_id>/ratings')
def product_ratings(product_id):
    cursor.execute("""
        select * from TRating
        inner join TUser on TRating.iUserId = TUser.iUserId
        where iProductId = ?
    """, product_id)

    ratings = cursor.fetchall()
    return render_template('partials/ratings.html', ratings=ratings)

##################################################################################
# custom filters
###################################################################################

@app.template_filter()
def dkk(value):
    return "{:.2f} kr.".format(value)