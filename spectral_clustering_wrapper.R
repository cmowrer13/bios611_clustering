spectral_clustering_fun <- function(d_threshold, nstart = 20, iter.max = 50) {
  
  function(x, k) {
    
    if (!is.matrix(x)) x <- as.matrix(x)
    n <- nrow(x)
    if (n == 0) stop("Empty data")
    if (k < 1) stop("k must be greater than or equal to 1")
    
    dmat <- as.matrix(dist(x, method = "euclidean", upper = TRUE, diag = TRUE))
    
    A <- matrix(0, n, n)
    A[dmat < d_threshold] <- 1
    diag(A) <- 0L
    A <- pmax(A, t(A))
    
    degs <- rowSums(A)
    D <- diag(degs)
    
    inv_sqrt_deg <- rep(0, n)
    nonzero <- degs > 0
    inv_sqrt_deg[nonzero] <- 1 / sqrt(degs[nonzero])
    S <- diag(inv_sqrt_deg) 
    L_sym <- diag(n) - S %*% A %*% S
    
    L_sym <- (L_sym + t(L_sym)) / 2
    
    eig <- eigen(L_sym, symmetric = T)
    vals <- eig$values
    vecs <- eig$vectors
    
    idx <- order(vals)[1:k]
    U <- vecs[, idx, drop = FALSE]
    
    row_norms <- sqrt(rowSums(U^2))
    row_norms[row_norms == 0] <- 1
    U <- U / row_norms
    
    km <- kmeans(U, centers = k, nstart = nstart, iter.max = iter.max)
    
    list(cluster = km$cluster)
  }
}