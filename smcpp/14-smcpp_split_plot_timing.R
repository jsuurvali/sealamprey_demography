# plot the split timing estimates from smcpp 

library(ggplot2)
library(ggbeeswarm)
library(ungeviz)
library(gridExtra)


# the input file ("splits.tsv") should contain one row for each population split estimate
# columns for splits.tsv:
# (1) mutation rate, (2) population, (3) chromosome (or "all"), (4) time estimate



poporder <- c(
  "superior", "michigan", "huron", "erie",
  "ontario", "cayuga", "seneca", "champlain"
)

df <- read.csv("splits.tsv", sep = "\t", header = FALSE)
colnames(df) <- c("mut", "pop", "chr", "x")

df$pop <- factor(df$pop, levels = poporder)
df$years <- df$x * 6

make_split_plot <- function(mut_df) {
  allsplit <- mut_df[mut_df$chr == "all", ]
  plotdf <- mut_df[mut_df$chr != "all", ]
  
  ggplot(plotdf, aes(y = years, x = pop)) +
    geom_violin(fill = "gray95") +
    geom_beeswarm(size = 1, alpha = 0.5, color = "gray40") +
    geom_hpline(data = allsplit, color = "black") +
    ylim(0, NA) +
    labs(
      title = paste("Mutation rate", unique(mut_df$mut)),
      x = "Lake",
      y = "Years ago"
    ) +
    theme_bw() +
    coord_flip()
}

make_split_plot_median <- function(mut_df) {
  plotdf <- mut_df[mut_df$chr != "all", ]
  median_df <- aggregate(years ~ pop, data = plotdf, FUN = median)
  
  ggplot(plotdf, aes(y = years, x = pop)) +
    geom_violin(fill = "gray95") +
    geom_beeswarm(size = 1, alpha = 0.5, color = "gray40") +
    geom_hpline(
      data = median_df,
      aes(y = years, x = pop),
      color = "black"
    ) +
    ylim(0, NA) +
    labs(
      title = paste("Mutation rate", unique(mut_df$mut)),
      x = "Lake",
      y = "Years ago"
    ) +
    theme_bw() +
    coord_flip()
}

make_split_plot_mean <- function(mut_df) {
  plotdf <- mut_df[mut_df$chr != "all", ]
  mean_df <- aggregate(years ~ pop, data = plotdf, FUN = mean)

  ggplot(plotdf, aes(y = years, x = pop)) +
    geom_violin(fill = "gray95") +
    geom_beeswarm(size = 1, alpha = 0.5, color = "gray40") +
    geom_hpline(
      data = mean_df,
      aes(y = years, x = pop),
      color = "black"
    ) +
    ylim(0, NA) +
    labs(
      title = paste("Mutation rate", unique(mut_df$mut)),
      x = "Lake",
      y = "Years ago"
    ) +
    theme_bw() +
    coord_flip()
}

make_split_plot_ci <- function(mut_df) {
  plotdf <- mut_df[mut_df$chr != "all", ]
  
  ci_df <- aggregate(years ~ pop, data = plotdf, function(z) {
    c(
      median = median(z),
      lower = quantile(z, 0.025),
      upper = quantile(z, 0.975)
    )
  })
  
  ci_df <- do.call(data.frame, ci_df)
  colnames(ci_df) <- c("pop", "median", "lower", "upper")
  
  ggplot(plotdf, aes(y = years, x = pop)) +
    geom_violin(fill = "gray95") +
    geom_beeswarm(size = 1, alpha = 0.5, color = "gray40") +
    
    geom_errorbar(
      data = ci_df,
      aes(x = pop, ymin = lower, ymax = upper),
      width = 0.2,
      color = "black",
      inherit.aes = FALSE
    ) +
    
    geom_point(
      data = ci_df,
      aes(x = pop, y = median),
      size = 2,
      color = "black",
      inherit.aes = FALSE
    ) +
    
    ylim(0, NA) +
    labs(
      title = paste("Mutation rate", unique(mut_df$mut)),
      x = "Lake",
      y = "Years ago"
    ) +
    theme_bw() +
    coord_flip()
}

plots <- lapply(split(df, df$mut), make_split_plot)
plots_with_median <- lapply(split(df, df$mut), make_split_plot_median)
plots_with_mean <- lapply(split(df, df$mut), make_split_plot_mean)
plots_with_ci <- lapply(split(df, df$mut), make_split_plot_ci)

pdf("splits.pdf", height = 10, width = 10)
grid.arrange(grobs = plots, ncol = 3)
dev.off()

pdf("splits_with_median.pdf", height = 10, width = 10)
grid.arrange(grobs = plots_with_median, ncol = 3)
dev.off()

pdf("splits_with_mean.pdf", height = 10, width = 10)
grid.arrange(grobs = plots_with_mean, ncol = 3)
dev.off()

pdf("splits_with_ci.pdf", height = 10, width = 10)
grid.arrange(grobs = plots_with_ci, ncol = 3)
dev.off()
