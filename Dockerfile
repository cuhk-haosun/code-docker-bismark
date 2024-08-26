# 指定基础镜像
FROM debian:latest

# 容器运行时监听22号端口
EXPOSE 22

# 后续指令的工作目录
WORKDIR /root

# apt update:更新包缓存（可以知道包的哪些版本可以被安装或升级）
# apt upgrade:升级包到最新版本,-y确认
RUN apt update && apt upgrade -y

# small sized programs
RUN apt install -y nano mc fail2ban openssh-server \
 curl wget git sshfs apt-utils 

# Programming tools 
RUN apt install -y python3 python3-pip build-essential zip samtools \
 bedtools perl r-base

# Bismark depencences:Bowtie2
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.5.4/bowtie2-2.5.4-sra-linux-x86_64.zip/download -O bowtie2-2.5.4-sra-linux-x86_64.zip \
    && unzip bowtie2-2.5.4-sra-linux-x86_64.zip \
    && echo 'export PATH=/root/bowtie2-2.5.4-sra-linux-x86_64/:$PATH' >> ~/.bashrc \
    && /bin/bash -c "source ~/.bashrc"

# Bismark
RUN wget https://github.com/FelixKrueger/Bismark/archive/refs/tags/v0.24.2.tar.gz -O Bismark-0.24.2.tar.gz \
    && tar xzf Bismark-0.24.2.tar.gz \
    && echo 'export PATH="'$(readlink -f Bismark-0.24.2)':$PATH"' >> ~/.bashrc \
    && /bin/bash -c "source ~/.bashrc"