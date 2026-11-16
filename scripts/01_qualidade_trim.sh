#!/bin/bash
set -e

SRR=$1
THREADS=$2

mkdir -p resultados/fastqc_bruto resultados/fastqc_limpo dados_trimados

fasterq-dump --split-files -e "$THREADS" "$SRR"
fastqc -t "$THREADS" --nogroup -o resultados/fastqc_bruto "${SRR}_1.fastq" "${SRR}_2.fastq"

trimmomatic PE -phred33 -threads "$THREADS" \
    "${SRR}_1.fastq" "${SRR}_2.fastq" \
    "dados_trimados/${SRR}_PE_1.fq" "dados_trimados/${SRR}_SR_1.fq" \
    "dados_trimados/${SRR}_PE_2.fq" "dados_trimados/${SRR}_SR_2.fq" \
    LEADING:20 TRAILING:20 SLIDINGWINDOW:4:25 MINLEN:36

fastqc -t "$THREADS" --nogroup -o resultados/fastqc_limpo "dados_trimados/${SRR}_PE_1.fq" "dados_trimados/${SRR}_PE_2.fq"

rm -f "${SRR}_1.fastq" "${SRR}_2.fastq" "dados_trimados/${SRR}_SR_1.fq" "dados_trimados/${SRR}_SR_2.fq"