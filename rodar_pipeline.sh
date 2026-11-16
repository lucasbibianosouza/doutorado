#!/bin/bash

THREADS=8
KAIJU_BIN="$HOME/treino/installkaiju/kaiju/bin"

while IFS= read -r SRR || [ -n "$SRR" ]; do
    [ -z "$SRR" ] && continue

    if [ -f "resultados/krona/${SRR}.krona" ]; then
        echo ">>> [PULANDO] $SRR já foi processada."
        continue
    fi

    echo ">>> Processando amostra: $SRR"
    if bash scripts/01_qualidade_trim.sh "$SRR" "$THREADS"; then
        # FUTURO: bash scripts/02_dehosting.sh "$SRR" "$THREADS"
        bash scripts/03_taxonomia_kaiju.sh "$SRR" "$THREADS"
    else
        echo "!!! Erro na amostra $SRR, pulando para a próxima..."
    fi
done < amostras.txt

ktImportText -o resultados/krona_geral.html resultados/krona/*.krona
"$KAIJU_BIN/kaiju2table" -t "$KAIJU_BIN/nodes.dmp" -n "$KAIJU_BIN/names.dmp" -r species \
    -o resultados/tabela_especies.tsv resultados/kaiju/*.kaiju.out