# Copyright (c) 2021 Wildrate.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
# following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
#    disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
###############################################################################
# Test locally with: 
#   docker build -t tinybuild .
#   docker run -rm tinybuild cmake
###############################################################################

# Need this particular version of ubuntu to avoid: 
# https://askubuntu.com/questions/1408528/apt-update-on-ubuntu22-04-results-in-error-100-on-some-docker-hosts
FROM ubuntu:20.04 
LABEL maintainer Wildrate<hello@wildrate.org>

# Do the following as root
USER root

# Have to set this to avoid any interactivity when tzdata is installed
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# The toolchain for the cross-compiler (note as well build-essential required)
RUN apt-get update && apt-get -y --no-install-recommends install \
    cmake \
    build-essential \
    git-all \
    gdbserver \
    gdb \
    python3 \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib

# This gets rysnc and ssh installed if running as a remote environment
#RUN apt-get -y --no-install-recommends install \
#    sudo \
#    rsync \
#    openssh-server

# Have to generate some keys for SSH as well 
# RUN ssh-keygen -A    

## Ports exposed for remote connection and debugging
#EXPOSE 22 2159

# Set the docker shell to be bash instead!
SHELL ["/bin/bash", "-c"]

# Create tiny user (also creates group)...
RUN useradd -rm -d /home/tiny -s /bin/bash -g root -G sudo -u 1000 tiny 
RUN echo "tiny:tiny" | chpasswd
USER tiny

# Ready to go
WORKDIR /home/tiny

# Run as root to launch
#ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
# Need to set it running here (as root)
#CMD service ssh restart
#CMD ["/usr/sbin/sshd","-D","-e","-f","/etc/ssh/sshd_config"]
# Run ssh and bash if required
#USER root
#ENTRYPOINT service ssh restart && bash

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
