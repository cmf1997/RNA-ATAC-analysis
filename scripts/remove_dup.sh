#!/bin/bash

set -e

picard=/lustre/home/acct-medzy/medzy/software/picard-2.26.11/picard.jar
wkDir=./result/align_star

bams=`find $wkDir -type f -name '*Aligned.sortedByCoord.out.bam' | grep -v 'rmDup' | sort`

for bam in $bams
do
    rmDupBam=`echo $bam | sed 's/Aligned.sortedByCoord.out.bam/rmDup.Aligned.sortedByCoord.out.bam/'`
    rmDupLog=${wkDir}/log/$(basename $rmDupBam | sed 's/bam$/rmDupLog/')

    if [ ! -f $rmDupBam ]
    then
        java -jar $picard MarkDuplicates -I $bam -O $rmDupBam -M $rmDupLog -REMOVE_DUPLICATES true -ASSUME_SORT_ORDER coordinate
    else
        echo $rmDupBam already exists!
    fi
done