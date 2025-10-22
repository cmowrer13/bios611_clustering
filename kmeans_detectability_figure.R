library(tidyverse)

sim_results <- read_csv("generated_data/sim_results.csv")

p <- ggplot(sim_results, aes(x = side_length, y = est_k, color = factor(n))) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_hline(aes(yintercept = n), linetype = "dashed", color = "black") +
  scale_x_reverse(breaks = seq(10, 1, by = -1)) +
  scale_y_continuous(breaks = seq(0, max(sim_results$est_k) + 1, 1)) + 
  labs(title = "Cluster detectibility vs separation distance",
       subtitle = "Estimated number of clusters from Gap Statistic (k-means)",
       x = "Side length (cluster separation)",
       y = "Estimated number of clusters",
       color = "Dimension (n)")

ggsave("figures/cluster_detectability_kmeans.png", p,
       width = 8, height = 6)
