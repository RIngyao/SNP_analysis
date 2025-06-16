#!/usr/bin/env bash
#SBATCH --job-name=mapping            # Job name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks (MPI processes) per node
#SBATCH --cpus-per-task=50            # Number of CPU cores per task
#SBATCH --mem=200G                    # Total Memory for all the task
#SBATCH --partition=cpu               # Partition name
#SBATCH --output=mapping.log	      # log

# About : mapping reads to reference genome using bwa and sorting
set -eu #x

func_map(){

	local indx=$1	# path of bwa indexed reference genome
	local r1=$2	# fastq - pair 1
	local r2=$3	# fastq - pair 2
	local dir=$4	# output directory name

	
	# -M option is require for compatibility with GATK
	echo "Mapping: $r1 and $r2"
	
	bwa mem $indx \
		-M $r1 $r2 \
		-t 7 | \
		samtools view -Sb - > "${dir}/mapped.bam"
	
	echo "Map success: ${dir}/mapped.bam"

	
	# sort
	echo "Sorting: ${dir}/mapped.bam"
	
	samtools sort "${dir}/mapped.bam" -@ 7 -m 5G -o "${dir}/mapped_sorted.bam"

	echo "Sort success: ${dir}/mapped_sorted.bam"

	# mapped reads statistics
	echo "Estimate stats : ${dir}/mapped_sorted.bam"
	samtools flagstat -@ 7 "${dir}/mapped_sorted.bam" > "${dir}/mapstats.out"
	echo "Stats complete : ${dir}/mapstats.out"

}


# run 5 jobs in parallel
batch=5
count=0

while read -r dir; do

	((count++ % batch == 0)) && wait

	func_map "ref/index" "${dir}/${dir}_R1.fastq_filtered.gz" "${dir}/${dir}_R2.fastq_filtered.gz" "$dir" &

done < "dir_list.txt"

wait

echo "All completed"
