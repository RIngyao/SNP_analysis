# About: R script for arranging coverage per chromosome and total
# 	Run this script after script_read_coverage_mosdepth.sh
#	It will execute inside the mosdepthCov directory
# 	For multiple samples, use it within a shell script - script_mosdepthRWrapper.sh
#	

# usage: Rscript script dir_name

args <- commandArgs(trailingOnly = TRUE)

# directory name
dir <- args[1]

# Load dependencies
if(!require(tidyverse)){
	install.packages("tidyverse", repo="https://cran.r-project.org")
	require(tidyverse)
}

if(!require(data.table)){
	install.pacages("data.table", repo="https://cran.r-project.org")
	require(data.table)
}


# actual size of chromosome
chromSize <- data.frame(chrom=paste0("Chr",c("1A", "1B", "1D", "2A", "2B", "2D", "3A", "3B", "3D", "4A", "4B", "4D", "5A", "5B", "5D", "6A", "6B", "6D", "7A", "7B", "7D", "Un")),
length=c(598660771,700547650,498638509,787782382,812756088,656544705,754128462,851934319,619618852,754227811,673810555,518332611,713360825,714805578,569951440,622669997,731188532,495380293,744491836,764082088,642921467,351582993))

# import data
df <- data.table::fread(file="coverage.thresholds.bed.gz", sep2 = "\t ") %>% as_tibble()

# rename header
colnames(df) <- c("chrom", "start", "end", "region", "d1x", "d3x", "d5x")

# rename chromosome: remove the trailing number
df$chrom <- str_sub(df$chrom, start=1, end=5)

# summation of the split chromosome
df2 <- df %>% summarise(d1x=sum(d1x), d3x=sum(d3x), d5x=sum(d5x), .by = chrom)


# append acutal size
df2$total <- chromSize$length


# get percentage
percDf <- df2 %>% mutate(d1x_per = round((d1x/total)*100, 2), d3x_per = round((d3x/total)*100, 2), d5x_per = round((d5x/total)*100,2)) %>%
  select(ends_with("_per"))

# append to df2
perChrom <- cbind(df2, percDf)


# find total depth
totalSum <- colSums(df2[, -1])
ts <- as.data.frame(t(totalSum))
ts$chrom <- dir #assign the sample ID


# determine percent
perTo <- ts %>% summarise(d1x_per = round((d1x/total)*100, 2), d3x_per = round((d3x/total)*100, 2), d5x_per = round((d5x/total)*100,2), .by = chrom)


#merge
totalDf <- cbind(perTo, ts[, -5]) %>% select(colnames(perChrom))


# merge total and per chromosome
final <- rbind(perChrom, totalDf)

# save the file
write_csv(final, "coverageData.csv")

# save only the total file: keep appending to the existing file
# save it in the main directory
total_file <- "../../coverageDataTotal.csv"

if(!file.exists(total_file)){
  write.table(totalDf, total_file, sep = ",", append = FALSE, row.names = FALSE, col.names = TRUE)
}else{
  write.table(totalDf, total_file, sep = ",", append = TRUE, row.names = FALSE, col.names = FALSE)
}


