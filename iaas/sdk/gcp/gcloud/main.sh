#!/bin/sh

PROJECTS=( \
         )
OUTPATH=$1
LOGDIR=(json csv)

if [ ! -d $OUTPATH ]; then
    mkdir $OUTPATH
fi

for dir in ${LOGDIR[@]};do
    mkdir $OUTPATH/$dir
done

for script in $(ls modules); do
    for pj in ${PROJECTS[@]}; do
        sh modules/$script $pj $OUTPATH
    done
done
