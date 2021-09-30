[![Docker Image CI](https://github.com/wildrate/tinybuild/actions/workflows/docker-image.yml/badge.svg)](https://github.com/wildrate/tinybuild/actions/workflows/docker-image.yml)

# tinybuild

Docker build image for MCU's.

Currently supports:
 - Raspberry Pi Pico

## Example to use image to compile code locally:
```
#!/usr/bin/env bash
# Assumes local $PWD/src folder

docker pull ghcr.io/wildrate/tinybuild:latest
mkdir build
docker run --rm -v $PWD/src:/tmp/src -v $PWD/build:/tmp/build -w /tmp/build tinybuild cmake ../src
docker run --rm -v $PWD/src:/tmp/src -v $PWD/build:/tmp/build -w /tmp/build tinybuild make
```

## Example to launch a local image to develop on:
```
# After you run this you should be able to login via SSH on port 3022
# > ssh -P 3022 tiny@localhost
# password is also 'tiny'
    
docker run --rm -it -p 3022:22 -p 7777:7777 -p 9999:9999 --privileged --name tinybuild ghcr.io/wildrate/tinybuild:latest
```
