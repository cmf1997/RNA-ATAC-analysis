#!/bin/bash

set -e

# Before analysis, you should build index for reference genome firstly!!!

# without annotation



# with Annotation
# STAR --runThreadN 10 --runMode genomeGenerate --genomeDir index \
# --genomeFastaFiles reference/genome.fa \
# --sjdbGTFfile reference/genes.gtf \
# --sjdbOverhang 149 

aligner=code/4_rna_align.sh

while read sample fq1 fq2;do
if [ -d result/align_star/$sample ]
then
    echo "`date '+[LXD] %D %T'` -- result/align_star/$sample already existed, skip"
else
    mkdir -p result/align_star/$sample

    sbatch -p small -n 9 --job-name=$sample --output=${sample}.hpc.out --error=${sample}.hpc.err --wrap "$aligner result/seq_trim/fastp/$sample/${sample}.1.trim.fq.gz result/seq_trim/fastp/$sample/${sample}.2.trim.fq.gz  result/align_star/$sample $genomeDir"  
fi
done < sample_run.txt

exit 0