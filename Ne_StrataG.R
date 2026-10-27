# estimate effective population size

library(tidyverse)
library(vcfR)
library(strataG)

get.LDNe <- function (inputVcf, threads) {
  read.vcfR(inputVcf, verbose = T) %>% vcfR2genind() %>% genind2gtypes() %>%
    ldNe(maf.threshold = 0, by.strata = TRUE, ci = 0.95, num.cores = threads)
}


poplist <- c("anadromous",
             "champlain",
             "fingerlakes",
             "seneca",
             "cayuga",
             "ontario",
             "greatlakes",
             "erie",
             "huron",
             "michigan",
             "superior")

ld.results <- list(poplist)
for (pop in poplist) {
  for (i in seq(1,20,1)) {
    filename <- paste(pop, "10k", i, "vcf.gz", sep = ".")
    ld.results[[pop]][[i]] <- get.LDNe(filename, 4)
ld.results
  }}


for (pop in poplist){
  ld.results[[pop]] %>%
    bind_rows %>%
    mutate(stratum=pop) %>%
    write.table(paste0(pop, ".ld_estimates.tsv"),
                sep = "\t",
                row.names = FALSE,
                col.names = TRUE,
                quote = FALSE)
}
