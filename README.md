## ATAC sequences data analysis
*adjust based on [DiffBind](https://bioconductor.org/packages/release/bioc/html/DiffBind.html) and [cinaR](https://eonurk.github.io/cinaR/index.html)*



### QC
```shell
# use fastqc to generate qc plot and multiqc to integrate in one
fastqc -o ${path}/fastqc -t 20 ${pathfastq}/*.fastq.gz
multiqc .
```

Trimmomatic



### process atac-seq data
*Align - Remove PCR Replicates - Call peaks - idr done by standard encode pipeline*

Set scripts/ample.json properly and run scripts/1_atac_batch_slurm.sh and scripts/2_atac_croo_matadata.sh
*if idr is true, IDR can be used with biological replicates to output a conservative "peak set can be interpreted as high confidence peaks". Also, IDR can be used with pseudo replicates to output an optimal "peak set.*

#### Requirement 

```R
BiocManager::install(c("ChIPseeker", "DESeq2", "edgeR", "fgsea","GenomicRanges", "limma", "preprocessCore", "sva"))
```

### Install Cmf-CinaR
*Custom cinaR package for analysis ATAC-seq or RNA-seq*
Package need download from cmf github

```shell
wget CmfcinaR_1.0.0.tar.gz
```

```R
install.packages("~/software/CmfcinaR_1.0.0.tar.gz",type="source",repos=NULL,lib="/lustre/home/acct-medzy/medzy-cai/.conda/envs/R-4.1.3/lib/R/library/")
```


### Save txdb for use

```R
library(GenomicFeatures)
# download gtf from http://www.ensembl.org/info/data/ftp/index.html
gtf_file <- "Mus_musculus.GRCm39.104.gtf.gz"
GRCm39 <- makeTxDbFromGFF(gtf_file, format="gtf")
saveDb(GRCm39,"GRCm39_Txdb.sqlite")

gtf_file <- "Homo_sapiens.GRCh38.105.gtf.gz"
GRCh38 <- makeTxDbFromGFF(gtf_file, format="gtf")
saveDb(GRCh38,"GRCh38_Txdb.sqlite")

# also support other species ...
```


### Usage

```R
library(AnnotationDbi) 
library(CmfcinaR)
library(DiffBind)

# use DiffBind for generating count matrix, require bam file and bam.bai and peak file (bed)
# csv file should be like 
config_path <- paste0 (file_dir, '/*.csv')
DBdata <- dba(sampleSheet=config_path, config=data.frame(RunParallel=TRUE),)

# remove blacklists
# DBA_BLACKLIST_HG19: Homo sapiens 19 (chromosomes have "chr")
# DBA_BLACKLIST_HG38: Homo sapiens 38 (chromosomes have "chr")
# DBA_BLACKLIST_GRCH37: Homo sapiens 37 (chromosomes are numbers)
# DBA_BLACKLIST_GRCH38: Homo sapiens 38 (chromosomes are numbers)
# DBA_BLACKLIST_MM9: Mus musculus 9
# DBA_BLACKLIST_MM10: Mus musculus 10
# or providing GRanges object from user specified blacklist
DBdata <- dba.blacklist(DBdata, blacklist=DBA_BLACKLIST_HG19,greylist=FALSE)

# count
DBdata <- dba.count(DBdata, minOverlap=2, summits=200, bParallel=TRUE, score = DBA_SCORE_NORMALIZED, bUseSummarizeOverlaps=TRUE)

# normalize
DBdata <- dba.normalize(DBdata)

# lib size
norm.factors <- dba.normalize(DBdata, bRetrieve=TRUE)$norm.factors

# save consensus matrix file
norm.count.matrix <- dba.peakset(DBdata, bRetrieve=TRUE, DataType=DBA_DATA_FRAME, writeFile = "norm.count.matrix.txt")

# load txdb 
txdb <- AnnotationDbi::loadDb("./GRCm39_Txdb.sqlite")

# run cina for DA
# generate contrast from sample.csv
contrasts <- c("B6", "B6", "B6", "B6", "B6", "NZO", "NZO", "NZO", "NZO", "NZO", "NZO", "B6", "B6", "B6", "B6", "B6", "NZO", "NZO", "NZO", "NZO", "NZO", "NZO")
# or
contrasts <- read.table(config_path)$group
results <- cinaR(norm.count.matrix, contrasts, reference.genome = "GRCh38._Txdb.sqlite", DA.choice=4, comparison.scheme = "OVO", experiment.type == "ATAC-Seq")
```


### GO and KEGG

```R
library(clusterprofiler)
source(scripts/GO_analysis.R)
```


### Remove package

```R
remove.packages("CmfcinaR",lib="/lustre/home/acct-medzy/medzy-cai/.conda/envs/R-4.1.3/lib/R/library/")
detach(package:CmfcinaR)
```


### Build package after modifying the code

```shell
git clone cinaR
# modify #
R CMD build Cmf-cinaR  
```