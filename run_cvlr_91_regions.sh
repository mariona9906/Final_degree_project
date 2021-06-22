#!/bin/bash
#
module purge
module load gcc/6.3.0
module load samtools

CRAMFILE=/scratch/devel/eraineri/cvlr/NA12878-sorted-merged.cram
REF=/scratch/devel/eraineri/cvlr/GRCh38.primary_assembly.genome.fa.bgz
DIR=/scratch/devel/malberola/cvlr/cvlr2/paper/
GENEDIR=/scratch/devel/malberola/cvlr/regions_from_paper.txt

while read gene chr start end; do

cd /scratch/devel/malberola/cvlr/cvlr/paper

REGION=${chr}:${start}-${end}

echo "Region: " ${REGION};

echo "DIR: " ${DIR};

samtools view -O cram,embed_ref -T ${REF} -@ 3 -o ${DIR}/cram_${gene}.cram ${CRAMFILE} ${REGION}

echo "Cram saved in: " ${DIR}/cram_${gene}.cram;

cd /scratch/devel/eraineri/bin/cvlr

module purge
module load gcc/6.3.0
module load openssl/1.0.2q
module load mkl
module load PYTHON/3.8.6
module load samtools

samtools index ${DIR}/cram_${gene}.cram

time -p ./cvlr.py meth ${DIR}/${gene}_cvlr ${REGION} ${DIR}/cram_${gene}.cram --maxit 50

cd ${DIR}

tar -czvf ${gene}_cvlr.tar.gz ${gene}_cvlr/;

done < "/scratch/devel/malberola/cvlr/regions_from_paper.txt"


