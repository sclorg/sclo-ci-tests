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
