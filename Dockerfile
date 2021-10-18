FROM ghcr.io/autamus/cmake:3.21.2

# docker build -t abigail .

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --fix-missing build-essential python3 python3-dev python3-pip gringo git

WORKDIR /opt

RUN git clone --depth 1 https://github.com/spack/spack && \
    pip3 install --upgrade pip && \
    pip3 install botocore boto3

RUN apt-get install -y software-properties-common && \
    add-apt-repository 'deb http://mirrors.kernel.org/ubuntu hirsute main universe' && \
    apt-get update && \
    apt-get install -y gcc-11 g++-11 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gcov gcov /usr/bin/gcov-7 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-7 --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-7 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 --slave /usr/bin/g++ g++ /usr/bin/g++-11 --slave /usr/bin/gcov gcov /usr/bin/gcov-11 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11;

# Prepare a source extraction of libabigail at /src (intended to be overwritten by user)
RUN git clone https://sourceware.org/git/libabigail.git /src
WORKDIR /src

# Install Libabigail to its own view
WORKDIR /opt/abigail-env
RUN . /opt/spack/share/spack/setup-env.sh && \
    spack env create -d . && \
    spack env activate . && \

    # This adds metadata for libabigail to spack.yaml
    spack develop --path /src libabigail@master && \

    # ...but we need spack add to add to the install list!
    spack add libabigail@master  && \
    spack --debug install
    
    # At this point you can spack install and then spack analyze
    # and it will use the development libabigail
