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


RUN apt install -y python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python && python --version   
RUN wget --cipher 'DEFAULT:!DH' https://bioinfo.umassmed.edu/pub/beenet 
#RUN wget --cipher 'DEFAULT:!DH' https://bioinfo.umassmed.edu/pub/STAR
## beenet bug: it has STAR 2.7.3a but expects 2.7.1a
RUN chmod 755 beenet && mv beenet /usr/bin/. 
## STAR 2.7.1a
#RUN chmod 755 STAR && mv STAR /usr/bin/. 

RUN conda update -n base -c defaults conda
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
RUN mkdir -p /project /nl /mnt /share
ENV PATH /opt/conda/envs/dolphinnext/bin:$PATH

RUN pip install wheel
RUN pip install pandas
