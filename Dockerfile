# Use an appropriate base image with the necessary tools
FROM cuhkhaosun/base:latest

LABEL maintainer="Xing Zhao"

# Install necessary tools
RUN apt update && apt install -y unzip bowtie2 samtools

# Set the working directory
WORKDIR /root

# Download the latest Bismark release
RUN wget -O bismark_latest.tar.gz $(curl -s https://api.github.com/repos/FelixKrueger/Bismark/releases/latest | grep "tarball_url" | cut -d '"' -f 4)

# Uncompress the tar.gz file
RUN mkdir -p /root/bismark && \
    tar -xzf bismark_latest.tar.gz --strip-components=1 -C /root/bismark

# Clean up the tarball to save space
RUN rm /root/bismark_latest.tar.gz

# Add Bismark to the PATH
ENV PATH="/root/bismark:$PATH"


# Download the set.thread.num.sh script
RUN curl -o /root/set.thread.num.sh https://raw.githubusercontent.com/cuhk-haosun/code-docker-script-lib/main/set.thread.num.sh && \
    chmod +x /root/set.thread.num.sh

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
#ENTRYPOINT ["/entrypoint.sh"]
