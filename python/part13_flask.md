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




## References

https://linuxhint.com/install-flask-arch-linux/

https://www.digitalocean.com/community/tutorials/how-to-create-your-first-web-application-using-flask-and-python-3