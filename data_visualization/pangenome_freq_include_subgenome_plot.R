setwd("~/Desktop/pan_genome_nov 2/QC_set/subgenome_and_pan_frequency/")
# read in collasped final matrix, add the pan gene as the firs column "pan_gene_##" 
pan_gene__freq_matrix <- read.csv("subgenome_pan_gene_frequency_for_visualization.csv")


gene_frequency_plot <- ggplot(pan_gene__freq_matrix, aes(x = genome_presence, y = count)) + 
  geom_bar(aes(fill = pan_gene_type), position = "stack", stat = "identity",fill = "black") +
  geom_bar(aes(alpha = subgenome), stat = "identity", fill = "grey") +
  scale_alpha_manual(values = c(0.9, 0.5, 0)) + 
  labs(x = "Number of Genomes",
       y = "Number of Pan Genes",
       fill = "Pan Gene Type",
       alpha = "Maize Subgenome") +
  scale_x_continuous(breaks = seq(1, 26, 1)) +
  ylim(0, 30000) + 
  theme(text = element_text(size = 12),legend.key = element_rect(fill = "black")) + theme_classic()
  

gene_frequency_plot + theme(legend.position = "none") 
 
  
gene_frequency_plot + theme(legend.key=element_rect(color="black"))  

### add the piechart in the exisiting plot 
#pan gene frequency 
gene_freq_for_visualization <- read.csv("subgenome_pan_gene_frequency_for_visualization.csv")
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
  pan_gene_frequency_anchor + annotate("text", x = 8, y = 18000, label = "Core Genes: 26.96%",size = 4.5) + annotate("text", x = 16, y = 26000, label = "Near-Core Genes: 4.00%",size = 4.5) +
  annotate("text", x = 14, y = 12000, label = "Dispensable Genes: 49.35%",size =4.5) + annotate("text", x = 20, y = 18000, label = "Private Genes: 19.69%",size = 4.5) + 
  stat_summary(fun.y = sum, aes(label = ..y.., group = genome_presence), geom = "text",vjust=0.5, size=4, angle = 90,hjust =-0.1 )

pan_gene_frequency_piechart + theme(legend.position = "none") + theme(axis.title.y = element_text(size=12),
                                                                      axis.title.x = element_text(size=12),
                                                                      axis.text.y = element_text(size=12), 
                                                                      axis.text.x = element_text(size=12),
                                                                      legend.text = element_text(size=12),
                                                                      legend.title=element_blank())


