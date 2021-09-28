[![Docker Image CI](https://github.com/wildrate/tinybuild/actions/workflows/docker-image.yml/badge.svg)](https://github.com/wildrate/tinybuild/actions/workflows/docker-image.yml)

# tinybuild

Docker build image for MCU's.

Currently supports:
 - Raspberry Pi Pico

Example to use image to compile code locally:
```
#!/usr/bin/env bash
# Assumes local $PWD/src folder

docker pull ghcr.io/wildrate/tinybuild:latest
mkdir build
docker run --rm -v $PWD/src:/tmp/src -v $PWD/build:/tmp/build -w /tmp/build tinybuild cmake ../src
docker run --rm -v $PWD/src:/tmp/src -v $PWD/build:/tmp/build -w /tmp/build tinybuild make
```
