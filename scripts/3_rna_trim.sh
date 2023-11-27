#!/bin/bash

set -e

while read sample fq1 fq2;do
if [ -d resulet/seq_trim/fastp/$sample ]
then
    echo "`date '+[LXD] %D %T'` -- resulet/seq_trim/fastp/$sample already existed, skip"
else
    mkdir -p resulet/seq_trim/fastp/$sample
    fastp -f 10 -F 10 -t 0 -T 0 -5 -3 -W 4 -M 15 -l 80 -c \
    -w 10 \
    -i $fq1 -I $fq2 \
    -o resulet/seq_trim/fastp/$sample/${sample}.1.trim.fq.gz \
    -O resulet/seq_trim/fastp/$sample/${sample}.2.trim.fq.gz \
    -h resulet/seq_trim/fastp/$sample/${sample}.fastp.html \
    -j resulet/seq_trim/fastp/$sample/${sample}.fastp.json
fi
done < sample_run.txt

exit 0