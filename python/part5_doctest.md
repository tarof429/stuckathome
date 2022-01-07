# Part 5: Doctest

Doctest allows us to run tests on a function based on docstrings. A simple example is shown below.

```python
"""
This function returns the sum of two numbers.

>>> add_two_numbers(3, 5)
8
"""
def add_two_numbers(x, y):
    return x + y 

if __name__ == '__main__':
    import doctest
    doctest.testmod()
```

When run, if there are no errors there is no output. To display verbose output, run the following.

```python
python -m doctest -v main.py
```

Docstrings can occur within the function as well.

```python
#!/usr/bin/python

# import testmod for testing our function 
from doctest import testmod 

# define a function to test 
def factorial(n): 
    ''' 
    This function calculates recursively and 
	returns the factorial of a positive number. 
	Define input and expected output: 
	>>> factorial(3) 
	6
	>>> factorial(5) 
	120
	'''
    if n <= 1: 
        return 1
    return n * factorial(n - 1) 

# call the testmod function 
if __name__ == '__main__': 
    testmod(name ='factorial', verbose = True)
```