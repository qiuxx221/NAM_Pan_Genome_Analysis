import pandas as pd
# getting a list of pan gene that has NA in the matrix 
# information include pan gene ID, genome it is coming from, and genome where it was missing
infile = '/Users/yinjieqiu/Desktop/NAM_pan_genome_final/909090/Tamden_variation/pan_gene_matrix_for_cyverse.csv'
pan_matrix = open(infile, "r")

# get header info
header = pan_matrix.readline()
header = header.strip()
header = header.split(",")
# key for pan genome name 

tandem_list = []
for line in pan_matrix:
    pan_gene = line.strip()
    pan_gene = line.split(',')
    for idx, gene_id in enumerate(pan_gene): 
        gene_info = [pan_gene[1].split(';')[0], header[idx],gene_id]
        if ";" in gene_info[2]:
            tandem_matrix = pan_gene[1].split(';')[0] + "\t"+ header[idx]+ "\t"+"Tandem"
            tandem_list.append(tandem_matrix)
#print(*tandem_list,)

with open('/Users/yinjieqiu/Desktop/NAM_pan_genome_final/909090/Tamden_variation/Tandem_list_all.txt', 'w') as f:
    for item in tandem_list:
        f.write("%s\n" % item)
