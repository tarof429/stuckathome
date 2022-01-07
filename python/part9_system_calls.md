# Part 9: System Calls

There are a few ways to run shell commands in Python.

The first is to use the system class in the os module. 

```python
import os

os.system('ls /')
```

One big limitation is that the output is sent to the console and you cannot store it in a variable. An alternative is to use methods in the subprocess module.

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

One solution is to use getoutput() and getstatusoutput() methods instead.

```python
import subprocess

stdout = subprocess.getoutput('ls -l /')
print(stdout)

exitcode, stdout = subprocess.getstatusoutput('df -h')
print(exitcode)
print(stdout)
```