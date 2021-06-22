#!/bin/bash
#


BAMFILE=/scratch/devel/malberola/bam/AR7960.bam
REF=/scratch/devel/talioto/de_novo_annotation/solea_senegalensis_MARTINEZPAU/annotation_out/SolSen1.scaffolds.fa

DIR=/scratch/devel/malberola/cvlr/solea/

GENEDIR=${DIR}/sole_gene_regions.txt



cd /scratch/devel/eraineri/bin/cvlr

module purge
module load gcc/6.3.0
module load openssl/1.0.2q
module load mkl
module load PYTHON/3.8.6
module load samtools


while read gene chr start end strand; do
REGION=${chr}:${start}-${end}

samtools index ${BAMFILE}

time -p ./cvlr.py meth ${DIR}/${gene}_cvlr ${REGION} ${BAMFILE} --maxit 50

done < "${GENEDIR}"

cd ${DIR}

while read gene chr start end strand; do
REGION=${chr}:${start}-${end}

tar -czvf ${gene}_cvlr.tar.gz ${gene}_cvlr/

done < "${GENEDIR}"


