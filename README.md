# NAM_Pan_Genome_Analysis

This file includes the method used for maize pan genome construction using 26 NAM genome asseblies.

The method includes the following steps: 
```
1. using nucmer identify sytenic block
2. using split-merge pipeline identify one to one gene mapping and tandem duplicates 
3. using R join the gene linking information and merge/merge genes information and construct pan gene matrix 
```

Module involved in the pan-genome construction:
```
nucmer: mummer/4.0.0.beta2
split_merge pipeline: https://github.com/HirschLabUMN/Split_genes/tree/master/Split_Merge_Pipeline
ncbi_blast: ncbi_blast+/2.8.1
```

Pan-genome construction:
1. Identify syntenic block using nucmer 
  Extract canonical sequence ID from the gff file 
```
for i in *.gff; do
  grep "canonical_transcript" "$i" | cut -f 9 | tr ";" "\n" | grep "transcript_id" | sed 's/transcript_id=//g' > $(basename "$i")canonical_transcript.txt
done  
```
  running nucmer 
```
Insert the final proprogator script 
```
2. Pulling canonical transcript gene gff file, below is one example 
```
perl pull_out_caononical_transcript_coded_from_gff.pl -i ~/nam_pan_genome/NAM_annotation/gff/zea_maysb73_core_3_87_1.gff -l  ~/nam_pan_genome/NAM_annotation/canonical_transcript/B73_canonical_transcript.txt -o B73_canonical.gff
```
3. Using canonical transcript CDS sequences to make blast database 
```
makeblastdb -in zea_maysb73_core_3_87_1.canonical.cds.fasta -out B73_cds_db -dbtype nucl
```
4. Set up all by all blast to search pan gene 
```
Insert final all by all propogator script 
```

After running the first 4 modules, output is reshaped for R processing

5. Add header to each of the canonical transcript file so the list can be used as query list 
```
sed -i '1 i\Query_gene' *_canonical_transcript.txt 
```
6. Duplicate the canonical transcript ID so it can be used for left_join in R
```
for i in *.txt; do
  id=$(echo "$i" | cut -d'_' -f1)
  paste -d '\t' "$i" "$i"| sed "1iQuery_gene\t$id" > $(basename "$i")_add.txt
done 
rename _canonical_transcript.txt_input.txt_add '' *.txt
```


