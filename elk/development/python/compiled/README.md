# What are compiled Python files and how to generate a byte-code file ?

Whenever the Python script compiles, it automatically generates a compiled code called as byte code. The byte-code is not actually interpreted to machine code, unless there is some exotic implementation such as PyPy.

The byte-code is loaded into the Python run-time and interpreted by a virtual machine, which is a piece of code that reads each instruction in the byte-code and executes whatever operation is indicated.

Byte Code is automatically created in the same directory as .py file, when a module of python is imported for the first time, or when the source is more recent than the current compiled file. Next time, when the program is run, python interpretator use this file to skip the compilation step.

Running a script is not considered an import and no .pyc file will be created. For instance, let’s write a script file abc.py that imports another module xyz.py. Now run abc.py file, xyz.pyc will be created since xyz is imported, but no abc.pyc file will be created since abc.py isn’t being imported.

But there exist an inbuilt py_compile and compileall modules and commands which facilitate the creation of .pyc file.

Using py_compile.compile function: The py_compile module can manually compile any module. One way is to use the py_compile.compile function in that module interactively:

```
import py_compile
py_compile.compile('abc.py')
```

This will write the .pyc to the same location as abc.py.
Using py_compile.main() function: It compiles several files at a time.

```
import py_compile
py_compile.main(['File1.py','File2.py','File3.py'])
```

Using compileall.compile_dir() function: It compiles every single python file present in the directory supplied.

```
import compileall
compileall.compile_dir(directoryname)
```

Using py_compile in Terminal:

`$ python -m py_compile File1.py File2.py File3.py ...`

Or, for Interactive Compilation of files

```    
$ python -m py_compile -
    File1.py
    File2.py
    File3.py
    .
    .
    .
```

Using compileall in Terminal: This command will automatically go recursively into sub directories and make .pyc files for all the python files it finds.

`$ python -m compileall`

Note: The compileall and py_compile module is part of the python standard library, so there is no need to install anything extra to use it.


## How to run a compiled file

`python filename.pyc`


## How to uncompile a file

1. Install a package called uncompyl6  - `pip install uncompyle6`
2. Run the command - `uncompyle6 -o . filename.pyc`


## Following is a sample python project

1. To normally run the project, you need to install the required packages first. `pip install -r requirements.txt`

2. To run the project, run the following command. `python test.py`

3. To generate the compiled byte-code files, run the following command. `python -m py_compile test.py`

4. It creates a directory named `__pycache__` if not present already and inside the directory is our `*.pyc` file.

5. To run the project directly from the byte-code file, run the following command. `python __pycache__/test.cpython-38.pyc` or change the .pyc filename as in your case.