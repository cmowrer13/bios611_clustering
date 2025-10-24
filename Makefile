.PHONY: clean

all: report.html

clean:
	rm -rf generated_data/*
	rm -rf figures/*
	rm -f report.html
	
report.html: figures/cluster_detectability_kmeans.png figures/cluster_detectability_spec.png
	Rscript -e "rmarkdown::render('report.Rmd', output_file='report.html', output_format='html_document')"
	
figures/cluster_detectability_kmeans.png: generated_data/sim_results.csv
	Rscript kmeans_detectability_figure.R
	
figures/cluster_detectability_spec.png: generated_data/shell_sim_results.csv
	Rscript spec_clustering_detectability_figure.R
	
generated_data/sim_results.csv: simulation_data.R generate_hypercube_data.R
	Rscript simulation_data.R
	
generated_data/shell_sim_results.csv: shell_simulation_data.R generate_shell_data.R spectral_clustering_wrapper.R
	Rscript shell_simulation_data.R
	
figures/shell_data_example.html: shell_data_example.R generate_shell_data.R
	Rscript shell_data_example.R
	
figures:
	mkdir -p figures
	
generated_data:
	mkdir -p generated_data