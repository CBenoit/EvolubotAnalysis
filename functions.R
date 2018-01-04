library(readr)
library(gridExtra)

# generate fitness plot and return the best ever fitness.
process_evolving_data <- function(exp_name, filepath) {
  data <- read_delim(filepath, ";")
  
  graph_y_range = range(0, data$bestever)
  
  plot(data$average, type = "o", pch = 21, col = "blue", ylim = graph_y_range, ann = FALSE)
  lines(data$best, type = "o", pch = 22, col ="green")
  lines(data$bestever, type = "o", pch = NA, lty = 2, col = "red")
  
  title(main = paste(exp_name, basename(filepath), length(data$win), "generations"), col.main="black", font.main=3)
  title(xlab="Generation", col.lab=rgb(0,0.5,0))
  title(ylab="Fitness", col.lab=rgb(0,0.5,0))
  
  legend(x = 0, y = graph_y_range[2],
         legend = c("average", "best", "best ever"), col = c("blue", "green", "red"),
         pch = c(21, 22, NA), lty = c(1, 1, 2))
  
  return(max(data$bestever))
}

# calculate interesting properties and generate histogram
process_best_units_data <- function(exp_name, filepath) {
  data <- read_delim(filepath, ";")
  
  stats <- data.frame(win.ratio = mean(data$win),
                      average = mean(data$survivors),
                      std.dev = sd(data$survivors),
                      min = min(data$survivors),
                      first.qua = quantile(data$survivors, 0.25),
                      median = median(data$survivors),
                      third.qua = quantile(data$survivors, 0.75),
                      max = max(data$survivors))
  
  brk <- c(0, 4, 8, 12, 16, 20)
  hist(data$survivors, ylim = c(0, length(data$win)), xlim = c(0, 22),
       col = heat.colors(length(brk)), breaks = brk, ann = FALSE,
       axes = FALSE)
  
  axis(side = 1, at = seq(0, 20, by = 4), las = 1)
  axis(side = 2, at = seq(0, 50, by = 2), las = 1)
  box()
  
  text(14, 50, paste("Win ratio:", round(mean(data$win), 2)))
  text(14, 47, paste("average survivors:", round(mean(data$survivors), 2)))
  text(14, 44, paste("std dev survivors:", round(sd(data$survivors), 2)))
  
  title(main = paste(exp_name, basename(filepath), length(data$win), "runs"), col.main="black", font.main=3)
  title(xlab="Survivors", col.lab=rgb(0,0.5,0))
  title(ylab="Frequency", col.lab=rgb(0,0.5,0))
  
  return(stats)
}

process_folder <- function(exp_name) {
  results <- data.frame()
  
  for (i in 1:3) {
    image_filename <- paste("./results/", exp_name, "/", i, "_stats_evolving.png", sep = "")
    png(image_filename, width = 800, height = 480)
    best_fitness <- process_evolving_data(exp_name, paste("./data/", exp_name, "/", i, "_stats_evolving.csv", sep = ""))
    dev.off()
    
    image_filename <- paste("./results/", exp_name, "/", i, "_stats_best_units.png", sep = "")
    png(image_filename, width = 500, height = 480)
    stats <- process_best_units_data(exp_name, paste("./data/", exp_name, "/", i, "_stats_best_units.csv", sep = ""))
    dev.off()
    
    results <- rbind(results, c(best.fitness = best_fitness, stats))
  }
    
  image_filename <- paste("./results/", exp_name, "/", "summary.png", sep = "")
  png(image_filename, width = 535, height = 100)
  grid.table(round(results, 2))
  dev.off()
  
  return(results)
}
