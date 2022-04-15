library(tidyverse)
library(purrr)
library(readr)
library(fs)
library(dplyr)
library(stringr)
library(ggplot2)
library(RColorBrewer)
library(scales)
library(viridis)

mosdepthdir = "coverage/mosdepth"
patternstr=".5000bp.thresholds.bed.gz$"
infiles <- list.files(path=mosdepthdir,pattern = patternstr, recursive = FALSE,full.names=TRUE)
mosdepthdir <- paste(mosdepthdir,"/",sep = "")
pattern <- str_replace(patternstr,"\\$","")
mdfiles <- tibble::rowid_to_column(data.frame(infiles),"source") %>% mutate_at("infiles",str_replace,mosdepthdir,"") %>% 
  mutate_at("infiles",str_replace,pattern,"")
mdfiles <- tibble(mdfiles)  %>% type_convert(col_types="ic")

#chrom	start	end	region	1X	10X	50X	100X	200X
mosdepth <- infiles %>% map_dfr(read_tsv, .id="source",skip=1,
                                col_names = c("Scaffold","Start","End","Region",
                                              "Cov1","Cov10","Cov50","Cov100","Cov200")) %>%
                              select(source,Scaffold,Start,End,Cov1)
mosdepth <- mosdepth %>% type_convert(col_types="iciii")
mosdepth <- mosdepth %>% left_join(mdfiles,by="source") %>% mutate(Length = End - Start) %>% select(infiles,Scaffold,Length,Cov1)

sumcovtotal <- mosdepth %>% group_by(infiles) %>% summarize(covtotal=sum(Cov1),genomelen=sum(Length)) %>% mutate(coveragePct=covtotal/genomelen)
write_tsv(sumcovtotal,"summary_recovery.tsv")
