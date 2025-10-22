library(cluster)
library(tidyverse)

source("generate_hypercube_data.R")

cluster_simulation <- function(n_values = 2:6,
                               side_lengths = seq(10, 1, by = -0.25),
                               k = 100,
                               noise_sd = 1.0,
                               nstart = 20,
                               iter.max = 50,
                               B = 20) {
  results <- list()
  
  for (n in n_values) {
    message("Running dimension n = ", n)
    for (side in side_lengths) {
      set.seed(13)
      
      dat <- generate_hypercube_clusters(n = n, k = k, side_length = side, noise_sd = noise_sd)
      dat_mat <- as.matrix(dat[, 1:n])
      
      gap <- clusGap(dat_mat,
                     FUN = function(x, k) kmeans(x, centers = k, nstart = nstart, iter.max = iter.max),
                     K.max = n + 3,
                     B = B)
      
      best_k <- maxSE(gap$Tab[, "gap"], gap$Tab[, "SE.sim"], method = "Tibs2001SEmax")
      
      results[[length(results) + 1]] <- data.frame(
        n = n,
        side_length = side,
        est_k = best_k)
    }
  }
  
  results_df <- do.call(rbind, results)
  return(results_df)
}

sim_results <- cluster_simulation()

write.csv(sim_results, "generated_data/sim_results.csv")
