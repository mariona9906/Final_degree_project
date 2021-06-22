#!/bin/bash
#
module load EXONERATE/2.4.0

GENEDIR=/scratch/devel/malberola/cvlr/regions_from_paper.txt
SEQ=/scratch/devel/malberola/orthologs/human/paper_imp_regions_seq.fa

module purge
module load gcc/6.3.0
module load openssl/1.0.2q
module load mkl
module load PYTHON/3.8.6
module load samtools

while read gene chr start end ; do
REGION=${chr}:${start}-${end}

samtools faidx /scratch/devel/eraineri/cvlr/GRCh38.primary_assembly.genome.fa.bgz ${REGION}

done < "${GENEDIR}" > "${SEQ}"

SEQ=/scratch/devel/malberola/orthologs/human/paper_imp_regions_seq.fa
REF=/scratch/devel/talioto/de_novo_annotation/solea_senegalensis_MARTINEZPAU/annotation_out/SolSen1.scaffolds.fa
OUT=/scratch/devel/malberola/orthologs/exonerate_out/paper_imp_genes2genome_out.txt

exonerate --showtargetgff 1  ${SEQ} ${REF} > ${OUT}

