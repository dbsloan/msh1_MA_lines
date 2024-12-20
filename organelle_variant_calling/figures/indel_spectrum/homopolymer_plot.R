library (tidyverse)

homopolymer_data = read.csv("homopolymer_plot_input.csv")

homopolymer_data$Size = factor(homopolymer_data$Size, levels = c("5_6", "7_8", "9_10", "11_12", "13_plus"), labels = c("5-6", "7-8", "9-10", "11-12", "13+"))
homopolymer_data$Homopolymer = factor(homopolymer_data$Homopolymer, labels = c("A/T Homopolymers", "G/C Homopolymers"))

ggplot(data=homopolymer_data, aes(x=Size, y=HomopolymerPerKb, color=Genome, group=Genome, shape=Genome)) +
  geom_point() +
  geom_line() +
  facet_wrap(~Homopolymer) +
  scale_y_log10() +
  ylab("Homopolymer Frequency (per kb)") +
  xlab ("Homopolymer Length (bp)") +
  theme_bw() +
  theme (panel.grid = element_blank(), legend.title = element_blank(), legend.position = "top") +
  theme (axis.title = element_text(size=7, face="bold"), axis.text = element_text(size=5.5), strip.text = element_text(size=7, face="bold"), legend.text = element_text(size=7)) +
  scale_color_manual(values=c("goldenrod2", "chartreuse4"))


ggsave("homopolymer_plot.pdf", width=3.15, height=2.5)