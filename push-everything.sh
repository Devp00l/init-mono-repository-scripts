#!/bin/bash

# $1 = main repo path
main_path=$(readlink -f $1)
cd ${main_path}
git push --all --force
git push --tags

