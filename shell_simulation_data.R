library(cluster)

source("spectral_clustering_wrapper.R")

shell_simulation <- function(max_radii = seq(10, 1, by = -1), 
                             n_shells = 4,
                             k_per_shell = 100,
                             noise_sd = 0.1,
                             d_threshold = 1,
                             nstart = 20,
                             iter.max = 50,
                             B = 20){
  
  results <- list()
  
  spec_fun <- spectral_clustering_fun(d_threshold = d_threshold,
                                      nstart = nstart,
                                      iter.max = iter.max)
  
  for (r in max_radii) {
    message("Running for max_radius = ", r)
    set.seed(13)
    
    dat <- generate_shell_clusters(n_shells = n_shells,
                                   k_per_shell = k_per_shell,
                                   max_radius = r,
                                   noise_sd = noise_sd)
    
    dat_mat <- as.matrix(dat[, c("X1", "X2", "X3")])
    
    gap <- tryCatch({
      clusGap(dat_mat,
              FUN = spec_fun,
              K.max = n_shells + 3,
              B = B,
              verbose = FALSE)
    }, error = function(e) {
      message("clusGap failed for max_radius = ", r, ": ", e$message)
      return(NULL)
    })
    
    if (is.null(gap) || is.atomic(gap)) {
      message("gap object invalid or atomic at max_radius = ", r)
      if (!is.null(gap)) print(str(gap))
      best_k <- NA
    } else if (is.null(gap$Tab)) {
      message("gap object missing Tab at max_radius = ", r)
      print(str(gap))
      best_k <- NA
    } else {
      best_k <- maxSE(
        gap$Tab[, "gap"],
        gap$Tab[, "SE.sim"],
        method = "Tibs2001SEmax"
      )
    }
    
    results[[length(results) + 1]] <- data.frame(
      max_radius = r,
      est_k = best_k)
  }
  
  results_df <- do.call(rbind, results)
  return(results_df)
}

shell_results <- shell_simulation()
