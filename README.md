# CI tests for Software Collections @ CentOS

This directory will include various tests that will be run for verifying Software Collection packages, that are provided by SCLo SIG group in CentOS.

To run all tests for a collection `foo` on CentOS 7, run in this root directory:
```
./run.sh foo 7
```

To run all tests for all collections on CentOS 7, run:
```
./run-all.sh 7
```

To run only particular test (e.g. package set validation in -candidate repository) for collection `foo` on CentOS 7, go to the particular directory and run:
```
cd validate-pkg-list
./run.sh foo 7
```

To run the same test (package set validation in -candidate repository) for all the collections, run:
```
cd validate-pkg-list
./run-all.sh 7
```

#More advanced tests

##Structure of tests
----
    ├── all
    ├── common      -- contains files common for all tests
    ├── sclo7       -- contains tests for sclo6
    ├── sclo6       -- contains tests for sclo7
        │
        ├── ruby200-rh          -- contains tests for the ruby200-rh
        │   ├── enabled_tests   -- list of enabled tests for ruby200-rh
        │   ├── machine.conf    -- config. file for virtual machine for ruby200-rh
        │   ├── mkvirt-sclo7.sh -- creates virtual machine for ruby-200-rh
        │   ├── runtests.sh     -- run tests listed in enabled_tests
        │   │
        │   └── tests           -- contains directories, each dir. contains a test
        │       │
        │       ├── check-version   -- a test
        │       │   ├── code        -- code of the test, may contain more files
        │       │   │   └── run.sh  -- the main script of the test
        │       │   ├── err         -- expected stderr (oprional)
        │       │   ├── out         -- expected stdout (optional)
        │       │   └── retcode     -- expected return code (optional)



##Usage
###Make a virtual machine
You may use the "mkvirt" script to create a virtual machine. If you run
it from the speciffic test directory you just need to specify the tree.
Configuration of the virtual machine is taken from the "machine.conf" file.

    cd sclo6/ruby200-rh
    ./mkvirt-sclo6.sh http://mirror.centos.org/centos/6.7/os/x86_64/

Of course you may create the virtual machine yourself.

###Run tests
You may use the "runtests.sh" script to run tests for the component.
The "runtests.sh" connects to the virtual machine specified in "machine.conf"
or to the machine specified on the command line.

It uses ssh to copy content of "code" directory of each test to the virtual
machine and then run the "run.sh" on the virutal machine. When "run.sh" is
done, it compares stdout, stderr and return code with valuse specified in
the test directory. Eg.

    sclo6/ruby200-rh/tests/check-version/out

When no expected stdout or stderr defined, it compares just return code.
When no return code is specified, the test is succesfull when it returns 0.

You may run the tests by:

    ./runtests.sh

Or when you want to run the tests on speciffic virtual machine

    ./runtests.sh <virtual-machine-name>

###Results
Simple results (passed/failed) are written to stdout. Acctual results (stdout, 
stderr and return code) can be faund in following directory:

    results/<name_of_the_test>/



##Required programs


