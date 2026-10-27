# analysis of population structure with snmf

library(tidyverse)
library(reshape2)
library(LEA)

# read in sample names
indvdat <- scan("pmar.norm.reduced.renamed.nam.nomissing.samples.tsv", "\n")

# define groupings for labeling (lakes for freshwater, states for anadromous)
pops <- c(
  rep("Massachusetts", 12),
  rep("New Brunswick", 12),
  rep("North Carolina", 8),
  rep("Maryland", 8),
  rep("Cayuga", 20),
  rep("Seneca", 9),
  rep("Superior", 47),
  rep("Huron", 63),
  rep("Michigan", 31),
  rep("Erie", 30),
  rep("Ontario", 38),
  rep("Champlain", 39)
)

# estimate ancestry coefficients for 1-10 ancestries
project1 = snmf("pmar.norm.reduced.renamed.nam.nomissing.maf005.hwe005.ld02.geno", K=1:10, entropy = TRUE, repetitions = 10, project = "new")
# project1 <- load.snmfProject("pmar.norm.reduced.renamed.nam.nomissing.maf005.hwe005.ld02.snmfProject") # use this to load an already created project instead

# plot and output cross entropy estimates for each k value
ce = list()
for (k in 1:10){
  ce[[k]] <- cbind(rep(k, 10), seq(1:10), cross.entropy(project1, K = k))
}
ce <- data.frame(do.call("rbind", ce))

colnames(ce) <- c("K", "run", "entropy")
ce$run <- paste("run", ce$run)

entropyplot <- ggplot(data = ce, aes(x = K, y = entropy, col = run)) + 
  scale_x_continuous(breaks = seq(0, 20, by = 1)) +
  geom_line() +
  xlab("Number of ancestral populations") + ylab("Cross-entropy") +
  theme_bw()

write.table(ce, file = "Xentropy.tsv", col.names = T, row.names = F)
pdf("Xentropy.pdf", width = 10, height = 4)
  entropyplot
dev.off()

# prepare data for plotting the results with optimal k value (K=4 here)
K4.1 <- Q(project1, K = 4, run = which.min(cross.entropy(project1, K = 4))) %>% as.data.frame()
K4.1$indv <- indvdat
K4.1$pop <- pops

newpoporder <- c(
  rep("10", 12), # Massachusetts
  rep("09", 12), # New Brunswick
  rep("12", 8), # North Carolina
  rep("11", 8), # Maryland
  rep("07", 20), # Cayuga
  rep("08", 9), # Seneca
  rep("02", 47), # Superior
  rep("04", 63), # Huron
  rep("03", 31), # Michigan
  rep("05", 30), # Erie
  rep("06", 38), # Ontario
  rep("01", 39) # Champlain
)

K4.1$poporder <- newpoporder
K4.1 <- K4.1[with(K4.1, order(newpoporder, -V3)),]
indv.sorted <- K4.1$indv
K4.1 <- K4.1[,c(1:4)] %>% as.matrix()
rownames(K4.1) <- indv.sorted

# create the admixture plot
K4.1 <- melt(K4.1); colnames(K4.1) <- c("Sample", "Ancestry", "Proportion")
pdf("K4sorted.pdf", width=20, height=2)
ggplot(data = K4.1, aes(x = Sample, y = Proportion, fill = Ancestry)) +
  geom_bar(position = 'fill', stat = 'identity') + scale_fill_manual(values = c("thistle2", "grey30", "darkseagreen", "skyblue3")) +
  theme_void() + theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust=1),legend.position="none")
dev.off()
