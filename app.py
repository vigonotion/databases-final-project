from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template('index.html', name='Otto')

@app.route('/checkout')
def checkout():
    return render_template('checkout.html', name='Otto')