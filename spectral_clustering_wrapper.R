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
    
    deg <- rowSums(A)
    inv_sqrt_deg <- ifelse(deg > 0, 1/sqrt(deg), 0)
    D_inv_sqrt <- diag(inv_sqrt_deg, n, n)
    
    L_sym <- diag(n) - (D_inv_sqrt %*% A %*% D_inv_sqrt)
    
    eig <- eigen(L_sym, symmetric = T)
    vals <- eig$values
    vecs <- eig$vectors
    
    ord <- order(vals, decreasing = FALSE)
    
    k_use <- min(k, n)
    Uk <- vecs[, ord[1:k_use], drop = FALSE]
    
    row_norms <- sqrt(rowSums(Uk^2))
    row_norms_adj <- ifelse(row_norms == 0, 1, row_norms)
    U_norm <- sweep(Uk, 1, row_norms_adj, FUN = "/")
    
    km <- kmeans(U_norm, centers = k, nstart = nstart, iter.max = iter.max)
    
    list(cluster = km$cluster)
  }
}
