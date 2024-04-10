FROM mambaorg/micromamba:1.5.6
ADD ../environment.yml .
RUN micromamba install -y -n base -f environment.yml && \
micromamba clean --all --yes
USER root
RUN mkdir /opt/pipeline
ENV PATH="/opt/pipeline:$PATH"
ADD ../my_first_notebook.sh /opt/pipeline/
ADD ../Deseq2.r /opt/pipeline
RUN chmod +x /opt/pipeline/my_first_notebook.sh
USER $MAMBA_USER
Add the environment.yml file
Add the /opt/pipeline folder to the image $PATH
Add the pipeline script to the /opt/pipeline folder
