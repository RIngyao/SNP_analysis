#!/bin/bash
#SBATCH --job-name=ARG             # Job name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks (MPI processes) per node
#SBATCH --cpus-per-task=50            # Number of CPU cores per task
#SBATCH --mem=200G                    # Total Memory for all the task
#SBATCH --partition=cpu               # Partition name
#SBATCH --output=addRepGrp.log

# About: Add or modify read group information in a BAM file using picard
#	This step is require to differentiate reads from different samples or library. So, unique ID is required
#	for all the samples.
#	It involve two steps: 
#		Firstly, create a unique ID for all the samples or library.
#		Secondly, after generating the ID run the AddOrReplaceReadGroups of picards


#------------Generate unique ID ------------------------------
# read group can also be generated from bam 
# extract the read group platform unit (RGPU): I generated  uniq ID from fastq and accession name
# 	zcat ${dir}_fastq.gz | head -n 1 | cut -c2-37 |  awk -v name="$dir", '{print name $1}' >> RGPU.txt
# example output of sample1 using the above command:
#	sample1 A01412:34:H7MK3DSXC:1:1101:1542:1000
# Additional info were manually added for each samples
# Final output for sample1:
# 	sample1   IC0534106_38_S1 A01412:34:H7MK3DSXC:1:1101:1542:1000    IC0534106       IC0534106_lib
# Generated ID for samples were saved as addOrRepID.txt in their respective directory.

#--------------modify read groups ------------------------------
# Execute the below commands after generating the above ID

set -eu #x

func_mod(){

	local idFile=$1		# ID file name
	local inBam=$2		# input sorted bam file
	local out=$3		# output  file  name
	local dir=$4		# dir name

	# navigate to the sample directory
	pushd $dir

	# check files
	if [[ ! -f  "$idFile" || ! -f "$inBam" ]]; then
		echo "Missing  files: $idFile | $inBam"
		exit  1
	fi

	echo "Processing: $dir"
	# Extract values from addOrRepID.txt
	rgsm=$(awk -F"\t" '{print $2}' $idFile)
	rgpu=$(awk -F"\t" '{print $3}' $idFile)
	rgid=$(awk -F"\t" '{print $4}' $idFile)
	rglb=$(awk -F"\t" '{print $5}' $idFile)

	java -Xms40g -jar picard.jar AddOrReplaceReadGroups \
		INPUT=$inBam \
		OUTPUT=$out  \
		RGSM="$rgsm" \
		RGPU="$rgpu" \
		RGID="$rgid" \
		RGLB="$rglb" \
		RGPL=Illumina \
		CREATE_INDEX=true
	
	# navigate back
	popd

	echo "Success : $dir"
}

# Run 4 parallel jobs
batch=4
count=0

# recomend to use GNU parallel, instead of for loop
while read -r dir; do

	((count++ %  batch == 0)) && wait

        func_mod "addOrRepID.txt" "mapped_sort_dedup.bam" "mapped_dedup_addOrRep.bam" $dir &

done < dir_list.txt

wait

echo "Completed"
