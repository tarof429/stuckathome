# Part 9: System Calls

There are a few ways to run system commands in Python.

The first is to use the system method in the os module. 

```python
import os

os.system('ls /')
```

One big limitation is that the output is sent to the console and you cannot store it in a variable. An alternative is to use methods in the subprocess module. For example: 

```python
import subprocess
output = subprocess.call("ls")
print(output)
```

One problem with subprocess is that it doesn't handle command arguments in the way you expect. For example, the code below will result in an exception.

```python
import subprocess
output = subprocess.call("ls -l /")
print(output)
# Results in FileNotFoundError: [Errno 2] No such file or directory: 'ls /'
```

One solution is to add an argument to use the shell.

```python
import subprocess
output = subprocess.call('ls -l /', shell=True)
print(output)
```

The output in this case only captures the exit code. If we need the ouptut, use `subprocess.check_output()`.

```python
import subprocess
output = subprocess.check_output('ls -l /', shell=True)
print(output.decode('utf-8'))
```

## References

https://www.digitalocean.com/community/tutorials/python-system-command-os-subprocess-call