# principal component analysis and plotting

library(tidyverse)
library(vcfR)
library(adegenet)
library(adegraphics)

lampreydat <- read.vcfR("pmar.norm.reduced.renamed.nam.nomissing.maf005.hwe005.ld02.vcf.gz") %>%
  vcfR2genind()

pops1 <- c(
  rep("Anadromous", 40),
  rep("Finger Lakes", 29),
  rep("EHMS", 171),
  rep("Ontario", 38),
  rep("Champlain", 39)
) %>% as.factor()

pops2 <- c(
  rep("Anadromous", 40),
  rep("Cayuga", 20),
  rep("Seneca", 9),
  rep("EHMS", 171),
  rep("Ontario", 38),
  rep("Champlain", 39)
) %>% as.factor() 



res.pca <- dudi.pca(lampreydat, scannf = FALSE, nf = 4)

pdf("pca12.pdf", height = 5, width = 5)
s.class(res.pca$li[,c(1,2)],
        fac = pops1,
        xlab = "\nPCA 1",
        ylab = "PCA 2\n",
        col = c("grey10", "blue", "darkgreen", "tomato", "orange"))
dev.off()

pdf("pca34.pdf", height = 5, width = 5)
s.class(res.pca$li[,c(3,4)],
        fac = pops2,
        xlab = "\nPCA 3",
        ylab = "PCA 4\n",
        col = c("grey10", "#F88379", "blue", "darkgreen", "orange", "firebrick"))
dev.off()
