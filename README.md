[bird_diet_metabarcoding-README.md](https://github.com/user-attachments/files/33134786/bird_diet_metabarcoding-README.md)
# Songbird diet metabarcoding with MinION nanopore sequencing

**Undergraduate thesis code, Purchase College, SUNY, 2019.**

Diet analysis of songbird fecal samples from Acadia National Park, Maine, by COI metabarcoding on the Oxford Nanopore MinION. Prey identifications were linked to mercury measurements to trace trophic transfer of mercury through the songbird food web. The work was presented as a keynote at the Purchase College School of Natural and Social Sciences Symposium and as a poster at the Northeast Natural History Conference, 2019.

> **Archived.** This repository is kept as a record of the original analysis and is not maintained. Scripts use the absolute paths and tool versions of the machine they were run on in 2019 and will not run unmodified. For current, reproducible work see [cdv-phylodynamics](https://github.com/batyanight/cdv-phylodynamics) and [wildphylo](https://github.com/batyanight/wildphylo).

## Approach

- **Marker:** mitochondrial COI, amplified with the mlCOIintF / jgHCO2198 primer pair (Leray et al. 2013).
- **Sequencing:** multiplexed barcoded libraries on MinION R9.4 flow cells, five runs.
- **Read processing:** Guppy basecalling and demultiplexing → Porechop adapter and barcode removal → NanoFilt quality filtering → minimap2 all-vs-all mapping + Racon read correction.
- **Taxonomic assignment:** BLASTn against a local COI reference database, with MEGAN for taxonomic summaries; hits retained at ≥ 97% pairwise identity.
- **Integration:** prey taxa per sample merged with mercury data in R.

## Files

| File | Contents |
|---|---|
| `informatics_pipeline_one.sh` | Basecalling through BLAST, per flow cell and barcode |
| `seq_taxa.R` | Joins BLAST hits to taxonomy and mercury data, filters to ≥ 97% identity |
| `blast_taxa_forHarris.R` | Per-sample taxon lists from Racon-corrected BLAST output |
| `ACADIA_bioinfo_notebook_BRN.txt` | Bioinformatics notebook: methods, commands and decisions |
| `BRN_lab_notebook060719.txt` | Wet-lab notebook for extraction, amplification and library prep |

## Reference

Leray M, Yang JY, Meyer CP, et al. A new versatile primer set targeting a short fragment of the mitochondrial COI region for metabarcoding metazoan diversity: application for characterizing coral reef fish gut contents. *Frontiers in Zoology* 10, 34 (2013). [doi:10.1186/1742-9994-10-34](https://doi.org/10.1186/1742-9994-10-34)

## Author

Batya R. Nightingale · [batyanight.github.io](https://batyanight.github.io) · [ORCID 0000-0002-0706-8951](https://orcid.org/0000-0002-0706-8951)
