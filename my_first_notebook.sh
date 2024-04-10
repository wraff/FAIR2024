#!/usr/bin/env bash

zenodo_get -t 60 -R 3 10.5281/zenodo.3997237

md5sum -c md5sums.txt

tar -xzf FAIR_Bioinfo_data.tar.gz && rm FAIR_Bioinfo_data.tar.gz

mkdir -p hisat2_indexes
hisat2-build Data/O.tauri_genome.fna hisat2_indexes/Otauri

mkdir -p quality
fastqc -o quality Data/*

message("hello world")

mkdir -p hisat2
for fq in Data/*.fastq.gz ; do
    echo ${fq} 
    libname=$(basename $fq .fastq.gz)
    hisat2 -x hisat2_indexes/Otauri -q -U ${fq} -S hisat2/${libname}.sam
    samtools view -b -o hisat2/${libname}.bam hisat2/${libname}.sam
    samtools sort -o hisat2/${libname}-sort.bam hisat2/${libname}.bam
    samtools index hisat2/${libname}-sort.bam
done

pwd

htseq-count -f bam -r pos -s no -t gene -i ID -m intersection-nonempty hisat2/*-sort.bam Data/O.tauri_annotation.gff > counts.txt

head counts.txt

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
R < $SCRIPT_DIR/Deseq2.r --no-save
