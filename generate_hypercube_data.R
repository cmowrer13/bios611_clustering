generate_hypercube_clusters <- function(n, k, side_length, noise_sd = 1.0) {
  
  if (n <= 0 | k <= 0) stop("n and k must be positive integers.")
  if (side_length <= 0) stop("side_length must be positive.")
  if (noise_sd < 0) stop("noise_sd must be non-negative.")
  
  centers <- diag(side_length, n, n)
  
  data_list <- vector("list", n)
  
  for (i in seq_len(n)){
    cluster_points <- matrix(rnorm(k * n, mean = 0, sd = noise_sd),
                             nrow = k, ncol = n)
    cluster_points <- sweep(cluster_points, 2, centers[i, ], "+")
    
    data_list[[i]] <- data.frame(cluster_points, cluster = i)
  }
  
  data <- do.call(rbind, data_list)
  rownames(data) <- NULL
  return(data)
}
