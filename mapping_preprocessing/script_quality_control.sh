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
# Software: fastp (v0.21.0)

set -eu #x

func_qc(){

	local pair1=$1		# fastq for pair1
	local pair2=$2		# fastq for pair2
	local out1=$3		# output filter file name for pair1
	local out2=$4		# output filter file name for pair2
	local json=$5		# json output file name
	local html=$6		# html output file name
	local report=$7		# report output file name
	local stats=$8		# statistics output file name

	fastp -i "$pair1" -I "$pair2" \
		-o "$out1" -O "$out2" \
		--json "$json" --html "$html" -R "$report" \
		--detect_adapter_for_pe -p -z 1 -q 30 -u 30 -l 50 \
		--thread 4 > "$stats"
}

batch=10	# run 10 jobs at a time. Alternative, use GNU parallel to manage CPU more efficiently 
count=0


while read -r dir; do

	((count++ % batch == 0)) && wait
	func_qc "${dir}/${dir}_L001_R1_001.fastq.gz" "${dir}/${dir}_L001_R2_001.fastq.gz" "${dir}/${dir}_R1.fastq_filtered.gz" "${dir}/${dir}_R2.fastq_filtered.gz" "${dir}/${dir}-Illumina_fastp.json" "${dir}/${dir}-fastp.html" "${dir}/${dir}-Illumina_fastp_report" "${dir}/${dir}_fastp.stats" &

done < "dir_list.txt"

wait

echo "Completed"

