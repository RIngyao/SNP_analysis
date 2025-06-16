#!/bin/bash

#SBATCH --job-name=depth          # Job name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks (MPI processes) per node
#SBATCH --cpus-per-task=40            # Number of CPU cores per task
#SBATCH --mem=160G                     # Total Memory for the task
#SBATCH --partition=cpu               # Partition
#SBATCH --output=mosdepth.log         # Output file

# About: analysis of read  coverage at 1x, 3x and  5x using mosdeppth
# usage: sbatch script dir_list


# check for dir list
if [[ $#  -eq  1 && -f $1 ]];then
	dir_list=$1
else
	echo "Usage error: script.sh dir_list"
	echo "Provide a file name listing the directory of samples. One name per line"
	echo "Exiting.."
	exit 1
fi



#function for depth analysis
cov_depth(){
        local file=$1			# directory file
        local bam=$2			# bam file
        local bed=$3		  	# chromosome bed file
        local prefix="coverage"

        pushd "$file"

        # run at 1x, 3x, 5x
        mosdepth --threads 3 \
                --by "../$bed" \
                --no-per-base \
                --thresholds 1,3,5 "$prefix" "$bam"

        # create a coverage dir and move it
        mkdir mosdepthCov

        mv coverage.* mosdepthCov

        popd
}

batch=10
count=0

for file in $(cat "$dir_list"); do
        ((count++ % $batch == 0)) && wait

        if [ -d "$file" ]; then
                cov_depth "$file" "snp_dedup_reads_addOrRep.bam" "chromosomeSize.bed" &
	else
		echo "$file is not a directory"
		exit 1
	fi

done

wait


echo "Completed"
