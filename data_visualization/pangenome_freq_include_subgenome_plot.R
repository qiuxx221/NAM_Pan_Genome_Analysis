library(data.table)
library(ggplot2)
library(ggsci)
library(table)
# add path to input file
pan_matrix <- read.csv("pan_freq_sub_plotting_matrix_fix.txt", sep = "\t")



gene_frequency_plot <- ggplot(pan_matrix, aes(x = genome_presence, y = count)) + 
  geom_bar(aes(fill = pan_gene_type), position = "stack", stat = "identity") +
  geom_bar(aes(alpha = subgenome), stat = "identity", fill = "grey") +
  scale_alpha_manual(values = c(0.9, 0.5, 0)) + 
  labs(x = "Number of Genomes",
       y = "Number of Pan Genes",
       fill = "Pan Gene Type",
       alpha = "Maize Subgenome") +
  scale_x_continuous(breaks = seq(1, 26, 1)) +
  ylim(0, 30000) + 
  theme(text = element_text(size = 20),legend.key = element_rect(fill = "black")) +
  scale_fill_npg() + 
  theme_classic() + 
  theme(legend.position = "none")

gene_frequency_plot + theme(legend.key=element_rect(color="black"))  

### add the piechart in the exisiting plot 
# piechart version 
blank_theme <- theme_minimal() + 
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank(),
    plot.title=element_text(size=0, face="bold")
  ) 

bp<- ggplotGrob(ggplot(gene_freq_for_visualization, aes(x="genome_presence", y=Pan_gene, fill=class))+
                  geom_bar(width = 1, stat = "identity")  +scale_fill_npg() + 
                  coord_polar("y") + blank_theme + labs(fill = "Pan Gene Type")+ theme(legend.position ="none") )


#ggplot(gene_freq_for_visualization, aes(x="genome_presence", y=Pan_gene, fill=class))+
 # geom_bar(width = 1, stat = "identity")  +scale_fill_npg() + 
  coord_polar("y") + blank_theme + labs(fill = "Pan Gene Type")+ theme(legend.position ="none")

#pdf("~/Desktop/NAM/gene_frequency_pie1.pdf", width=11,height=6,pointsize=12, paper='special')
pie_chart_gene_frequency <- pie + blank_theme 


pan_gene_frequency_anchor <- gene_frequency_plot + 
  annotation_custom(
    grob = bp,
    xmin = 2,
    xmax = 25,
    ymin = 5000,
    ymax = 27000
  ) 

pan_gene_frequency_piechart <- 
  pan_gene_frequency_anchor + annotate("text", x = 8, y = 18000, label = "Core Genes: 27.13%",size = 4.5) + annotate("text", x = 16, y = 26000, label = "Softcore Genes: 4.00%",size = 4.5) +
  annotate("text", x = 14, y = 12000, label = "Dispensable Genes: 49.08%",size =4.5) + annotate("text", x = 20, y = 18000, label = "Private Genes: 19.79%",size = 4.5) + 
  stat_summary(fun.y = sum, aes(label = ..y.., group = genome_presence), geom = "text",vjust=0.5, size=4, angle = 90,hjust =-0.1 )

pan_gene_frequency_piechart
  


