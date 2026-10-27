# plot results from GONE for sea lamprey history

library(tidyverse)
library(patchwork)

df <- read.table("gone_results.tsv", header = FALSE, sep = "\t")
colnames(df) <- c("pop", "run_no", "gens", "popsize")
df$gens <- 6* df$gens
df <- df[df$gens <= 1000,]

poplist <- c("champlain",
             "seneca",
             "cayuga",
             "ontario",
             "erie",
             "huron",
             "michigan",
             "superior")

results <- list()
for (i in poplist){results[[i]] <- df[df$pop == i,]}

plot.champlain <- ggplot(results$champlain, aes(x = gens, y = popsize, group = run_no)) +
  geom_line(color="skyblue3") + theme_bw() + ylim(0,4000) + ggtitle("Lake Champlain") + xlab("Years before 2021") + ylab("Ne")
 
plot.fingerlakes <- ggplot(results$seneca, aes(x = gens, y = popsize, group = run_no)) +
  geom_line(color="#673147") +
  geom_line(data = results$cayuga, color = "#F88379") + theme_bw() + ylim(0,4000) +
  theme(legend.position = "none") + ggtitle("Finger Lakes") + xlab("Years before 2019") + ylab("Ne")

plot.greatlakes <- ggplot(results$erie, aes(x = gens, y = popsize, group = run_no)) +
  geom_line(data = results$erie, color="#AFE1AF") +
  geom_line(data = results$huron, color = "#50C878") +
  geom_line(data = results$superior, color = "#008000") +
  geom_line(data = results$michigan, color = "#2AAA8A") +
  geom_line(data = results$ontario, color = "orange") +
  theme_bw() + theme(legend.position = "none") + ylim(0,4000) +
  ggtitle("Great Lakes") + xlab("Years before 2019") + ylab("Ne")


pdf("gone_finalplot.pdf", height = 4, width = 11)
plot.greatlakes + plot.champlain + plot.fingerlakes + plot_layout(nrow = 1)
dev.off()
