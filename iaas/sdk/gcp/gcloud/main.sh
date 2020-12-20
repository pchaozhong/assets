#!/bin/sh

PROJECTS=( \
           nomura-market-app-dev \
               nomura-market-cmn \
               nomura-market-cmn-network-dev \
               nomura-market-data-dev \
               nomura-market-dev \
               nomura-market-open-data-dev \
               nomura-market-prod \
               nomura-market-remote-access \
               nomura-market-secure-data-dev
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
