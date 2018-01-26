library(xtable)

unit.name <- c("mm","mz","vv","vx")
unit.dir <- c("marine_vs_marine","marine_vs_zerg","vulture_vs_vulture","vulture_vs_xealot")
method <- c("vanilla","unified","cascade","novelty") 

df <- data.frame(matrix(ncol = 4, nrow = 0))
x <- c("win","survivors","method","unit")
colnames(df) <- x

# Generate a bit data frame with all the results from "stats_best_units
for (unit in 1:4) {
  for (m in method) {
    dirname <- paste(unit.dir[unit], m, "NEAT", sep = "_")
    for (i in 1:3) {
      f <- read.csv(paste("data",dirname, paste0(i,"_stats_best_units.csv"), sep = "/"), sep = ";")
      f <- cbind(f, method = m, unit = unit.name[unit])
      df <- rbind(df,f)
    }
  }
}

victories <- df[df$win == 1,]

Overall.Win.Ratio <- nrow(victories)/nrow(df)
# Overall win ration for 2400 games: 0.65625

agg.winratio <- aggregate(win~method*unit, FUN = function(x) {sum(x)/length(x)}, data = df)
agg.survival <- aggregate(survivors~method*unit, FUN = median, data = victories)

table.quantitative <- xtable(data.frame(agg.winratio$method, agg.winratio$unit, agg.winratio$win, agg.survival$survivors))

# Survival Analysis: MZ vanilla and cascade seem to have lower survival rates
#boxplot(survivors~method, data = victories)
#boxplot(survivors~unit, data = victories)
#boxplot(survivors~unit*method, data = victories)
# Box plot for suvirvorship


#boxplot(survivors~method*unit, data = victories)

library(ggplot2)
library(forcats)
# Basic box plot
#bp <- ggplot(victories, aes(x=survivors, y=method))+
#  geom_boxplot()
# Horizontal box plot
#bp + coord_flip()
#bp


bdf <- data.frame(f1=victories$method, 
                 f2=victories$unit,
                 survivors=victories$survivors)

bdf$f1f2 <- interaction(bdf$f1, bdf$f2)
labs <- c("Novelty vulture/zealot","Cascade vulture/zealot", "Unified vulture/zealot", "Vanilla vulture/zealot",
          "Novelty vulture/vulture", "Cascade vulture/vulture", "Unified vulture/vulture", "Vanilla vulture/vulture",
          "Novelty marine/zergling", "Cascade marine/zergling", "Unified marine/zergling", "Vanilla marine/zergling",
          "Novelty marine/marine", "Cascade marine/marine", "Unified marine/marine", "Vanilla marine/marine")

boxp <- ggplot(aes(y = survivors, x = fct_rev(f1f2)), data = bdf) + geom_boxplot() + coord_flip() + xlab(NULL) + scale_x_discrete(labels=labs)
boxp
ggsave("boxplot.png", width=8, height = 10, units="cm")



