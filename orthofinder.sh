#!/bin/bash
#
#SBATCH --cpus-per-task=16
export PATH=export PATH=/apps/FASTME/2.1.5/bin/:$PATH
module purge
module load gcc/4.9.3-gold mcl
module load intel BLAST+/2.2.28

WD=/scratch/devel/malberola/orthologs
echo "Orthofinder folder:" ${WD}/orthofinder/;

while read acc ; do curl -s "https://www.uniprot.org/uniprot/$acc.fasta" ; done < /scratch/devel/malberola/orthologs/uniprot_ids.txt > ${WD}/orthofinder/uniprot_seqs.fa

/apps/ORTHOFINDER/2.2.6/bin/orthofinder -a 8 -f ${WD}/orthofinder/

