FROM debian:latest

EXPOSE 22

WORKDIR /root

RUN apt update && apt upgrade -y

# small sized programs
RUN apt install -y nano mc fail2ban openssh-server \
 curl wget git sshfs apt-utils 

# Programming tools 
RUN apt install -y python3 python3-pip build-essential zip samtools \
 bedtools perl

# Bismark depencences:Bowtie2
RUN apt install -y bowtie2

# Bismark
RUN wget https://github.com/FelixKrueger/Bismark/archive/refs/tags/v0.24.2.tar.gz -O Bismark-0.24.2.tar.gz \
    && tar xzf Bismark-0.24.2.tar.gz \
    && echo 'export PATH="'$(readlink -f Bismark-0.24.2)':$PATH"' >> ~/.bashrc \
    && /bin/bash -c "source ~/.bashrc" \