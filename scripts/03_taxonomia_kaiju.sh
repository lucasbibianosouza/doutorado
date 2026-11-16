#!/bin/bash
set -e

SRR=$1
THREADS=$2
KAIJU_BIN="$HOME/treino/installkaiju/kaiju/bin"

mkdir -p resultados/kaiju resultados/krona

"$KAIJU_BIN/kaiju" -z "$THREADS" \
    -t "$KAIJU_BIN/nodes.dmp" \
    -f "$KAIJU_BIN/viruses/kaiju_db_viruses.fmi" \
    -i "dados_trimados/${SRR}_PE_1.fq" -j "dados_trimados/${SRR}_PE_2.fq" \
    -o "resultados/kaiju/${SRR}.kaiju.out"

"$KAIJU_BIN/kaiju2krona" \
    -t "$KAIJU_BIN/nodes.dmp" -n "$KAIJU_BIN/names.dmp" \
    -i "resultados/kaiju/${SRR}.kaiju.out" \
    -o "resultados/krona/${SRR}.krona"

rm -f "dados_trimados/${SRR}_PE_1.fq" "dados_trimados/${SRR}_PE_2.fq"