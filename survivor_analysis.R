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

# Survival Analysis: MZ vanilla and cascade seem to have lower survival rates
agg.survival <- aggregate(survivors~unit*method, FUN = median, data = victories)
#boxplot(survivors~method, data = victories)
#boxplot(survivors~unit, data = victories)
#boxplot(survivors~unit*method, data = victories)
# Box plot for suvirvorship



