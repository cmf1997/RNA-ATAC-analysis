samples='Gas_Pbmc_S0504_C5d1 Gas_Pbmc_S0804_C3d1 Gas_Pbmc_S0904_C3d1 Eso_Pbmc_S1304_C1d1'
result_path=/lustre/home/acct-medzy/medzy-cai/project/project_gas/results/encode_atac/

for sample in $samples
do
        file_out_name=`ls ${sample}/atac/`
        if [ ! -d {sample}/atac/${file_out_name}/peak ];
        then
                cd ${sample}/atac/${file_out_name}
                echo processing $sample metadata
                croo metadata.json
                cd $result_path
        else
                echo $sample metadata parsed!
        fi
done