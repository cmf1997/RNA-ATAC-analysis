#!/bin/bash

set -e

if [ -d result/seq_qc ]
then 
    echo "`date '+[LXD] %D %T'` -- result/seq_qc already existed, skip"
else
    mkdir -p result/seq_qc
    fastqc -t 10  -o result/seq_qc/ data/*.fastq.gz
fi

multiqc .

exit 0