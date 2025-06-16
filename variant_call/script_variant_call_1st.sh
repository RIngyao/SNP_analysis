#!/bin/env bash

# About: haplotype calling using gatk4

set -eu

# 
sample_list="sample.txt" 	# list of sample to run: one sample per line
ref="ref_wheatv2.1"		# reference sequence

# Function
hap_cal() {


        local sample=$1                 # sample ID for processing
	local ref=$2			# reference
	local bam=$4			# input bam file - processe
	local out=$5			# output file name

        echo "Processing $sample"
        # run the haplotypecaller
        gatk --java-options "-Xmx100G" HaplotypeCaller \
                -R "$ref" \
                -I "$bam" \
                -ERC GVCF \
		-ploidy 6 \
                --stand-call-conf 30 \
                -O "$out" \
                --native-pair-hmm-threads 45


    echo "Haplotype calling successful for $sample"

}


# Execute the haplotypecaller

while read -r sample; do
    if [ -d "$sample" ]; then
        pushd "$sample" || { echo "Error: Unable to change directory to $sample"; exit 1; }

        # Run the function in the background
        hap_cal "$sample" "$ref" "snp_dedup_reads_addOrRep.bam" "snp.g.vcf.gz" &

        # Return to the parent directory
        popd || exit
    else
        echo "Error: No directory named $sample"
        exit 1
    fi
done < "$sample_list"

wait

echo "All processes completed"

