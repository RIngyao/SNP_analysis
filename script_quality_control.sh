#!/usr/bin/env bash
#SBATCH --job-name=fastp              # Job name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks (MPI processes) per node
#SBATCH --cpus-per-task=50            # Number of CPU cores per task
#SBATCH --mem=200G                    # Total Memory for all the task
#SBATCH --partition=cpu               # Partition name

# About: quality control of raw sequenced data using fastp/

# 	I have stored the raw FASTQ files into separate directories based on accession.
# 	The name of the dir are listed in a file - dir_list.txt

set -eu #x

batch=10	# run 10 jobs at a time. Alternative, use GNU parallel to manage CPU more efficiently 
count=0

while read -r dir; do

	((count++ % batch == 0)) && wait
	
	fastp -i  "${dir}/${dir}_L001_R1_001.fastq.gz" \
		-I "${dir}/${dir}_L001_R2_001.fastq.gz" \
		-o "${dir}/${dir}_R1.fastq_filtered.gz" \
		-O "${dir}/${dir}_R2.fastq_filtered.gz" \
		--thread 4 \
		--json "${dir}/${dir}-Illumina_fastp.json" \
		--html "${dir}/${dir}-fastp.html" \
		-q 30 -u 30 -l 50 \
		--detect_adapter_for_pe -p -z 1 \
		-R "${dir}/${dir}-Illumina_fastp_report" > "${dir}/${dir}_fastp.stats" 2>&1 &

done < "dir_list.txt"

wait

echo "Completed"

