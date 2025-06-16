#!/usr/bin/env bash

# About: determining the summary of the data - number of bases (raw and clean), duplicate rate and adapter trimmed reads. 
#	The input file is the output file of fastp. 

# Directory to proceed
 dir="dir_list.txt"

# add header to output file 
echo  "sampleID,beforeBases,beforeReads,afterBases,afterReads,adapter,duplicateRate" > qc_summary.txt

while read -r p; do
  file="${p}_fastp.stats"
  
  echo "Processing: $file"

  # navigate to the directory
  pushd "$p" || exit

  # Before: reads
  br1=$(grep -A 2 "Read1 before filtering:" "$file" | awk '/total reads:/ {print $NF}')
  br2=$(grep -A 2 "Read2 before filtering:" "$file" | awk '/total reads:/ {print $NF}')

  # After: reads
  ar1=$(grep -A 2 "Read1 after filtering:" "$file" | awk '/total reads:/ {print $NF}')
  ar2=$(grep -A 2 "Read2 after filtering:" "$file" | awk '/total reads:/ {print $NF}')

  # Before: bases
  bb1=$(grep -A 2 "Read1 before filtering:" "$file" | awk '/total bases:/ {print $NF}')
  bb2=$(grep -A 2 "Read2 before filtering:" "$file" | awk '/total bases:/ {print $NF}')

  # After: bases
  ab1=$(grep -A 2 "Read1 after filtering:" "$file" | awk '/total bases:/ {print $NF}')
  ab2=$(grep -A 2 "Read2 after filtering:" "$file" | awk '/total bases:/ {print $NF}')

  # reads with adapter trimmed
  adp=$(awk '/reads with adapter trimmed:/ {print $NF}' "$file")

  # duplicate rate
  dupr=$(awk '/Duplication rate:/ {print $NF}' "$file")

  # Sum
  br12=$((br1 + br2))
  ar12=$((ar1 + ar2))
  bb12=$((bb1 + bb2))
  ab12=$((ab1 + ab2))

  # navigate back
  popd

  #save
  echo "$p,$bb12,$br12,$ab12,$ar12,$adp,$dupr" >> qc_summary.txt


done < "$dir"
