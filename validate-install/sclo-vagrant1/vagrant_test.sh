#!/bin/bash

cd ~/sync/
vagrant up
vagrant ssh -c 'cd sync; sudo env "PATH=$PATH" ./runtests.sh'
exit $?

