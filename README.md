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

Note:
```
Genes used for this pan genome analysis are genes annoated on chromsome, scaffold genes are not included. 
```

Pan-genome construction:
1. Identify syntenic block using nucmer 
  Extract canonical sequence ID that are on chromsomes from the gff file 
```
for i in *.gff; do
  grep "canonical_transcript" "$i" | grep -v scaf |cut -f 9 | tr ";" "\n" | grep "transcript_id" | sed 's/transcript_id=//g' > "$i"_canonical_transcript.txt
done  
```
2. Pulling canonical transcript gene gff file, below is one example 
```
perl pull_out_caononical_transcript_coded_from_gff.pl -i ~/nam_pan_genome/NAM_annotation/gff/zea_maysb73_core_3_87_1.gff -l  ~/nam_pan_genome/NAM_annotation/canonical_transcript/B73_canonical_transcript.txt -o B73_canonical.gff
```
3. Using canonical transcript CDS sequences to make blast database 
```
makeblastdb -in zea_maysb73_core_3_87_1.canonical.cds.fasta -out B73_cds_db -dbtype nucl
```
4. running nucmer at -c 1000, example of the script is shown below. All pairs are generated using mummer_c1000_propogator.sh 
```
nucmer --mum -c 1000 -p HP301_B73_c1000 /panfs/roc/groups/6/maize/shared/databases/genomes/Zea_mays/HP301_NAMassembly/Zm-HP301-REFERENCE-NAM-1.0/Zm-HP301-REFERENCE-NAM-1.0.fasta /panfs/roc/groups/6/maize/shared/databases/genomes/Zea_mays/B73_NAMassembly/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0.fasta
```
nucmer output was further processed using nucmer_post_processing.sh
and filtered that the syntenic block must be on the same chr
```
for j in *.coords ; do
  grep -v scaf "$j"  | awk '(NR>1) && ($12 == $13 )' > "$j"_filter_chr_nucmer 
done 
```

5. Set up all by all blast to search pan gene using script all_by_all_blast_batch.sh. Below is an example of the script
```
python3 All_by_All_Blast_COedits_10.py -q /home/hirschc1/qiuxx221/nam_pan_genome/NAM_annotation/canonical_gff/B73_canonical.gff -s /home/hirschc1/qiuxx221/nam_pan_genome/NAM_annotation/canonical_gff/P39_canonical.gff -b /home/hirschc1/qiuxx221/nam_pan_genome/NAM_annotation/canonical_fasta/P39_cds_db -l /home/hirschc1/qiuxx221/nam_pan_genome/NAM_annotation/canonical_fasta/zea_maysb73_core_3_87_1.canonical.cds.fasta -o /home/hirschc1/qiuxx221/nam_pan_genome/all_by_all_1000_new_annotation_10_filter_nucmer/B73_P39_AllbyAll_res.txt -n /home/hirschc1/qiuxx221/nucmer_1000_filter/B73_P39_c1000.fil.coords -g ab
```
After running the first 4 modules, output is reshaped for R processing

6. Add header to each of the canonical transcript file so the list can be used as query list 
```
sed -i '1 i\Query_gene' *_canonical_transcript.txt 
```
7. Duplicate the canonical transcript ID so it can be used for left_join in R
```
for i in *.txt; do
  id=$(echo "$i" | cut -d'_' -f1)
  paste -d '\t' "$i" "$i"| sed "1iQuery_gene\t$id" >  "$i"_add.txt
done 
```

8. processing all_by_all_blast output 
```
```

9. input all output from step 6,7,8 into R to make the base matrix using R script: make_base_pan_matrix.R
```
This step input all pairs information and align into a single matrix. gene without pairs is recored as NA 
```

10. compressing the base matrix by merging ID that present more than once within a column using R script: compressing_duplicate_ID.R
```
Gene pairs will be picked up by all by all blast files in both directions (B73_B97 vs B97_B73). gene ID has the chance to present more than once. This step joins all gene ID, tandem dulicates will be separated by ";"
```


