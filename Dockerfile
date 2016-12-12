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
    && make \
    && make install \
    && ldconfig

# Cleanup
RUN apt-get purge -y $BUILD_PACKAGES \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/thework/*