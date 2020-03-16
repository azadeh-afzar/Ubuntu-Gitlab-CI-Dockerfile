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

# install system libs.
RUN apt-get install --assume-yes build-essential libssl-dev zlib1g-dev libbz2-dev
RUN apt-get install --assume-yes libreadline-dev libsqlite3-dev libncurses5-dev libc6
RUN apt-get install --assume-yes libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev
RUN apt-get install --assume-yes lsb-release lsb-core python-openssl software-properties-common

# install make.
RUN apt-get install --assume-yes make

# install GNU C Compiler versions.
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get install --assume-yes gcc-7 g++-7
RUN apt-get install --assume-yes gcc-8 g++-8
RUN apt-get install --assume-yes gcc-9 g++-9

# set GNU C Compiler versions priorities.
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9 --slave /usr/bin/gcov gcov /usr/bin/gcov-9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80 --slave /usr/bin/g++ g++ /usr/bin/g++-8 --slave /usr/bin/gcov gcov /usr/bin/gcov-8
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gcov gcov /usr/bin/gcov-7

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

# clean apt-get.
RUN apt-get clean all

# get llvm installer shell script.
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# install codeclimate coverage reporter.
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /usr/bin/cc-test-reporter
RUN chmod +x /usr/bin/cc-test-reporter

