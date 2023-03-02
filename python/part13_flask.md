# Part 13: Flask

## How to Install Flask for ArchLinux

Flask is provided by the `python-virtualenv` package.

```
sudo pacman -S python-virtualenv
```

## How to create a virtual environment with venv

Below is an example of how to create a virtual environment with a directory called venv.

```
python -m venv venv
```

To activate it, run:

```
. ./venv/bin/activate
```

To deactivate it, run

```
deactivate
```

## How To Create Your First Web Application Using Flask and Python

In your virtual environment, use pip to install flask

```
pip install flask
```

Create a file called main.py with the following content. This file contains one route.

```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return '<h1>Hello World!</h1>'
```

Now run the web application using the provided script run.sh

```
sh ./run.sh
```

Now let's add another route.

```
@app.route('/about/')
def about():
    return 'This is a simple Fask app'
```

If we save the file and navigate to /about, we should see our new page.

We can also create a route that takes an argument.

```
@app.route('/capitalize/<word>/')
def capitalize(word):
    return '<h1>{0}</h1>'.format(escape(word.capitalize()))
```

## References

https://linuxhint.com/install-flask-arch-linux/

https://www.digitalocean.com/community/tutorials/how-to-create-your-first-web-application-using-flask-and-python-3