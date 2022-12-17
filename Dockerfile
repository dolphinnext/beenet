FROM ubuntu:22.04
LABEL author="alper.kucukural@umassmed.edu"  description="Docker image containing all requirements for the dolphinnext/honeycomb pipeline"

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git
RUN apt install -y python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python && python --version   
RUN wget --cipher 'DEFAULT:!DH' https://bioinfo.umassmed.edu/pub/beenet 
RUN wget --cipher 'DEFAULT:!DH' https://bioinfo.umassmed.edu/pub/STAR
RUN chmod 755 beenet && mv beenet /usr/bin/. 
## STAR 2.7.1a
RUN chmod 755 STAR && mv STAR /usr/bin/. 
