#!/bin/bash

set -e

featureCounts=`/lustre/home/acct-medzy/medzy-cai/software/subread-2.0.6/bin/featureCounts`

# featureCounts -T 8 -f -t gene -p -B -c -g gene_id -a *.gtf -o samples.count *.bam # .bam can be multi file
i=0
while read sample fq1 fq2;do
    bam_array[$i]=result/align_star/$sample/${sample}_Aligned.sortedByCoord.out.bam
    let i++
done < sample_run.txt

if [ -d result/featureCounts ]
then
    echo "`date '+[LXD] %D %T'` -- result/featureCounts already existed, skip"
else
    mkdir -p result/featureCounts
    eval ${featureCounts} -T 8 \
    -f -t gene \
    -p -B \
    -g gene_id \
    -a /lustre/home/acct-medzy/medzy/genomes/Mus_musculus.GRCm39.Ensembl104/annotation/Mus_musculus.GRCm39.104.gtf \
    -o result/featureCounts/all_samples.counts.txt ${bam_array[@]}
fi

exit 0