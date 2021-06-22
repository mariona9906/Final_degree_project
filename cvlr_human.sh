#!/bin/bash
#

CRAMFILE=/scratch/devel/eraineri/cvlr/NA12878-sorted-merged.cram
GTF=/scratch/devel/malberola/cvlr/Homo_sapiens.GRCh38.90.gtf.gz
DIR=/scratch/devel/malberola/cvlr/cvlr2
GENEDIR=/scratch/devel/malberola/cvlr/imprinted-genes.txt


cd /scratch/devel/eraineri/bin/cvlr

module purge
module load gcc/6.3.0
module load openssl/1.0.2q
module load mkl
module load PYTHON/3.8.6
module load samtools

while read gene chr start end strand; do
REGION=chr${chr}:${start}-${end}
echo "Region: " ${REGION};

echo "DIR: " ${DIR};

samtools index ${CRAMFILE}

time -p ./cvlr.py meth ${DIR}/${gene}_cvlr ${REGION} ${CRAMFILE} --maxit 50


tar -czvf ${DIR}/${gene}_cvlr.tar.gz ${DIR}/${gene}_cvlr/

done < "$GENEDIR"

while read gene chr start end strand; do
zgrep -w '"'${gene}'";' ${GTF} | awk '$3 == "transcript"' | awk '{print $1, $3, $4, $5, $7, $10, $14,  $18, $24}' | awk '{gsub(/\"|\;/,"")}1' 

done < "$GENEDIR"> /scratch/devel/malberola/cvlr/transcript_positions.txt


