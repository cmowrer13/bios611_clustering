library(tidyverse)

sim_results <- read_csv("generated_data/shell_sim_results.csv")

p <- ggplot(sim_results, aes(x = max_radius, y = est_k)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_hline(aes(yintercept = 4), linetype = "dashed", color = "black") +
  scale_x_reverse(breaks = seq(10, 1, by = -1)) +
  scale_y_continuous(breaks = seq(0, 4, 1)) + 
  labs(title = "Cluster detectibility vs max shell radius",
       subtitle = "Estimated number of clusters from Gap Statistic (Spectral Clustering)",
       x = "Max shell radius (cluster separation)",
       y = "Estimated number of clusters")

ggsave("figures/cluster_detectability_spec.png", p,
       width = 8, height = 6)
