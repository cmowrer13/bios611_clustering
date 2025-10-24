.PHONY: clean

clean:
	rm -rf generated_data/*
	rm -rf figures/*
	
all: figures/cluster_detectability_kmeans.png figures/shell_data_example.html figures/cluster_detectability_spec.png

figures/cluster_detectability_kmeans.png: generated_data/sim_results.csv
	Rscript kmeans_detectability_figure.R
	
generated_data/sim_results.csv: simulation_data.R generate_hypercube_data.R
	Rscript simulation_data.R
	
figures/shell_data_example.html: shell_data_example.R generate_shell_data.R
	Rscript shell_data_example.R
	
figures/cluster_detectability_spec.png: generated_data/shell_sim_results.csv
	Rscript spec_clustering_detectability_figure.R
	
generated_data/shell_sim_results.csv: shell_simulation_data.R generate_shell_data.R spectral_clustering_wrapper.R
	Rscript shell_simulation_data.R
	
figures:
	mkdir -p figures
	
generated_data:
	mkdir -p generated_data