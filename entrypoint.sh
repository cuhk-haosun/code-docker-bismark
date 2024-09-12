#!/bin/bash

# Directory paths
INPUT_DIR="/mnt/in"
OUTPUT_DIR="/mnt/out"
REF_DIR="/mnt/ref"

# Find all .R1.fastq.gz files in the input directory
for file1 in "$INPUT_DIR"/*.R1.fastq.gz; do

  # Find the corresponding .R2.fastq.gz file by replacing .R1. with .R2.
  file2="${file1/R1/R2}"

  # Check if both paired files exist
  if [ -f "$file1" ] && [ -f "$file2" ]; then
    echo "Processing paired files: $file1 and $file2"
    
    # Run the bismark command with paired files
    /root/bismark -1 "$file1" -2 "$file2" -o "$OUTPUT_DIR"
    
    echo "Finished processing: $file1 and $file2"
  else
    echo "Paired file for $file1 not found"
  fi
done
