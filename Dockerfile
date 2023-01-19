FROM ubuntu:22.04
LABEL author="alper.kucukural@umassmed.edu"  description="Docker image containing all requirements for the dolphinnext/honeycomb pipeline"

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Install dolphin-tools
RUN git clone https://github.com/dolphinnext/tools /usr/local/bin/dolphin-tools
ENV PATH /usr/local/bin/dolphin-tools/:$PATH


COPY environment.yml /
RUN . /opt/conda/etc/profile.d/conda.sh && \ 
    conda activate base && \
    conda update conda && \
    conda install -c conda-forge mamba && \
    mamba env create -f /environment.yml && \
    mamba install -c bioconda snpeff && \
    mamba clean -a

RUN mkdir -p /project /nl /mnt /share
ENV PATH /opt/conda/envs/dolphinnext/bin:$PATH

RUN wget --cipher 'DEFAULT:!DH' https://bioinfo.umassmed.edu/pub/beenet 
## beenet bug: it has STAR 2.7.3a but expects 2.7.1a
RUN chmod 755 beenet && mv beenet /usr/bin/. 

RUN apt-get update && apt-get install -y gcc unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN aws --version

RUN pip install wheel
RUN pip install pandas
