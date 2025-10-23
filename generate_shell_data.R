generate_shell_clusters <- function(n_shells, k_per_shell, max_radius, noise_sd = 0.1){
  
  if (n_shells <1 | k_per_shell <1) stop("n)shells and k_per_shell must be positive integers")
  if (max_radius <= 0) stop("max_radius must be positive")
  if (noise_sd < 0) stop("noise_sd must be non-negative")
  
  radii <- seq(max_radius / n_shells, max_radius, length.out = n_shells)
  
  data_list <- vector("list", n_shells)
  
  for (i in seq_len(n_shells)){
    r <- radii[i]
    
    theta <- runif(k_per_shell, 0, 2*pi)
    phi <- acos(runif(k_per_shell, -1, 1))
    
    r_noise <- r + rnorm(k_per_shell, mean = 0, sd = noise_sd)
    
    x <- r_noise * sin(phi) * cos(theta)
    y <- r_noise * sin(phi) * sin(theta)
    z <- r_noise * cos(phi)
    
    data_list[[i]] <- data.frame(X1 = x, X2 = y, X3 = z, shell = i)
  }
  
  data <- do.call(rbind, data_list)
  rownames(data) <- NULL
  return(data)
}
