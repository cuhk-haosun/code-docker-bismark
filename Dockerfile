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
RUN mkdir -p /root/Bismark \
    && wget $(curl -s https://api.github.com/repos/FelixKrueger/Bismark/releases/latest | grep "tarball_url" | cut -f4 -d '"') -O Bismark-latest.tar.gz

RUN tar -xzf Bismark-latest.tar.gz -C /root/Bismark --strip-components 1 \
    && rm -f /root/Bismark-latest.tar.gz \
    && echo 'export PATH="'$(readlink -f Bismark)':$PATH"' >> ~/.bashrc \
    && /bin/bash -c "source ~/.bashrc" 

