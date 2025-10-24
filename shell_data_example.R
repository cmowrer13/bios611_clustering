library(htmlwidgets)
library(tidyverse)
library(plotly)

source("generate_shell_data.R")

shell_data <- generate_shell_clusters(n_shells = 4, k_per_shell = 100, max_radius = 10, noise_sd = 0.1)

p <- plot_ly(shell_data, x = ~X1, y = ~X2, z = ~X3, color = ~factor(shell),
        colors = RColorBrewer::brewer.pal(4, "Set1"),
        type = "scatter3d", mode = "markers",
        marker = list(size = 3, opacity = 0.7)) %>%
  layout(scene = list(aspectmode = "data"))

saveWidget(p, "figures/shell_data_example.html")
