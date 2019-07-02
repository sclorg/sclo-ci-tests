#!/bin/bash

set -ex

# check connection first
test $(echo ping | redis-cli) == "PONG"

# store some data
echo set myvar does-redis-work | redis-cli

# load stored data
test $(echo get myvar | redis-cli) == "does-redis-work"
