#!/usr/bin/python

from markupsafe import escape
from flask import Flask

app = Flask(__name__)

@app.route('/')
@app.route('/index/')
def hello():
    return '<h1>Hello World!</h1>'

@app.route('/about/')
def about():
    return 'This is a simple Fask app'

@app.route('/capitalize/<word>/')
def capitalize(word):
    return '<h1>{0}</h1>'.format(escape(word.capitalize()))