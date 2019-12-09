from flask import Flask, render_template, session, escape, request, redirect, url_for, flash
from dotenv import load_dotenv
import os
import db
from collections import Counter

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
    if not 'email' in session:
        return render_template('checkout.html', logged_in=False)
    checkoutItems=GetUniqueProducts()
    numberOfItems=len(checkoutItems)
    usersCreditCards=GetCreditCardsFromEmail(escape(session['email']))
    total=0
    for i in range(0,len(checkoutItems)):
        total=total+checkoutItems[i][2]
    return render_template('checkout.html', logged_in=True, name=escape(session['name']), email=escape(session['email']) ,checkoutItems=checkoutItems, usersCrditCards=usersCreditCards, numberOfItems=numberOfItems,total=total)

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
    #if request.method == 'POST':
    if 'email' in session:
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
            #return render_template('RateAndComment.html')
            return "Succes"
        except:
            cursor.rollback()
            #return render_template('RateAndComment.html', rating=rating, comment=comment)
            return "Failed: tried commit to datbase"
    else:
        return "Failed: not logged in"
        #return render_template('RateAndComment.html')

@app.route("/ShoppingCart")
def ShoppingCart():
    if "cartProduct" not in session:
        session["cartProduct"] = []
    shoppingCart=GetUniqueProducts()
    numberOfItems=len(shoppingCart)
    if 'email' in session:
        return render_template('ShoppingCart.html', logged_in=True, name=escape(session['name']), email=escape(session['email']), haspurchases=True, cartProduct=shoppingCart, numberOfItems=numberOfItems)
    else:
        return render_template('ShoppingCart.html', logged_in=False, haspurchases=True, cartProduct=shoppingCart, numberOfItems=numberOfItems)

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


@app.route('/Purchase', methods=['POST'])
def Purchase():
    
    

    return "done"


#######################
# methods
#############

#returns list of creditcards from user given their emil as parameters
def GetCreditCardsFromEmail(email):
    cursor.execute("""
        select iUserId from TUser
        where cEmail = ?
        """, email)
    UserId=cursor.fetchone()[0]
    cursor.execute("""
        select cCreditCardNo from TCreditCard
        where iUserId = ?
        """, UserId )
    usersCreditCards=cursor.fetchall()
    return usersCreditCards

#returns a list containing uniqe products 
#and the amount of those objects and the total price of all the objects    
def GetUniqueProducts():
    tempCart=session["cartProduct"]
    counter=Counter(tempCart)
    checkoutItems=[]
    for product_id in counter:
        cursor.execute("""
            select * from TProduct
            where iProductId = ?
        """, product_id)
        product= cursor.fetchone()
        #pos 1 product object            | list[x][0]
        #pos 2 amount of products        | list[x][1]
        #pos 3 total price (pos1*pos2)   | list[x][2]
        checkoutItems.append([product,counter[product_id],(counter[product_id]*product.fUnitPrice)])
    return checkoutItems


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


