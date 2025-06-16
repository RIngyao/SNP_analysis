#!/bin/bash
# About: merged GVCF files of all the varieties into a single GVCF for joint genotyping
#	First generate a file for splitted chromosomes.
#	Example: cat chr1a.intervals
#			Chr1A
#			Chr1A1

# array for all the splitted chromosomes
chrom=("chr1a" "chr1b" "chr1d" "chr2a" "chr2b" "chr2d" "chr3a" "chr3b" "chr3d" "chr4a" "chr4b" "chr4d" "chr5a" "chr5b" "chr5d" "chr6a" "chr6b" "chr6d" "chr7a" "chr7b" "chr7d" "chruk")

ref="ref_wheatv2.1" 	# reference sequence

#function to run the combineGVCFs
run_gvcf(){
	
	local chr=$1		# chromomosome name 
	local variety=$2	# dir for varieties
	local out=$3		# output file
	local ref=$4		# reference sequence
	local interval=$5	# splited chromosome
       
	echo "Processing chromosome: $chr"
      
	# create a directory
	if [[ ! -d $chr ]];then
       		mkdir $chr
       	fi
	
 	gatk CombineGVCFs --java-options "-Xmx90G" \
        -R  "$ref" \
        -V "${variety}/26.g.vcf.gz" \
        -V "${variety}/agar-local/snp.g.vcf.gz" \
        -V "${variety}/ao-90/snp.g.vcf.gz" \
        -V "${variety}/bansi-224/snp.g.vcf.gz" \
        -V "${variety}/c-306/snp.g.vcf.gz" \
        -V "$variety/dharwad/snp.g.vcf.gz" \
        -V "$variety/dl-788-2-vidisha/snp.g.vcf.gz" \
        -V "$variety/DWR-162/snp.g.vcf.gz" \
        -V "$variety/DWR-16KEERTHI/snp.g.vcf.gz" \
        -V "$variety/DWR-225/snp.g.vcf.gz" \
        -V "$variety/gw2/snp.g.vcf.gz" \
        -V "$variety/gw-322/snp.g.vcf.gz" \
        -V "$variety/h1-1531/snp.g.vcf.gz" \
        -V "$variety/hd-2009-arjun/snp.g.vcf.gz" \
        -V "$variety/HD-2189/snp.g.vcf.gz" \
        -V "$variety/hd-2888/snp.g.vcf.gz" \
        -V "$variety/hd-2931/snp.g.vcf.gz" \
        -V "$variety/hd-2932/snp.g.vcf.gz" \
        -V "$variety/HD-2967/snp.g.vcf.gz" \
        -V "$variety/hi-1500-amrita/snp.g.vcf.gz" \
        -V "$variety/hi-617-sujata/snp.g.vcf.gz" \
        -V "$variety/Hindi-62/snp.g.vcf.gz" \
        -V "$variety/hs-240/snp.g.vcf.gz" \
        -V "$variety/huw-234-malviya-234/snp.g.vcf.gz" \
        -V "$variety/hw-741/snp.g.vcf.gz" \
        -V "$variety/IC_107371/snp.g.vcf.gz" \
        -V "$variety/IC_111837/snp.g.vcf.gz" \
        -V "$variety/IC_111838/snp.g.vcf.gz" \
        -V "$variety/IC_111853/snp.g.vcf.gz" \
        -V "$variety/IC_112039/snp.g.vcf.gz" \
        -V "$variety/IC_112047/snp.g.vcf.gz" \
        -V "$variety/IC_112048/snp.g.vcf.gz" \
        -V "$variety/IC_112049/snp.g.vcf.gz" \
        -V "$variety/IC_128159/snp.g.vcf.gz" \
        -V "$variety/IC_128225/snp.g.vcf.gz" \
        -V "$variety/IC_138560/snp.g.vcf.gz" \
        -V "$variety/IC_296443/snp.g.vcf.gz" \
        -V "$variety/IC_37583/snp.g.vcf.gz" \
        -V "$variety/IC_398298/snp.g.vcf.gz" \
        -V "$variety/IC_443761/snp.g.vcf.gz" \
        -V "$variety/IC_573144/snp.g.vcf.gz" \
        -V "$variety/IC_640652/snp.g.vcf.gz" \
        -V "$variety/jhusia/snp.g.vcf.gz" \
        -V "$variety/k-53/snp.g.vcf.gz" \
        -V "$variety/k-65/snp.g.vcf.gz" \
        -V "$variety/k-68/snp.g.vcf.gz" \
        -V "$variety/k-7903-halna/snp.g.vcf.gz" \
        -V "$variety/karchia-n/snp.g.vcf.gz" \
        -V "$variety/kharchia-lal-gehun/snp.g.vcf.gz" \
        -V "$variety/lal-bahadur/snp.g.vcf.gz" \
        -V "$variety/LGM-165/snp.g.vcf.gz" \
        -V "$variety/lok-1/snp.g.vcf.gz" \
        -V "$variety/macs-6222/snp.g.vcf.gz" \
        -V "$variety/mondhya/snp.g.vcf.gz" \
        -V "$variety/motia/snp.g.vcf.gz" \
        -V "$variety/mundia/snp.g.vcf.gz" \
        -V "$variety/narmada/snp.g.vcf.gz" \
        -V "$variety/narmada-4/snp.g.vcf.gz" \
        -V "$variety/NBPGR_11/snp.g.vcf.gz" \
        -V "$variety/NBPGR_12/snp.g.vcf.gz" \
        -V "$variety/NBPGR_13/snp.g.vcf.gz" \
        -V "$variety/NBPGR_41/snp.g.vcf.gz" \
        -V "$variety/NBPGR_47/snp.g.vcf.gz" \
        -V "$variety/NBPGR_49/snp.g.vcf.gz" \
        -V "$variety/NEPHAD-4/snp.g.vcf.gz" \
        -V "$variety/ni-5439/snp.g.vcf.gz" \
        -V "$variety/NP-101/snp.g.vcf.gz" \
        -V "$variety/np-4/snp.g.vcf.gz" \
        -V "$variety/pbw343/snp.g.vcf.gz" \
        -V "$variety/PISSI-LOCAL/snp.g.vcf.gz" \
        -V "$variety/RAJ-3765/snp.g.vcf.gz" \
        -V "$variety/safed-mundia/snp.g.vcf.gz" \
        -V "$variety/sharbati-vk-sk00-111-b/snp.g.vcf.gz" \
        -V "$variety/SONALIKA/snp.g.vcf.gz" \
        -V "$variety/sonora-64/snp.g.vcf.gz" \
        -V "$variety/type-1/snp.g.vcf.gz" \
        -V "$variety/type-11/snp.g.vcf.gz" \
        -V "$variety/up-2338/snp.g.vcf.gz" \
        -V "$variety/UP-262/snp.g.vcf.gz" \
        -V "$variety/vl-829/snp.g.vcf.gz" \
        -V "$variety/wh-147/snp.g.vcf.gz" \
        -V "$variety/wr544/snp.g.vcf.gz" \
        -V "${variety}"/7_S21/snp.g.vcf.gz \
        -V "${variety}"/24_S2/snp.g.vcf.gz \
        -V "${variety}"/38_S1/snp.g.vcf.gz \
        -V "${variety}"/39_S22/snp.g.vcf.gz \
        -V "${variety}"/45_S23/snp.g.vcf.gz \
        -V "${variety}"/48_S4/snp.g.vcf.gz \
        -V "${variety}"/49_S5/snp.g.vcf.gz \
        -V "${variety}"/50_S6/snp.g.vcf.gz \
        -V "${variety}"/54_S8/snp.g.vcf.gz \
        -V "${variety}"/56_S24/snp.g.vcf.gz \
        -V "${variety}"/57_S9/snp.g.vcf.gz \
        -V "${variety}"/59_S10/snp.g.vcf.gz \
        -V "${variety}"/61_S11/snp.g.vcf.gz \
        -V "${variety}"/63_S12/snp.g.vcf.gz \
        -V "${variety}"/64_S25/snp.g.vcf.gz \
        -V "${variety}"/65_S3/snp.g.vcf.gz \
        -V "${variety}"/66_S13/snp.g.vcf.gz \
        -V "${variety}"/68_S14/snp.g.vcf.gz \
        -V "${variety}"/69_S7/snp.g.vcf.gz \
        -V "${variety}"/71_S26/snp.g.vcf.gz \
        -V "${variety}"/72_S15/snp.g.vcf.gz \
        -V "${variety}"/73_S27/snp.g.vcf.gz \
        -V "${variety}"/76_S28/snp.g.vcf.gz \
        -V "${variety}"/77_S29/snp.g.vcf.gz \
        -V "${variety}"/79_S30/snp.g.vcf.gz \
        -V "${variety}"/83_S31/snp.g.vcf.gz \
        -V "${variety}"/84_S32/snp.g.vcf.gz \
        -V "${variety}"/15a_S17/snp.g.vcf.gz \
        -V "${variety}"/17a_S18/snp.g.vcf.gz \
        -V "${variety}"/20a_S19/snp.g.vcf.gz \
        -V "${variety}"/21a_S20/snp.g.vcf.gz \
        -V "${variety}"/10_S4/snp.g.vcf.gz \
        -V "${variety}"/18_S5/snp.g.vcf.gz \
        -V "${variety}"/19_S6/snp.g.vcf.gz \
        -V "${variety}"/29_S7/snp.g.vcf.gz \
        -V "${variety}"/74_S8/snp.g.vcf.gz \
        -V "${variety}"/78_S9/snp.g.vcf.gz \
        -V "${variety}"/87_S10/snp.g.vcf.gz \
        -V "${variety}"/82_S11/snp.g.vcf.gz \
        -V "${variety}"/92_S12/snp.g.vcf.gz \
        -V "${variety}"/93_S13/snp.g.vcf.gz \
        -V "${variety}"/104_S14/snp.g.vcf.gz \
        -V "${variety}"/125_S15/snp.g.vcf.gz \
        -V "${variety}"/127_S16/snp.g.vcf.gz \
        -V "${variety}"/129_S17/snp.g.vcf.gz \
        -V "${variety}"/131_S18/snp.g.vcf.gz \
        -V "${variety}"/132_S19/snp.g.vcf.gz \
        -V "${variety}"/133_S20/snp.g.vcf.gz \
        -V "${variety}"/134_S21/snp.g.vcf.gz \
        -V "${variety}"/135_S22/snp.g.vcf.gz \
        -V "${variety}"/136_S23/snp.g.vcf.gz \
        -V "${variety}"/130_S30/snp.g.vcf.gz \
        -V "${variety}"/99_S31/snp.g.vcf.gz \
        -V "${variety}"/126_S32/snp.g.vcf.gz \
        -V "${variety}"/128_S33/snp.g.vcf.gz \
        -V "${variety}"/86_S34/snp.g.vcf.gz \
        -V "${variety}"/91_S35/snp.g.vcf.gz \
        -V "${variety}"/2_S1/snp.g.vcf.gz \
        -V "${variety}"/3_S2/snp.g.vcf.gz \
        -V "${variety}"/12_S3/snp.g.vcf.gz \
        -V "${variety}"/16_S4/snp.g.vcf.gz \
        -V "${variety}"/26_S5/snp.g.vcf.gz \
        -V "${variety}"/30_S6/snp.g.vcf.gz \
        -V "${variety}"/31_S7/snp.g.vcf.gz \
        -V "${variety}"/32_S8/snp.g.vcf.gz \
        -V "${variety}"/33_S9/snp.g.vcf.gz \
        -V "${variety}"/37_S10/snp.g.vcf.gz \
        -V "${variety}"/41_S11/snp.g.vcf.gz \
        -V "${variety}"/42_S12/snp.g.vcf.gz \
        -V "${variety}"/46_S13/snp.g.vcf.gz \
        -V "${variety}"/51_S14/snp.g.vcf.gz \
        -V "${variety}"/52_S15/snp.g.vcf.gz \
        -V "${variety}"/58_S16/snp.g.vcf.gz \
        -V "${variety}"/60_S17/snp.g.vcf.gz \
        -V "${variety}"/67_S18/snp.g.vcf.gz \
        -V "${variety}"/75_S19/snp.g.vcf.gz \
        -V "${variety}"/80_S20/snp.g.vcf.gz \
        -V "${variety}"/81_S21/snp.g.vcf.gz \
        -V "${variety}"/94_S22/snp.g.vcf.gz \
        -V "${variety}"/95_S23/snp.g.vcf.gz \
        -V "${variety}"/96_S24/snp.g.vcf.gz \
        -V "${variety}"/102_S25/snp.g.vcf.gz \
        -V "${variety}"/103_S26/snp.g.vcf.gz \
        -V "${variety}"/88_S27/snp.g.vcf.gz \
        -V "${variety}"/98_S28/snp.g.vcf.gz \
        -V "${variety}"/25_S30/snp.g.vcf.gz \
        -V "${variety}"/40_S31/snp.g.vcf.gz \
        -V "${variety}"/44_S32/snp.g.vcf.gz \
        -V "${variety}"/36_S33/snp.g.vcf.gz \
        -V "${variety}"/90_S34/snp.g.vcf.gz \
        -V "${variety}"/100_S29/snp.g.vcf.gz \
        -V "${variety}"/101_S30/snp.g.vcf.gz \
        -V "${variety}"/13_S9/snp.g.vcf.gz \
        -V "${variety}"/14_S10/snp.g.vcf.gz \
        -V "${variety}"/1P_S23/snp.g.vcf.gz \
        -V "${variety}"/1_S2/snp.g.vcf.gz \
        -V "${variety}"/22_S5/snp.g.vcf.gz \
        -V "${variety}"/23_S1/snp.g.vcf.gz \
        -V "${variety}"/27_S11/snp.g.vcf.gz \
        -V "${variety}"/28_S12/snp.g.vcf.gz \
        -V "${variety}"/2P_S24/snp.g.vcf.gz \
        -V "${variety}"/34_S13/snp.g.vcf.gz \
        -V "${variety}"/35_S27/snp.g.vcf.gz \
        -V "${variety}"/3P_S25/snp.g.vcf.gz \
        -V "${variety}"/43_S14/snp.g.vcf.gz \
        -V "${variety}"/47_S15/snp.g.vcf.gz \
        -V "${variety}"/4P_S26/snp.g.vcf.gz \
        -V "${variety}"/4_S7/snp.g.vcf.gz \
        -V "${variety}"/53_S16/snp.g.vcf.gz \
        -V "${variety}"/5_S8/snp.g.vcf.gz \
        -V "${variety}"/62_S20/snp.g.vcf.gz \
        -V "${variety}"/6_S3/snp.g.vcf.gz \
        -V "${variety}"/70_S17/snp.g.vcf.gz \
        -V "${variety}"/85_S21/snp.g.vcf.gz \
        -V "${variety}"/89_S28/snp.g.vcf.gz \
        -V "${variety}"/97_S22/snp.g.vcf.gz \
        -V "${variety}"/9_S4/snp.g.vcf.gz \
        -L "$interval" \
        -O "${chr}/${out}"

         echo "Completed chromosome: $chr"
}

batch=4
count=0
# run the function for each chromosome
for chr in ${chrom[@]};do
       ((count++ % batch == 0)) && wait
       run_gvcf "$chr" "variety" "combine.g.vcf.gz" "$ref" "interval/${chr}.intevals" &
done

wait

echo "All completed"
