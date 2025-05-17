library (ggplot2)

MA_germ = read.csv("MA_germ.csv")
MA_germ$mw = factor(MA_germ$mw, levels=c("Wild", "Mutant"), labels=c("Wild Type", "msh1"))

#this makes a boxplot with data scatter
ggplot(MA_germ, aes(x=mw, y=germ)) +
  geom_boxplot(aes(fill = mw), outlier.shape = NA, size=0.5) +  # Box plot without outliers
  geom_jitter(aes(color = gen), width = 0.15, size = 0.75, stroke=0.5, alpha = 0.4) +  # Scattered points
  facet_wrap(~gen) +  # Facet wrap by Group
  scale_fill_manual(values = c("gray", "firebrick3")) +  # Change box colors
  scale_color_manual(values = c("black", "black", "black")) + # Change dot colors
  xlab("Genotype") +
  ylab("Percent Germination") +
  theme_bw() +
  theme (legend.position = "none",
         axis.text = element_text(size=6),
         axis.title = element_text(size=7, face="bold"),
         strip.text = element_text(size=6),
         panel.grid = element_blank()
         )

ggsave("germination.pdf", width=3.25, height = 2.25)