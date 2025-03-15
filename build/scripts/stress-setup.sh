#!/bin/bash 

echo "Creating a docker container that contains the stress utility...."
docker run -ti --rm polinux/stress bash 