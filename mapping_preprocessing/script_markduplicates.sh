#!/bin/bash
#SBATCH --job-name=markDup             # Job name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks (MPI processes) per node
#SBATCH --cpus-per-task=50            # Number of CPU cores per task
#SBATCH --mem=200G                    # Total Memory for all the task
#SBATCH --partition=cpu               # Partition name
#SBATCH --output=markDup.log

#About: identify and mark duplicate reads in BAM
set -eu #x

# run 2 jobs in parallel
batch=2
count=0

while read -r dir; do

	((count++ % batch == 0)) && wait

	java -Xms90g -jar picard.jar MarkDuplicates \
		INPUT=${dir}/mapped_sorted.bam \
		OUTPUT=${dir}/mapped_sort_dedup.bam \
		METRICES_FILE=${dir}/dedup_metrics.txt \
		ASSUME_SORTED=TRUE \
		REMOVE_DUPLICATES=TRUE \
		VALIDATION_STRINGENCY=LENIENT \
		CREATE_INDEX=true \
		TMP_DIR=${dir}/tmp \
		MAX_FILE_HANDLES=1000 &

done < dir_list.txt


wait

echo "Completed"
