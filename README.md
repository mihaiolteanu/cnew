# cnew
Create a new c empty project with Makefile with automatic dependency generation, unit tests setup and git initialization
# How to use

Call `cnew` with an argument specifying the project name. This will create a new folder structure containing a src, obj,
include and tests folders, respectively. This will also add a .gitignore file with typical settings for a c project and
a Makefile with automatic dependency generation. The Makefile also generates the test executable.
A simple `add` implementation and interface plus tests is provided as an example.

```
$ ls -lah
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:26 .
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 08:34 ..
```

```
$ cnew myproject
$ ls -lah
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 .
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 08:34 ..
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 myproject
```

```
$ cd myproject
$ ls -lah
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 .
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 ..
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 .git
-rw-r--r-- 1 olteanum Domain Users  360 Apr  1 10:30 .gitignore
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 include
-rw-r--r-- 1 olteanum Domain Users 1.2K Apr  1 10:30 Makefile
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 obj
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 src
drwxr-xr-x 1 olteanum Domain Users    0 Apr  1 10:30 tests
```

# Installation
```
$ git clone https://github.com/mihaiolteanu/cnew
$ cd cnew
$ cp cnew.sh /usr/local/bin/cnew
```
