#!/bin/bash
#

GFF=/scratch/devel/talioto/de_novo_annotation/solea_senegalensis_MARTINEZPAU/annotation_out/SolSen1A.gff3
ORTHOLOGS=/scratch/devel/malberola/orthologs/orthofinder/Results_May20/WorkingDirectory/Orthologues_May28/Orthologues/Orthologues_SolSen1A.longestpeptide/SolSen1A.longestpeptide_v_uniprot_seqs.csv
REGIONS_OUT=/scratch/devel/malberola/cvlr/solea/sole_gene_regions.txt

while read orthogroup protein_sole protein_human; do 

grep ${protein_sole} ${GFF} | awk '{gsub(/\"|\;/," ")}1' | awk '{print $12, $1, $4, $5, $7}' | awk '{gsub(/\"|\product=/,"")}1'

done < "${ORTHOLOGS}" > ${REGIONS_OUT}


