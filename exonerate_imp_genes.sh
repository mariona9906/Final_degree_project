#!/bin/bash
#

module load EXONERATE/2.4.0

QUERY=/scratch/devel/malberola/orthologs/human/imprinted-genes_seq.fa
TARGET=/scratch/devel/talioto/de_novo_annotation/solea_senegalensis_MARTINEZPAU/
annotation_out/SolSen1.scaffolds.fa
OUT=/scratch/devel/malberola/orthologs/exonerate_out/june11_imp_genes2genome_out
.txt

exonerate --showtargetgff 1  ${QUERY} ${TARGET} > ${OUT}
