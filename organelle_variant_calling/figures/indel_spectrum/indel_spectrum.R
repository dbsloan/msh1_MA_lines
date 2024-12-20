library (tidyverse)
library(ggh4x)

setwd("/Users/sloan/Documents/ColoradoState/projects/mutation_detection/msh1_MA_lines/Analysis/20241029_45_lines/variant_summary/indel_spectrum/") 

indel_data = read.csv("indel_spectrum.csv")
indel_data$Homopolymer = factor(indel_data$Homopolymer, labels = c("A/T Homopolymers", "G/C Homopolymers"))

indel_data = indel_data %>% 
  filter(Length < 4) %>%
  mutate(Length = if_else(Indel == "Deletion", Length * -1 + 1, Length)) %>%
  mutate(Count = if_else(Genome == "Mitochondrial", Count * -1, Count)) 

indel_data$Length = factor(indel_data$Length, labels = c("-3", "-2", "-1", "+1", "+2", "+3"))

ggplot(data=indel_data, aes(x=Length, y=Count, fill=Genome, group=Genome)) +
  geom_bar(stat="identity") +
  facet_wrap(~Homopolymer) +
  coord_flip() +
  ylab("Indel Count") +
  xlab ("Indel Length (bp)") +
  ylim (c(-250,250)) +
  theme_bw() +
  theme (panel.grid = element_blank(), legend.title = element_blank(), legend.position = "none") +
  theme (axis.title = element_text(size=7, face="bold"), axis.text = element_text(size=5.5), strip.text = element_text(size=7, face="bold"), legend.text = element_text(size=7)) +
  scale_fill_manual(values=c("goldenrod2", "chartreuse4"))

ggsave("indelSpectrum_plot.pdf", width=3.15, height=1.95)
