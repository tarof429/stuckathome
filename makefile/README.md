# Makefile

Makefile is a universal tool for compiling C code on Linux. It can vastly simplify the steps needed to build a program.

A Makefile has the following syntax:

```sh
target: dependencies
    command
```

For example, suppose we need to compile a file written in C. It might look something like this:

```sh
hello: main.c
	cc -o hello main.c
```

We can declare variables in Makefile to further simplify the code needed to compile programs.

```sh
CC=gcc
```

If you want to hide the messages in the command section, prefix it with `@`:

```sh
@echo "Compiling main.c"
```

## References

https://www.youtube.com/watch?v=_r7i5X0rXJk 