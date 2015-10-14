# Testing of install and base usage for SCLo packages

This test takes input from ../PackageLists and checks whether:

* collection is able to be installed
* if there is a directory that is called as the collection, then `<collection>/run.sh` is run

## Usage

run `./run.sh <collection> <el_version>` for checking one collection for installation.

For example checking whether `mariadb55` installs properly, run:

```
./run.sh mariadb55 7
```

For checking functionality for all collections (for el7), run:

```
./run-all.sh 7
```
