library(pheatmap)
library(grid)

plastid_heatmap_data = read.csv("plastid_heatmap_matrix_only.csv")
plastid_heatmap_matrix = as.matrix(plastid_heatmap_data)

mito_heatmap_data = read.csv("mito_heatmap_matrix_only.csv")
mito_heatmap_matrix = as.matrix(mito_heatmap_data)

custom_pheatmap <- function(mat, color_pal, WT_lines, Mut_lines) {

    p = pheatmap(
    mat,
    color = color_pal,
    cluster_rows = FALSE, 
    cluster_cols = FALSE, 
    display_numbers = FALSE, 
    legend = FALSE,
    #show_colnames = FALSE,
    fontsize_col = 4, 
  )
 
   grid.lines(
    x = unit(c(WT_lines / (WT_lines + Mut_lines), WT_lines / (WT_lines + Mut_lines)), "npc"),  # Normalize position
    y = unit(c(0, 1), "npc"),  # Full height
    gp = gpar(col = "black", lwd = 0.5)  # Line style
  )
  
  grid.rect(
    x = 0.5, y = 0.5, width = 1, height = 1,  # Position and size
    gp = gpar(col = "black", lwd = 0.5, fill = NA)  # Border style
  )
}

custom_colors_plastid <- colorRampPalette(c("white", "chartreuse4"))(100)
custom_colors_mito <- colorRampPalette(c("white", "goldenrod3"))(100)

custom_pheatmap (plastid_heatmap_matrix, custom_colors_plastid, 20, 22)
custom_pheatmap (mito_heatmap_matrix, custom_colors_mito, 20, 22)