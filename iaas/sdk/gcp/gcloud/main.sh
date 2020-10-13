#!/bin/sh

PROJECTS=( \
    )

OUTPATH=$1
LOGDIR=(json csv)

source common/make_output_dir.sh

for dir in ${LOGDIR[@]}; do
    make_log_parent $OUTPATH $dir
done

for script in $(ls modules); do
    for pj in ${PROJECTS[@]}; do
        sh modules/$script $pj $OUTPATH > /dev/null
    done
done
