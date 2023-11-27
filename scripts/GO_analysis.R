library(ggplot2)
library(dplyr)
library(clusterProfiler)
library(org.Mm.eg.db)
library(DOSE)
library(ggrepel)


ego_plot_function <- function(geneset, background,plot_name){
  ego <- enrichGO(gene = geneset,
                  OrgDb = org.Mm.eg.db,
                  keyType = 'ENSEMBL',
                  universe = background,
                  ont = 'BP',## 'BP','MF','CC','all'
                  pvalueCutoff = 0.05,
                  qvalueCutoff = 0.05,
                  pAdjustMethod = 'BH',
                  readable = T)
  
  if(length(ego$Description)==0){
    print(geneset)
    print("find no enrichment")
  } else {
    ego_plot <- dotplot(ego, showCategory=20, font.size = 6,label_format = 45)
    ggsave(filename = paste0("GO_dot_",plot_name), ego_plot, path = './', width = 7, height = 7)
    
    #ego_plot_bar <- barplot(ego, showCategory = 20, font.size = 6,label_format = 45)
    #ggsave(filename = plot_name, ego_plot_bar, path = './20231121_go/Plot/', width = 7, height = 7)
    
    ego_df <- as.data.frame(ego@result)
    GO_terms <- ego_df$Description[1:10]
    ego_df <- mutate(ego_df,fc = log(parse_ratio(ego@result$GeneRatio)/parse_ratio(ego@result$BgRatio),2),pv = -log(p.adjust,10))
    ego_plot_point <- ggplot(ego_df[1:100,],aes(x=fc,y=Count,label= ifelse(Description %in% GO_terms, Description, ""),size=pv, color = pv)) + geom_point() + geom_text_repel() + theme_bw() + xlab("Log(Fold change)") +
      ylab("Gene count") + guides(size=guide_legend(title = "-log(p.adjust)")) + guides(color='none')
    ggsave(filename = paste0("GO_vol_",plot_name), ego_plot_point, path = './', width = 10, height = 8)
  }
  
}

genetables <- c("run1","run2","run3")
for (genetable_name in genetables){
  gene_table <- read.table(paste0("your_folder/",genetable_name),header = T)
  # remove na in log2FoldChange and padj
  gene_table <- gene_table[!is.na(gene_table$log2FoldChange),] 
  gene_table <- gene_table[!is.na(gene_table$padj),] 
  pos_gene <- gene_table$ID[gene_table$log2FoldChange > 1 & gene_table$padj < 0.1]
  neg_gene <- gene_table$ID[gene_table$log2FoldChange < -1 & gene_table$padj < 0.1]
  background <- gene_table$ID

  namelist <- c("pos_","neg_")
  genelist <- list(pos_gene,neg_gene)
  for (i in seq_along(namelist)){
    plot_name = paste0(namelist[i],genetable_name,".pdf")
    ego_plot_function(geneset = genelist[[i]],background = background,plot_name=plot_name)
  }
  
}
