if (!dir.exists("./data")) {
  stop("not in the right directory.")
}

library(gridExtra)
source("functions.R")

dir.create("./results", showWarnings = FALSE)

all_summary <- data.frame()
for (dir in list.dirs(path = "./data", full.names = FALSE, recursive = FALSE)) {
  dir.create(paste("./results/", dir, sep = ""), showWarnings = FALSE)
  results <- process_folder(dir)
  all_summary <- rbind(all_summary, stringsAsFactors = FALSE, c(exp.name = dir, round(results[which.max(results$win.ratio),], 2)))
}

png("./results/summary.png", width = 780, height = 380)
grid.table(all_summary)
dev.off()
