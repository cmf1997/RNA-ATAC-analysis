#!/bin/bash

set -e

fq1=$1
fq2=$2
sample=$3
#genome=`/lustre/home/acct-medzy/medzy/genomes/Mus_musculus.GRCm39.Ensembl104/genome_STAR/genome_without_anno/`
genome=`/lustre/home/acct-medzy/medzy/genomes/Mus_musculus.GRCm39.Ensembl104/genome_STAR/genome_with_anno/`


STAR=/lustre/home/acct-medzy/medzy/anaconda3/bin/STAR

# not splicing 
#$STAR --runMode alignReads --runThreadN 8 --genomeDir $genome --genomeLoad NoSharedMemory --readFilesIn $fq1 $fq2 --readFilesCommand zcat --outFileNamePrefix $sample. --outSAMtype BAM SortedByCoordinate --outBAMcompression 6 --outFilterMultimapNmax 1 --outFilterMismatchNoverLmax 0.06 --outFilterMatchNmin 30 --outFilterMatchNminOverLread 0.55 --outFilterScoreMinOverLread 0.55 --seedSearchStartLmax 30 --alignIntronMax 1 --alignEndsType Local --clip3pAdapterSeq CTGTCTCTTA CTGTCTCTTA --clip3pAdapterMMp 0.1 0.1

# enable splicing
$STAR --runMode alignReads --runThreadN 8 --genomeDir $genome --genomeLoad NoSharedMemory --readFilesIn $fq1 $fq2 --readFilesCommand zcat --outFileNamePrefix $sample. --outSAMtype BAM SortedByCoordinate --outBAMcompression 6 --outFilterMultimapNmax 1 --outFilterMismatchNoverLmax 0.06 --outFilterMatchNmin 30 --outSJfilterOverhangMin 30 10 10 10 --seedSearchStartLmax 30 --alignIntronMin 20 --alignIntronMax 20000 --alignEndsType Local