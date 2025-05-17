library(tidyverse)

depth = read.table("organelle_coverage.txt", header=TRUE)

depth = depth %>%
  filter(!Library %in% c("W3_6_F8", "M3_1_F8", "M3_7_F7"))

depth <- depth %>%
  mutate(
    organelle_mapping = as.numeric(gsub("%", "", organelle_mapping))
  )

depth <- depth %>%
  mutate(Mitochondrial = organelle_mapping * mito_coverage / 
           (mito_coverage + plastid_coverage))

depth <- depth %>%
  mutate(Plastid = organelle_mapping * plastid_coverage / 
           (mito_coverage + plastid_coverage))

depth <- depth %>%
  mutate(Genotype = ifelse(startsWith(Library, "M"), "msh1",
                           ifelse(startsWith(Library, "W"), "Wild Type", NA)))

depth$Genotype = factor (depth$Genotype, levels = c("Wild Type", "msh1"))

ggplot(data=depth, aes(x=Mitochondrial, y=Plastid, color=Genotype)) +
  geom_point(alpha=0.75) +
  theme_bw() +
  scale_color_manual(values = c("gray", "firebrick3")) +
  xlab("Mitochondrial Mapping Percentage") +
  ylab("Plastid Mapping Percentage") +
  xlim(c(0,7)) +
  ylim(c(0,35)) +
  theme(legend.position="none",
        axis.text = element_text(size=6),
        axis.title = element_text(size=7, face="bold"),
        legend.text = element_text(size=6),
        panel.grid = element_blank()
  )

  ggsave("depth1.pdf", width=3.25, height=3.25)

depth %>%
  pivot_longer(
    cols = c(Mitochondrial, Plastid),
    names_to = "organelle",
    values_to = "coverage"
  ) %>%
  ggplot(aes(x=Genotype, y=coverage, fill=Genotype)) +
    geom_boxplot(outlier.shape = NA) +
    geom_jitter(width=0.2, alpha=0.5, size=0.5) +
    facet_wrap(~organelle, scales = "free_y") +
    scale_y_continuous(limits = c(0, NA)) +
    theme_bw() +
    scale_fill_manual(values = c("gray", "firebrick3")) +
    ylab("Mapping Percentage") +
    theme(legend.position="none",
          axis.text = element_text(size=6),
          axis.title = element_text(size=7, face="bold"),
          strip.text = element_text(size=6),
          legend.text = element_text(size=6),
          panel.grid = element_blank()
    )

  ggsave("depth2.pdf", width=3.25, height=3.25)

t.test (data=depth, Mitochondrial ~ Genotype)
t.test (data=depth, Plastid ~ Genotype)



