#!/usr/bin/env bash
# bash strict mode : http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

LEPTONICA="leptonica-1.73.tar.gz"
TESSERACT="tesseract-master.zip"
if [ ! -d ./temp ]; then
    mkdir ./temp
fi

#gogo
if [ ! -f ./temp/${LEPTONICA} ]; then
    echo "leptonica not found, downloading tarball"
    curl -L -o ./temp/${LEPTONICA} http://www.leptonica.org/source/leptonica-1.73.tar.gz 
fi

if [ ! -f ./temp/${TESSERACT} ]; then
    echo "tesseract not found, downloading tarball"
    curl -L -o ./temp/${TESSERACT} https://github.com/tesseract-ocr/tesseract/archive/master.zip
fi 

echo "building docker container"
docker build --squash -t "dbmobilelife/docker-python-opencv-tesseract"  .