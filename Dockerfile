# TODO: FROM docker-python-opencv
FROM ubuntu:16.04

RUN mkdir /tmp/thework
WORKDIR /tmp/thework

ARG BUILD_PACKAGES="autoconf    \
    automake                    \
    g++                         \
    libtool                     \
    libjpeg8-dev                \
    libpng12-dev                \
    libtiff5-dev                \
    pkg-config                  \
    zlib1g-dev"

ARG EXTRA_PACKAGES="autotools-dev \
    binutils cpp cpp-5 dpkg-dev file g++-5 gcc gcc-5 libc-dev-bin libc6-dev \
    libcc1-0 libcilkrts5 libdpkg-perl libgcc-5-dev libjbig-dev libjpeg-turbo8-dev \
    liblzma-dev libstdc++-5-dev linux-libc-dev m4 make patch"

RUN apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_PACKAGES 

ADD ./temp/leptonica-1.73.tar.gz .
ADD ./temp/tesseract-master.tar.gz .

# build and install leptonica
RUN cd ./leptonica-1.73 \
    && ./configure \
    && make -j2 \
    && make install \
    && cd ..


# build and install tesseract 4 
RUN cd ./tesseract-master \
    && ./autogen.sh LIBLEPT_HEADERSDIR=/usr/local/lib --with-extra-libraries=/usr/local/lib \
    && ./configure \
    && make -j2 \
    && make install \
    && ldconfig

RUN CPPFLAGS=-I/usr/local/include pip install tesserocr

# Cleanup
RUN apt-get purge -y $BUILD_PACKAGES $EXTRA_PACKAGES \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/thework/*