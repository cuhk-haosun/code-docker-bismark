#!/bin/bash

# Directory paths
INPUT_DIR="/mnt/in"
OUTPUT_DIR="/mnt/out"
REF_DIR="/mnt/ref"

# Source the script to set THREAD_NUM
echo -e "\e[0;34mInfo: Running set.thread.num.sh to set THREAD_NUM...\e[0m"
source /root/set.thread.num.sh

# manual override
THREAD_NUM=16

echo -e "\e[0;34mInfo: List the INPUT_DIR ...\e[0m"
ls $INPUT_DIR


# Find all .R1.fastq.gz files in the input directory
for file1 in "$INPUT_DIR"/*.R1.fastq.gz; do

  # Find the corresponding .R2.fastq.gz file by replacing .R1. with .R2.
  file2="${file1/R1/R2}"

  # Check if both paired files exist
  if [ -f "$file1" ] && [ -f "$file2" ]; then
    echo -e "\e[0;34mInfo: Processing paired files: $file1 and $file2\e[0m"
    
    # Run the bismark command with paired files
    bismark -p $THREAD_NUM $REF_DIR -1 "$file1" -2 "$file2" -o "$OUTPUT_DIR"
    
    echo -e "\e[0;34mInfo: Finished processing: $file1 and $file2\e[0m"
  else
    echo -e "\e[0;31mError: Paired file for $file1 not found\e[0m"
  fi
done

# Loop over each BAM file in the OUTPUT_DIR
for bamfile in "$OUTPUT_DIR"/*.bam; do
    # Skip if no BAM files are found
    if [ ! -e "$bamfile" ]; then
        echo -e "\e[0;31mError: No BAM files found in $OUTPUT_DIR.\e[0m"
        break
    fi
    
    # Define the output sorted BAM file name
    sorted_bam="${bamfile%.bam}.sorted.bam"
    
    echo -e "\e[0;34mInfo: Processing $bamfile...\e[0m"
    
    # Sort the BAM file using samtools and store the output in the sorted BAM file
    if samtools sort -@ "$THREAD_NUM" -o "$sorted_bam" "$bamfile"; then
        echo -e "\e[0;34mInfo: Sorting completed: $sorted_bam\e[0m"
        
        # Index the sorted BAM file
        if samtools index "$sorted_bam"; then
            echo -e "\e[0;34mInfo: Indexing completed: ${sorted_bam}.bai\e[0m"
        else
            echo -e "\e[0;31mError: Indexing failed for $sorted_bam\e[0m"
        fi
    else
        echo -e "\e[0;31mError: Sorting failed for $bamfile\e[0m"
    fi
    
done
