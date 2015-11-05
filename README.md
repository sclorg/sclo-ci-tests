# CI tests for Software Collections @ CentOS

This repository includes various tests that will be run for verifying Software Collection packages, that are provided by [SCLo SIG group in CentOS](https://wiki.centos.org/SpecialInterestGroup/SCLo).

To run all tests for a collection `foo` on CentOS 7, run the `./run-all-tests.sh` with name(s) of the collection(s):
```
./run-all-tests.sh rh-python34
```
or run `run.sh` script in particular collection directory:
```
./run-all-tests.sh rh-python34
```

To run all tests for all collections on CentOS 7, run:
```
cd collections/rh-postgresql94-rh
./run.sh
```

To run only particular test (e.g. package set validation in -candidate repository) for collection `foo` on CentOS 7, go to the particular directory and run:
```
cd collections/rh-postgresql94-rh/validate-pkg-list
./run.sh
```

To run the test that verifies all the packages sets (it is possible to run it on any system, not only testing VM) for all the collections, run:
```
cd validate-pkg-list
./run-all.sh 7
```

##Structure of tests
```
    ├── common      -- contains files common for all tests
    ├── collections -- contains tests for all collections
        │
        ├── ruby200-rh          -- contains tests for the ruby200-rh collection
        │   ├── enabled_tests   -- sorted list of enabled tests for ruby200-rh collection
        │   ├── run.sh          -- runs all tests listed in enabled_tests file
        │   ├── check-version   -- a test for checking whether proper version is available
        │   │       ├── run.sh      -- the main script of the test
        │   │       ├── err         -- expected stderr (oprional)
        │   │       ├── out         -- expected stdout (optional)
        │   │       └── retcode     -- expected return code (optional)
        │   └── install         -- a test for installation of the collection
        │           └── run.sh      -- the main script of the test
```

When "run.sh" is run, it compares stdout, stderr and return code with valuse specified in
the test directory. Eg.

    collections/ruby200-rh/tests/check-version/out

When no expected stdout or stderr defined, it compares just return code.
When no return code is specified, the test is succesfull when it returns 0.

###Results
Simple results (passed/failed) are written to stdout. Acctual results (stdout, 
stderr and return code) can be faund in the directory under /tmp, that is printed
to the stdout:

```
Running tests for rh-python34-rh ...
[FAILED]	install
[FAILED]	check-version
[FAILED]	uninstall
[PASSED]	validate-pkg-list

1 tests passed, 3 tests failed.

Failed tests:
	  install check-version uninstall
Logs are stored in /tmp/sclo-results-s6Fhun
NOT ALL TESTS PASSED SUCCESSFULLY
```

##Usage with remote machine

###Make a virtual machine
You may use the "mkvirt" script to create a virtual machine. If you run
it from the speciffic test directory you just need to specify the tree.
Configuration of the virtual machine is taken from the "machine.conf" file.

```
cd vm
./mkvirt-sclo6.sh -s 3 http://mirror.centos.org/centos/6.7/os/x86_64/
```
    
Of course you may create the virtual machine yourself.

###Run tests
You may use the `run-remote-git.sh` script to run tests for the component
on remote machine. This script connects to the remote machine, downloads this
repository there and will execute the `run.sh` script in the same location.

It uses `SSH_HOST` (hostname or IP) or `VM_NAME` (VM domain) environment
variables to identify the host and then `SSH_PASS` enviroment variable to
connect to the machine. Variable `SSH_USER` is optional and can be used to set
user that should be used in `ssh` commands.

For example running `rh-python34` tests on remote machine `192.168.122.24` where
we may identify as `root` user with `secret` as password, run:

```
export SSH_HOST=192.168.122.24
export SSH_PASS=secret
collections/rh-python34-rh/run-remote-git.sh
```

##Required programs on guest machine
```
scl-utils
```
##Required programs on host machine
```    
libvirt
sshpass
html2text
```
