library(ggplot2)
library(tidyr)
library(dplyr)
library(ggpubr)

workdir <-"/home/mariona/Desktop/TFG/final_scripts/"
args <- commandArgs(trailingOnly=TRUE)
species <- args[1]
print(species)


tss_position <- read.table(paste(workdir, "data/transcript_positions.txt", sep =''))

dat <- read.table(gzfile(paste(workdir, "data/meth-NBCB7.txt.gz", sep ='')))

imp_genes_positions <- read.delim(paste(workdir, "data/",species,"/imp_genes_",species,".txt", sep =''), header=FALSE, sep = ' ')


#Blueprint


for (gene_name in imp_genes_positions$V1){

imp_gene_position <- subset(imp_genes_positions, V1==gene_name)

##
## LCLs
##

column_names <-c("gene_pos","a", "v0","b","c", "v1","d");
reg_species <- read.table(paste(workdir, "data/", species, "/", gene_name,"_cvlr/pos-depth-mean-by-cl.txt",sep = "") , header=FALSE, col.names = column_names)
#region<- reg_species %>% select(1, 3, 6)

print(paste("clust_species_1", gene_name, sep = " "))
clust1_species <- ggplot(reg_species, aes(x= gene_pos))+ geom_point(aes(y=v0), size= 0.7,  alpha =0.9, color = "#E64B35B2") +
  labs( y ="Cluster 1", x= "Position", subtitle= "LCLs") +
  scale_x_continuous( breaks=waiver(), n.breaks = 4, limits= c(min(reg_species$gene_pos), max(reg_species$gene_pos))) +
  scale_y_continuous(limits = c(0,1)) + theme_classic() +
  theme(axis.text.x = element_blank(), legend.title = element_blank(), axis.title.x= element_blank()) +
  geom_hline(aes(yintercept=0.5), size= 0.4,  linetype = 2)

print(paste("clust_species_2", gene_name, sep = " "))
clust2_species <- ggplot(reg_species, aes(x= gene_pos))+ geom_point(aes(y=v1), size= 0.7,  alpha =0.9, color= "#8491B4B2") +
  labs( y ="Cluster 2", x= "Position") +
  scale_x_continuous( breaks=waiver(), n.breaks = 4, limits= c(min(reg_species$gene_pos), max(reg_species$gene_pos))) +
  scale_y_continuous(limits = c(0,1)) + theme_classic() +
  theme(axis.text.x = element_blank(), legend.title = element_blank(), axis.title.x= element_blank()) +
  geom_hline(aes(yintercept=0.5), size= 0.4,  linetype = 2)

print(paste("diff_species", gene_name, sep = " "))
diff_species <- ggplot(reg_species, aes(x= gene_pos))+ geom_point(aes(y=v1-v0), size= 0.7,  alpha =0.9, color = "#1B9E77") +
  geom_hline(aes(yintercept=0), size= 0.4,  linetype = 2) +
  labs( y ="Clusters diff", x= "Position") +
  scale_x_continuous(breaks=waiver(), n.breaks = 4, limits= c(min(reg_species$gene_pos), max(reg_species$gene_pos))) +
  scale_y_continuous(limits = c(-1,1)) + theme_classic()



if(species == "human"){
##
## Blueprint
##

subset_blueprint <- subset(dat, V1==paste("chr",imp_gene_position$V2, sep ="") & imp_gene_position$V3<dat$V2 & dat$V2<imp_gene_position$V4)

tss_pos <- subset(tss_position, V8 == gene_name)
print(paste("blueprint", gene_name, sep = " "))

blueprint <- ggplot(subset_blueprint, aes(x= V2)) + geom_point(aes(y = V3),  size= 0.7,  alpha =0.8, color= "#4393C3") +
  labs( y = "Methylation (%)", x= 'Position',  subtitle ="Blueprint LCLs") +
  scale_x_continuous( breaks=waiver(), n.breaks = 4, limits= c(min(subset_blueprint$V2), max(subset_blueprint$V2))) +
  scale_y_continuous(limits = c(0,1)) +
  theme_classic() + geom_hline(aes(yintercept=0.5), size= 0.3,  linetype = 2)

if (gene_name == "GNAS" || gene_name == "MEG3" ){
  bseq_gnas <- read.delim(paste(workdir,"data/ENCODE/",gene_name,".txt", sep=''), header=FALSE)

  wgbs <-ggplot(bseq_gnas, aes(x =V2))+ geom_point(aes(y=  V11/100), size= 0.7,  alpha =0.8, color= "#F4A582") +
  labs(x = "Position", y = "Methylation (%)", subtitle = "WGBS ENCODE LCLs") +
  scale_x_continuous( breaks=waiver(), n.breaks = 4, limits= c(min(bseq_gnas$V2), max(bseq_gnas$V2))) +
  scale_y_continuous(limits = c(0,1)) +
  theme_classic() + geom_hline(aes(yintercept=0.5), size= 0.3,  linetype = 2)

   for (i in tss_pos$V5){
if (i == "+") {
  blueprint <- blueprint + geom_vline(data=tss_pos, aes(xintercept = V3), linetype = 2, size= 0.2, alpha= 0.4, color= '#666666')
  diff_species <- diff_species + geom_vline(data=tss_pos, aes(xintercept = V3), linetype = 2, size= 0.2, alpha= 0.4, color= '#666666')
  wgbs <- wgbs + geom_vline(data=tss_pos, aes(xintercept = V3), linetype = 2, size= 0.2, alpha= 0.4, color= '#666666')
  }
if (i == "-") {
  blueprint <- blueprint + geom_vline(data=tss_pos, aes(xintercept = V4), linetype = 2,size= 0.2, alpha= 0.4, color= '#666666')
  diff_species <- diff_species + geom_vline(data=tss_pos, aes(xintercept = V4), linetype = 2,size= 0.2, alpha= 0.4, color= '#666666')
  wgbs <- wgbs +  geom_vline(data=tss_pos, aes(xintercept = V4), linetype = 2,size= 0.2, alpha= 0.4, color= '#666666')
  }
   }
  plt <- ggarrange(blueprint, wgbs,
          nrow =2, ncol=1 , heights = c(3.9,3.7,4), widths = c(5),
          common.legend = TRUE, align = "v")

print(annotate_figure(plt,top = text_grob(paste(gene_name, " methylation percentage", sep = ""), color = "black", size = 12)))

  ggsave(paste(workdir, "final_plots/blueprint_ENCODE_", gene_name,"_", Sys.Date(),".png", sep = ""), width = 8, height = 6)
}
else{
  for (i in tss_pos$V5){
if (i == "+") {
  blueprint <- blueprint + geom_vline(data=tss_pos, aes(xintercept = V3), linetype = 2, size= 0.2, alpha= 0.4, color= '#666666')
  diff_species <- diff_species + geom_vline(data=tss_pos, aes(xintercept = V3), linetype = 2, size= 0.2, alpha= 0.4, color= '#666666')
  }
if (i == "-") {
  blueprint <- blueprint + geom_vline(data=tss_pos, aes(xintercept = V4), linetype = 2,size= 0.2, alpha= 0.4, color= '#666666')
  diff_species <- diff_species + geom_vline(data=tss_pos, aes(xintercept = V4), linetype = 2,size= 0.2, alpha= 0.4, color= '#666666')
}
print(blueprint)
ggsave(paste(workdir, "final_plots/blueprint_", gene_name,"_", Sys.Date(),".png", sep = ""), width = 9, height = 6)

  }
##
## Add tss
##


}

}

plt <- ggarrange(clust1_species, clust2_species, diff_species,
          nrow =3, ncol=1 , heights = c(3.9,3.7,4), widths = c(5),
          common.legend = TRUE, align = "v")


if (species== "sole"){
  print(annotate_figure(plt,top = text_grob(paste(gene_name, " methylation percentage (", imp_gene_position$V6, " ortholog)", sep = ""), color = "black", size = 12)))
  ggsave(paste(workdir, "final_plots/",species,"_", gene_name,"_", imp_gene_position$V6,"_", Sys.Date(),".png", sep = ""), width = 8, height = 9)

}
else{
  print(annotate_figure(plt,top = text_grob(paste(gene_name, " methylation percentage", sep = ""), color = "black", size = 12)))
ggsave(paste(workdir, "final_plots/",species,"_", gene_name,"_", Sys.Date(),".png", sep = ""), width = 8, height = 9)
}


}


