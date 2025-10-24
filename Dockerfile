FROM rocker/verse:latest

USER root

RUN Rscript -e "install.packages(c('cluster', 'htmlwidgets', 'plotly'), repos='https://cloud.r-project.org')"

WORKDIR /home/rstudio/work