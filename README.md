# Matlab stdin pipe

Using Python or Java to run external processes from Matlab with stdin pipe.
These examples are readily adaptable to more complex situations.

* Java: built into Matlab, more complicated call syntax
* Python: easier syntax, end user has to setup

Using Matlab system() does not allow for stdin pipes, but these examples do allow stdin pipes.

These methods can be used asynchronously in a number of ways, depending on your application.
Using stdin / stdout instead of temporary files can be faster.
Ultimately the fastest runtime performance is probably by directly connecting the compiled executable to Matlab libraries, but that takes considerable additional development time.

This piping method works with blackbox executables or executables that cannot be recompiled for various reasons.
If your application allows, doing this directly in Python is generally easier and of course Python works better than Matlab for many such real-world deployed applications.

## Windows

On Windows, using `system()` with MPIexec can cause intermittent segfaults that don't occur from Terminal.
Try using py.subprocess instead of system() on Windows, checking first that the user has Python available.
