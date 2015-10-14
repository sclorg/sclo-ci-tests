# Package lists validation for SCLo packages

This test takes input from ../PackageLists and checks whether:

* all packages included in `all` list are in the repository
* there are no additional packages that are not in `all` list and don't belong to the collection
* architecture is correct in the repository

## Usage

run `./run.sh <collection> <el_version>` for checking one collection for specified elX.

For example checking package list for el7 for `mariadb55` collection is done this way:

```
./run.sh mariadb55 7
```

For checking package lists for all collections (for el7), run:

```
./run-all.sh 7
```

## Experimental

For checking whether the collection (e.g. mariadb55) may be installed, run:

```
./run-install.sh mariadb55 7
```
