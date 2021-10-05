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

FROM ubuntu:latest
MAINTAINER Wildrate <hello@wildrate.org>

# Do the following as root
USER root

# Have to set this to avoid any interactivity when tzdata is installed
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# The toolchain for the cross-compiler (note as well build-essential required)
RUN apt-get update && apt-get -y --no-install-recommends install \
    cmake \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib \
    build-essential \
    git-all \
    gdbserver \
    gdb \
    python3

# This gets rysnc and ssh installed
RUN apt-get -y --no-install-recommends install \
    sudo \
    rsync \
    openssh-server

# Have to generate some keys for SSH
RUN ssh-keygen -A    

# (critically) Add a SSH remote server
# See: https://pages.github.coecis.cornell.edu/cs5450/website/assignments/p1/docker.html
#RUN mkdir /var/run/sshd
#RUN echo 'root:root' | chpasswd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

# Ports exposed for remote connection and debugging
EXPOSE 22 2159

# Set the docker shell to be bash instead!
SHELL ["/bin/bash", "-c"]

# Need to set it running here (as root)
CMD service ssh restart
#CMD ["/usr/sbin/sshd","-D","-e","-f","/etc/ssh/sshd_config"]

# Just put everything into /tmp
WORKDIR /tmp
RUN git clone https://github.com/raspberrypi/pico-sdk.git

# Make sure modules loaded in
WORKDIR /tmp/pico-sdk
RUN git submodule update --init

# Create tiny user (also creates group)...
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 tiny 
RUN echo "tiny:tiny" | chpasswd
USER tiny

# Make sure environment set for them
ENV PICO_SDK_PATH=/tmp/pico-sdk

# Ready to go
WORKDIR /home/tiny

# If run direct - just provide a shell
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]

