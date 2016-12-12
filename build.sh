#!/usr/bin/env bash
# bash strict mode : http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

LEPTONICA="leptonica-1.73.tar.gz"
TESSERACT="tesseract-master.tar.gz"
TESSERACT_MODEL="eng.traineddata"
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
    curl -L -o ./temp/${TESSERACT} https://github.com/tesseract-ocr/tesseract/archive/master.tar.gz
fi 

if [ ! -f ./temp/${TESSERACT_MODEL} ]; then
    echo "tessseract model not found, downloading"
    curl -L -o ./temp/${TESSERACT_MODEL} https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata
fi

echo "building docker container"
docker build --squash -t "dbmobilelife/docker-python-opencv-tesseract"  .