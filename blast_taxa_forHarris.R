#set wd to desktop or whatever 

#uploads tab delim txt file -- taxa database
taxa_database=read.delim("taxdb2.txt", header=FALSE, sep="\t")
#gives column names
names(taxa_database) <- c("accession", "taxa")

#uploads tabular blast file 
blast=read.delim("barcode1racon2_blast", header=FALSE, sep = "\t")


#assigns names of columns
#names(blast) <- c("sample", "sequenceID", "accession", "pairwiseident", "length", "mismatch", "qstart", "qend", "sstart", "send", "qlen", "slen", "eval", "bitscore", "gaps", "qseq" )
names(blast) <- c("sequenceID", "accession", "pairwiseident", "length", "mismatch", "qstart", "qend", "sstart", "send", "qlen", "slen", "eval", "bitscore", "gaps", "qseq" )

#merge will apply the taxa name based on the accession
blast_taxa=merge(blast, taxa_database, by.x="accession", by.y="accession", all.x=TRUE, all.y=FALSE)

#subset of pairwise ident of greater or equal to 97
racon2_97=subset(blast_taxa, blast_taxa$pairwiseident >= 97)

#list unique taxa of 97% subset
racon2_97_ut<-unique(racon2_97$taxa)
#view the list of taxa that meet the 97% criteria 
print(racon2_97_ut)
#export that list into a tab delim
write.table(racon2_97_ut, file = "R1_barcode01_racon2_unique_taxa", row.names = FALSE, col.names = TRUE, append = FALSE, quote = FALSE, sep = "\t")

require(ggplot2)
#load diet and hg sheet
ash=read.csv("acadia_seq_with_hg.csv", header=TRUE, sep = ",")
str(ash)
#ash$count_seq=count()

ggplot(data = ash, aes(x = sample, y = taxa)) +
  geom_tile(aes(fill = length(taxa)))

