FROM ubuntu:bionic

LABEL maintainer="Mohammad Mahdi Baghbani Pourvahid <MahdiBaghbani@protonmail.com>"

# set frontend to noneinteractive.
ARG DEBIAN_FRONTEND=noninteractive

# change default shell from sh to bash.
SHELL ["/bin/bash", "-l", "-c"]

# update apt database.
RUN apt-get update --assume-yes

# install apt utils to speed up configs.
RUN apt-get install --assume-yes --no-install-recommends apt-utils

# install make.
RUN apt-get install --assume-yes make

# install GNU C Compiler.
RUN apt-get install --assume-yes gcc

# install system libs.
RUN apt-get install --assume-yes build-essential libssl-dev zlib1g-dev libbz2-dev
RUN apt-get install --assume-yes libreadline-dev libsqlite3-dev libncurses5-dev libc6
RUN apt-get install --assume-yes libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev
RUN apt-get install --assume-yes python-openssl

# set locale.
RUN apt-get install --assume-yes locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# install git.
RUN apt-get install --assume-yes git

# install curl.
RUN apt-get install --assume-yes curl

# install wget.
RUN apt-get install --assume-yes wget

# install gnupg.
RUN apt-get install --assume-yes gnupg

# disable ipv6 in docker for gpg.
RUN mkdir -p ~/.gnupg
RUN chmod 700 ~/.gnupg
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
RUN chmod 600 ~/.gnupg/*

# install llvm toolchain.
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# install codeclimate coverage reporter.
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /usr/bin/cc-test-reporter
RUN chmod +x /usr/bin/cc-test-reporter

# specify working directory.
ENV TESTBUILD ~/test_and_build
RUN mkdir -p $TESTBUILD
WORKDIR $TESTBUILD

