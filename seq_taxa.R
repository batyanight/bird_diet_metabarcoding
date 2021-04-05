#set wd to /Volumes/BRN_seagate/minion/acadiaR
accessions_taxa=read.delim("new_taxa_db.txt", header=FALSE, sep="\t")
names(accessions_taxa) <- c("accession", "taxa")
blast=read.delim("acadia_labeled_blasts", header=FALSE, sep = "\t")
names(blast) <- c("sample", "sequenceID", "accession", "pairwiseident", "length", "mismatch", "qstart", "qend", "sstart", "send", "qlen", "slen", "eval", "bitscore", "gaps", "qseq" )
mercury=read.csv("mercury.csv", header=TRUE, sep = ",")

blast_taxa=merge(blast, accessions_taxa, by.x="accession", by.y="accession", all.x=TRUE, all.y=FALSE)
blast_taxa_mercury=merge(blast_taxa, mercury, by.x="sample", by.y="sample", all.x=TRUE, all.y=FALSE)
blast_taxa_97=subset(blast_taxa, blast_taxa$pairwiseident >= 97)

blast_taxa_mercury_97=subset(blast_taxa_mercury, blast_taxa_mercury$pairwiseident >= 97)

sample1=subset(blast_taxa_mercury_97, blast_taxa_mercury_97$sample=="1")
sample1unique_taxa=unique(sample1$taxa)
print(sample1unique_taxa)

unique_taxa=tapply(blast_taxa_mercury_97, blast_taxa_mercury_97$sample, unique(blast_taxa_mercury_97$taxa))
write.table(blast_taxa_mercury_97, file = "R1_barcode01_racon2_unique_taxa", row.names = FALSE, col.names = TRUE, append = FALSE, quote = FALSE, sep = "\t")
write.csv(blast_taxa_mercury_97, file = "acadia_sequences.csv", row.names = FALSE, col.names = TRUE, append = FALSE, quote = FALSE, sep = ",")
write.csv(blast_taxa_97, file="acadia_blast.csv", row.names = FALSE, col.names = TRUE, append = FALSE, quote = FALSE, sep = ",")
