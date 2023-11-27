#!/bin/bash

set -e

samples='run1 run2 run3'
result_path=/lustre/home/acct-medzy/medzy-cai/project/project_***/results/encode_atac/

if [ ! -d ${result_path} ];
then
        mkdir -p ${result_path}
fi

cd $result_path

for sample in $samples
do
        if [ ! -d ${result_path}/${sample}/atac ];
        then
                sbatch -p small -n 10 --job-name=${sample} --output=${sample}.hpc.out --error=${sample}.hpc.err --wrap "module load jdk/12.0.2_10-gcc-9.2.0 ; caper run /lustre/home/acct-medzy/medzy-cai/software/atac-seq-pipeline/atac.wdl -i ${sample}.json --singularity --out-dir ${sample}"
        else
                echo $sample results exists!
        fi
done