#this shell script is located in cd /Users/batyanightingale/ACADIA
#each flongle folder will be in /Users/batyanightingale/ACADIA
#labeled blasts folder is in ACADIA, all sample files will be collected there then concatenated into one text file
mkdir labeled_blasts 
mkdir megan

#basecalling and demultiplexing is done by each sequencing run (or flongle) then porechop and nanofilt is done by barcode
cd /Users/batyanightingale/ACADIA/FLONGLE1
mkdir basecalled
mkdir demultiplexed

##assumes all fast5 files are in a folder called "fast5" at /Users/batyanightingale/ACADIA/FLONGLE1/fast5
##will need to find and replace all for certain parameters like directories, flowcell, and kit 

#Step 1- basecalling
/Applications/ont-guppy-cpu/bin/./guppy_basecaller --input_path /Users/batyanightingale/ACADIA/FLONGLE1/fast5  --save_path /Users/batyanightingale/ACADIA/FLONGLE1/basecalled  --flowcell FLO-MIN106 --kit SQK-PBK004

#combining basecalled files for NanoComp
cat /Users/batyanightingale/ACADIA/FLONGLE1/basecalled/*.fastq > /Users/batyanightingale/ACADIA/FLONGLE1_basecalled.fastq

#Step 2- demultiplexing 
/Applications/ont-guppy-cpu/bin/./guppy_barcoder -i /Users/batyanightingale/ACADIA/FLONGLE1/basecalled/ -s /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed --barcode_kits SQK-PBK004

##########################################################################################
##############################BARCODE01###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode01
cat *.fastq > barcode01.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode01.fastq -o barcode01_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode01_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode01_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode01_t_f.fastq > barcode01_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode01_t_f_cp.fastq    barcode01_t_f.fastq  >    barcode01_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode01_t_f.fastq    barcode01_map.paf   barcode01_t_f_cp.fastq   >   barcode01_racon.fasta
cp barcode01_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode01_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode01
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode01_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode01/FLONGLE1barcode01blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode01

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B1\t" $0}' < FLONGLE1barcode01blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode01_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode01blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed


##########################################################################################
##############################BARCODE02###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode02
cat *.fastq > barcode02.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode02.fastq -o barcode02_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode02_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode02_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode02_t_f.fastq > barcode02_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode02_t_f_cp.fastq    barcode02_t_f.fastq  >    barcode02_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode02_t_f.fastq    barcode02_map.paf   barcode02_t_f_cp.fastq   >   barcode02_racon.fasta
cp barcode02_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode02_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode02
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode02_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode02/FLONGLE1barcode02blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode02

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B2\t" $0}' < FLONGLE1barcode02blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode02_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode02blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE03###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode03
cat *.fastq > barcode03.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode03.fastq -o barcode03_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode03_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode03_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode03_t_f.fastq > barcode03_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode03_t_f_cp.fastq    barcode03_t_f.fastq  >    barcode03_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode03_t_f.fastq    barcode03_map.paf   barcode03_t_f_cp.fastq   >   barcode03_racon.fasta
cp barcode03_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode03_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode03
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode03_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode03/FLONGLE1barcode03blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode03

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B3\t" $0}' < FLONGLE1barcode03blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode03_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode03blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE04###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode04
cat *.fastq > barcode04.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode04.fastq -o barcode04_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode04_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode04_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode04_t_f.fastq > barcode04_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode04_t_f_cp.fastq    barcode04_t_f.fastq  >    barcode04_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode04_t_f.fastq    barcode04_map.paf   barcode04_t_f_cp.fastq   >   barcode04_racon.fasta
cp barcode04_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode04_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode04
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode04_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode04/FLONGLE1barcode04blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode04

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B4\t" $0}' < FLONGLE1barcode04blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode04_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode04blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE05###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode05
cat *.fastq > barcode05.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode05.fastq -o barcode05_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode05_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode05_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode05_t_f.fastq > barcode05_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode05_t_f_cp.fastq    barcode05_t_f.fastq  >    barcode05_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode05_t_f.fastq    barcode05_map.paf   barcode05_t_f_cp.fastq   >   barcode05_racon.fasta
cp barcode05_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode05_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode05
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode05_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode05/FLONGLE1barcode05blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode05

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B5\t" $0}' < FLONGLE1barcode05blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode05_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode05blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE06###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode06
cat *.fastq > barcode06.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode06.fastq -o barcode06_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode06_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode06_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode06_t_f.fastq > barcode06_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode06_t_f_cp.fastq    barcode06_t_f.fastq  >    barcode06_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode06_t_f.fastq    barcode06_map.paf   barcode06_t_f_cp.fastq   >   barcode06_racon.fasta
cp barcode06_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode06_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode06
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode06_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode06/FLONGLE1barcode06blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode06

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B6\t" $0}' < FLONGLE1barcode06blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode06_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode06blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE07###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode07
cat *.fastq > barcode07.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode07.fastq -o barcode07_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode07_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode07_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode07_t_f.fastq > barcode07_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode07_t_f_cp.fastq    barcode07_t_f.fastq  >    barcode07_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode07_t_f.fastq    barcode07_map.paf   barcode07_t_f_cp.fastq   >   barcode07_racon.fasta
cp barcode07_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode07_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode07
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode07_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode07/FLONGLE1barcode07blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode07

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B7\t" $0}' < FLONGLE1barcode07blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode07_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode07blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE08###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode08
cat *.fastq > barcode08.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode08.fastq -o barcode08_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode08_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode08_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode08_t_f.fastq > barcode08_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode08_t_f_cp.fastq    barcode08_t_f.fastq  >    barcode08_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode08_t_f.fastq    barcode08_map.paf   barcode08_t_f_cp.fastq   >   barcode08_racon.fasta
cp barcode08_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode08_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode08
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode08_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode08/FLONGLE1barcode08blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode08

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B8\t" $0}' < FLONGLE1barcode08blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode08_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode08blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE09###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode09
cat *.fastq > barcode09.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode09.fastq -o barcode09_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode09_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode09_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode09_t_f.fastq > barcode09_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode09_t_f_cp.fastq    barcode09_t_f.fastq  >    barcode09_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode09_t_f.fastq    barcode09_map.paf   barcode09_t_f_cp.fastq   >   barcode09_racon.fasta
cp barcode09_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode09_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode09
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode09_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode09/FLONGLE1barcode09blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode09

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B9\t" $0}' < FLONGLE1barcode09blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode09_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode09blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed

##########################################################################################
##############################BARCODE10###################################################
#step 3- concatenate 
cd /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode10
cat *.fastq > barcode10.fastq 

#step 4- porechop (removing barcodes and adapters)
echo BEGIN PORECHOP
porechop -i barcode10.fastq -o barcode10_t.fastq
echo END PORECHOP

#step 5- nanofilt (quality control)
echo BEGIN NANOFILT
cat barcode10_t.fastq | NanoFilt -q 8 -l 100 --maxlength 600 > barcode10_t_f.fastq
echo END NANOFILT 

#step 6- making copy of file with new names (prep for minimap/racon)
sed 's/@/@1/g' < barcode10_t_f.fastq > barcode10_t_f_cp.fastq
echo COPY EDIT FILE FOR MINIMAP2 RACON MADE 

#minimap2 (mapping reads against themselves)
minimap2   barcode10_t_f_cp.fastq    barcode10_t_f.fastq  >    barcode10_map.paf
echo minimap2 COMPLETE 

#racon (fragment correction)
racon   -f  barcode10_t_f.fastq    barcode10_map.paf   barcode10_t_f_cp.fastq   >   barcode10_racon.fasta
cp barcode10_racon.fasta /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode10_racon.fasta
echo RACON COMPLETE

#tabular blast 
echo STARTING tabular BLAST FOR barcode10
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode10_racon.fasta  -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode10/FLONGLE1barcode10blast_tabular90 -outfmt "6 qseqid sseqid pident length mismatch qstart qend sstart send qlen slen evalue bitscore gaps qseq" -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo tabular blast completed FOR barcode10

#label tabular blast with sample id and put in labeled_blasts folder here we have flongle 1 sample 2
awk '{print "F1B10\t" $0}' < FLONGLE1barcode10blast > /Users/batyanightingale/ACADIA/labeled_blasts/sample1.txt
echo tabular blast has been labeled with sampleid

#text blast for MEGAN6 (I tried and tried to get to a tabular format that worked but I couldn't)
echo text blast begin
/Applications/ncbi-blast-2.9.0+/bin/./blastn -query barcode10_racon.fasta   -db /Users/batyanightingale/Desktop/SP/422019_BRN_COI/COI/COI_database -out /Users/batyanightingale/ACADIA/megan/FLONGLE1barcode10blast_text -num_threads 24 -max_target_seqs 1 -evalue 1e-20 -perc_identity 90
echo text blast completed


##########################################################################################
# checking to make sure all of the files are in the right place:
#########################################################################################
ls -l /Users/batyanightingale/ACADIA
ls -l /Users/batyanightingale/ACADIA/labeled_blasts
ls -l /Users/batyanightingale/ACADIA/megan
ls -l /Users/batyanightingale/ACADIA/FLONGLE1
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode01
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode02
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode03
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode04
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode05
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode06
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode07
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode08
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode09
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode10
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode11
ls -l /Users/batyanightingale/ACADIA/FLONGLE1/demultiplexed/barcode12
# ##########################################################################################
##########################################################################################
# summary statistics and plots 
##########################################################################################

nanoplot --summary /Users/batyanightingale/ACADIA/FLONGLE1/basecalled/sequencing_summary.txt --loglength -o /Users/batyanightingale/ACADIA/FLONGLE1/basecalled/sequencing_summary_nanoplot_loglength

NanoComp --fastq /Users/batyanightingale/ACADIA/FLONGLE1_basecalled.fastq /Users/batyanightingale/ACADIA/FLONGLE2_basecalled.fastq /Users/batyanightingale/ACADIA/FLONGLE3_basecalled.fastq /Users/batyanightingale/ACADIA/FLONGLE4_basecalled.fastq --names SITE1 SITE2 SITE3 SITE4 --outdir /Users/batyanightingale/ACADIA/

NanoStat --fastq reads.fastq.gz --outdir statreports

##########################################################################################
## can copy/paste for all barcodes or maybe a loop?
#####################FINISHING UP########################################################
###after all flongles are finished
#cd /Users/batyanightingale/ACADIA/labeled_blasts
#cat *.txt > acadia_seq.txt

#this file can be input into excel for the VLOOKUP protocol for species names (working on R script that can do all of that automatically)

